package components;

import ecx.AutoComp;
import de.polygonal.ds.IntHashTable;
import kha.math.Vector2i;

class Mouse extends AutoComp<MouseData> {}

class MouseData {
	
	public var position: Vector2i;
	public var changeInPosition: Vector2i;
	public var buttons: IntHashTable<MouseButtonState>;
	public var wheel: Int = 0;

	public function new() {
		buttons = new IntHashTable<MouseButtonState>(16);
	}

}

enum MouseButtonState {
	Down(x:Int, y:Int);
	Up(x:Int, y:Int);
}
