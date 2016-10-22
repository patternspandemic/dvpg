package systems.renderers;

import ecx.System;
import ecx.Wire;

import kha.Color;
import kha.graphics2.Graphics;

import core.KhaRenderService;

class RenderBackgroundSystem extends System {

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {
		var graphics: Graphics = _krs.canvas.g2;
		var bgColor: Color = Color.fromValue(0xFF333333);

		graphics.begin(true, bgColor);
		graphics.end();
	}
}
