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
import components.*;

class RenderFilledRegionsSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;

	var _entities: Family<Dot, Site, Region>;
	var _dot: Wire<Dot>;
	var _site: Wire<Site>;
	var _region: Wire<Region>;

	var _settings: Wire<Settings>;

	var _krs: Wire<KhaRenderService>;

	public function new() {}

	override function update(): Void {

		var globalGraphEntity = _namedEntities.get('GlobalGraph');
		var globalGraphSettings = _settings.get(globalGraphEntity);

		if (globalGraphSettings.get('renderFilledRegions')) {

			var c: Color;
			var graphics: Graphics = _krs.canvas.g2;

			graphics.begin(false);

			c = graphics.color;

			for (entity in _entities) {
				var color: Color = _dot.get(entity).color;
				var region: Array<FastVector2> = _region.get(entity).regionMap.get(globalGraphEntity.id);
				if (region != null && region.length > 0) {
					graphics.color = color;
					var centroid = polyCentroid(region);
					// This is odd:
					// fillPolygon adds its first two args to each vert in verts, thus offsetting the polygon
					// by centroid. To counteract this, I had to sub centroid from each mapped vert. I think the
					// first 2 args of fillPolygon set where the tri fan starts. I think one could translate to 
					// centroid, fillPolygon at 0, 0, ... then translate -centroid? I thought I tried this :/
					var verts = region.map(function(fv: FastVector2) { return new Vector2(fv.x - centroid.x, fv.y - centroid.y); });
					graphics.fillPolygon(centroid.x, centroid.y, verts);
					graphics.color = Color.Red;
					graphics.drawCircle(centroid.x, centroid.y, 6.0, 3.0);
				}
			}

			graphics.color = c;

			graphics.end();

		}
	}

	function polyCentroid(verts: Array<FastVector2>): Vector2 {
		var areaSixFold: Float = 6 * polyArea(verts);
		var centroid: Vector2 = new Vector2(0.0, 0.0);
		var length: Int = verts.length;
		for (i in 0...length) {
			var iNext = (i + 1) % length;
			var common: Float = (verts[i].x * verts[iNext].y) - (verts[iNext].x * verts[i].y);
			centroid.x += (verts[i].x + verts[iNext].x) * common;
			centroid.y += (verts[i].y + verts[iNext].y) * common;
		}
		centroid.x = centroid.x / areaSixFold;
		centroid.y = centroid.y / areaSixFold;
		return centroid;
	}

	function polyArea(verts: Array<FastVector2>): Float {
		var area: Float = 0.0;
		var length: Int = verts.length;
		for (i in 0...length) {
			var iNext = (i + 1) % length;
			area += (verts[i].x * verts[iNext].y) - (verts[iNext].x * verts[i].y);
		}
		return area / 2.0;
	}
}
