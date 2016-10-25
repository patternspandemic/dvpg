package systems.generators;

import ecx.System;
import ecx.Wire;
import ecx.Entity;

import services.EntityCreatorService;
import services.NamedEntityService;

@:config
class KeysGeneratorSystem extends System {

	var _creator:Wire<EntityCreatorService>;
	var _namedEntities: Wire<NamedEntityService>;

	public function new() {}

	override function initialize() {
		var keys: Entity = _creator.createKeys();
		_namedEntities.set('Keys', keys);
	}
}
