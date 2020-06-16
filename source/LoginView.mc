using Toybox.WatchUi as Ui;

class LoginDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}
}

class LoginView extends Ui.View {

	hidden var _transaction;
	
	hidden var _running;
	
	function initialize() {
		View.initialize();
		_transaction = new LoginTransaction(new LoginTransactionDelegate());
		_running = false;
	}
	
	function onLayout(dc) {
		setLayout(Rez.Layouts.LoginLayout(dc));
	}
	
	function onShow() {
		if(_running == false) {
			_transaction.go();
			_running = true;
		}
	}
}