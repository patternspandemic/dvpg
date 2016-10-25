package systems.generators;

import ecx.System;
import ecx.Wire;
import ecx.Entity;

import services.EntityCreatorService;
import services.NamedEntityService;

@:config
class MouseGeneratorSystem extends System {

	var _creator:Wire<EntityCreatorService>;
	var _namedEntities: Wire<NamedEntityService>;

	public function new() {}

	override function initialize() {
		var mouse: Entity = _creator.createMouse(0, 0, 0, 0);
		_namedEntities.set('Mouse', mouse);
	}
}
