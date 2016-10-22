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
	var _sites: Wire<Sites>;
	var _triangles: Wire<Triangles>;
	var _triangulation: Wire<Triangulation>;
	var _region: Wire<Region>;
	var _regions: Wire<Regions>;
	var _hull: Wire<Hull>;
	var _onion: Wire<Onion>;
	var _minSpanTree: Wire<MinSpanTree>;
	var _circle: Wire<Circle>;
	var _circles: Wire<Circles>;
	//var _cell: Wire<Cell>;

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
		_region.create(entity);
		_triangles.create(entity);
		_circle.create(entity);
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

	// TODO: Parametrize creation of various graph components
	public function createDelaunayVoronoiGraph(): Entity {
		var entity: Entity = world.create();
		_sites.create(entity).setup();
		_triangles.create(entity);
		_triangulation.create(entity);
		_regions.create(entity);
		_hull.create(entity);
		_onion.create(entity);
		_minSpanTree.create(entity);
		_circles.create(entity);
		// _cell.create(entity);
		return entity;
	}
}
