import { CARTA } from "carta-protobuf";
import { Client, AckStream, Wait } from "./CLIENT";
import config from "./config2.json";
const WebSocket = require('isomorphic-ws');
import * as Socket from "./SocketOperation-mylin-1.4";

let testServerUrl = config.serverURL0;
let testSubdirectory = config.path.performance;
let connectTimeout = config.timeout.connection;
let readFileTimeout = 5000;//config.timeout.readFile;
let regionTimeout = 5000;//config.timeout.region;
let momentTimeout = 400000;//config.timeout.moment;
let sleepTimeout: number = config.timeout.sleep;

interface AssertItem {
    precisionDigit: number;
    registerViewer: CARTA.IRegisterViewer;
    openFile: CARTA.IOpenFile[];
    setRegion: CARTA.ISetRegion;
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
           directory: testSubdirectory + "/cube_B",
           file: "HD163296_CO_2_1.fits",
           hdu: "0",
           fileId: 0,
           renderMode: CARTA.RenderMode.RASTER,
       },
        {
            directory: testSubdirectory + "/cube_B",
            file: "HD163296_CO_2_1.image",
            fileId: 0,
            renderMode: CARTA.RenderMode.RASTER,
        },
       {
           directory: testSubdirectory + "/cube_B",
           file: "HD163296_CO_2_1.hdf5",
           hdu: "0",
           fileId: 0,
           renderMode: CARTA.RenderMode.RASTER,
       },
    ],
    setRegion: {
        fileId: 0,
        regionId: -1,
        regionInfo: {
            regionType: CARTA.RegionType.RECTANGLE,
            controlPoints: [{ x: 181.0, y: 261.0 }, { x: 380.0, y: 415.0 }],
            // controlPoints: [{ x: 218, y: 218.0 }, { x: 200.0, y: 200.0 }],
            rotation: 0,
        },
    },
    setSpectralRequirements: {
        fileId: 0,
        regionId: 1,
        spectralProfiles: [{ coordinate: "z", statsTypes: [CARTA.StatsType.Mean] }],
    },
    momentRequest: {
        fileId: 0,
        regionId: 1,
        axis: CARTA.MomentAxis.SPECTRAL,
        mask: CARTA.MomentMask.Include,
        moments: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        pixelRange: { min: 0.1, max: 1.0 },
        spectralRange: { min: 0, max: 249 },
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
            // beforeAll(async()=>{
            //     cartaBackend = await Socket.CartaBackend();
            //     await Wait(1000);
            // },20000)

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
    
                    let ack: AckStream;
                    test(`(Step 2)"${assertItem.openFile[key].file}" Set region, the responses should arrive within ${regionTimeout} ms`, async () => {
                        await Connection.send(CARTA.SetRegion, assertItem.setRegion);
                        await Connection.send(CARTA.SetSpectralRequirements, assertItem.setSpectralRequirements);
                        let temp = await Connection.receive(CARTA.SetRegionAck);
                        expect(temp.success).toEqual(true);
                        // let temp2 = await Connection.receive(CARTA.SpectralProfileData);
                        let temp2 = await Connection.streamUntil((type, data) => type == CARTA.SpectralProfileData ? data.progress == 1 : false);
                        // expect(temp2.SpectralProfileData[0].progress).toEqual(1);
                    }, readFileTimeout);
                });
            });

            let FileId: number[] = [];
            describe(`Moment generator`, () => {
                let ack: AckStream;
                test(`(Step 3)"${assertItem.openFile[key].file}": Receive a series of moment progress within ${momentTimeout}ms`, async () => {
                    await sleep(sleepTimeout);
                    await Connection.send(CARTA.MomentRequest, assertItem.momentRequest);
                    ack = await Connection.streamUntil(type => type == CARTA.MomentResponse);
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

                // test(`Assert openFileAcks[].fileInfoExtended`,()=>{
                //     ack.MomentResponse[0].openFileAcks.map(ack => {
                //         const coord = assertItem.setRegion.regionInfo.controlPoints;
                //         expect(ack.fileInfoExtended.height).toEqual(coord[1].y + 1);
                //         expect(ack.fileInfoExtended.width).toEqual(coord[1].x + 1);
                //         expect(ack.fileInfoExtended.dimensions).toEqual(3);
                //         expect(ack.fileInfoExtended.depth).toEqual(1);
                //         expect(ack.fileInfoExtended.stokes).toEqual(1);
                //     });
                // });

                // test(`Assert openFileAcks[].fileInfoExtended.headerEntries.length = 47`,()=>{
                //     ack.MomentResponse[0].openFileAcks.map((ack,index)=>{
                //         expect(ack.fileInfoExtended.headerEntries.length).toEqual(47);
                //     });
                // });

                // test(`Assert openFileAcks[].fileInfoExtended.computedEntries.length = 13`,()=>{
                //     ack.MomentResponse[0].openFileAcks.map((ack,index)=>{
                //         expect(ack.fileInfoExtended.computedEntries.length).toEqual(13);
                //     });
                // });
            });

            describe(`Requset moment image`,()=>{
                let RasterTileSync: CARTA.RasterTileSync[] = [];
                let RasterTileData: CARTA.RasterTileData[] = [];
                test(`(Step 4)"${assertItem.openFile[key].file}": Receive all image data until RasterTileSync.endSync = true, within ${readFileTimeout}ms`,async()=>{
                    for (let idx = 0; idx < FileId.length; idx++){
                        await Connection.send(CARTA.AddRequiredTiles,{
                            fileId: FileId[idx],
                            tiles: [0],
                            compressionType: CARTA.CompressionType.NONE,
                            compressionQuality: 0,
                        });
                        await Connection.streamUntil((type, data) => type == CARTA.RasterTileSync ? data.endSync : false).then(ack =>{
                            // let tt1 = ack.RasterTileSync.slice(-1);
                            RasterTileSync.push(...ack.RasterTileSync.slice(-1));
                            RasterTileData.push(...ack.RasterTileData);
                        });
                    };
                    RasterTileSync.map(ack => {
                        expect(ack.endSync).toBe(true);
                    });
                }, readFileTimeout);

                test(`Assert RASTER_TILE_SYNC.fileId`,()=>{
                    RasterTileData.map((ack,index) => {
                        expect(ack.fileId).toEqual(FileId[index]);
                    });
                });

                test(`Receive RASTER_TILE_DATA`,()=>{
                    expect(RasterTileData.length).toEqual(FileId.length);
                });

                test(`Assert RASTER_TILE_DATA.fileId`,()=>{
                    RasterTileData.map((ack,index)=>{
                        expect(ack.fileId).toEqual(FileId[index]);
                    });
                });

                // test(`Assert RASTER_TILE_DATA.tiles`,()=>{
                //     RasterTileData.map(ack=>{
                //         expect(ack.tiles[0].height).toEqual(251);
                //         expect(ack.tiles[0].width).toEqual(251);
                //         expect(ack.tiles[0].imageData.length).toEqual(251 * 251 * 4);
                //         expect(ack.tiles[0].nanEncodings.length).toEqual(0);
                //     });
                // });

                // test(`Assert RASTER_TILE_DATA.tiles[0].imageData[5][5]`,()=>{
                //     RasterTileData.map((ack,index)=>{
                //         const data = (new Float32Array(ack.tiles[0].imageData.slice().buffer));
                //         // console.log(data[5*5])
                //         expect(data[5*5]).toBeCloseTo(intensity[index], assertItem.precisionDigit);
                //     });
                // });
            });
            // afterAll(() => Connection.close());
            afterAll(async done => {
                await Connection.close();
                // cartaBackend.kill();
                // await Wait(5000);
                // cartaBackend.on("close", () => done());
            }, 10000);
        });
    };
});
