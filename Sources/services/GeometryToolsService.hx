package services;

import ecx.Service;
import ecx.Wire;

import kha.math.FastVector2;
import kha.math.Vector2;

class GeometryToolsService extends Service {

	public function new() {}

	public function polyCentroid(verts: Array<FastVector2>): Vector2 {
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

	public function polyArea(verts: Array<FastVector2>): Float {
		var area: Float = 0.0;
		var length: Int = verts.length;
		for (i in 0...length) {
			var iNext = (i + 1) % length;
			area += (verts[i].x * verts[iNext].y) - (verts[iNext].x * verts[i].y);
		}
		return area / 2.0;
	}

}