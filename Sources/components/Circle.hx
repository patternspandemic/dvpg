package components;

import ecx.AutoComp;

import de.polygonal.ds.IntHashTable;

import com.nodename.geom.Circle as GeomCircle;

class Circle extends AutoComp<CircleData> {}

class CircleData {

	public var circleMap: IntHashTable<GeomCircle>;

	public function new() {
		this.circleMap = new IntHashTable<GeomCircle>(16);
	}

}
