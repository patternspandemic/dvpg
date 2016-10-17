package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import kha.FastFloat;
import kha.math.FastVector2;
import kha.math.FastMatrix3;

import components.*;
import components.Transform.TransformData;

class TransformSystem extends System {
	
	var _entities:Family<Transform>;
	var _transform:Wire<Transform>;

	public function new() {}

	override function update(): Void {
		for (entity in _entities){
			// Update the entity's transform matrix by order of
			// scale, rotate, translate.
			var trans:TransformData = _transform.get(entity);
			trans.transform = FastMatrix3.translation(trans.position.x, trans.position.y) 
					 .multmat(FastMatrix3.rotation(trans.rotation))
					 .multmat(FastMatrix3.scale(trans.scale.x, trans.scale.y));
		}
	}

}
