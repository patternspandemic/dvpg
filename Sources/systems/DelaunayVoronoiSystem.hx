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
	
	// How to make components optional for the family?
	var _dualGraphs: Family<Sites, Triangles, Regions, Hull, Onion, MinSpanTree>; // Cell
	var _sites: Wire<Sites>;
	var _triangles: Wire<Triangles>;
	var _regions: Wire<Regions>;
	var _hulls: Wire<Hull>;
	var _onions: Wire<Onion>;
	var _minSpanTrees: Wire<MinSpanTree>;
	//var _cells: Wire<Cell>;

	var _boundedEntities: Family<Bounds>;
	var _bounds: Wire<Bounds>;

	public function new() {}

	override function update(): Void {

		// Get the bounds of the first and only bounded entity
		var bounds = _bounds.get(_boundedEntities.get(0));

	}
}
