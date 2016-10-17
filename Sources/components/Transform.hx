package components;

import ecx.AutoComp;

import kha.FastFloat;
import kha.math.FastVector2;
import kha.math.FastMatrix3;

class Transform extends AutoComp<TransformData> {}

class TransformData {

	public var transform: FastMatrix3;
	public var position: FastVector2;
	public var scale: FastVector2;
	public var rotation: FastFloat;

	public function new() {
		this.transform = FastMatrix3.identity();
		this.position = new FastVector2();
		this.scale = new FastVector2();
		this.rotation = 0.0;
	}

	public function setup(px:FastFloat, py:FastFloat, ?rot:FastFloat, ?sx:FastFloat, ?sy:FastFloat): Void {
		this.position.x = px;
		this.position.y = py;
		if (sx != null) this.scale.x = sx;
		if (sy != null) this.scale.y= sy;
		if (rot != null) this.rotation = rot;
	}

}
