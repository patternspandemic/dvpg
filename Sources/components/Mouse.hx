package components;

import ecx.AutoComp;

class Mouse extends AutoComp<MouseData> {}

class MouseData {
	
	public var buttons:Map<Int, MouseButtonState>;
	public var wheel:Int = 0;

	public function new() {
		buttons = new Map<Int, MouseButtonState>();
	}

}

enum MouseButtonState {
	Down(x:Int, y:Int);
	Up(x:Int, y:Int);
}
