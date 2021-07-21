import { CARTA } from "carta-protobuf";
import { Client, AckStream } from "./CLIENT";
import config from "./config2.json";
const WebSocket = require('isomorphic-ws');

let testServerUrl: string = config.serverURL0;
let testSubdirectory: string = config.path.performance;
let connectTimeout: number = config.timeout.connection;
let openFileTimeout: number = 7000;//config.timeout.openFile; //7000
let readFileTimeout: number = 5000;//config.timeout.readFile; //5000

interface AssertItem {
    registerViewer: CARTA.IRegisterViewer;
    filelist: CARTA.IFileListRequest;
    fileOpen: CARTA.IOpenFile[];
    initTilesReq: CARTA.IAddRequiredTiles;
    initSetCursor: CARTA.ISetCursor;
    initSpatialRequirements: CARTA.ISetSpatialRequirements;
    histogram: CARTA.ISetHistogramRequirements;
    cubeHistogramTimeout: number[];
};

let assertItem: AssertItem = {
    registerViewer: {
        sessionId: 0,
        clientFeatureFlags: 5,
    },
    filelist: { directory: testSubdirectory },
    fileOpen: [
        {
            directory: testSubdirectory + "/cube_B",
            file: "cube_B_09600_z00100.fits",
            hdu: "0",
            fileId: 0,
            renderMode: CARTA.RenderMode.RASTER,
        },
    ],
    initTilesReq: {
        fileId: 0,
        compressionQuality: 11,
        compressionType: CARTA.CompressionType.ZFP,
        tiles: [33558529, 33558528, 33554433, 33554432, 33562625, 33558530, 33562624, 33554434, 33562626],
    },
    initSetCursor: {
        fileId: 0,
        point: { x: 1, y: 1 },
    },
    initSpatialRequirements:
    {
        fileId: 0,
        regionId: 0,
        spatialProfiles: [{coordinate:"x"}, {coordinate:"y"}],
    },
    histogram: {
        fileId: 0,
        regionId: -2,
        histograms: [{ channel: -2, numBins: -1 }],
    },
    cubeHistogramTimeout: [300000],
    // cubeHistogramTimeout: [12000, 60000, 300000, 1000000, 12000, 60000, 300000, 1000000, 500, 500, 500, 500],
};

describe("PERF_CUBE_HISTOGRAM",()=>{
    for (const [key,value] of assertItem.fileOpen.entries()) {
        let cartaBackend: any;
        describe(`for "${value.file}"`, () => {

            let Connection: Client;
            test(`CARTA is ready & Send a Session:`,async () => {
                Connection = new Client(testServerUrl);
                await Connection.open();
                await Connection.registerViewer(assertItem.registerViewer);
                await Connection.send(CARTA.CloseFile, { fileId: -1 });
            }, connectTimeout);

            describe(`Go to "${assertItem.fileOpen[key].directory}" folder and open image "${assertItem.fileOpen[key].file}":": `, () => {
                test(`(Step 1)"${assertItem.fileOpen[key].file}" OPEN_FILE_ACK and REGION_HISTOGRAM_DATA should arrive within ${openFileTimeout} ms`, async () => {
                    let OpenAck = await Connection.openFile(value);
                    // OpenFileAck | RegionHistogramData
                }, openFileTimeout);

                let ack: AckStream;
                test(`(Step 1)"${assertItem.fileOpen[key].file}" SetImageChannels & SetCursor responses should arrive within ${readFileTimeout} ms`, async () => {
                    await Connection.send(CARTA.SetCursor, assertItem.initSetCursor);
                    await Connection.send(CARTA.SetSpatialRequirements, assertItem.initSpatialRequirements);
                    await Connection.send(CARTA.AddRequiredTiles, assertItem.initTilesReq);

                    ack = await Connection.streamUntil((type, data) => type == CARTA.RasterTileSync ? data.endSync : false);
                    expect(ack.RasterTileSync.length).toEqual(2); //RasterTileSync: start & end
                    expect(ack.RasterTileData.length).toEqual(assertItem.initTilesReq.tiles.length); //only 1 Tile returned
                }, readFileTimeout);

                describe(`Set histogram requirements:`, () => {
                    test(`(Step 2)"${assertItem.fileOpen[key].file}" REGION_HISTOGRAM_DATA should arrive completely within ${assertItem.cubeHistogramTimeout[key]} ms:`, async () => {
                        await Connection.send(CARTA.SetHistogramRequirements, assertItem.histogram);
                        let RegionHistogramDataTemp = await Connection.receive(CARTA.RegionHistogramData);
                        let ReceiveProgress: number = RegionHistogramDataTemp.progress;

                        if (ReceiveProgress != 1) {
                            while (ReceiveProgress < 1) {
                                RegionHistogramDataTemp = await Connection.receive(CARTA.RegionHistogramData);
                                ReceiveProgress = RegionHistogramDataTemp.progress
                                console.warn('' + value.file + ' Region Histogram progress :', ReceiveProgress)
                            };
                            expect(ReceiveProgress).toEqual(1);
                        };
                    }, assertItem.cubeHistogramTimeout[key]);
                });
            });
            afterAll(async done => {
                await Connection.close();
            }, 10000);
        });
    }
});



