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
			var vx: Float = ((Math.random() - 0.5) * 2.0) * 50;
			var vy: Float = ((Math.random() - 0.5) * 2.0) * 50;
			_creator.createDot(
				Math.random() * Project.width,
				Math.random() * Project.height,
				Math.atan2(vy, vx),
				0.8, 0.7,
				vx, vy,
				Color.fromFloats(Math.random(), Math.random(), Math.random())
			);
		}
	}
}
