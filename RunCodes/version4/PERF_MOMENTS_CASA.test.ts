import { CARTA } from "carta-protobuf";
import { Client, AckStream, Wait } from "./CLIENT";
import config from "./config2.json";
const WebSocket = require('isomorphic-ws');

let testServerUrl = config.serverURL0;
let testSubdirectory = config.path.QA;
let connectTimeout = config.timeout.connection;
let readFileTimeout = 5000;//config.timeout.readFile;
let setSpectralReqTimeout = 5000;//config.timeout.region;
let momentTimeout = 400000;//config.timeout.moment;
let sleepTimeout: number = config.timeout.sleep;

interface AssertItem {
    precisionDigit: number;
    registerViewer: CARTA.IRegisterViewer;
    openFile: CARTA.IOpenFile[];
    addTilesReq: CARTA.IAddRequiredTiles;
    setCursor: CARTA.ISetCursor;
    setSpatialReq: CARTA.ISetSpatialRequirements;
    setSpectralRequirements: CARTA.ISetSpectralRequirements;
    momentRequest: CARTA.IMomentRequest;
};

let assertItem: AssertItem = {
    precisionDigit: 4,
    registerViewer: {
        sessionId: 0,
        clientFeatureFlags: 5,
    },
    openFile: [
       {
           directory: testSubdirectory,
           file: "S255_IR_sci.spw25.cube.I.pbcor.image",
           hdu: "",
           fileId: 0,
           renderMode: CARTA.RenderMode.RASTER,
       },
    ],
    addTilesReq: {
        fileId: 0,
        compressionQuality: 11,
        compressionType: CARTA.CompressionType.ZFP,
        tiles: [0],
    },
    setCursor: {
        fileId: 0,
        point: { x: 960, y: 960 },
    },
    setSpatialReq: {
        fileId: 0,
        regionId: 0,
        spatialProfiles: [{coordinate:"x"}, {coordinate:"y"}]
    },
    setSpectralRequirements: {
        fileId: 0,
        regionId: 0,
        spectralProfiles: [{ coordinate: "z", statsTypes: [CARTA.StatsType.Mean] }],
    },
    momentRequest: {
        fileId: 0,
        regionId: 0,
        axis: CARTA.MomentAxis.SPECTRAL,
        mask: CARTA.MomentMask.Include,
        moments: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        pixelRange: { min: 0.1, max: 1.0 },
        spectralRange: { min: 0, max: 400 },
        // spectralRange: { min: 73, max: 114 },
    },
};
const momentName = [
    "average", "integrated", "weighted_coord", "weighted_dispersion_coord",
    "median", "median_coord", "standard_deviation", "rms", "abs_mean_dev",
    "maximum", "maximum_coord", "minimum", "minimum_coord",
];
const intensity = [ // Testing intensity at the (5, 5) of each moment image
    0.86652, 2.27450, 302.11578, 31.72338,
    0.91866, 305.16903, 0.18203, 0.88238, 0.09988,
    0.95470, 305.16903, 0.67406, 251.49975,
];

describe("PERF_LOAD_IMAGE",()=>{
    for (const [key,value] of assertItem.openFile.entries()) {
        let cartaBackend: any;
        describe(`for "${value.file}"`, () => {

            let Connection: Client;
            test(`CARTA is ready & Send a Session:`,async () => {
                Connection = new Client(testServerUrl);
                await Connection.open();
                await Connection.registerViewer(assertItem.registerViewer);
                await Connection.send(CARTA.CloseFile, { fileId: -1 });
            }, connectTimeout);

            function sleep(ms) {
                return new Promise(resolve => setTimeout(resolve, ms)).then(() => { console.log('sleep!') });
            }

            describe(`Go to "${assertItem.openFile[key].directory}" folder`, () => {
                describe(`open the file "${value.directory}/${assertItem.openFile[key].file}"`, () => {
                    test(`(Step 1)"${assertItem.openFile[key].file}" OPEN_FILE_ACK and REGION_HISTOGRAM_DATA should arrive within ${readFileTimeout} ms`, async () => {
                        let OpenAck = await Connection.openFile(value); // OpenFileAck | RegionHistogramData
                        expect(OpenAck.OpenFileAck.success).toEqual(true);
                    }, readFileTimeout);
    
                    let acktemp: AckStream;
                    test(`(Step 2)"${assertItem.openFile[key].file}" Set SET_SPECTRAL_REQUIREMENTS, the responses should arrive within ${setSpectralReqTimeout} ms`, async () => {
                        await Connection.send(CARTA.AddRequiredTiles, assertItem.addTilesReq);
                        await Connection.send(CARTA.SetCursor, assertItem.setCursor);
                        acktemp = await Connection.streamUntil((type, data) => type == CARTA.RasterTileSync ? data.endSync : false);
                        expect(acktemp.RasterTileSync.length).toEqual(2); //RasterTileSync: start & end
                        expect(acktemp.RasterTileData.length).toEqual(assertItem.addTilesReq.tiles.length); //only 1 Tile returned

                        await Connection.send(CARTA.SetSpatialRequirements, assertItem.setSpatialReq);
                        await Connection.receive(CARTA.SpatialProfileData);
                        
                        await Connection.send(CARTA.SetSpectralRequirements, assertItem.setSpectralRequirements);
                        let temp = await Connection.streamUntil((type,data) => type == CARTA.SpectralProfileData && data.progress == 1)
                        // let temp = await Connection.receive(CARTA.SpectralProfileData);
                        // expect(temp.progress).toEqual(1);
                    }, readFileTimeout);
                });
            });

            let FileId: number[] = [];
            describe(`Moment generator`, () => {
                let ack: AckStream;
                test(`(Step 3)"${assertItem.openFile[key].file}": Receive a series of moment progress within ${momentTimeout}ms`, async () => {
                    await sleep(sleepTimeout);
                    await Connection.send(CARTA.MomentRequest, assertItem.momentRequest);
                    ack = await Connection.stream(23);
                    // ack = await Connection.streamUntil(type => type == CARTA.MomentResponse);
                    // console.log(ack);
                    FileId = ack.RegionHistogramData.map(data => data.fileId);
                    expect(ack.MomentProgress.length).toBeGreaterThan(0);
                    console.log(ack.MomentProgress)
                }, momentTimeout);

                test(`Receive ${assertItem.momentRequest.moments.length} REGION_HISTOGRAM_DATA`,()=>{
                    expect(FileId.length).toEqual(assertItem.momentRequest.moments.length);
                });

                test(`Assert MomentResponse.success = true`,()=>{
                    expect(ack.MomentResponse[0].success).toBe(true);
                });

                test(`Assert MomentResponse.openFileAcks.length = ${assertItem.momentRequest.moments.length}`,()=>{
                    expect(ack.MomentResponse[0].openFileAcks.length).toEqual(assertItem.momentRequest.moments.length);
                });

                test(`Assert all MomentResponse.openFileAcks[].success = true`,()=>{
                    ack.MomentResponse[0].openFileAcks.map(ack => {
                        expect(ack.success).toBe(true);
                    });
                });

                test(`Assert all openFileAcks[].fileId > 0`,()=>{
                    ack.MomentResponse[0].openFileAcks.map(ack => {
                        expect(ack.fileId).toBeGreaterThan(0);
                    });
                });

                test(`Assert openFileAcks[].fileInfo.name`,()=>{
                    ack.MomentResponse[0].openFileAcks.map((ack,index)=>{
                        expect(ack.fileInfo.name).toEqual(assertItem.openFile[key].file + ".moment." + momentName[index])
                    });
                });

            });

            afterAll(async done => {
                await Connection.close();
            }, 10000);
        });
    };
});
