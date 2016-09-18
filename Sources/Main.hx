package;

import kha.System;

class Main {
	public static function main() {
		System.init({title: "Delaunay Voronoi Playground", width: Project.width, height: Project.height}, function () {
			new Project();
		});
	}
}
