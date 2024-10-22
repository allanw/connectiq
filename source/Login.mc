using Toybox.Communication as Comm;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class LoginTransaction
{
	hidden var _delegate;
	hidden var _complete;
	
	function initialize(delegate) {
		_delegate = delegate;
		_complete = false;
		
		Comm.registerForOAuthMessages(method(:accessCodeResult));	
	}
	
	function accessCodeResult(value) {
		if( value.data != null) {
			_complete = true;
			// Extract the access code from the JSON response
			getAccessToken(value.data["value"]);
		}
		else {
			Sys.println("Error in accessCodeResult");
			Sys.println("data = " + value.data);
			_delegate.handleError(value.responseCode);
		}
	}
	
	// Convert the authorization code to the access token
	function getAccessToken(accessCode) {
		// Make HTTPS POST request to request the access token
		Comm.makeWebRequest(
			// URL
			"https://www.strava.com/oauth/token",
			// Post parameters
			{
				"client_secret"=>$.ClientSecret,
				"client_id"=>$.ClientId,
				"code"=>accessCode
			},
			// Options to the request
			{
				:method => Comm.HTTP_REQUEST_METHOD_POST
			},
			// Callback to handle response
			method(:handleAccessResponse)
		);
	}
	
	// Callback to handle receiving the access code
	function handleAccessResponse(responseCode, data) {
		// If we got data back then we were successful.
		// Otherwise pass the error onto the delegate
		if( data != null) {
			_delegate.handleResponse(data);
		} else {
			Sys.println("Error in handleAccessResponse");
			Sys.println("data = " + data);
			_delegate.handleError(responseCode);
		}
	}
	
	// Method to kick off transaction
	function go() {
		// Kick off a request for the user's credentials
		Comm.makeOAuthRequest(
			// URL for the authorization URL
			"https://www.strava.com/oauth/authorize",
			// POST parameters
			{
				"client_id"=>$.ClientId,
				"response_type"=>"code",
				"scope"=>"public",
				"redirect_uri"=>$.RedirectUri
			},
			// Redirect URL
			$.RedirectUri,
			// Response type
			Comm.OAUTH_RESULT_TYPE_URL,
			// Value to look for
			{"code"=>"value"}
			);
	}
}


// This is a TransactionDelegate for handling the login
class LoginTransactionDelegate extends TransactionDelegate {
	
	function initialize() {
		TransactionDelegate.initialize();
	}
	
	// Handle an error from the server
	function handleError(code) {
		var msg = WatchUi.loadResource( Rez.Strings.error );
		msg += code;
		Ui.switchToView(new ErrorView(msg), null, Ui.SLIDE_IMMEDIATE);
	}
	
	// Handle a successful response from the server
	function handleResponse(data) {
		// Store the access and refresh tokens in properties
		// For app store apps the properties are encrypted using
		// a randomly generated key
		App.getApp().setProperty("refresh_token", data["refresh_token"]);
		App.getApp().setProperty("access_token", data["access_token"]);
		// Store away the athlete id
		App.getApp.setProperty("athlete_id", data["athlete"]["id"]);
		// Switch to the data view
		Ui.switchToView(new MyView(), null, Ui.SLIDE_IMMEDIATE);
	}
	
}