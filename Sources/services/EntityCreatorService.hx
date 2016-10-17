package services;

import ecx.Service;
import ecx.Wire;
import ecx.World;
import ecx.Entity;

import components.*;

class EntityCreatorService extends Service {

	var _transform:Wire<Transform>;
	var _position:Wire<Position>;
	var _motion:Wire<Motion>;
	var _mouse:Wire<Mouse>;
	var _keys:Wire<Keys>;
	var _dot:Wire<Dot>;

	public function new(): Void {}

	public function createDot(x:Float, y:Float, rot:Float, sx:Float, sy:Float, vx:Float, vy:Float, color:kha.Color):Entity {
		var entity:Entity = world.create();
		_transform.create(entity).setup(x, y, rot, sx, sy);
		var vel = _motion.create(entity);
		vel.x = vx;
		vel.y = vy;
		// _position.create(entity).setup(x, y);
		// _motion.create(entity).setup(vx, vy);
		_dot.create(entity).setup(color);
		world.commit(entity);
		return entity;
	}

	public function createMouse(x:Int, y:Int, dx:Int, dy:Int): Entity {
		var entity:Entity = world.create();
		_position.create(entity).setup(x, y);
		var vel = _motion.create(entity);
		vel.x = dx;
		vel.y = dy;
		// _motion.create(entity).setup(dx, dy);
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
