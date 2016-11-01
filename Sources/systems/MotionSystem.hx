package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;
import ecx.common.systems.TimeSystem;

import kha.FastFloat;
import kha.math.FastVector2;

import Project;

import services.NamedEntityService;

import components.*;

class MotionSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;
	var _bounds: Wire<Bounds>;

	var _entities:Family<Transform, Motion>;
	var _transform:Wire<Transform>;
	var _motion:Wire<Motion>;

	var _time:Wire<TimeSystem>;

	var _dragThreshold: FastFloat = 50.0;

	public function new() {}

	override function update(): Void {

		// Get the bounds of the first and only bounded entity
		var globalSettings = _settings.get(_namedEntities.get('GlobalSettings'));
		var bounds = _bounds.get(_namedEntities.get('CanvasBounds'));
		var trans;
		var pos;
		var vel;
		var speedMult = globalSettings.get('siteSpeedMultiplier');
		var drag = globalSettings.get('siteDrag');
		drag = drag / 100;
		var dt = _time.deltaTime;
		var x, vx, y, vy;

		for (entity in _entities) {
			trans = _transform.get(entity);
			pos = trans.position;
			vel = _motion.get(entity);

			if (vel.length > _dragThreshold) {
				var velD = vel.mult(1.0 - drag);
				_motion.set(entity, velD);
				vel = velD;
			}

			// Bounce horizontally
			x = pos.x + (speedMult * vel.x * dt);
			if (x < bounds.left) { x = bounds.left; vel.x *= -1;}
			else if (x > bounds.right) { x = bounds.right; vel.x *= -1;}

			// Bounce vertically
			y = pos.y + (speedMult * vel.y * dt);
			if (y < bounds.top) { y = bounds.top; vel.y *= -1;}
			else if (y > bounds.bottom) { y = bounds.bottom; vel.y *= -1;}

			// Assign the new position
			pos.x = x;
			pos.y = y;

			// Rotate in the direction of travel
			trans.rotation = Math.atan2(vel.y, vel.x);
		}
	}
}
