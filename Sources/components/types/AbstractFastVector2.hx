package components.types;

import kha.math.FastVector2;
import com.nodename.geom.Point;

abstract AbstractFastVector2(FastVector2) {

	inline function new(v: FastVector2) {
		this = v;
	}

	@:from
	static public function fromPoint(p: Point) {
		return new FastVector2(p.x, p.y);
	}

}
