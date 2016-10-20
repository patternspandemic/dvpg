package components;

import ecx.AutoComp;

import de.polygonal.ds.IntHashTable;

import components.types.AbstractFastVector2;

class Triangles extends AutoComp<TrianglesData> {}

class TrianglesData {

	public var trianglesMap: IntHashTable<Array<Array<AbstractFastVector2>>>;

	public function new() {
		this.trianglesMap = new IntHashTable<Array<Array<AbstractFastVector2>>>(16);
	}

}
