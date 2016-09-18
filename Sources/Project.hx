package;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import ecx.common.EcxCommon;

import ecx.Entity;
import ecx.Wire;

import core.KhaUpdateService;
import core.KhaRenderService;
import components.Position;
import components.Dot;
import systems.RenderDots;

class Project {

	public static var width:Int = 1024;
	public static var height:Int = 768;

	var _world:World;

	var _position:Wire<Position>;
	var _dot:Wire<Dot>;

	public function new() {
		
		var config = new WorldConfig();

		// Priorities
		var preUpdate:Int = 1;
		var update:Int = 2;
		var move:Int = 3;
		var resolveCollisions:Int = 4;
		var stateMachines:Int = 5;
		var behavior:Int = 6;
		var animate:Int = 7;
		var render:Int = 8;	

		config.include(new EcxCommon());

		// Kha Services & Systems
		config.add(new KhaUpdateService());
		config.add(new KhaRenderService(width, height));
		// config.add(new StatsView());

		// Project Services
		// ...

		// Project Systems
		config.add(new RenderDots(), render);

		// Project Components
		config.add(new Position());
		config.add(new Dot());

		// Create the World
		_world = Engine.createWorld(config, 1000);

		// TODO: Move into Systems
		for (i in 0...300) {
			var entity = _world.create();
			_position.create(entity).setup(Math.random() * width, Math.random() * height);
			_dot.create(entity).setup(kha.Color.fromFloats(Math.random(), Math.random(), Math.random()));
			_world.commit(entity);
		}
	}
}
