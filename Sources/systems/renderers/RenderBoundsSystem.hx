package systems.renderers;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.Color;
import kha.math.FastVector2;
import kha.math.Vector2;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

import services.NamedEntityService;
import core.KhaRenderService;
import components.*;

class RenderBoundsSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _bounds: Wire<Bounds>;
	var _settings: Wire<Settings>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {

		var bounds = _bounds.get(_namedEntities.get('InsetBounds'));
		var globalGraphSettings = _settings.get(_namedEntities.get('GlobalGraph'));

		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;
		graphics.color = Color.fromValue(0xFF222222);

		if (globalGraphSettings.get('renderBounds')) {
			graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, 3.0);
		}

		graphics.color = c;

		graphics.end();

	}
}
