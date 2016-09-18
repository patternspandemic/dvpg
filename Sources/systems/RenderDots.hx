package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.Framebuffer;
import kha.Color;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

import core.KhaRenderService;
import components.Position;
import components.Dot;

class RenderDots extends System {
	
	var _entities:Family<Position, Dot>;
	var _position:Wire<Position>;
	var _dot:Wire<Dot>;

	var _krs:Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {
		var x:Float;
		var y:Float;
		var c:Color;
		var graphics:Graphics = _krs.canvas.g2;

		graphics.begin();
		for (entity in _entities) {
			x = _position.get(entity).x;
			y = _position.get(entity).y;
			c = _dot.get(entity).color;
			graphics.color = c;
			graphics.drawCircle(x, y, 5.0, 3.0);
		}

		graphics.drawCircle(128, 128, 10, 5, 16);

		graphics.end();
	}
}
