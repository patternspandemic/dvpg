package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;

import services.EntityCreatorService;

import de.polygonal.ds.BitVector;

import kha.input.Keyboard as KhaKeyboard;
import kha.Key;

import components.*;

import haxe.io.Bytes;
using haxe.EnumTools.EnumValueTools;

/*
 *	This system maps Kha's special keys to the first 32 bits of a
 *	de.polygonal.ds.BitVector, and CHAR keys to the bit indexed by the char's
 *	code, generally bits 33 - 128. The system and related component, Keys, 
 *	stores and syncs 2 BitVectors. One for down keys, and another for up keys.
 *	Other systems can then choose to act on key events to their liking.
 *
 *	FIXME: There are some issues of bits being stuck due to SHIFT interaction
 *	durring key-chord type scenarios.
 */
class KeySystem extends System {

	// The keys family of entity
	var _keysEntities:Family<Keys>;
	var _keys:Wire<Keys>;

	// For creating a keys entity
	var _creator:Wire<EntityCreatorService>;

	// Keys related system state
	var _downKeys:BitVector;
	var _upKeys:BitVector;

	public function new(): Void {
		_downKeys = new BitVector(128);
		_upKeys = new BitVector(128);
	}

	override function initialize(): Void {
		// Have Kha notify this system of keyboard events
		KhaKeyboard.get().notify(
			onKeyDown,
			onKeyUp);
	}

	override function update(): Void {
		// Make sure we have a keys entity.
		if (_keysEntities.length == 0) {
			_creator.createKeys();
			return;
		}

		// There's really only one keys entity here
		for (entity in _keysEntities) {
			var keys = _keys.get(entity);
			var prevFrameDown:Bytes;
			var curFrameDown:Bytes;
			var curFrameUp:Bytes;
			var b:Int;

			prevFrameDown = Bytes.ofData(keys.downKeys.toBytes());
			curFrameDown = Bytes.ofData(_downKeys.toBytes());
			curFrameUp = Bytes.ofData(_upKeys.toBytes());

			// For each byte ...
			for (b in 0...curFrameDown.length) {
				// Combine set down bits of this and previous frame
				curFrameDown.set(b, prevFrameDown.get(b) | curFrameDown.get(b));
				// But clear the down bits that are now up.
				// FIXME: Key Up without Down: Note that it is
				// possible for the corresponding down bit to be unset here
				// on the same frame, thus other systems may only see an Up
				// state.
				curFrameDown.set(b, curFrameDown.get(b) & (~curFrameUp.get(b)));
			}

			// Assign the current frame's computed bits to the entity
			keys.downKeys.ofBytes(curFrameDown.getData());

			// Remove previous frame's Up key state on the entity,
			// then assign this frame's Up state.
			keys.upKeys.clearAll(); // Neccessary?
			keys.upKeys.ofBytes(curFrameUp.getData());

			// Clear this system's key states for the next update.
			_downKeys.clearAll();
			_upKeys.clearAll();
		}
	}

	function onKeyDown(key:Key, char:String): Void {
		switch key {
			case Key.CHAR:
				// Key is one of Kha's non-special keys,
				// use the character code.
				_downKeys.set(char.charCodeAt(0));
			case _:
				// Key is one of Kha's special keys,
				// use the enum value's position
				_downKeys.set(key.getIndex());
		}
	}

	function onKeyUp(key:Key, char:String): Void {
		switch key {
			case Key.CHAR:
				// Key is one of Kha's non-special keys,
				// use the character code.
				var code:Int = char.charCodeAt(0);
				_upKeys.set(code);
			case _:
				var index:Int = key.getIndex();
				// Key is one of Kha's special keys,
				// use the enum value's position
				_upKeys.set(index);
		}
	}

}
