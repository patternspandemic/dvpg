package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.math.FastVector2;

import components.*;

class SiteSystem extends System {
	
	var _entities: Family<Site, Transform>;
	var _site: Wire<Site>;
	var _transform: Wire<Transform>;

	public function new() {}

	override function update(): Void {
		for (entity in _entities) {
			// Update the site data with that of the transform's position
			var position: FastVector2 = _transform.get(entity).position;
			_site.get(entity).setTo(position.x, position.y);
		}
	}

}
