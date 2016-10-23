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

class RenderMinSpanTreeSystem extends System {

	// Delaunay / Voronoi entities would ideally also have component which
	// specifies which things to draw, regions, triangulation, etc.
	var _entities: Family<MinSpanTree>;
	var _minSpanTree: Wire<MinSpanTree>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {
		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;
		graphics.color = Color.fromValue(0xFFFFFFFF);
		for (entity in _entities) {
			var minSpanTree: Array<Array<FastVector2>> = _minSpanTree.get(entity);
			for (line in minSpanTree) {
				graphics.drawLine(line[0].x, line[0].y, line[1].x, line[1].y, 3.0);
			}
		}
		graphics.color = c;

		graphics.end();
	}
}