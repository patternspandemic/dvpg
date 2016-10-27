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

class RenderFilledTrianglesSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _geomTools: Wire<GeometryToolsService>;
	var _dot: Wire<Dot>;
	var _site: Wire<Sites>;
	var _triangles: Wire<Triangles>;

	var _settings: Wire<Settings>;

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


		// var color: Color = _dot.get(entity).color;
		var color: Color = Color.Green;

		for (triangle in triangles) {
			if (triangle != null && triangle.length > 0) {
				var centroid = _geomTools.polyCentroid(triangle);

				if (globalGraphSettings.get('renderFilledTriangles')) {
					graphics.color = color;
					var verts = triangle.map(function(fv: FastVector2) { return new Vector2(fv.x, fv.y); });
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
