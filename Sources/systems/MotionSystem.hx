package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.common.systems.TimeSystem;

import Project;

import components.Position;
import components.Motion;

class MotionSystem extends System {
	
	var _entities:Family<Position, Motion>;
	var _position:Wire<Position>;
	var _motion:Wire<Motion>;

	var _time:Wire<TimeSystem>;

	public function new() {}

	override function update(): Void {
		var pos;
		var vel;
		var dt = _time.deltaTime;
		var x, vx, y, vy;
		for (entity in _entities) {
			pos = _position.get(entity);
			vel = _motion.get(entity);

			x = pos.x + (vel.vx * dt);
			vx = vel.vx;
			if (x < 0) { x = 0; vel.vx *= -1;}
			else if (x > Project.width) { x = Project.width; vel.vx *= -1;}

			y = pos.y + (vel.vy * dt);
			vy = vel.vy;
			if (y < 0) { y = 0; vel.vy *= -1;}
			else if (y > Project.height) { y = Project.height; vel.vy *= -1;}

			pos.x = x;
			pos.y = y;
		}
	}
}
