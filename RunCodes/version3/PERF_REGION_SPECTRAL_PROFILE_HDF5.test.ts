import { CARTA } from "carta-protobuf";
import { Client, AckStream } from "./CLIENT";
import config from "./config2.json";
const WebSocket = require('isomorphic-ws');

let testServerUrl: string = config.serverURL0;
let testSubdirectory: string = config.path.performance;
let connectTimeout: number = config.timeout.connection;
let openFileTimeout: number = config.timeout.openFile;
let readFileTimeout: number = config.timeout.readFile;
let readRegionTimeout: number = config.timeout.region;
let spectralProfileTimeout: number = 120000;

interface AssertItem {
    registerViewer: CARTA.IRegisterViewer;
    filelist: CARTA.IFileListRequest;
    fileOpen: CARTA.IOpenFile[];
    initTilesReq: CARTA.IAddRequiredTiles;
    initSetCursor: CARTA.ISetCursor;
    initSpatialRequirements: CARTA.ISetSpatialRequirements;
    setRegion: CARTA.ISetRegion[];
    setSpectralRequirements: CARTA.ISetSpectralRequirements[];
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
            file: "cube_B_01600_z01000.hdf5",
            hdu: "0",
            fileId: 0,
            renderMode: CARTA.RenderMode.RASTER,
        },
    ],
    initTilesReq: {
        fileId: 0,
        compressionQuality: 11,
        compressionType: CARTA.CompressionType.ZFP,
        tiles: [0],
    },
    initSetCursor: {
        fileId: 0,
        point: { x: 1, y: 1 },
    },
    initSpatialRequirements:
    {
        fileId: 0,
        regionId: 0,
        spatialProfiles: ["x", "y"],
    },
    setRegion: [
        {
            fileId: 0,
            regionId: -1,
            regionInfo: {
                controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
                rotation: 0,
                regionType: 3,

            },
        },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        {
            fileId: 0,
            regionId: -1,
            regionInfo: {
                controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
                regionType: 3,
                rotation: 0,
            },
        },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        {
            fileId: 0,
            regionId: -1,
            regionInfo: {
                controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
                regionType: 3,
                rotation: 0,
            },
        },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        {
            fileId: 0,
            regionId: -1,
            regionInfo: {
                controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
                regionType: 3,
                rotation: 0,
            },
        },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        {
            fileId: 0,
            regionId: -1,
            regionInfo: {
                controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
                regionType: 3,
                rotation: 0,
            },
        },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        {
            fileId: 0,
            regionId: -1,
            regionInfo: {
                controlPoints: [{ x: 800, y: 800 }, { x: 400, y: 400 }],
                regionType: 3,
                rotation: 0,
            },
        },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
        // {
        //     fileId: 0,
        //     regionId: -1,
        //     regionInfo: {
        //         controlPoints: [{ x: 1600, y: 1600 }, { x: 800, y: 800 }],
        //         regionType: 3,
        //         rotation: 0,
        //     },
        // },
    ],
    setSpectralRequirements: [
        {
            spectralProfiles: [{ coordinate: "z", statsTypes: [4] },],
            regionId: 1,
            fileId: 0,
        },
    ],
}

describe("PERF_REGION_SPECTRAL_PROFILE", () => {
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

            describe(`Go to "${assertItem.filelist.directory}" folder`, () => {
                describe(`open the file "${value.directory}/${assertItem.fileOpen[key].file}"`, () => {
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

                    test(`(Step 2)"${assertItem.fileOpen[key].file}" SET_REGION_ACK should arrive within ${readRegionTimeout} ms`, async () => {
                        await Connection.send(CARTA.SetRegion, assertItem.setRegion[key]);
                        await Connection.receive(CARTA.SetRegionAck);
                    }, readRegionTimeout);

                    let ack3: AckStream;
                    test(`(Step 3)"${assertItem.fileOpen[key].file}" SPECTRAL_PROFILE_DATA stream should arrive within ${spectralProfileTimeout} ms`, async () => {
                        await Connection.send(CARTA.SetSpectralRequirements, assertItem.setSpectralRequirements[0]);

                        let SpectralProfileDataTemp = await Connection.receive(CARTA.SpectralProfileData);
                        let ReceiveProgress: number = SpectralProfileDataTemp.progress;
                        console.warn('' + assertItem.fileOpen[key].file + ' SpectralProfileData progress :', ReceiveProgress)


                        if (ReceiveProgress != 1) {
                            while (ReceiveProgress < 1) {
                                SpectralProfileDataTemp = await Connection.receive(CARTA.SpectralProfileData);
                                ReceiveProgress = SpectralProfileDataTemp.progress
                                console.warn('' + assertItem.fileOpen[key].file + ' SpectralProfileData progress :', ReceiveProgress)
                            };
                            expect(ReceiveProgress).toEqual(1);
                        };
                    }, spectralProfileTimeout);
                });
            });
            afterAll(async done => {
                await Connection.close();
            }, 10000);
        });
    }
});



