package systems.generators;

import ecx.System;
import ecx.Wire;

import services.EntityCreatorService;

@:config
class GlobalGraphGeneratorSystem extends System {

	var _creator:Wire<EntityCreatorService>;

	public function new() {}

	override function initialize() {
		_creator.createDelaunayVoronoiGraph();
	}
}
