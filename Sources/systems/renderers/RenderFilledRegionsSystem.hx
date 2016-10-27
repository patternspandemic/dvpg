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

class RenderFilledRegionsSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _geomTools: Wire<GeometryToolsService>;

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
		var c: Color;
		var graphics: Graphics = _krs.canvas.g2;

		graphics.begin(false);

		c = graphics.color;

		for (entity in _entities) {
			var color: Color = _dot.get(entity).color;
			var region: Array<FastVector2> = _region.get(entity).regionMap.get(globalGraphEntity.id);
			if (region != null && region.length > 0) {
				var centroid = _geomTools.polyCentroid(region);
					
				if (globalGraphSettings.get('renderFilledRegions')) {
					graphics.color = color;
					var verts = region.map(function(fv: FastVector2) { return new Vector2(fv.x - centroid.x, fv.y - centroid.y); });
					graphics.fillPolygon(centroid.x, centroid.y, verts);
				}

				if (globalGraphSettings.get('renderRegionCentroids')) {
					graphics.color = Color.fromFloats(0.6 * color.R, 0.6 * color.G, 0.6 * color.B, color.A);
					graphics.drawCircle(centroid.x, centroid.y, 6.0, 3.0);
				}
			}
		}

		graphics.color = c;
		graphics.end();
	}
}
