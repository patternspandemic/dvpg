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

class RenderOnionSystem extends System {

	var _entities: Family<Onion, Settings>;
	var _onion: Wire<Onion>;
	var _settings: Wire<Settings>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {

		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;
		graphics.color = Color.fromValue(0xFF772266);

		for (entity in _entities) {
			if (_settings.get(entity).get('renderOnion')) {
				var onion: Array<Array<FastVector2>> = _onion.get(entity);
				for (ring in onion) {
					graphics.drawPolygon(0, 0, ring.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); }), 4.0);
				}
			}
		}

		graphics.color = c;

		graphics.end();

	}
}
