package;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import ecx.common.EcxCommon;

import components.Position;
import components.Dot;
import systems.RenderDots;

class Project {

	var _world:World;

	public function new() {
		
		var config = new WorldConfig();

		// Priorities
		// ...

		config.include(new EcxCommon());

		// Kha Services & Systems
		// ...

		// Project Services
		// ...

		// Project Systems
		// ...

		// Project Components
		// ...

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
