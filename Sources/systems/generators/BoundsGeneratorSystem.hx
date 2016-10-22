package systems.generators;

import ecx.System;
import ecx.Wire;

import services.EntityCreatorService;
import core.KhaRenderService;

import components.*;

@:config
class BoundsGeneratorSystem extends System {

	var _creator: Wire<EntityCreatorService>;
	var _krs: Wire<KhaRenderService>;
	var _bounds: Wire<Bounds>;

	public function new() {}

	override function initialize() {
		// Generate a bounds entity with the component initialized to
		// the canvas' size, but with coordinates centered around the
		// canvas origin, which should be center window.
		var halfWidth = _krs.canvas.width / 2;
		var halfHeight = _krs.canvas.height / 2;
		var bounds = _bounds.get(_creator.createBounds());
		bounds.setTo(
			halfWidth * -1,
			halfHeight * -1,
			halfWidth * 2,
			halfHeight * 2
		);
	}
}