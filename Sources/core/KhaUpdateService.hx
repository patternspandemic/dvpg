package core;

import ecx.Service;
import ecx.Wire;
import ecx.common.systems.SystemRunner;

import kha.Scheduler;

class KhaUpdateService extends Service {

	var _runner:Wire<SystemRunner>;

	public function new() {}

	override function initialize() {
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update() {
		_runner.updateFrame();
	}
}
