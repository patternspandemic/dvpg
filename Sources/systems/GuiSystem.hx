package systems;

import ecx.System;
import ecx.Family;
import ecx.Wire;

import kha.Key;
import kha.Assets;
import kha.graphics2.Graphics;

import zui.Zui;
import zui.Id;

import core.KhaRenderService;

import services.NamedEntityService;

import components.*;
import haxe.ds.StringMap;

class GuiSystem extends System {

	var _namedEntities: Wire<NamedEntityService>;
	var _settings: Wire<Settings>;

	var _stats: Wire<StatsSystem>;
	var _krs: Wire<KhaRenderService>;

	var _ui: Zui;
	var _winId: String;
	var _showGui: Bool = false;

	var _globalGraph_RenderStatesExist: Bool;
	var _globalGraph_RenderSitesCheckID: String;
	var _globalGraph_RenderRegionsCheckID: String;
	var _globalGraph_RenderFilledRegionsCheckID: String;
	var _globalGraph_RenderRegionCentroidsCheckID: String;
	var _globalGraph_RenderTriangulationCheckID: String;
	var _globalGraph_RenderFilledTrianglesCheckID: String;
	var _globalGraph_RenderTriangleCentroidsCheckID: String;
	var _globalGraph_RenderHullCheckID: String;
	var _globalGraph_RenderOnionCheckID: String;
	var _globalGraph_RenderMinSpanTreeCheckID: String;
	var _globalGraph_RenderCirclesCheckID: String;
	var _globalGraph_RenderBoundsCheckID: String;

	public function new() {
		_ui = new Zui(Assets.fonts.HackRegular, 16, 14);
		_winId = Id.window();

		_globalGraph_RenderStatesExist = false;
		_globalGraph_RenderSitesCheckID = Id.check();
		_globalGraph_RenderRegionsCheckID = Id.check();
		_globalGraph_RenderFilledRegionsCheckID = Id.check();
		_globalGraph_RenderRegionCentroidsCheckID = Id.check();
		_globalGraph_RenderTriangulationCheckID = Id.check();
		_globalGraph_RenderFilledTrianglesCheckID = Id.check();
		_globalGraph_RenderTriangleCentroidsCheckID = Id.check();
		_globalGraph_RenderHullCheckID = Id.check();
		_globalGraph_RenderOnionCheckID = Id.check();
		_globalGraph_RenderMinSpanTreeCheckID = Id.check();
		_globalGraph_RenderCirclesCheckID = Id.check();
		_globalGraph_RenderBoundsCheckID = Id.check();
	}

	override function update(): Void {

		var globalSettings = _settings.get(_namedEntities.get('GlobalSettings'));

		if (globalSettings.get('showGUI')) {
			var graphics: Graphics = _krs.canvas.g2;

			graphics.pushTranslation(Project.width / -2, Project.height / -2);

			_ui.redrawWindow(_winId);
			_ui.begin(graphics);

			if (_ui.window(_winId, 0, 0, Std.int(Project.width / 4), Project.height, Zui.LAYOUT_VERTICAL)) {

				// Stats
				if (_ui.node(Id.node(), "Stats", 1, false)) {
					_ui.row([3/10, 2/10, 2/10, 3/10]);
					_ui.text("" + _stats.dt, Zui.ALIGN_CENTER);
					_ui.text("< DT");
					_ui.text("FPS >");
					_ui.text("" + _stats.fps, Zui.ALIGN_CENTER);
				}

				_ui.separator();

				// Profiling
				var profile: Bool = globalSettings.get('profile');
				if (_ui.node(Id.node(), "Profiling", 1, false)) {

					_ui.row([1/5, 3/5, 1/5]);
					_ui.text("");
					if (_ui.button('Toggle ${profile ? "Off" : "On"}')) {
						globalSettings.set('profile', !profile);
					}
					_ui.text("");

					if (profile) {
						_ui.indent();
						var i:Int = 0;
						for (prof in _stats.profiles.keys()) {
							if (_ui.node(Id.node() + '_${i++}', prof, 0, false)) {
								var p = _stats.profiles.get(prof);
								_ui.indent();
								_ui.text('Timing: ${p.timing} ms');
								_ui.text('Timing Max: ${p.timingMax} ms');
								_ui.text('Changed Max: ${p.changed}');
								_ui.text('Removed Max: ${p.removed}');
								_ui.unindent();
							}
						}

						if (_ui.node(Id.node(), "Components", 0, false)) {
							_ui.indent();
							for (comp in _stats.comps.keys()) {
								_ui.row([1/2, 1/2]);
								_ui.text(comp, Zui.ALIGN_RIGHT);
								_ui.text(" " + _stats.comps.get(comp), Zui.ALIGN_LEFT);
							}
							_ui.unindent();
						}
						_ui.unindent();
					}
				}

				_ui.separator();

				// Global Delaunay Voronoi Graphic
				var globalGraphSettings = _settings.get(_namedEntities.get('GlobalGraph'));
				syncGlobalGraphSettingsToStates(globalGraphSettings);
				if (_ui.node(Id.node(), "Global Graph", 1, true)) {
					_ui.indent();
					_ui.text('Render:');
					_ui.indent();
					_ui.check(_globalGraph_RenderSitesCheckID, 'Sites', globalGraphSettings.get('renderSites'));
					_ui.check(_globalGraph_RenderRegionsCheckID, 'Regions', globalGraphSettings.get('renderRegions'));
					_ui.check(_globalGraph_RenderFilledRegionsCheckID, 'Filled Regions', globalGraphSettings.get('renderFilledRegions'));
					_ui.check(_globalGraph_RenderRegionCentroidsCheckID, 'Region Centroids', globalGraphSettings.get('renderRegionCentroids'));
					_ui.check(_globalGraph_RenderTriangulationCheckID, 'Triangulation', globalGraphSettings.get('renderTriangulation'));
					_ui.check(_globalGraph_RenderFilledTrianglesCheckID, 'Filled Triangles', globalGraphSettings.get('renderFilledTriangles'));
					_ui.check(_globalGraph_RenderTriangleCentroidsCheckID, 'Triangle Centroids', globalGraphSettings.get('renderTriangleCentroids'));
					_ui.check(_globalGraph_RenderHullCheckID, 'Hull', globalGraphSettings.get('renderHull'));
					_ui.check(_globalGraph_RenderOnionCheckID, 'Onion', globalGraphSettings.get('renderOnion'));
					_ui.check(_globalGraph_RenderMinSpanTreeCheckID, 'Min Span Tree', globalGraphSettings.get('renderMinSpanTree'));
					_ui.check(_globalGraph_RenderCirclesCheckID, 'Circles', globalGraphSettings.get('renderCircles'));
					_ui.check(_globalGraph_RenderBoundsCheckID, 'Bounds', globalGraphSettings.get('renderBounds'));
					_ui.unindent();
					_ui.unindent();
					_globalGraph_RenderStatesExist = true;
				}
				syncStatesToGlobalGraphSettings(globalGraphSettings);

				_ui.separator();

				// Site Settings
				if (_ui.node(Id.node(), "Sites", 1, true)) {
					_ui.indent();
					var siteCnt: Int = Std.int(_ui.slider(Id.slider(), 'Count', 3.0, 50.0, true, 1, globalSettings.get('siteCount'), true));
					globalSettings.set('siteCount', siteCnt);
					var siteSpeedMult: Float = _ui.slider(Id.slider(), 'Speed Multiplier', 0.0, 3.0, true, 100, globalSettings.get('siteSpeedMultiplier'), true);
					globalSettings.set('siteSpeedMultiplier', siteSpeedMult);
					var siteDrag: Float = _ui.slider(Id.slider(), 'Drag', 0.0, 1.0, true, 100, globalSettings.get('siteDrag'), true);
					globalSettings.set('siteDrag', siteDrag);
					_ui.unindent();
				}
			}

			_ui.end();

			graphics.popTransformation();
		}
	}

	function syncGlobalGraphSettingsToStates(settings: StringMap<Dynamic>): Void {
		if (_globalGraph_RenderStatesExist) {
			_ui.checkStates.get(_globalGraph_RenderSitesCheckID).selected = settings.get('renderSites');
			_ui.checkStates.get(_globalGraph_RenderRegionsCheckID).selected = settings.get('renderRegions');
			_ui.checkStates.get(_globalGraph_RenderFilledRegionsCheckID).selected = settings.get('renderFilledRegions');
			_ui.checkStates.get(_globalGraph_RenderRegionCentroidsCheckID).selected = settings.get('renderRegionCentroids');
			_ui.checkStates.get(_globalGraph_RenderTriangulationCheckID).selected = settings.get('renderTriangulation');
			_ui.checkStates.get(_globalGraph_RenderFilledTrianglesCheckID).selected = settings.get('renderFilledTriangles');
			_ui.checkStates.get(_globalGraph_RenderTriangleCentroidsCheckID).selected = settings.get('renderTriangleCentroids');
			_ui.checkStates.get(_globalGraph_RenderHullCheckID).selected = settings.get('renderHull');
			_ui.checkStates.get(_globalGraph_RenderOnionCheckID).selected = settings.get('renderOnion');
			_ui.checkStates.get(_globalGraph_RenderMinSpanTreeCheckID).selected = settings.get('renderMinSpanTree');
			_ui.checkStates.get(_globalGraph_RenderCirclesCheckID).selected = settings.get('renderCircles');
			_ui.checkStates.get(_globalGraph_RenderBoundsCheckID).selected = settings.get('renderBounds');
		}
	}

	function syncStatesToGlobalGraphSettings(settings: StringMap<Dynamic>): Void {
		if (_globalGraph_RenderStatesExist) {
			settings.set('renderSites', _ui.checkStates.get(_globalGraph_RenderSitesCheckID).selected);
			settings.set('renderRegions', _ui.checkStates.get(_globalGraph_RenderRegionsCheckID).selected);
			settings.set('renderFilledRegions', _ui.checkStates.get(_globalGraph_RenderFilledRegionsCheckID).selected);
			settings.set('renderRegionCentroids', _ui.checkStates.get(_globalGraph_RenderRegionCentroidsCheckID).selected);
			settings.set('renderTriangulation', _ui.checkStates.get(_globalGraph_RenderTriangulationCheckID).selected);
			settings.set('renderFilledTriangles', _ui.checkStates.get(_globalGraph_RenderFilledTrianglesCheckID).selected);
			settings.set('renderTriangleCentroids', _ui.checkStates.get(_globalGraph_RenderTriangleCentroidsCheckID).selected);
			settings.set('renderHull', _ui.checkStates.get(_globalGraph_RenderHullCheckID).selected);
			settings.set('renderOnion', _ui.checkStates.get(_globalGraph_RenderOnionCheckID).selected);
			settings.set('renderMinSpanTree', _ui.checkStates.get(_globalGraph_RenderMinSpanTreeCheckID).selected);
			settings.set('renderCircles', _ui.checkStates.get(_globalGraph_RenderCirclesCheckID).selected);
			settings.set('renderBounds', _ui.checkStates.get(_globalGraph_RenderBoundsCheckID).selected);
		}
	}
}
