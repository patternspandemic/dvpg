package systems;

import ecx.System;
import kha.Scheduler;

class FpsMeterSystem extends System {

	public var framesPerSecond(default, null): Float = 0.0;
	public var frameTimeAverage(default, null): Float = 0.0;
	public var inverval: Float = 1.0;

	var _frames: Int = 0;
	var _lastTime: Float = 0.0;
	var _accDeltaTime: Float = 0.0;

	public function new() {}

	override function update() {
		++_frames;

		var now: Float = Scheduler.realTime();
		var deltaTime: Float = (now - _lastTime);
		_lastTime = now;

		_accDeltaTime += deltaTime;

		if(_accDeltaTime >= inverval) {
			framesPerSecond = _frames / inverval;
			frameTimeAverage = _accDeltaTime / _frames;
			_frames = 0;
			_accDeltaTime = 0;
		}
	}
}
