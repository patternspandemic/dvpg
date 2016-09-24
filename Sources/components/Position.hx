package components;

import ecx.AutoComp;

class Position extends AutoComp<Point> {}

class Point {

	public var x : Float;
	public var y : Float;

	public function new() {}

	public function setup(x:Float, y:Float): Void {
		this.x = x;
		this.y = y;
	}
	
}
