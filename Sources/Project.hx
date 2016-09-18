package;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import ecx.common.EcxCommon;

import core.KhaUpdateService;
import core.KhaRenderService;
import components.Position;
import components.Dot;
import systems.RenderDots;

class Project {

	var _world:World;

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
		config.add(new KhaRenderService());
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
		// for (i in 0...300)
		// 	world.engine.create([
		// 		new Position(
		// 			Math.random() * System.windowWidth(),
		// 			Math.random() * System.windowHeight()),
		// 		new Dot(kha.Color.fromFloats(Math.random(),Math.random(),Math.random()))
		// 	]);

	}
}
