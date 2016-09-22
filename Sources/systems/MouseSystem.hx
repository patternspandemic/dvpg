package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import services.EntityCreatorService;

import components.Mouse;
import components.Mouse.MouseButtonState;
import components.Position;
import components.Motion;

class MouseSystem extends System {

	var _entities:Family<Mouse, Position, Motion>;
	var _mouse:Wire<Mouse>;
	var _position:Wire<Position>;
	var _motion:Wire<Motion>;

	var _creator:Wire<EntityCreatorService>;

	var _x:Int;
	var _y:Int;
	var _dx:Int;
	var _dy:Int;
	var _w:Int;
	var _buttons:Map<Int, MouseButtonState>;

	public function new(): Void {
		_buttons = new Map<Int, MouseButtonState>();
		_w = 0;
	}

	override function initialize(): Void {
		kha.input.Mouse.get().notify(
			onMouseDown,
			onMouseUp,
			onMouseMove,
			onMouseWheel);
	}

	override function update(): Void {
		// Make sure we have a mouse entity.
		if (_entities.length == 0) {
			_creator.createMouse(_x, _y, _dx, _dy);
			return;
		}

		// There's really only one mouse here
		for (entity in _entities) {
			var mouse = _mouse.get(entity);
			var mousePosition = _position.get(entity);
			var mouseMotion = _motion.get(entity);

			// FIXME: Probs a more efficient way to do this.

			// Remove previous frame's UP button states
			for (k in mouse.buttons.keys()){
				switch mouse.buttons[k] {
					case Up(_, _):
						mouse.buttons.remove(k);
					case Down(_, _): // Down states stay and are replaced by UPs
				}
			}

			// Set this frame's states
			for (k in _buttons.keys()){
				mouse.buttons[k] = _buttons[k];
				// and clear for nect update
				_buttons.remove(k);
			}

			// Set mouse position, motion, and wheel
			mousePosition.setup(_x, _y);
			mouseMotion.setup(_dx, _dy);
			mouse.wheel = _w;
			_w = 0;
		}
	}

	function onMouseDown(button:Int, x:Int, y:Int): Void {
		_buttons[button] = Down(x, y);
	}

	function onMouseUp(button:Int, x:Int, y:Int): Void {
		_buttons[button] = Up(x, y);
	}

	function onMouseMove(x:Int, y:Int, dx:Int, dy:Int): Void {
		_x = x;
		_y = y;
		_dx = dx;
		_dy = dy;
	}

	function onMouseWheel(w:Int): Void {
		_w += w;
	}

}