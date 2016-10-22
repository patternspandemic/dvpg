package systems.renderers;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.Color;
import kha.math.FastMatrix3;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

import core.KhaRenderService;
import components.*;

class RenderDotSystem extends System {

	var _entities:Family<Transform, Dot>;
	var _transform:Wire<Transform>;
	var _dot:Wire<Dot>;

	var _krs:Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {
		var transform:FastMatrix3;
		var c:Color;
		var graphics:Graphics = _krs.canvas.g2;

		graphics.begin(false);
		for (entity in _entities) {
			transform = _transform.get(entity).transform;
			c = _dot.get(entity).color;
			graphics.color = c;
			graphics.pushTransformation(graphics.transformation.multmat(transform));
			graphics.fillTriangle(
				10.0, 0.0,
				-10.0, 10.0,
				-10.0, -10.0);
			graphics.fillTriangle(
				-15.0, 0.0,
				-10.0, -5.0,
				-10.0, 5.0);
			graphics.popTransformation();
		}
		graphics.end();
	}
}
