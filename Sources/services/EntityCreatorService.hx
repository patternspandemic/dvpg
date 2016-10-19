package services;

import ecx.Service;
import ecx.Wire;
import ecx.World;
import ecx.Entity;

import kha.math.Vector2i;

import components.*;

class EntityCreatorService extends Service {

	var _mouse: Wire<Mouse>;
	var _keys: Wire<Keys>;
	var _transform: Wire<Transform>;
	var _motion: Wire<Motion>;
	var _bounds: Wire<Bounds>;
	var _site: Wire<Site>;
	var _dot: Wire<Dot>;

	public function new(): Void {}

	public function createDot(x:Float, y:Float, rot:Float, sx:Float, sy:Float, vx:Float, vy:Float, color:kha.Color):Entity {
		var entity:Entity = world.create();
		_transform.create(entity).setup(x, y, rot, sx, sy);
		var vel = _motion.create(entity);
		vel.x = vx;
		vel.y = vy;
		_dot.create(entity).setup(color);
		_site.create(entity).setTo(x, y);
		world.commit(entity);
		return entity;
	}

	public function createMouse(x:Int, y:Int, dx:Int, dy:Int): Entity {
		var entity:Entity = world.create();
		var mouseData = _mouse.create(entity);
		mouseData.position = new Vector2i(x, y);
		mouseData.changeInPosition = new Vector2i(dx, dy);
		world.commit(entity);
		return entity;
	}

	public function createKeys(): Entity {
		var entity:Entity = world.create();
		_keys.create(entity);
		world.commit(entity);
		return entity;
	}

	public function createBounds(): Entity {
		var entity: Entity = world.create();
		_bounds.create(entity);
		world.commit(entity);
		return entity;
	}
}
