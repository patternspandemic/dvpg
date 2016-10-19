package core;

import ecx.Service;

import kha.System;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Assets;
import kha.math.FastMatrix3;

class KhaRenderService extends Service {

	// Rendering Systems will drawa on this canvas
	public var canvas(default, null):Image;

	public function new(width:Int, height:Int): Void {
		canvas = Image.createRenderTarget(width, height);
		// Move the canvas' origin in the center of the window
		canvas.g2.translate(width / 2, height / 2);
		canvas.g2.font = Assets.fonts.HackRegular;
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
