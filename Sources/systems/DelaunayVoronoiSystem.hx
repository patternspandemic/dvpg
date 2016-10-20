package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;

import components.*;

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
			sites.included.clear(); // Clear previous frame's included site entities
			for (sitedEntity in _siteFamily) {
				if (!sites.excluded.has(sitedEntity.id)) {
					// sitedEntity should be included, and its Point pushed to
					// the collection to be passed to Voronnoi. 
					sites.included.set(sitedEntity.id);
					points.push(_site.get(sitedEntity));
				}
			}

			
			
		// Dispose of _voronoi if not null
		// Create new Voronoi with site points and bounds

		// Gather _voronoi.regions and map to _regions component
		// Assign each site entity its region

		// Gather _voronoi.triangles and map to _triangles component (required lib altering)
		// Assign each site entity its triangles

		// Gather _voronoi.delaunayTriangulation and map to _triangulation component (new component required)

		// Gather _voronoi.hull and map to _hulls component

		// Gather _voronoi.spanningTree and map to _minSpanTrees component

		// Calculate the onion and assign to _onions component

		}
	}
}
