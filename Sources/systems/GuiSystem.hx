package systems;

import ecx.System;
import ecx.Family;
import ecx.Wire;

import kha.Key;
import kha.Assets;
import kha.graphics2.Graphics;

import zui.Zui;
import zui.Id;

import core.KhaRenderService;
import components.*;

class GuiSystem extends System {

	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	var _stats:Wire<StatsSystem>;
	var _krs:Wire<KhaRenderService>;

	var _ui:Zui;
	var _winId:String;
	var _showGui:Bool = false;

	public function new() {
		_ui = new Zui(Assets.fonts.HackRegular, 16, 14);
		_winId = Id.window();
	}

	override function update(): Void {
		// There's really only one keys entity here
		for (entity in _keysEntities) {
			var keys = _keys.get(entity);
			// Toggle Gui with TAB key
			if (keys.upKeys.has(Key.TAB.getIndex())) {
				this._showGui = !this._showGui;
			}
		}

		if (this._showGui) {
			var graphics:Graphics = _krs.canvas.g2;
			_ui.redrawWindow(_winId);
			_ui.begin(graphics);

			if (_ui.window(_winId, 0, 0, Std.int(Project.width / 4), Project.height, Zui.LAYOUT_VERTICAL)) {

				// Stats
				if (_ui.node(Id.node(), "Stats", 2, false)) {
					_ui.row([3/10, 2/10, 2/10, 3/10]);
					_ui.text("" + _stats.dt, Zui.ALIGN_CENTER);
					_ui.text("< DT");
					_ui.text("FPS >");
					_ui.text("" + _stats.fps, Zui.ALIGN_CENTER);
				}

				_ui.separator();

				// Profiling
				if (_ui.node(Id.node(), "Profiling", 1, false)) {

					_ui.row([1/5, 3/5, 1/5]);
					_ui.text("");
					if (_ui.button('Toggle ${_stats.profile ? "Off" : "On"}')) {
						_stats.profile = !_stats.profile;
					}
					_ui.text("");

					_ui.indent();
					var i:Int = 0;
					for (prof in _stats.profiles.keys()) {
						if (_ui.node(Id.node() + '_${i++}', prof, 0, false)) {
							var p = _stats.profiles.get(prof);
							_ui.indent();
							_ui.text('Timing: ${p.timing} ms');
							_ui.text('Timing Max: ${p.timingMax} ms');
							_ui.text('Changed Max: ${p.changed}');
							_ui.text('Removed Max: ${p.removed}');
							_ui.unindent();
						}
					}

					if (_stats.profile) {
						if (_ui.node(Id.node(), "Components", 0, false)) {
							_ui.indent();
							for (comp in _stats.comps.keys()) {
								_ui.row([1/2, 1/2]);
								_ui.text(comp, Zui.ALIGN_RIGHT);
								_ui.text(" " + _stats.comps.get(comp), Zui.ALIGN_LEFT);
							}
							_ui.unindent();
						}
					}
					_ui.unindent();
				}

				_ui.separator();

				// Next node...
			}

			_ui.end();
		}
	}

}
