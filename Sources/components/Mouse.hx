package components;

import ecx.AutoComp;
import de.polygonal.ds.IntHashTable;

class Mouse extends AutoComp<MouseData> {}

class MouseData {
	
	// TODO: Internalize mouse entity's position component.
	public var buttons:IntHashTable<MouseButtonState>;
	public var wheel:Int = 0;

	public function new() {
		buttons = new IntHashTable<MouseButtonState>(16);
	}

}

enum MouseButtonState {
	Down(x:Int, y:Int);
	Up(x:Int, y:Int);
}
