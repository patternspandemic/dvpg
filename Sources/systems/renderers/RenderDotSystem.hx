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

	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	var _krs:Wire<KhaRenderService>;

	var _draw: Bool = true;

	public function new() {}

	override function update(): Void {

		// Toggle drawing with 's' key up
		var keys = _keys.get(_keysEntities.get(0));
		if (keys.upKeys.has("s".code)) {
			this._draw = !this._draw;
		}

		if (this._draw) {
			var transform: FastMatrix3;
			var c: Color;
			var prevC: Color;
			var graphics: Graphics = _krs.canvas.g2;

			graphics.begin(false);
			prevC = graphics.color;

			for (entity in _entities) {
				transform = _transform.get(entity).transform;
				c = _dot.get(entity).color;
				graphics.pushTransformation(graphics.transformation.multmat(transform));
				graphics.color = Color.fromValue(0xFF333333);
				graphics.fillTriangle(
					17.0, 0.0,
					-14.0, 15.0,
					-14.0, -15.0);
				graphics.color = c;
				graphics.fillTriangle(
					10.0, 0.0,
					-10.0, 10.0,
					-10.0, -10.0);
				graphics.color = Color.fromValue(0xFF333333);
				graphics.fillTriangle(
					-19.0, 0.0,
					-10.0, -9.0,
					-10.0, 9.0);
				graphics.color = c;
				graphics.fillTriangle(
					-15.0, 0.0,
					-10.0, -5.0,
					-10.0, 5.0);
				graphics.popTransformation();
			}
			
			graphics.color = prevC;
			graphics.end();
		}
	}
}
