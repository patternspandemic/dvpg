package;

import kha.Assets;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import ecx.common.systems.*;

import core.*;
import components.*;
import services.*;
import systems.*;
import systems.generators.*;

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
		var gui:Int = 9;

		// Kha Services & Systems
		config.add(new KhaUpdateService());
		config.add(new KhaRenderService(width, height));

		// Project Services
		config.add(new SystemRunner());
		config.add(new EntityCreatorService());

		// Project Systems
		config.add(new TimeSystem(), -1000);
		config.add(new FpsMeter(), -999);
		config.add(new BoundsGeneratorSystem(), preUpdate);
		config.add(new GlobalGraphGeneratorSystem(), preUpdate);
		config.add(new DotGeneratorSystem(), preUpdate);
		config.add(new MouseSystem(), update);
		config.add(new KeySystem(), update);
		config.add(new TransformSystem(), update);
		config.add(new SiteSystem(), update);
		config.add(new DelaunayVoronoiSystem(), update);
		config.add(new MotionSystem(), move);
		config.add(new RenderDotSystem(), render);
		config.add(new GuiSystem(), gui);
		config.add(new StatsSystem(), 1000);

		// Project Components
		config.add(new Mouse());
		config.add(new Keys());
		config.add(new Transform());
		config.add(new Bounds());
		config.add(new Site());
		config.add(new Sites());
		config.add(new Triangles());
		config.add(new Triangulation());
		config.add(new Region());
		config.add(new Regions());
		config.add(new Hull());
		config.add(new Onion());
		config.add(new MinSpanTree());
		// Circle?
		// Cell
		config.add(new Motion());
		config.add(new Dot());

		// Create the World
		_world = Engine.createWorld(config, 1000);
	}
}
