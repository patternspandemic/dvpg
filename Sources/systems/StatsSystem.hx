package systems;

import ecx.System;
import ecx.Wire;
import ecx.Family;
import ecx.common.systems.FpsMeter;
import ecx.common.systems.SystemRunner;
import ecx.common.systems.TimeSystem;

import kha.Key;
import kha.Color;
import kha.graphics2.Graphics;

import core.KhaRenderService;
import components.*;

class StatsSystem extends System {

	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	var _fpsMeter:Wire<FpsMeter>;
	var _time:Wire<TimeSystem>;
	var _runner:Wire<SystemRunner>;
	var _krs:Wire<KhaRenderService>;

	public function new() {}

	override function update() {
		var graphics:Graphics = _krs.canvas.g2;
		var lines = [
			"fps: " + formatD2(_fpsMeter.framesPerSecond),
			"dt: " + formatD2(_time.deltaTime * 1000) + " ms"
		];

		// There's really only one keys entity here
		for (entity in _keysEntities) {
			var keys = _keys.get(entity);
			// Toggle profilling with TAB key
			if (keys.upKeys.has(Key.TAB.getIndex())) {
				_runner.profile = !_runner.profile;
			}
		}

		if (_runner.profile) {

			lines.push("");

			for (profile in _runner.profileData) {
				var timing = '${formatD2(profile.updateTime * 1000)} + ${formatD2(profile.invalidateTime * 1000)} ms';
				var timingMax = '${formatD2(profile.updateTimeMax * 1000)} + ${formatD2(profile.invalidateTimeMax * 1000)} ms';
				var entitiesInfo = 'changed max: ${profile.changed}; removed max: ${profile.removed}';
				lines.push('${profile.name} : $timing | max: $timingMax | $entitiesInfo');
			}

			lines.push("");

			for (component in world.components()) {
				if (component != null) {
					var name = Type.getClassName(Type.getClass(component));
					var size = component.getObjectSize();
					lines.push('$name : ${size > 0 ? Std.string(size) : "?"} bytes');
				}
			}
		}


		var lineYOffset:Int = 5;
		graphics.begin(false);
		graphics.color = Color.White;
		graphics.fontSize = 14;
		
		for(line in lines) {
			graphics.drawString(line, 5, lineYOffset);
			lineYOffset += 20;
		}
		graphics.end();
	}

	function formatD2(f:Float):Float {
		return Std.int(f * 100) / 100;
	}
}