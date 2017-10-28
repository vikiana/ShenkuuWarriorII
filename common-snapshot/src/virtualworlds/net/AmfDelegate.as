//Marks the right margin of code *******************************************************************
package virtualworlds.net
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.Responder;
	
	
	/**
	 * Amfphp delegate.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>chrisa</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	*/
	public class AmfDelegate  extends EventDispatcher
	{
		//--------------------------------------------------------------------------
	    //Public properties
	    //--------------------------------------------------------------------------	
		/**
		 * Default amfphp gateway url.
		 */
		 public static const DEFAULT_GATEWAY_URL : String = "http://services.petpetpark-d.mtvi.com/amfphp/gateway.php";
		 
		//--------------------------------------------------------------------------
	    //Private properties
	    //--------------------------------------------------------------------------	
	    /**
		 * The amfphp gateway url.
		 */
		 public function get gatewayURL():String { return _gatewayURL; }
		 public function set gatewayURL(value:String):void{ _gatewayURL = value;}
		 private var _gatewayURL : String;
		 
		/**
		 * Remoting connection.
		 */
		 private var _remotingConnection : RemotingConnection;
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		/**
		 * Creates a new AmfDelegate instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		*/
		public function AmfDelegate()
		{
			
		}
		
		//--------------------------------------------------------------------------
		//Methods
		//--------------------------------------------------------------------------	
		// public 
		/**
	    * Connect to the amfphp service.
	    * 
	    */
		public function connect():void
		{
			if(_gatewayURL == null ){
				throw new Error("gatewayURL undefined");
			}
			
			if(_remotingConnection == null){
				_remotingConnection = new RemotingConnection(_gatewayURL);
				_remotingConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
			
		}
		
		/**
		 * Register remote classes.
		 * 
		 * @param classesArray An array of classes to register.
		 * 
		 */
		 public function registerRemoteClasses(classesArray:Array):void
		 {
		 	var i : int;
		 	var iMax : int = classesArray.length;
		 	for(i = 0; i < iMax; i ++ ){
		 		classesArray[i].register();
		 	}
		 }
		 
		 /**
		  * Call a remote method.
		  * 
		  * @param functionName The name of the function to call(example: GameService.sendScore).
		  * @param responder The responder Object responsible for handling service call success and fault.
		  * @param ...rest optional arguments.
		  * 
		 */
		 public function callRemoteMethod(functionName:String, responder : Responder, ... rest):void
		 {
		 	var temp : Array = [functionName, responder].concat(rest);
		 	_remotingConnection.call.apply(this, temp);
		 	
		 }
   		// private
	   
		//--------------------------------------------------------------------------
	    //Events
	    //--------------------------------------------------------------------------	
		/**
	    * Handler for NetStatusEvent.NET_STATUS.
	    * 
	    * @param event The <code>NetStatusEvent</code>
	    * 
	    */
	    private function onNetStatus(event:NetStatusEvent) : void
	    {
			trace ("connection"+event);
	    	dispatchEvent(event);
	    } 

	}
}