export type PropertyValue = string | number | boolean;

export interface Properties {
	[key: string]: PropertyValue;
}

export interface Point {
	x: number;
	y: number;
}

export interface Vector {
	x: number;
	y: number;
}

export interface Tile {
	id: number;
	type: string;
	properties?: Properties;
}

export interface Tileset {
	name: string;
	firstgid: number;
	filename: string;
	tilewidth: number;
	tileheight: number;
	spacing: number;
	margin: number;
	columns: number;
	image: string;
	imagewidth: number;
	imageheight: number;
	tileoffset: Vector;
	properties: Properties;
	tilecount: number;
	tiles: Tile[];
}

export interface RectangleObject {
	id: number;
	name: string;
	type: string;
	shape: 'rectangle';
	x: number;
	y: number;
	width: number;
	height: number;
	rotation: number;
	gid?: number;
	visible: boolean;
	properties: Properties;
}

export interface PointObject {
	id: number;
	name: string;
	type: string;
	shape: 'point';
	x: number;
	y: number;
	width: number;
	height: number;
	rotation: number;
	gid?: number;
	visible: boolean;
	properties: Properties;
}

export interface EllipseObject {
	id: number;
	name: string;
	type: string;
	shape: 'ellipse';
	x: number;
	y: number;
	width: number;
	height: number;
	rotation: number;
	gid?: number;
	visible: boolean;
	properties: Properties;
}

export interface PolylineObject {
	id: number;
	name: string;
	type: string;
	shape: 'polyline';
	x: number;
	y: number;
	width: number;
	height: number;
	rotation: number;
	gid?: number;
	visible: boolean;
	polyline: Point[];
	properties: Properties;
}

export interface PolygonObject {
	id: number;
	name: string;
	type: string;
	shape: 'polygon';
	x: number;
	y: number;
	width: number;
	height: number;
	rotation: number;
	gid?: number;
	visible: boolean;
	polygon: Point[];
	properties: Properties;
}

type TiledObject =
	| RectangleObject
	| PointObject
	| EllipseObject
	| PolylineObject
	| PolygonObject;

type Layer = TileLayer | ObjectGroup | Group;

/** @luaIterator @tupleReturn */
type TileLayerIterable = Iterable<
	[number, number, number, number, number, number]
>;

export interface TileLayer {
	// tiled exports
	type: 'tilelayer';
	id: number;
	name: string;
	x: number;
	y: number;
	width: number;
	height: number;
	visible: boolean;
	opacity: number;
	offsetx: number;
	offsety: number;
	properties: Properties;
	encoding: 'lua';
	data: number[];

	// cartographer additions
	/** @tupleReturn */
	gridToPixel: (x: number, y: number) => [number, number];
	/** @tupleReturn */
	pixelToGrid: (x: number, y: number) => [number, number];
	/** @tupleReturn */
	getGridBounds: () => [number, number, number, number];
	/** @tupleReturn */
	getPixelBounds: () => [number, number, number, number];
	getTileAtGridPosition: (x: number, y: number) => number | false;
	setTileAtGridPosition: (x: number, y: number, gid: number) => void;
	getTileAtPixelPosition: (x: number, y: number) => number | false;
	setTileAtPixelPosition: (x: number, y: number, gid: number) => void;
	getTiles: () => TileLayerIterable;
	update: (dt: number) => void;
	draw: () => void;
}

export interface ObjectGroup {
	// tiled exports
	type: 'objectgroup';
	id: number;
	name: string;
	visible: boolean;
	opacity: number;
	offsetx: number;
	offsety: number;
	draworder: 'topdown' | 'index';
	properties: Properties;
	objects: TiledObject[];

	// cartographer additions
	/** @tupleReturn */
	gridToPixel: (x: number, y: number) => [number, number];
	/** @tupleReturn */
	pixelToGrid: (x: number, y: number) => [number, number];
	update: (dt: number) => void;
	draw: () => void;
}

export interface Group {
	// tiled exports
	type: 'group';
	id: number;
	name: string;
	visible: boolean;
	opacity: number;
	offsetx: number;
	offsety: number;
	properties: Properties;
	layers: Layer[];

	// cartographer additions
	/** @tupleReturn */
	gridToPixel: (x: number, y: number) => [number, number];
	/** @tupleReturn */
	pixelToGrid: (x: number, y: number) => [number, number];
	getLayer: (...path: string[]) => Layer;
	update: (dt: number) => void;
	draw: () => void;
}

export interface TiledMap {
	// tiled exports
	version: string;
	luaversion: string;
	tiledversion: string;
	orientation: 'orthogonal' | 'isometric' | 'staggered' | 'hexagonal';
	renderorder: 'right-down' | 'right-up' | 'left-down' | 'left-up';
	width: number;
	height: number;
	tilewidth: number;
	tileheight: number;
	nextlayerid: number;
	nextobjectid: number;
	properties: Properties;
	tilesets: Tileset[];
	layers: Layer[];

	// cartographer additions
	getTileset: (gid: number) => Tileset;
	getTile: (gid: number) => Tile;
	getTileType: (gid: number) => string;
	getTileProperty: (gid: number, propertyName: string) => PropertyValue;
	setTileProperty: (
		gid: number,
		propertyName: string,
		propertyValue: PropertyValue
	) => void;
	getLayer: (...path: string[]) => Layer;
	update: (dt: number) => void;
	drawBackground: () => void;
	draw: () => void;
}

export function load(path: string): TiledMap;
