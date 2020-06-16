using Toybox.Application;

const RedirectUri = "https://localhost";

class NewProjectApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	if(!System.getDeviceSettings().phoneConnected) {
        	return [ new ConnectToGcmView() ];
        }
        else {
        	return [ new LoginView(), new LoginDelegate() ];
        }
    }

}