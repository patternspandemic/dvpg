package systems.renderers;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.Color;
import kha.math.FastVector2;
import kha.math.Vector2;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

import core.KhaRenderService;
import components.*;

class RenderHullSystem extends System {

	var _entities: Family<Hull, Settings>;
	var _hull: Wire<Hull>;
	var _settings: Wire<Settings>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {

		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;
		graphics.color = Color.fromValue(0xFF117722);

		for (entity in _entities) {
			if (_settings.get(entity).get('renderHull')) {
				var hull: Array<FastVector2> = _hull.get(entity);
				graphics.drawPolygon(0, 0, hull.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 4.0);
			}
		}

		graphics.color = c;

		graphics.end();

	}
}
