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
import services.NamedEntityService;
import services.GeometryToolsService;
import components.*;
import components.types.AbstractFastVector2;

class RenderFilledTrianglesSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;
	var _geomTools: Wire<GeometryToolsService>;
	var _triangles: Wire<Triangles>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {

		var globalGraphEntity = _namedEntities.get('GlobalGraph');
		var globalGraphSettings = _settings.get(globalGraphEntity);
		var triangles = _triangles.get(globalGraphEntity).trianglesMap.get(globalGraphEntity.id);
		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;

		var r: Float;
		var g: Float;
		var b: Float;
		var m: Float;
		var color: Color;

		for (triangle in triangles) {
			if (triangle != null && triangle.length > 0) {
				var centroid = _geomTools.polyCentroid(triangle);
				var verts = triangle.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); });
				r = verts[1].sub(centroid).length;
				g = verts[2].sub(centroid).length;
				b = verts[0].sub(centroid).length;
				m = Math.max(r, Math.max(g, b));
				color = Color.fromFloats(r/m, g/m, b/m);

				if (globalGraphSettings.get('renderFilledTriangles')) {
					graphics.color = color;
					graphics.fillTriangle(verts[0].x, verts[0].y, verts[1].x, verts[1].y, verts[2].x, verts[2].y);
				}

				if (globalGraphSettings.get('renderTriangleCentroids')) {
					graphics.color = Color.fromFloats(0.6 * color.R, 0.6 * color.G, 0.6 * color.B, color.A);
					graphics.drawCircle(centroid.x, centroid.y, 3.0, 2.0);
				}

			}
		}

		graphics.color = c;
		graphics.end();
	}
}
