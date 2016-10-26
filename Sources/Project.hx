package;

import kha.Assets;

import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import ecx.common.systems.*;
import ecx.common.components.Name;

import core.*;
import components.*;
import services.*;
import systems.*;
import systems.generators.*;
import systems.renderers.*;

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
		var renderA:Int = 10;
		var renderB:Int = 11;
		var renderC:Int = 12;
		var renderD:Int = 13;
		var renderE:Int = 14;
		var renderF:Int = 15;
		var renderG:Int = 16;
		var renderH:Int = 17;
		var renderI:Int = 18;
		var gui:Int = 20;

		// Kha Services & Systems
		config.add(new KhaUpdateService());
		config.add(new KhaRenderService(width, height));

		// Project Services
		config.add(new SystemRunner());
		config.add(new EntityCreatorService());
		config.add(new NamedEntityService());

		// Project Systems
		config.add(new TimeSystem(), -1000);
		config.add(new FpsMeter(), -999);

		// Pre-Update (1)
		config.add(new MouseGeneratorSystem(), preUpdate);
		config.add(new KeysGeneratorSystem(), preUpdate);
		config.add(new GlobalSettingsGeneratorSystem(), preUpdate);
		config.add(new BoundsGeneratorSystem(), preUpdate);
		config.add(new GlobalGraphGeneratorSystem(), preUpdate);
		config.add(new DotGeneratorSystem(), preUpdate);

		// Update (2)
		config.add(new MouseSystem(), update);
		config.add(new KeySystem(), update);
		config.add(new TransformSystem(), update);
		config.add(new SiteSystem(), update);
		config.add(new DelaunayVoronoiSystem(), update);

		// Move (3)
		config.add(new MotionSystem(), move);

		// Behavior (6)
		config.add(new KeyBindsSystem(), behavior);

		// Render (10-19)
		// TODO: Turn render system priorities indide out with a
		// RenderGlobalGraphSystem, RenderSelectedGraphSystem
		// (for site specific cv graph rendering). Then use only
		// a couple render priorities.
		config.add(new RenderBackgroundSystem(), renderA);
		config.add(new RenderBoundsSystem(), renderB);
		config.add(new RenderFilledRegionsSystem(), renderC);
		config.add(new RenderRegionsSystem(), renderD);
		config.add(new RenderCirclesSystem(), renderD);
		config.add(new RenderOnionSystem(), renderE);
		config.add(new RenderTriangulationSystem(), renderF);
		config.add(new RenderHullSystem(), renderG);
		config.add(new RenderMinSpanTreeSystem(), renderH);
		config.add(new RenderDotSystem(), renderI);

		// GUI (20)
		config.add(new GuiSystem(), gui);

		config.add(new StatsSystem(), 1000);

		// Project Components
		config.add(new Mouse());
		config.add(new Keys());
		config.add(new Settings());
		config.add(new Name());
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
		config.add(new Circle());
		config.add(new Circles());
		// Cell
		config.add(new Motion());
		config.add(new Dot());

		// Create the World
		_world = Engine.createWorld(config, 1000);
	}
}
