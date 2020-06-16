using Toybox.WatchUi;

class ErrorView extends WatchUi.View {
	hidden var _message;
	
	function initialize(message) {
		View.initialize();
	}
	
	function onLayout(dc) {
		setLayout(Rez.Layouts.ErrorLayout(dc));
		var vie = View.findDrawableById("Message");
		view.setText(_message.toString());
	}
}