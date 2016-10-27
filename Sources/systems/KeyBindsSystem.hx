package systems;

import ecx.Family;
import ecx.System;
import ecx.Wire;

import kha.Key;

import services.NamedEntityService;

import components.*;

class KeyBindsSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _keys: Wire<Keys>;
	var _settings: Wire<Settings>;

	public function new() {}

	override function update() {
		var keys = _keys.get(_namedEntities.get('Keys'));
		var globalSettings = _settings.get(_namedEntities.get('GlobalSettings'));
		var globalGraphSettings = _settings.get(_namedEntities.get('GlobalGraph'));

		// GUI toggle
		if (keys.upKeys.has(Key.TAB.getIndex())) {
			globalSettings.set('showGUI', !globalSettings.get('showGUI'));
		}

		// Profiling toggle
		if (keys.upKeys.has("`".code)) {
			globalSettings.set('profile', !globalSettings.get('profile'));
		}

		// Render sites toggle
		if (keys.upKeys.has("s".code)) {
			globalGraphSettings.set('renderSites', !globalGraphSettings.get('renderSites'));
		}

		// Render regions toggle
		if (keys.upKeys.has("r".code)) {
			globalGraphSettings.set('renderRegions', !globalGraphSettings.get('renderRegions'));
		}

		// Render filled regions toggle
		if (keys.upKeys.has("f".code)) {
			globalGraphSettings.set('renderFilledRegions', !globalGraphSettings.get('renderFilledRegions'));
		}

		// Render region centroids toggle
		if (keys.upKeys.has(".".code)) {
			globalGraphSettings.set('renderRegionCentroids', !globalGraphSettings.get('renderRegionCentroids'));
		}

		// Render triangulation toggle
		if (keys.upKeys.has("t".code)) {
			globalGraphSettings.set('renderTriangulation', !globalGraphSettings.get('renderTriangulation'));
		}

		// Render filled triangles toggle
		if (keys.upKeys.has("y".code)) {
			globalGraphSettings.set('renderFilledTriangles', !globalGraphSettings.get('renderFilledTriangles'));
		}

		// Render triangle barycenters toggle
		if (keys.upKeys.has(",".code)) {
			globalGraphSettings.set('renderTriangleCentroids', !globalGraphSettings.get('renderTriangleCentroids'));
		}

		// Render hull toggle
		if (keys.upKeys.has("h".code)) {
			globalGraphSettings.set('renderHull', !globalGraphSettings.get('renderHull'));
		}

		// Render onion toggle
		if (keys.upKeys.has("o".code)) {
			globalGraphSettings.set('renderOnion', !globalGraphSettings.get('renderOnion'));
		}

		// Render minspantree toggle
		if (keys.upKeys.has("m".code)) {
			globalGraphSettings.set('renderMinSpanTree', !globalGraphSettings.get('renderMinSpanTree'));
		}

		// Render circles toggle
		if (keys.upKeys.has("c".code)) {
			globalGraphSettings.set('renderCircles', !globalGraphSettings.get('renderCircles'));
		}

		// Render bounds toggle
		if (keys.upKeys.has("b".code)) {
			globalGraphSettings.set('renderBounds', !globalGraphSettings.get('renderBounds'));
		}
	}

}