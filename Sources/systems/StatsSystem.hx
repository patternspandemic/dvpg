package systems;

import ecx.Family;
import ecx.System;
import ecx.Wire;
import ecx.common.systems.FpsMeter;
import ecx.common.systems.SystemRunner;
import ecx.common.systems.TimeSystem;

import kha.Key;

import components.*;

class StatsSystem extends System {

	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	var _fpsMeter:Wire<FpsMeter>;
	var _time:Wire<TimeSystem>;
	var _runner:Wire<SystemRunner>;

	var _clearMaps:Bool = false;

	public var fps:Float = 0.0;
	public var dt:Float = 0.0;
	public var profile:Bool = false;
	public var profiles:Map<String, SystemProfile>;
	public var comps:Map<String, Int>;

	public function new() {
		this.profiles = new Map<String, SystemProfile>();
		this.comps = new Map<String, Int>();
	}

	override function update() {
		// React to Gui button
		_runner.profile = this.profile;

		// There's really only one keys entity here
		for (entity in _keysEntities) {
			var keys = _keys.get(entity);
			// Toggle profilling with ` key
			if (keys.upKeys.has("`".code)) {
				this.profile = !this.profile;
				_runner.profile = this.profile;
			}
		}

		// Update fps and dt
		this.fps = formatD2(_fpsMeter.framesPerSecond);
		this.dt = formatD2(_time.deltaTime * 1000);

		if (this.profile) {

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
	var timing:Float;
	var timingMax:Float;
	var changed:Int;
	var removed:Int;
}
