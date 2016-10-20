package components;

import ecx.AutoComp;
import ecx.Entity;

import de.polygonal.ds.IntHashSet;

class Sites extends AutoComp<SitesData> {}

class SitesData {

	public var included: IntHashSet;
	public var excluded: IntHashSet;

	public function new() {
		this.included = new IntHashSet(16);
		this.excluded = new IntHashSet(16);
	}

	public function setup(?excluded: Array<Entity>) {
		if (excluded != null) {
			for (e in excluded) {
				this.excluded.set(e.id);
			}
		}
	}

}
