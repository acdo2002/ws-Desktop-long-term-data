import { CARTA } from "carta-protobuf";
import { Client, AckStream } from "./CLIENT";
import config from "./config2.json";
const WebSocket = require('isomorphic-ws');

let testServerUrl: string = config.serverURL0;
let testSubdirectory: string = config.path.performance;
let connectTimeout: number = config.timeout.connection;
let openFileTimeout: number = 5000;//config.timeout.openFile;
let readFileTimeout: number = 5000;//config.timeout.readFile;

interface AssertItem {
    registerViewer: CARTA.IRegisterViewer;
    filelist: CARTA.IFileListRequest;
    fileOpen: CARTA.IOpenFile[];
    addTilesReq: CARTA.IAddRequiredTiles[];
    setCursor: CARTA.ISetCursor;
    setImageChannel: CARTA.ISetImageChannels[];
    initTilesReq: CARTA.IAddRequiredTiles;
    initSetCursor: CARTA.ISetCursor;
    initSpatialRequirements: CARTA.ISetSpatialRequirements;
}
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
    addTilesReq: [
        {
            fileId: 0,
            compressionQuality: 11,
            compressionType: CARTA.CompressionType.ZFP,
            tiles: [33558529, 33558528, 33554433, 33554432, 33562625, 33558530, 33562624, 33554434, 33562626],
        },
        {
            fileId: 0,
            compressionQuality: 11,
            compressionType: CARTA.CompressionType.ZFP,
            tiles: [67125252, 67129348, 67125253, 67129349, 67125251, 67121156, 67129347, 67121157, 67121155, 67133444, 67125254, 67133445, 67129350, 67133443, 67121158, 67125250, 67117060, 67129346, 67117061, 67121154, 67117059, 67133446, 67137540, 67125255, 67133442, 67117062, 67137541, 67129351, 67137539, 67121159, 67117058, 67125249, 67129345, 67137542, 67133447, 67121153, 67137538, 67117063, 67133441, 67125256, 67117057, 67129352, 67137543, 67121160, 67125248, 67133448, 67137537, 67129344, 67121152, 67117064, 67133440, 67117056, 67137544, 67137536],
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
        spatialProfiles: [{coordinate:"x"}, {coordinate:"y"}],
    },
}


describe("PERF_RASTER_TILE_DATA", () => {
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
                        let OpenAck = await Connection.openFile(value); // OpenFileAck | RegionHistogramData
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

                    let ack2: AckStream;
                    test(`(Step 2)"${assertItem.fileOpen[key].file}" RasterTileData responses should arrive within ${readFileTimeout} ms`, async () => {
                        await Connection.send(CARTA.AddRequiredTiles, assertItem.addTilesReq[1]);

                        ack2 = await Connection.streamUntil((type, data) => type == CARTA.RasterTileSync ? data.endSync : false);
                        let ack2RasterTile = ack2.RasterTileData
                        expect(ack2RasterTile.length).toBe(assertItem.addTilesReq[1].tiles.length)
                    }, readFileTimeout);
                });
            });
            afterAll(async done => {
                await Connection.close();
            }, 10000);
        });
    };
});


