package components;

import ecx.AutoComp;

class Motion extends AutoComp<Velocity> {}

class Velocity {

	public var vx:Float;
	public var vy:Float;

	public function new() {}

	public function setup(velocityX:Float, velocityY:Float) {
		this.vx = velocityX;
		this.vy = velocityY;
	}
	
}
