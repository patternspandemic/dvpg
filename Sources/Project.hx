package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

import edge.*;
import com.nodename.delaunay.Voronoi;
import com.nodename.geom.LineSegment;
import com.nodename.geom.Point;
import com.nodename.geom.Rectangle;
import zui.Zui;
import zui.Id;

class Project {
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update(): Void {
		
	}

	function render(framebuffer: Framebuffer): Void {		
	}
}
