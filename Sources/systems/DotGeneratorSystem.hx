package systems;

import ecx.System;
import ecx.Wire;

import kha.Color;

import services.EntityCreatorService;

@:config
class DotGeneratorSystem extends System {

	var _creator:Wire<EntityCreatorService>;

	public function new() {}

	override function initialize() {
		for (i in 0...20) {
			_creator.createDot(
				Math.random() * Project.width,
				Math.random() * Project.height,
				(Math.random() * 50) - 5,
				(Math.random() * 50) - 5,
				Color.fromFloats(Math.random(), Math.random(), Math.random())
			);
		}
	}
}
