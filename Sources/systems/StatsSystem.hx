package systems;

import ecx.Family;
import ecx.System;
import ecx.Wire;
import ecx.common.systems.FpsMeter;
import ecx.common.systems.SystemRunner;
import ecx.common.systems.TimeSystem;

import kha.Key;

import services.NamedEntityService;

import components.*;

class StatsSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;
	var _fpsMeter: Wire<FpsMeter>;
	var _time: Wire<TimeSystem>;
	var _runner: Wire<SystemRunner>;

	var _clearMaps:Bool = false;

	public var fps: Float = 0.0;
	public var dt: Float = 0.0;
	public var profiles: Map<String, SystemProfile>;
	public var comps: Map<String, Int>;

	public function new() {
		this.profiles = new Map<String, SystemProfile>();
		this.comps = new Map<String, Int>();
	}

	override function update() {

		var globalSettings = _settings.get(_namedEntities.get('GlobalSettings'));
		var profiling: Bool = globalSettings.get('profile');

		// Observe global profile setting
		_runner.profile = profiling;

		// Update fps and dt
		this.fps = formatD2(_fpsMeter.framesPerSecond);
		this.dt = formatD2(_time.deltaTime * 1000);

		if (profiling) {

			// Collect systems profile data
			for (profile in _runner.profileData) {
				this.profiles.set(
					profile.name, 
					{
						timing: formatD2((profile.updateTime + profile.invalidateTime) * 1000),
						timingMax: formatD2((profile.updateTimeMax + profile.invalidateTimeMax) * 1000),
						changed: profile.changed,
						removed: profile.removed
					});
			}

			// Collect component profile data
			for (comp in world.components()) {
				if (comp != null) {
					var name = Type.getClassName(Type.getClass(comp)).substring(11);
					var size = comp.getObjectSize();
					this.comps.set(name, size);
				}
			}

			// Clear maps when profile turned off
			_clearMaps = true;
		}
		else {
			if (_clearMaps) {
				// Clear the maps
				this.profiles = new Map<String, SystemProfile>();
				this.comps = new Map<String, Int>();
				_clearMaps = false;
			}
		}
	}

	function formatD2(f:Float):Float {
		return Std.int(f * 100) / 100;
	}
}

typedef SystemProfile = {
	var timing: Float;
	var timingMax: Float;
	var changed: Int;
	var removed: Int;
}
