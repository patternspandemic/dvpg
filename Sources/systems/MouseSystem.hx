package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import services.EntityCreatorService;

import components.*;
import components.Mouse.MouseButtonState;

class MouseSystem extends System {

	// The mouse family of entity
	var _mouseEntities:Family<Mouse, Position, Motion>;
	var _mouse:Wire<Mouse>;
	var _position:Wire<Position>;
	var _motion:Wire<Motion>;

	// For creating a mouse entity
	var _creator:Wire<EntityCreatorService>;

	// Mouse related system state
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
		// Have Kha notify this system of mouse events
		kha.input.Mouse.get().notify(
			onMouseDown,
			onMouseUp,
			onMouseMove,
			onMouseWheel);
	}

	override function update(): Void {
		// Make sure we have a mouse entity.
		if (_mouseEntities.length == 0) {
			if (_x != 0 && _y != 0) {
				_creator.createMouse(_x, _y, _dx, _dy);
			}
			return;
		}

		// There's really only one mouse here
		for (entity in _mouseEntities) {
			var mouse = _mouse.get(entity);
			var mousePosition = _position.get(entity);
			var mouseMotion = _motion.get(entity);

			// Remove previous frame's UP button
			// states on the entity
			for (k in mouse.buttons.keys()){
				switch mouse.buttons[k] {
					case Up(_, _):
						mouse.buttons.remove(k);
					case Down(_, _):
						// Down states stay, are replaced by UPs
					case _:
				}
			}

			// Set this frame's states
			for (k in _buttons.keys()){
				mouse.buttons[k] = _buttons[k];
				// and clear for next update
				_buttons.remove(k);
			}

			// Set mouse position, motion, and wheel
			mousePosition.setup(_x, _y);
			mouseMotion.setup(_dx, _dy);
			mouse.wheel = _w;
			_w = 0; // clear wheel for next update
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
		// Wheel movement accumulated over the frame
		_w += w;
	}

}
