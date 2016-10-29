package services;

import ecx.Service;
import ecx.Wire;
import ecx.World;
import ecx.Entity;
import ecx.common.components.Name;

import haxe.ds.StringMap;

import components.*;

class NamedEntityService extends Service {

	var _name: Wire<Name>;
	var _nameToEntityIDMap: StringMap<Int>;

	public function new() {
		_nameToEntityIDMap = new StringMap<Int>();
	}

	// Get the named entity
	public function get(name: String): Entity {
		var id = _nameToEntityIDMap.get(name);
		if (id != null) {
			return world.getEntity(id);
		} else {
			return Entity.NULL;
		}
	}

	// Set a name component on entity and store in the
	// service mapping.
	public function set(name: String, entity: Entity, ?force: Bool = false): Bool {
		if (_name.has(entity)) {
			// entity already named with component
			return false;
		} else if (_nameToEntityIDMap.exists(name) && force == false) {
			// name already in mapping with no forced overwrite
			return false;
		} else {
			// Create and set a name component on the entity
			_name.create(entity);
			_name.set(entity, name);
			// Store the entity in the mapping
			return store(entity, true);
		}
	}

	// Store an entity already with a name component in the
	// service mapping. Entities already stored under the same
	// name may be forcefully overwitten.
	public function store(entity: Entity, ?force: Bool = false): Bool {
		if (_name.has(entity)) {
			var name: String = _name.get(entity);
			if (!_nameToEntityIDMap.exists(name) || force) {
				_nameToEntityIDMap.set(name, entity.id);
				return true;
			} else {
				// name already exists in mapping, no forced overwrite
				return false;
			}
		} else {
			// entity should already have name component
			return false;
		}
	}

	// Remove a name from the service mapping
	public function remove(name: String): Bool {
		return _nameToEntityIDMap.remove(name);
	}
}
