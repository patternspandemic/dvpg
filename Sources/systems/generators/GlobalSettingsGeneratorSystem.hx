package systems.generators;

import ecx.System;
import ecx.Wire;
import ecx.Entity;

import services.EntityCreatorService;
import services.NamedEntityService;

import components.*;

@:config
class GlobalSettingsGeneratorSystem extends System {

	var _creator:Wire<EntityCreatorService>;
	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;

	public function new() {}

	override function initialize() {
		var globalSettings: Entity = _creator.createSettings();
		var settings = _settings.get(globalSettings);
		settings.set('showGUI', false);
		settings.set('profile', false);
		_namedEntities.set('GlobalSettings', globalSettings);
	}
}
