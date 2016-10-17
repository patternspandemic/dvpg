package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.common.systems.TimeSystem;

import kha.FastFloat;
import kha.math.FastVector2;

import Project;

import components.*;

class MotionSystem extends System {
	
	var _entities:Family<Transform, Motion>;
	var _transform:Wire<Transform>;
	var _motion:Wire<Motion>;

	var _time:Wire<TimeSystem>;

	public function new() {}

	override function update(): Void {
		var trans;
		var pos;
		var vel;
		var dt = _time.deltaTime;
		var x, vx, y, vy;
		for (entity in _entities) {
			trans = _transform.get(entity);
			pos = trans.position;
			vel = _motion.get(entity);

			x = pos.x + (vel.x * dt);
			vx = vel.x;
			if (x < 0) { x = 0; vel.x *= -1;}
			else if (x > Project.width) { x = Project.width; vel.x *= -1;}

			y = pos.y + (vel.y * dt);
			vy = vel.y;
			if (y < 0) { y = 0; vel.y *= -1;}
			else if (y > Project.height) { y = Project.height; vel.y *= -1;}

			pos.x = x;
			pos.y = y;

			trans.rotation = Math.atan2(vel.y, vel.x);
		}
	}
}
