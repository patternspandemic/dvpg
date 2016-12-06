package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;
import ecx.common.components.Name;

import kha.Color;
import kha.math.Random;

import services.*;
import components.*;

import de.polygonal.ds.tools.ObjectPool;

class SitesManagerSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _name: Wire<Name>;
	var _creator: Wire<EntityCreatorService>;
	var _settings: Wire<Settings>;
	var _bounds: Wire<Bounds>;

	var _entities: Family<Site>;
	var _site: Wire<Site>;

	var _sitedEntityPool: ObjectPool<Entity>;
	var _canvasHalfW: Float;
	var _canvasHalfH: Float;
	var _globalSettings: Entity;

	var _random: Random;

	public function new() {
		_sitedEntityPool = new ObjectPool<Entity>(sitedEntityFactory, sitedEntityDisposer, 50);
		_random = new Random(0);
	}

	override function initialize() {
		// Set some info needed for the factory
		var canvasBounds = _bounds.get(_namedEntities.get('CanvasBounds'));
		_canvasHalfW = canvasBounds.width / 2;
		_canvasHalfH = canvasBounds.height / 2;

		// Preallocate the default site count, get and activate the entities
		_globalSettings = _namedEntities.get('GlobalSettings');
		var initialCnt: Int = _settings.get(_globalSettings).get('siteCount');
		_sitedEntityPool.preallocate(initialCnt);
		var sitedEntity: Entity;
		for (i in 0...initialCnt) {
			sitedEntity = _sitedEntityPool.get();
			world.activate(sitedEntity);
		}
	}

	override function update(): Void {
		var desiredSiteCount: Int = _settings.get(_globalSettings).get('siteCount');
		var currentSiteCount: Int = _entities.length;
		var tempSitedEntity: Entity;
		if (currentSiteCount < desiredSiteCount) {
			// Get some from the pool
			for (i in 0...(desiredSiteCount - currentSiteCount)) {
				tempSitedEntity = _sitedEntityPool.get();
				world.activate(tempSitedEntity);
			}
		} else if (currentSiteCount > desiredSiteCount) {
			// Put some back in the pool
			for (i in 0...(currentSiteCount - desiredSiteCount)) {
				tempSitedEntity = _entities.get(i);
				world.deactivate(tempSitedEntity);
				_sitedEntityPool.put(tempSitedEntity);
			}
		}
	}

	function sitedEntityFactory(): Entity {
		var i: Int = _sitedEntityPool.size;
		var y: Float = _random.GetFloatIn(-1.0, 1.0) * _canvasHalfH;
		var x: Float = _random.GetFloatIn(-1.0, 1.0) * _canvasHalfW;
		var vx: Float = _random.GetFloatIn(-1.0, 1.0) * 50;
		var vy: Float = _random.GetFloatIn(-1.0, 1.0) * 50;
		var dot: Entity = _creator.createDot(
			x, y,
			Math.atan2(vy, vx),
			0.8, 0.7,
			vx, vy,
			Color.fromFloats(_random.GetFloatIn(0.0, 1.0), _random.GetFloatIn(0.0, 1.0), _random.GetFloatIn(0.0, 1.0))
		);
		_namedEntities.set('Dot${i}', dot);
		return dot;
	}

	function sitedEntityDisposer(entity: Entity): Void {
		_namedEntities.remove(_name.get(entity));
		world.destroy(entity);
	}
}
