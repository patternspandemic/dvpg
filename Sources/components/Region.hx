package components;

import ecx.AutoComp;

import de.polygonal.ds.IntHashTable;

import components.types.AbstractFastVector2;

class Region extends AutoComp<RegionData> {}

class RegionData {

	public var regionMap: IntHashTable<Array<AbstractFastVector2>>;

	public function new() {
		this.regionMap = new IntHashTable<Array<AbstractFastVector2>>(16);
	}

}
