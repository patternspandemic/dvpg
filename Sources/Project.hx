package;

import kha.Assets;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import ecx.common.EcxCommon;

import ecx.System; //tmp
import ecx.Wire; //tmp
import kha.Color; //tmp

import core.KhaUpdateService;
import core.KhaRenderService;
import components.Position;
import components.Motion;
import components.Dot;
import services.EntityCreatorService;
import systems.StatsSystem;
import systems.MotionSystem;
import systems.RenderDotSystem;

class Project {

	public static var width:Int = 1024;
	public static var height:Int = 768;

	var _world:World;

	public function new() {
		Assets.loadEverything(createWorld);
	}

	function createWorld() {
		
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

		// Project Services
		config.add(new EntityCreatorService());

		// Project Systems
		config.add(new StatsSystem(), 1000);
		config.add(new SitesSystem(), preUpdate);
		config.add(new MotionSystem(), move);
		config.add(new RenderDotSystem(), render);

		// Project Components
		config.add(new Position());
		config.add(new Motion());
		config.add(new Dot());

		// Create the World
		_world = Engine.createWorld(config, 1000);
	}
}

// TODO: Rename to Generator|ConfigSystem? and promote to systems package.
@:config
class SitesSystem extends System {

	var _creator:Wire<EntityCreatorService>;

	public function new() {}

	public override function initialize() {
		for (i in 0...20) {
			_creator.createDot(
				Math.random() * Project.width,
				Math.random() * Project.height,
				(Math.random() * 50) - 5,
				(Math.random() * 50) - 5,
				Color.fromFloats(Math.random(), Math.random(), Math.random())
			);
		}
	}

}
