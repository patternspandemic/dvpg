package components;

import ecx.AutoComp;

import de.polygonal.ds.IntHashTable;

import kha.math.FastVector2;

class Region extends AutoComp<RegionData> {}

class RegionData {

	public var regionMap: IntHashTable<Array<FastVector2>>;

	public function new() {
		this.regionMap = new IntHashTable<Array<FastVector2>>(16);
	}

}
