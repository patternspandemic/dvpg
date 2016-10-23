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

	// Delaunay / Voronoi entities would ideally also have component which
	// specifies which things to draw, regions, triangulation, etc.
	var _entities: Family<Hull>;
	var _hull: Wire<Hull>;

	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	var _krs: Wire<KhaRenderService>;

	var _draw: Bool = false;

	public function new() {}

	override function update(): Void {

		// Toggle drawing with 'h' key up
		var keys = _keys.get(_keysEntities.get(0));
		if (keys.upKeys.has("h".code)) {
			this._draw = !this._draw;
		}

		if (this._draw) {
			var c: Color;
			var graphics: Graphics = _krs.canvas.g2;

			graphics.begin(false);

			c = graphics.color;
			graphics.color = Color.fromValue(0xFF117722);
			for (entity in _entities) {
				var hull: Array<FastVector2> = _hull.get(entity);
				graphics.drawPolygon(0, 0, hull.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 4.0);
			}
			graphics.color = c;

			graphics.end();
		}
	}
}
