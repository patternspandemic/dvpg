package systems;

import ecx.Wire;
import ecx.System;
import ecx.Family;
import ecx.Entity;

import kha.FastFloat;
import kha.math.FastVector2;

import services.NamedEntityService;

import components.*;
import components.Mouse.MouseData;
import components.Mouse.MouseButtonState;

class DraggableSiteSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;

	var _entities: Family<Site, Transform, Motion>;
	var _site: Wire<Site>;
	var _transform: Wire<Transform>;
	var _motion: Wire<Motion>;

	var _bounds: Wire<Bounds>;
	var _settings: Wire<Settings>;
	var _mouse: Wire<Mouse>;

	var _draggedEntity: Entity;
	var _distanceTheshold: FastFloat = 25.0;

	public function new() {}

	override function update(): Void {
		var canvasBounds = _bounds.get(_namedEntities.get('CanvasBounds'));
		var globalGraphSettings = _settings.get(_namedEntities.get('GlobalGraph'));
		var mouseEntity: Entity = _namedEntities.get('Mouse');

		if (_mouse.has(mouseEntity)) {

			var mouse: MouseData = _mouse.get(mouseEntity);
			var buttonState = mouse.buttons.get(0);

			if (buttonState != null) {
				switch (buttonState) {

					case Down(x, y):

						// Do not drag invisible sites
						if (globalGraphSettings.get('renderSites') == true) {

							if (_draggedEntity == null) {
								// Look for a site we might be dragging on
								var sitePos: FastVector2;
								// Transform mouse down coords to canvas coords
								var mouseDownPos: FastVector2 = new FastVector2(
											x - (canvasBounds.width / 2),
											y - (canvasBounds.height / 2));
								for (entity in _entities) {
									sitePos = _transform.get(entity).position;
									if (sitePos.sub(mouseDownPos).length <= _distanceTheshold) {
										_draggedEntity = entity;
										break;
									}
								}
							}

							if (_draggedEntity != null) {
								// Transform mouse position coords to canvas coords
								var mousePos: FastVector2 = new FastVector2(
											mouse.position.x - (canvasBounds.width / 2),
											mouse.position.y - (canvasBounds.height / 2));
								_transform.get(_draggedEntity).position = mousePos;
								_motion.set(_draggedEntity, new FastVector2(mouse.changeInPosition.x * 50, mouse.changeInPosition.y * 50));
							}

						} else {
							_draggedEntity = null;
						}

					case _: // Up
						_draggedEntity = null;
				}
			}
		}
	}

}
