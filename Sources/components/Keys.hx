package components;

import ecx.AutoComp;
import de.polygonal.ds.BitVector;

class Keys extends AutoComp<KeysData> {}

class KeysData {

	public var downKeys:BitVector;
	public var upKeys:BitVector;

	public function new() {
		downKeys = new BitVector(128);
		upKeys = new BitVector(128);
	}

}
