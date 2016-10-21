package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;

import kha.math.FastVector2;

import components.*;
import components.types.AbstractFastVector2;

import com.nodename.delaunay.Voronoi;
import com.nodename.geom.Point;
import com.nodename.geom.LineSegment;

class DelaunayVoronoiSystem extends System {
	
	var _siteFamily: Family<Site>;
	var _site: Wire<Site>;

	// How to make components optional for the family?
	var _dualGraphFamily: Family<Sites, Triangles, Regions, Hull, Onion, MinSpanTree>; // Cell
	var _sites: Wire<Sites>;
	var _triangles: Wire<Triangles>;
	var _region: Wire<Region>;
	var _regions: Wire<Regions>;
	var _hulls: Wire<Hull>;
	var _onions: Wire<Onion>;
	var _minSpanTrees: Wire<MinSpanTree>;
	//var _cells: Wire<Cell>;

	var _boundsFamily: Family<Bounds>;
	var _bounds: Wire<Bounds>;

	var _voronoi: Voronoi;

	public function new() {}

	override function update(): Void {

		// Get the bounds of the first and only bounded entity
		var bounds = _bounds.get(_boundsFamily.get(0));

		for (graphEntity in _dualGraphFamily) {

			// Gather site Points, record site entity ids into sites component
			var points: Array<Point> = new Array<Point>(); 
			var sites = _sites.get(graphEntity); // Sites component of graphEntity
			var includedEntities: Array<Entity> = new Array<Entity>();
			sites.included.clear(); // Clear previous frame's included site entities
			for (sitedEntity in _siteFamily) {
				if (!sites.excluded.has(sitedEntity.id)) {
					// sitedEntity should be included, and its Point pushed to
					// the collection to be passed to Voronnoi. 
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
			var allTriangles: Array<Array<FastVector2>> = new Array<Array<FastVector2>>();
			var includedEntity: Entity;
			for (i in 0...includedEntities.length) {
				includedEntity = includedEntities[i]; // Alligned with points array

				// Get its Point referenced region mapped to Region component type
				region = _voronoi.region(points[i]).map(pointToFastVector2);
				// Assign to the included entity's Region componnent if it has one
				if (_region.has(includedEntity)) {
					_region.get(includedEntity).regionMap.set(graphEntity.id, region);
				}
				// And push to the collection of allRegions to be assigned to
				// graphEntity's Regions component
				allRegions.push(region);

				// TODO: Triangles require mods to hxDelaunay lib
				// triangles = _voronoi.??..map(arrayOfPointToFastVector2);
				// if (_triangles.has(includedEntity)) {
				// 	_triangles.get(includedEntity).trianglesMap.set(graphEntity.id, triangles);
				// }
				// And push to the collection of allTriangles to be assigned to
				// graphEntity's Triangles component
				// allTriangles.push(triangles);
			}
			// Assign collections of all regions and triangles to the graphEntity
			_regions.set(graphEntity, allRegions);
			// _triangles.get(graphEntity).trianglesMap.set(graphEntity, allTriangles); // Non-optimized for graph entities

		// Gather _voronoi.delaunayTriangulation and map to _triangulation component (new component required)

		// Gather _voronoi.hull and map to _hulls component

		// Gather _voronoi.spanningTree and map to _minSpanTrees component

		// Calculate the onion and assign to _onions component

		}
	}

	private inline function arrayOfPointToFastVector2(points: Array<Point>): Array<FastVector2> {
		return points.map(pointToFastVector2);
	}

	private inline function pointToFastVector2(p: Point): FastVector2 {
		return AbstractFastVector2.fromPoint(p);
	}
}
