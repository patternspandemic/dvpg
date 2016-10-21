package components;

import ecx.AutoComp;

import de.polygonal.ds.IntHashTable;

import kha.math.FastVector2;

class Triangles extends AutoComp<TrianglesData> {}

class TrianglesData {

	public var trianglesMap: IntHashTable<Array<Array<FastVector2>>>;

	public function new() {
		this.trianglesMap = new IntHashTable<Array<Array<FastVector2>>>(16);
	}

}
