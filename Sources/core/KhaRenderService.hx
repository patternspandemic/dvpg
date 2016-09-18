package core;

import ecx.Service;
// import ecx.Wire;

import kha.System;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;

class KhaRenderService extends Service {

	// Rendering Systems will drawa on this canvas
	public var canvas(default, null):Image;

	public function new(width:Int, height:Int): Void {
		canvas = Image.createRenderTarget(width, height);
	}

	override function initialize(): Void {
		System.notifyOnRender(render);
	}

	function render(framebuffer:Framebuffer): Void {
		var graphics = framebuffer.g2;
		graphics.begin();
		Scaler.scale(canvas, framebuffer, System.screenRotation);
		graphics.end();
	}
}
