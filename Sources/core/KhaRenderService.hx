package core;

import ecx.Service;
// import ecx.Wire;

import kha.System;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;

class KhaRenderService extends Service {

	// Rendering Systems will drawa on this canvas
	public var canvas:Image;

	public function new() {
		canvas = Image.createRenderTarget(System.windowWidth(), System.windowHeight());
	}

	override function initialize() {
		System.notifyOnRender(render);
	}

	function render(framebuffer:Framebuffer): Void {
		var graphics = framebuffer.g2;
		graphics.begin();
		Scaler.scale(canvas, framebuffer, System.screenRotation);
		graphics.end();
	}
}
