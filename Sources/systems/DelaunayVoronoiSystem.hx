package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;

import kha.math.FastVector2;

import components.*;
import components.types.AbstractFastVector2; // TODO: Remove abstract

import com.nodename.delaunay.Voronoi;
import com.nodename.delaunay.Triangle;
import com.nodename.geom.Point;
import com.nodename.geom.LineSegment;
import com.nodename.geom.Rectangle;
import com.nodename.geom.Circle as GeomCircle;

class DelaunayVoronoiSystem extends System {
	
	var _siteFamily: Family<Site>;
	var _site: Wire<Site>;
	var _region: Wire<Region>;
	var _triangles: Wire<Triangles>;
	var _circle: Wire<Circle>;

	// How to make components optional for the family?
	var _dualGraphFamily: Family<Sites, Triangles, Triangulation, Regions, Hull, Onion, MinSpanTree, Circles>; // Cell
	var _sites: Wire<Sites>;
	var _triangulation: Wire<Triangulation>;
	var _regions: Wire<Regions>;
	var _hull: Wire<Hull>;
	var _onion: Wire<Onion>;
	var _minSpanTree: Wire<MinSpanTree>;
	var _circles: Wire<Circles>;
	//var _cells: Wire<Cell>;

	var _boundsFamily: Family<Bounds>;
	var _bounds: Wire<Bounds>;

	var _voronoi: Voronoi;

	public function new() {}

	@:access(com.nodename.delaunay.Voronoi._triangles)
	override function update(): Void {

		// Get the bounds of the first and only bounded entity
		var bounds: Rectangle = _bounds.get(_boundsFamily.get(0));

		for (graphEntity in _dualGraphFamily) {

			// Gather site Points, record site entity ids into sites component
			var points: Array<Point> = new Array<Point>(); 
			var sites = _sites.get(graphEntity); // Sites component of graphEntity
			var includedEntities: Array<Entity> = new Array<Entity>();
			sites.included.clear(); // Clear previous frame's included site entities
			for (sitedEntity in _siteFamily) {
				if (!sites.excluded.has(sitedEntity.id)) {
					// sitedEntity should be included, and its Point pushed to
					// the collection to be passed to Voronoi.
					sites.included.set(sitedEntity.id);
					includedEntities.push(sitedEntity);
					points.push(_site.get(sitedEntity));
				}
			}

			// Dispose of previous _voronoi and recalculate
			if (_voronoi != null) {
				_voronoi.dispose();
				_voronoi = null;
			}
			_voronoi = new Voronoi(points, null, bounds);

			// Gather _voronoi regions & triangles, map to respective components
			var region: Array<FastVector2>;
			var allRegions: Array<Array<FastVector2>> = new Array<Array<FastVector2>>();
			var triangles: Array<Array<FastVector2>>;
			var allTriangles: Array<Array<FastVector2>>; // = new Array<Array<FastVector2>>();
			var circle: GeomCircle;
			var allCircles: Array<GeomCircle>;
			var includedEntity: Entity;

			// TEMP
			allTriangles = _voronoi._triangles.map(triangleToArrayOfFastVector2);
			// TEMP ?
			allCircles = _voronoi.circles();

			for (i in 0...includedEntities.length) {
				includedEntity = includedEntities[i]; // Alligned with points array

				// Get its Point referenced region mapped to Region component type
				region = _voronoi.region(points[i]).map(pointToFastVector2);
				// Assign to the included entity's Region component if it has one
				if (_region.has(includedEntity)) {
					_region.get(includedEntity).regionMap.set(graphEntity.id, region);
				}
				// And push to the collection of allRegions to be assigned to
				// graphEntity's Regions component
				allRegions.push(region);

				// TODO
				// triangles = _voronoi.triangles(points[i]).map(triangleToArrayOfFastVector2);

				// TEMPORARY - Dig through allTriangles to find includedEntity's tris
				// triangles = triangleFilter(allTriangles, AbstractFastVector2.fromPoint(points[i]));
				var v: FastVector2 = AbstractFastVector2.fromPoint(points[i]);
				triangles = allTriangles.filter(function(t: Array<FastVector2>) {
					var res: Bool = false;
					for (tv in t) {
						if (tv.x == v.x && tv.y == v.y) {
							res = true;
							break;
						}
					}
					return res;
				});

				// Assign to the includedEntity's Triangles component if it has one
				if (_triangles.has(includedEntity)) {
					_triangles.get(includedEntity).trianglesMap.set(graphEntity.id, triangles);
				}
				// And push to the collection of allTriangles to be assigned to
				// graphEntity's Triangles component
				// allTriangles.push(triangles);

				// TEMPORARY - Dig through allCircles to find includedEntity's circle
				var p: Point = points[i];
				circle = allCircles.filter(function(c: GeomCircle) {
					return (c.center.x == p.x && c.center.y == p.y);
				}).pop();

				if (circle != null && _circle.has(includedEntity)) {
					_circle.get(includedEntity).circleMap.set(graphEntity.id, circle);
				}
			}

			// Assign collections of all regions, triangles, and circles to the graphEntity
			_regions.set(graphEntity, allRegions);
			_triangles.get(graphEntity).trianglesMap.set(graphEntity.id, allTriangles); // Non-optimized for graph entities
			_circles.set(graphEntity, allCircles);

			// Gather delaunay triangulation and map to _triangulation component on graphEntity
			var triangulation: Array<Array<FastVector2>>;
			triangulation = _voronoi.delaunayTriangulation().map(lineSegmentToArrayOfFastVector2);
			_triangulation.set(graphEntity, triangulation);

			// Gather hull and map to _hulls component on graphEntity
			var hull: Array<FastVector2>;
			hull = _voronoi.hullPointsInOrder().map(pointToFastVector2);
			_hull.set(graphEntity, hull);

			// Gather spanningTree and map to _minSpanTree component on graphEntity
			var mst: Array<Array<FastVector2>>;
			mst = _voronoi.spanningTree().map(lineSegmentToArrayOfFastVector2);
			_minSpanTree.set(graphEntity, mst);

			// Generate the onion and assign to _onion component on graphEntity
			var onion: Array<Array<FastVector2>>;
			onion = generateOnion(_voronoi, bounds);
			_onion.set(graphEntity, onion);
		}
	}

	private function triangleToArrayOfFastVector2(tri: Triangle): Array<FastVector2> {
		var result: Array<FastVector2> = new Array<FastVector2>();
		for (s in tri.sites) {
			result.push(AbstractFastVector2.fromPoint(s.coord));
		}
		return result;
	}

	private inline function arrayOfPointToFastVector2(points: Array<Point>): Array<FastVector2> {
		return points.map(pointToFastVector2);
	}

	private inline function lineSegmentToArrayOfFastVector2(line: LineSegment): Array<FastVector2> {
		return [
			pointToFastVector2(line.p0),
			pointToFastVector2(line.p1)
		];
	}

	private inline function pointToFastVector2(p: Point): FastVector2 {
		return AbstractFastVector2.fromPoint(p);
	}

	private function generateOnion(voronoi: Voronoi, bounds: Rectangle): Array<Array<FastVector2>> {
		var onion = new Array<Array<Point>>();
		var points = voronoi.siteCoords();

		while (points.length > 2) {
			var v: Voronoi = new Voronoi(points, null, bounds);
			var peel: Array<Point> = v.hullPointsInOrder();
			for (p in peel) points.remove(p);
			onion.push(peel);
			v.dispose();
			v = null;
		}

		if (points.length > 0) onion.push(points);

		return onion.map(arrayOfPointToFastVector2);
	}
}
