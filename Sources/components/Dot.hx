package components;

import ecx.AutoComp;
import kha.Color;

class Dot extends AutoComp<DotData> {}

class DotData {
	public var color:Color;

	public function new() {}

	public function setup(color:Color): Void {
		this.color = color;
	}
}
