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

		// For circular layout
		var count: Int = 20;
		var radBetween: Float = 2 * Math.PI / count;

		for (i in 0...count) {
			var x: Float = Math.cos(radBetween * i) * 100;
			var y: Float = Math.sin(radBetween * i) * 100;
			var vx: Float = ((Math.random() - 0.5) * 2.0) * 50;
			var vy: Float = ((Math.random() - 0.5) * 2.0) * 50;
			_creator.createDot(
				x, y,
				Math.atan2(vy, vx),
				0.8, 0.7,
				vx, vy,
				Color.fromFloats(Math.random(), Math.random(), Math.random())
			);
		}
	}
}
