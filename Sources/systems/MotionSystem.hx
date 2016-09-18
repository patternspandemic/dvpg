package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import Project;

import components.Position;
import components.Motion;

class MotionSystem extends System {
	
	var _entities:Family<Position, Motion>;
	var _position:Wire<Position>;
	var _motion:Wire<Motion>;

	public function new() {}

	override function update(): Void {
		var pos;
		var vel;
		for (entity in _entities) {
			pos = _position.get(entity);
			vel = _motion.get(entity);
			if (pos.x < 0 || pos.x > Project.width) vel.vx *= -1;
			if (pos.y < 0 || pos.y > Project.height) vel.vy *= -1;
			pos.x += vel.vx;
			pos.y += vel.vy;
		}
	}
}
