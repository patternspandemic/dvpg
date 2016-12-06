package systems.renderers;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;

import kha.Color;
import kha.math.FastVector2;
import kha.math.Vector2;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

import com.nodename.geom.Circle as GeomCircle;

import services.NamedEntityService;
import services.GeometryToolsService;
import core.KhaRenderService;

import components.*;

class RenderGlobalGraphSystem extends System {

	// General Wires
	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;

	// Families
	var _circlesFamily: Family<Circles, Settings>;
	var _hullFamily: Family<Hull, Settings>;
	var _minSpanTreeFamily: Family<MinSpanTree, Settings>;
	var _onionFamily: Family<Onion, Settings>;
	var _regionsFamily: Family<Regions, Settings>;
	var _siteRegionFamily: Family<Dot, Site, Region>;
	var _triangulationFamily: Family<Triangulation, Settings>;

	// Components
	var _bounds: Wire<Bounds>;
	var _circles: Wire<Circles>;
	var _dot: Wire<Dot>;
	var _hull: Wire<Hull>;
	var _minSpanTree: Wire<MinSpanTree>;
	var _onion: Wire<Onion>;
	var _region: Wire<Region>;
	var _regions: Wire<Regions>;
	var _site: Wire<Site>;
	var _triangles: Wire<Triangles>;
	var _triangulation: Wire<Triangulation>;

	// Drawing Wires
	var _krs: Wire<KhaRenderService>;
	var _geomTools: Wire<GeometryToolsService>;

	// System State
	var _c: Color;

	public function new() {}

	override function update(): Void {
		var globalGraphEntity = _namedEntities.get('GlobalGraph');
		var globalGraphSettings = _settings.get(globalGraphEntity);
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		if (globalGraphSettings.get('renderBounds')) renderBounds(graphics);
		if (globalGraphSettings.get('renderFilledRegions')) renderFilledRegions(graphics, globalGraphEntity);
		if (globalGraphSettings.get('renderRegionCentroids')) renderRegionCentroids(graphics, globalGraphEntity);
		if (globalGraphSettings.get('renderRegions')) renderRegions(graphics);
		if (globalGraphSettings.get('renderCircles')) renderCircles(graphics);
		if (globalGraphSettings.get('renderFilledTriangles')) renderFilledTriangles(graphics, globalGraphEntity);
		if (globalGraphSettings.get('renderTriangleCentroids')) renderTriangleCentroids(graphics, globalGraphEntity);
		if (globalGraphSettings.get('renderTriangulation')) renderTriangulation(graphics);
		if (globalGraphSettings.get('renderOnion')) renderOnion(graphics);
		if (globalGraphSettings.get('renderHull')) renderHull(graphics);
		if (globalGraphSettings.get('renderMinSpanTree')) renderMinSpanTree(graphics);

		graphics.end();
	}

	inline function renderBounds(graphics: Graphics): Void {
		var bounds = _bounds.get(_namedEntities.get('InsetBounds'));
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFF222222);
		graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, 3.0);
		graphics.color = _c;
	}

	inline function renderFilledRegions(graphics: Graphics, globalGraphEntity: Entity): Void {
		_c = graphics.color;
		for (entity in _siteRegionFamily) {
			var color: Color = _dot.get(entity).color;
			var region: Array<FastVector2> = _region.get(entity).regionMap.get(globalGraphEntity.id);
			if (region != null && region.length > 0) {
				var centroid = _geomTools.polyCentroid(region);	
				graphics.color = color;
				var verts = region.map(function(fv: FastVector2) { return new Vector2(fv.x - centroid.x, fv.y - centroid.y); });
				graphics.fillPolygon(centroid.x, centroid.y, verts);
			}
		}
		graphics.color = _c;
	}
	// TODO: Optimize renderFilledRegions and renderRegionCentroids
	inline function renderRegionCentroids(graphics: Graphics, globalGraphEntity: Entity): Void {
		_c = graphics.color;
		for (entity in _siteRegionFamily) {
			var color: Color = _dot.get(entity).color;
			var region: Array<FastVector2> = _region.get(entity).regionMap.get(globalGraphEntity.id);
			if (region != null && region.length > 0) {
				var centroid = _geomTools.polyCentroid(region);
				graphics.color = Color.fromFloats(0.6 * color.R, 0.6 * color.G, 0.6 * color.B, color.A);
				graphics.drawCircle(centroid.x, centroid.y, 6.0, 3.0);
			}
		}
		graphics.color = _c;
	}

	inline function renderRegions(graphics: Graphics): Void {
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFF222222);
		for (entity in _regionsFamily) {
			var regions: Array<Array<FastVector2>> = _regions.get(entity);
			for (region in regions) {
				if (region.length > 0) { // Don't draw empty regions
					graphics.drawPolygon(0, 0, region.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 2.0);
				}
			}
		}
		graphics.color = _c;
	}

	inline function renderCircles(graphics: Graphics): Void {
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFF222222);
		for (entity in _circlesFamily) {
			var circles: Array<GeomCircle> = _circles.get(entity);
			for (circle in circles) {
				graphics.fillCircle(circle.center.x, circle.center.y, circle.radius);
			}
		}
		graphics.color = _c;
	}

	inline function renderFilledTriangles(graphics: Graphics, globalGraphEntity: Entity): Void {
		_c = graphics.color;
		var triangles = _triangles.get(globalGraphEntity).trianglesMap.get(globalGraphEntity.id);
		var r: Float;
		var g: Float;
		var b: Float;
		var m: Float;
		var color: Color;
		for (triangle in triangles) {
			if (triangle != null && triangle.length > 0) {
				var centroid = _geomTools.polyCentroid(triangle);
				var verts = triangle.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); });
				r = verts[1].sub(centroid).length;
				g = verts[2].sub(centroid).length;
				b = verts[0].sub(centroid).length;
				m = Math.max(r, Math.max(g, b));
				color = Color.fromFloats(r/m, g/m, b/m);
				graphics.color = color;
				graphics.fillTriangle(verts[0].x, verts[0].y, verts[1].x, verts[1].y, verts[2].x, verts[2].y);
			}
		}
		graphics.color = _c;
	}
	// TODO: Optimize renderFilledTriangles and renderTriangleCentroids
	inline function renderTriangleCentroids(graphics: Graphics, globalGraphEntity: Entity): Void {
		_c = graphics.color;
		var triangles = _triangles.get(globalGraphEntity).trianglesMap.get(globalGraphEntity.id);
		var r: Float;
		var g: Float;
		var b: Float;
		var m: Float;
		var color: Color;
		for (triangle in triangles) {
			if (triangle != null && triangle.length > 0) {
				var centroid = _geomTools.polyCentroid(triangle);
				var verts = triangle.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); });
				r = verts[1].sub(centroid).length;
				g = verts[2].sub(centroid).length;
				b = verts[0].sub(centroid).length;
				m = Math.max(r, Math.max(g, b));
				color = Color.fromFloats(r/m, g/m, b/m);
				graphics.color = Color.fromFloats(0.6 * color.R, 0.6 * color.G, 0.6 * color.B, color.A);
				graphics.drawCircle(centroid.x, centroid.y, 3.0, 2.0);
			}
		}
		graphics.color = _c;
	}

	inline function renderTriangulation(graphics: Graphics): Void {
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFF444444);
		for (entity in _triangulationFamily) {
			var triangulation: Array<Array<FastVector2>> = _triangulation.get(entity);
			for (triangle in triangulation) {
				graphics.drawPolygon(0, 0, triangle.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 2.0);
			}
		}
		graphics.color = _c;
	}

	inline function renderOnion(graphics: Graphics): Void {
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFF772266);
		for (entity in _onionFamily) {
			var onion: Array<Array<FastVector2>> = _onion.get(entity);
			for (ring in onion) {
				graphics.drawPolygon(0, 0, ring.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 4.0);
			}
		}
		graphics.color = _c;
	}

	inline function renderHull(graphics: Graphics): Void {
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFF117722);
		for (entity in _hullFamily) {
			var hull: Array<FastVector2> = _hull.get(entity);
			graphics.drawPolygon(0, 0, hull.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 4.0);
		}
		graphics.color = _c;
	}

	inline function renderMinSpanTree(graphics: Graphics): Void {
		_c = graphics.color;
		graphics.color = Color.fromValue(0xFFFFFFFF);
		for (entity in _minSpanTreeFamily) {
			var minSpanTree: Array<Array<FastVector2>> = _minSpanTree.get(entity);
			for (line in minSpanTree) {
				graphics.drawLine(line[0].x, line[0].y, line[1].x, line[1].y, 3.0);
			}
		}
		graphics.color = _c;
	}
}
