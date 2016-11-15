package systems.generators;

import ecx.System;
import ecx.Wire;
import ecx.Entity;

import services.EntityCreatorService;
import services.NamedEntityService;

import components.*;

@:config
class GlobalGraphGeneratorSystem extends System {

	var _creator:Wire<EntityCreatorService>;
	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;

	public function new() {}

	override function initialize() {
		var globalGraph: Entity = _creator.createDelaunayVoronoiGraph();
		var settings = _settings.get(globalGraph);
		settings.set('renderSites', true);
		settings.set('renderRegions', false);
		settings.set('renderFilledRegions', false);
		settings.set('renderRegionCentroids', false);
		settings.set('renderTriangulation', false);
		settings.set('renderFilledTriangles', false);
		settings.set('renderTriangleCentroids', false);
		settings.set('renderHull', false);
		settings.set('renderOnion', false);
		settings.set('renderMinSpanTree', false);
		settings.set('renderCircles', false);
		settings.set('renderBounds', false);
		settings.set('animateSites', true);
		_namedEntities.set('GlobalGraph', globalGraph);
	}
}
