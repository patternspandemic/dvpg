package systems.renderers;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.Color;
import kha.math.FastVector2;
import kha.math.Vector2;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

import com.nodename.geom.Circle as GeomCircle;

import core.KhaRenderService;
import components.*;

class RenderCirclesSystem extends System {

	var _entities: Family<Circles, Settings>;
	var _circles: Wire<Circles>;
	var _settings: Wire<Settings>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {

		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;
		graphics.color = Color.fromValue(0xFF222222);

		for (entity in _entities) {
			if (_settings.get(entity).get('renderCircles')) {
				var circles: Array<GeomCircle> = _circles.get(entity);
				for (circle in circles) {
					graphics.fillCircle(circle.center.x, circle.center.y, circle.radius);
				}
			}
		}

		graphics.color = c;

		graphics.end();
	}
}
