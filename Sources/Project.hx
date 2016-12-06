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
		var generate:Int = 1;
		var preUpdate:Int = 2;
		var update:Int = 3;
		var postUpdate:Int = 4;
		var move:Int = 5;
		var resolveCollisions:Int = 6;
		var stateMachines:Int = 7;
		var behavior:Int = 8;
		var animate:Int = 9;

		var renderA:Int = 10;
		var renderB:Int = 11;
		var renderC:Int = 12;
		var renderD:Int = 13;
		var renderE:Int = 14;
		var renderF:Int = 15;
		var renderG:Int = 16;
		var renderH:Int = 17;
		var renderI:Int = 18;
		var renderJ:Int = 19;

		var gui:Int = 20;

		// Kha Services & Systems
		config.add(new KhaUpdateService());
		config.add(new KhaRenderService(width, height));

		// Project Services
		config.add(new SystemRunner());
		config.add(new EntityCreatorService());
		config.add(new NamedEntityService());
		config.add(new GeometryToolsService());

		// Project Systems
		config.add(new TimeSystem(), -1000);
		// config.add(new FpsMeter(), -999);
		config.add(new FpsMeterSystem(), -999);

		// Generate (1)
		config.add(new MouseGeneratorSystem(), generate);
		config.add(new KeysGeneratorSystem(), generate);
		config.add(new GlobalSettingsGeneratorSystem(), generate);
		config.add(new BoundsGeneratorSystem(), generate);
		config.add(new GlobalGraphGeneratorSystem(), generate);

		// Pre-Update (2)
		config.add(new MouseSystem(), preUpdate);
		config.add(new KeySystem(), preUpdate);
		config.add(new SitesManagerSystem(), preUpdate);
		config.add(new DraggableSiteSystem(), preUpdate);

		// Update (3)
		config.add(new TransformSystem(), update);
		config.add(new SiteSystem(), update);

		// Post-Update (4)
		config.add(new DelaunayVoronoiSystem(), postUpdate);

		// Move (5)
		config.add(new MotionSystem(), move);

		// Behavior (8)
		config.add(new KeyBindsSystem(), behavior);

		// Render (10-19)
		config.add(new RenderBackgroundSystem(), renderA);
		config.add(new RenderGlobalGraphSystem(), renderB);
		// config.add(new RenderSelectedSiteSystem(), renderC);
		config.add(new RenderDotSystem(), renderD);

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
