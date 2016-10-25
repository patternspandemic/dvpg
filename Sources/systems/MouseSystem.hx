package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import services.NamedEntityService;

import de.polygonal.ds.IntHashTable;

import components.*;
import components.Mouse.MouseButtonState;

class MouseSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _mouse:Wire<Mouse>;

	// Mouse related system state
	var _x:Int;
	var _y:Int;
	var _dx:Int;
	var _dy:Int;
	var _w:Int;
	var _buttons:IntHashTable<MouseButtonState>;

	public function new(): Void {
		_buttons = new IntHashTable<MouseButtonState>(16);
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
		// Get the mouse component attached to the 'Mouse' entity
		var mouse = _mouse.get(_namedEntities.get('Mouse'));

		// Remove previous frame's UP button
		// states on the entity
		for (k in mouse.buttons.keys()){
			switch mouse.buttons.get(k) {
				case Up(_, _):
					mouse.buttons.unset(k);
				case _:
					// Down states stay, are replaced by UPs
			}
		}

		// Set this frame's states
		for (k in _buttons.keys()){
			mouse.buttons.unset(k);
			mouse.buttons.set(k, _buttons.get(k));
			// and clear for next update
			_buttons.unset(k);
		}

		// Set mouse position, motion, and wheel
		mouse.position.x = _x;
		mouse.position.y = _y;
		mouse.changeInPosition.x = _dx;
		mouse.changeInPosition.y = _dy;
		mouse.wheel = _w;
		_w = 0; // clear wheel for next update
	}

	function onMouseDown(button:Int, x:Int, y:Int): Void {
		_buttons.unset(button);
		_buttons.set(button, Down(x, y));
	}

	function onMouseUp(button:Int, x:Int, y:Int): Void {
		_buttons.unset(button);
		_buttons.set(button, Up(x, y));
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
