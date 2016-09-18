package services;

import ecx.Service;
import ecx.Wire;
import ecx.World;
import ecx.Entity;

import components.Position;
import components.Motion;
import components.Dot;

class EntityCreatorService extends Service {

	var _position:Wire<Position>;
	var _motion:Wire<Motion>;
	var _dot:Wire<Dot>;

	public function new(): Void {}

	public function createDot(x:Float, y:Float, vx:Float, vy:Float, color:kha.Color):Entity {
		var entity:Entity = world.create();
		_position.create(entity).setup(x, y);
		_motion.create(entity).setup(vx, vy);
		_dot.create(entity).setup(color);
		world.commit(entity);
		return entity;
	}
}
