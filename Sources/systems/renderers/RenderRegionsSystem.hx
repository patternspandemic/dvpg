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

class RenderRegionsSystem extends System {

	// Delaunay / Voronoi entities would ideally also have component which
	// specifies which things to draw, regions, triangulation, etc.
	var _entities: Family<Regions>;
	var _regions: Wire<Regions>;

	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	var _krs: Wire<KhaRenderService>;

	var _draw: Bool = false;

	public function new() {}

	override function update(): Void {

		// Toggle drawing with 'r' key up
		var keys = _keys.get(_keysEntities.get(0));
		if (keys.upKeys.has("r".code)) {
			this._draw = !this._draw;
		}

		if (this._draw) {
			var c: Color;
			var graphics: Graphics = _krs.canvas.g2;

			graphics.begin(false);

			c = graphics.color;
			graphics.color = Color.fromValue(0xFF222222);
			for (entity in _entities) {
				var regions: Array<Array<FastVector2>> = _regions.get(entity);
				for (region in regions) {
					graphics.drawPolygon(0, 0, region.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 2.0);
				}
			}
			graphics.color = c;

			graphics.end();
		}
	}
}
