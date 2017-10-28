/*
 *	Package: AMFPHP [1.4-1.9]
 *	Version: 1.1
 *	Author: Kyle Brekke
 *
 *	This package connects and executes amfphp requests in a simple
 *	and contained form using NetConnection and call back functions
 *
 *	Example:
 *	var rConn:amfphp = new amfphp("http://localhost/amfphp/gateway.php", "Helloworld.say", new Array("Hello World"), {onResponse:testResponse});
 *
 * amfphp():
 	gatewayURL: 	url of the gateway.php file of your amfphp server
	callFunction: 	the name of the php function: "subfolder.file/class.function"
	objectEncoding: is a uint representing either AMF0 or AMF3
	debug:			This determines whether or not the class traces values as
 *					certain key moments to help with debugging server info
 *
 * extended arguments:
 * 	onResponse - 		callback function if server returns the response
 *						and it passes in response + parameters
 * 	OnResponseParams - 	object of the paramters to pass onReponse callback
 * 	onError - 			callback function if server returns an error
 * 	OnErrorParams - 	object of the paramters to pass onError callback
 * 	serverReponse - 	the object that holds the "result" object (read only)
 *	errorResponse -		the object that folds the "error" object (read only)
 *
 *
 * assocMySQL(serverResponse):
 *	a function that processes the server response into an associative
 *	array for easy use in projects
 *		serverReponse - 	the object that holds the "result"
 *
 * walkResponse(serverResponse):
 *	a function that traces 2 layers deep of object properties
 *	that can be useful in debugging error objects or MySQL returns
 */

 /**
  * Modified by Robert Brisita
	* 8/25/2008 12:40 PM
	*  Modifications:
	* 	Extend EventDispatcher instead of Sprite.
	* 		Reason it never uses any of Sprite's functionality.
	*
	* 	Added request method.
	* 		Reason so that the user doesn't always have to say new amfphp
	* 		when wanting to communicate with AMFPHP service.
	*
	* 	Constructor no longer needs arguments to construct.
	* 		Reason so that user can create one amfphp instance
	* 		and use that through out the application.
	*
	* 	Added setupAMFConnection method.
	* 		Reason so that the NetConnection Instance only needs
	* 		to be setup once versus the old implementation
	* 		of setup everytime user called amfphp constructor.
	*
	* 	Added amfCall method.
	* 		As to not duplicate code on the amfConnection member.
	*
	* 	Added event listeners.
	* 		Correctly listens for events now for better error
	* 		handling.  Was listening for "ArgumentError" but
	* 		NetConnection will never dispatch that event.
	*
	* 	Fixed errors in walkResponse method and changed it to a recursive method.
	* 		The conditional if was testing the string rather
	* 		than the object itself.
	* 		The inner for loop was checking the string rather
	* 		than the object.
	* 		The inner for loop was a "for each in" when it should
	* 		be a "for in".
	*
	* 	Fixed bug with _extraArgs.
	* 		_extraArgs creates a new Object in the instace declaration
	* 		but the constructor passes in null as default.  This
	* 		leads to a null reference at runtime.
  */
package virtualworlds.com.kylebrekke.amfphp
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;

	/**
	 * Setups a NetConnection and Responders
	 * to communicate with a server running
	 * AMFPHP.
	 */
	public class amfphp extends EventDispatcher
	{
		// Class Options
		private const objEncoding:uint = 0;
		private const _debug:Boolean = true;
		
		// Class Objects
		private var amfConnection:NetConnection = new NetConnection();
		private var amfResponder:Responder = new Responder(handleResponse, faultResponse);
		
		// Private Variables
		private var _gatewayURL:String;
		private var _callFunction:String;
		private var _parameters:Array;
		private var _extraArgs:Object;
		private var _servResponse:*;
		private var _errorResponse:*;
		
		public function get serverResponse():* {
			return _servResponse;
		}
		public function get errorResponse():* {
			return _errorResponse;
		}
		
		public function amfphp(gatewayURL:String = null,
														callFunction:String = null,
														amfArgs:Array = null,
														extraArgs:Object = null)
		{
			
			
			// Set up NetConnection
			setupAMFConnection();
			
			// Validate arguments
			if(gatewayURL && callFunction)
			{
				request(gatewayURL, callFunction, amfArgs, extraArgs);
			}
		}
		
		//////////
		// Methods
		//////////
		
		/**
		 * Request given call function from the given gateway.
		 *
		 * @param	gatewayURL 		Gateway where the service lives.
		 * @param	callFunction	Function to execute on the gateway service.
		 * @param	amfArgs				Any aruments to pass to function.
		 * @param	extraArgs			Function call backs that amfphp will call on error or result of NetConnection call.
		 */
		public function request(gatewayURL:String,
														callFunction:String,
														amfArgs:Array = null,
														extraArgs:Object = null):void
		{
			
			
			
			
			
			
			
			_gatewayURL = gatewayURL;
			_callFunction = callFunction;
			_extraArgs = extraArgs;
			
			// Prepare variables to be sent
			initAmfArgs(amfArgs);
			
			amfCall();
		}
		
		public static function assocMySQL(result:Object):Array {
			if (!result.serverInfo) {
				return null;
			}
			
			var sqlRecordSet:Array = new Array()
			for (var row:Number=0;row<result.serverInfo.initialData.length;row++) {
				sqlRecordSet[row] = new Array();
				for (var colIndex:* in result.serverInfo.columnNames) {
					sqlRecordSet[row][result.serverInfo.columnNames[colIndex]] = result.serverInfo.initialData[row][colIndex];
				}
			}
			return sqlRecordSet;
		}
		
		/**
		 * Display member of the given object in the trace output.
		 * Mainly for debugging purposes.
		 *
		 *
		 * @param	result 		Result object to parse and display members from.
		 * @param	a_spacer	Spacing text for each member that is an object inside a parent object.
		 */
		public static function walkResponse(result:Object, a_spacer:String = "--"):void
		{
			for(var layerOne:String in result)
			{
				
				if(result[layerOne] is Object)
				{
					walkResponse(result[layerOne], a_spacer + "--");
				}
			}
		}
		
		/**
		 * Creates _parameters member so that it can be sent
		 * through a NetConnection instance.  Uses _callFunction
		 * member.
		 *
		 * @param	amfArgs Array holding values to be sent.
		 */
		private function initAmfArgs(amfArgs:Array):void {
			_parameters = new Array(_callFunction, amfResponder);
			for (var j:* in amfArgs) {
				_parameters.push(amfArgs[j]);
			}
		}
		
		/**
		 * Called from constructor
		 * to setup NetConnection and
		 * connect the call.
		 */
		private function initAmfConnection():void
		{
			setupAMFConnection();
			amfCall();
		}
		
		/**
		 * Set object encoding and listeners for
		 * NetConnection instance amfConnection.
		 */
		private function setupAMFConnection():void
		{
			amfConnection.objectEncoding = objEncoding;
			
			amfConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			amfConnection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			amfConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			amfConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		}
		
		/**
		 * Using amfConnection to connect to
		 * _gatewayURL passing in _parameters.
		 */
		private function amfCall():void
		{
			
			
			
			
			
			amfConnection.connect(_gatewayURL);
			if (_debug) { walkResponse(_parameters); }
			this.amfConnection.call.apply(this, _parameters);
		}
		
		//////////
		// Events
		//////////
		
		private function handleResponse(result:Object):void
		{
			if (_debug) {  }
			
			_servResponse = result;
			
			if(_extraArgs)
			{
				walkResponse(_extraArgs);
				
				if(_extraArgs.onResponse !== undefined)
				{
					var responseParams:Array = new Array();
					responseParams.push(_servResponse);
					
					if(_extraArgs.onResponseParams !== undefined)
					{
						responseParams.splice(1, 0, _extraArgs.onResponseParams.toString());
					}
					
					_extraArgs.onResponse.apply(this, responseParams);
				}
			}
		}
		
		private function faultResponse(result:Object):void
		{
			if (_debug) {  }
			
			_errorResponse = result;
			
			if(_extraArgs)
			{
				if(_extraArgs.onError !== undefined)
				{
					var errorParams:Array = new Array();
					errorParams.push(_errorResponse);
					
					if(_extraArgs.onErrorParams !== undefined)
					{
						errorParams.splice(1, 0, _extraArgs.onErrorParams.toString());
					}
					
					_extraArgs.onError.apply(this, errorParams);
				}
			}
		}
		
		private function onNetStatus(a_evt:NetStatusEvent):void
		{
			
			
			walkResponse(a_evt.info);
			this.dispatchEvent(a_evt);
			
			// Old usage
			handleNCStatus(a_evt);
		}
		
		private function onAsyncError(a_evt:AsyncErrorEvent):void
		{
			
			
			walkResponse(a_evt.error);
			this.dispatchEvent(a_evt);
			
			// Old usage
			handleNCStatus(a_evt);
		}
		
		private function onIOError(a_evt:IOErrorEvent):void
		{
			
			
			this.dispatchEvent(a_evt);
			
			// Old usage
			handleNCStatus(a_evt);
		}
		
		private function onSecurityError(a_evt:SecurityErrorEvent):void
		{
			
			
			this.dispatchEvent(a_evt);
			
			// Old usage
			handleNCStatus(a_evt);
		}
		
		// Old usage
		// Class Events Constants
		public static const NETWORK_ERROR:String = "networkError";

		private function handleNCStatus(evt:*):void {
			if (_debug) {  }
			this.dispatchEvent(new Event(NETWORK_ERROR));
		}		
	}
}
