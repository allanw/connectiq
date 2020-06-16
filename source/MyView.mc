using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class MyView extends Ui.View {

	function initialize() {
		View.initialize();
	}


	function onLayout(dc) {
		setLayout(Rez.Layouts.Summary(dc));
	}
	
	function onUpdate(dc) {
		View.onUpdate(dc);
	}
	
	function onHide() {
	}
}