package services;

import ecx.Service;
import ecx.Wire;
import ecx.World;
import ecx.Entity;

import components.*;

class EntityCreatorService extends Service {

	var _position:Wire<Position>;
	var _motion:Wire<Motion>;
	var _mouse:Wire<Mouse>;
	var _keys:Wire<Keys>;
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

	public function createMouse(x:Int, y:Int, dx:Int, dy:Int): Entity {
		var entity:Entity = world.create();
		_position.create(entity).setup(x, y);
		_motion.create(entity).setup(dx, dy);
		_mouse.create(entity);
		world.commit(entity);
		return entity;
	}

	public function createKeys(): Entity {
		var entity:Entity = world.create();
		_keys.create(entity);
		world.commit(entity);
		return entity;
	}
}
