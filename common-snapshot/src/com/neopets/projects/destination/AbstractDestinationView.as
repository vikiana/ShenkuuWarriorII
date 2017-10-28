/**
 *	It's a document class for click destination project
 *	Think this as more of a display shell class.
 *	Its main functions are:
 *	A. In charge of initialization, (retrieve user data etc.)
 *	B. Then notify Destination to take over the control
 *	C. Add or remove pages (or scenes) from the stage when it's told to do so by DestinationControl
 *	D. Report to DestinationControl (via dispatchEvent) any button that's clicked on the stage
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */
 
 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------
 /**
  * Prep:
  *	To use any classes here, you must create a class(es) and extend abstract classes you wish to use
  *	Every time any class name (or abstract class name) is mentioned, 
  * assume I am referring it as a child class of that abstract class.
  *
  * Workflow:
  * 1) DestinationView (D.view) should be your document class
  * 2) D.view should instantiates DestinationControl(D.control) class
  *	3) D.view retrieves user name and once it's ready it'll dispatch an event for D.control to hear 
  *	4) upon hearing it, D.control takes over the control and usually sets up the landing page
  *	5) Once this inital dynamic has been set up, a triangle dynamic is formed:
  *
  *	ABS. DESTINATION VIEW (or its child)
  * -In charge of adding and removing "pages" (scene) from the stage when it is told to do so by D.control 
  *	-When display Objects are clicked, it will report to D.control via event dispatcher
  *	
  *	ABS. DESTINATION CONTROL (or its child)
  *	-It is in charge of hearing what's being clicked from the stage and taking appropriate actions   
  *	-However Not all actions must be contolled by DestinationControl.
  *
  * OTHER THE PAGES
  *	-Each "page" must extend AbstractClass or one of its children
  *	-Each page should set up its components ex. introPage should set up it's own background, buttons, etc.
  * -Small actions can be managed within page itself
  **/
 
package com.neopets.projects.destination
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	//
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	
		
	public class AbstractDestinationView extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public static const OBJ_CLICKED:String = "obj_clicked"	//is dispatched when any objects are clicked
		public static const SETUP_READY:String = "setup_ready"  //is dispatched when it's ready to give contol over to destinationControl
		
		public const ADD_DISPLAY_OBJ:String = "add Display Object"
		public const REMOVE_DISPLAY_OBJ:String = "remove Display object"
		public const USER_NAME_SET:String = "connected_to_server_and_retrieved_user_name"
		public const GUEST_USER:String = "GUEST_USER_ACCOUNT"
		
		private var mControl:AbstractDestinationControl;
		private var mUserName:String
		private var mConnection:NetConnection;
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		public function AbstractDestinationView():void
		{
			trace ("Destination started");
			addEventListener(ADD_DISPLAY_OBJ, addDisplayObj, false, 0, true)
			addEventListener(REMOVE_DISPLAY_OBJ, removeDisplayObj, false, 0, true)
			addEventListener(MouseEvent.MOUSE_DOWN, handleClick, false, 0, true)
			retrieveUserInfo()
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		public function get userName():String
		{
			return mUserName
		}
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		//connects to feedapet amfphp (for now until we come up with generic amfphp system) and retrieve user data
		protected function retrieveUserInfo():void
		{
			trace("FUNCTION: connect to server and retrieve user data");
			mConnection = new NetConnection();
			mConnection.objectEncoding = ObjectEncoding.AMF0;
			mConnection.connect("http://www.neopets.com/amfphp/gateway.php");
			getUsername();
		}
		
		// Check the log in status by retrieving user name
		protected function getUsername():void
		{
			var responder = new Responder(returnUsername, usernameError);
			mConnection.call("FeedAPet.getUsername", responder);
		}
		
		// Returns the user name if successfully conneted.  
		// Note: String "false" will be returned if user is not logged in
		protected function returnUsername(p:String) 
		{
			trace("USERNAME = " + p);
			if (p == "false")
			{
				trace ("user not logged in")
				mUserName = GUEST_USER
				dispatchEvent(new Event (USER_NAME_SET));
			}
			else 
			{
				mUserName = p
				dispatchEvent(new Event (USER_NAME_SET));
			}
		}
		
		//return error if retrieving name was unsuccessful
		protected function usernameError(f:Object) 
		{
			trace("USERNAME ERROR: " + f.description);
		}
		
		// Child must override this and initiate a child of destination control
		protected function mainControlInit():void{};
		
		// Child should either call this function or override it to notify the control (or its child) class when ready
		protected function readyForSetup():void
		{
			dispatchEvent(new Event (SETUP_READY))
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		// when a obj is clicked from, report the cliecked obj to destination control (or its child)
		private function handleClick(e:Event):void 
		{
			dispatchEvent(new CustomEvent({DATA:e.target},OBJ_CLICKED))
		}
		
		// add created page (or scene) to the stage 
		private function addDisplayObj (e:CustomEvent):void
		{
			trace (e.oData.DATA, "is added to stage")
			addChild(e.oData.DATA)
		}
		// removes a designated page (or scene) from the stage 
		private function removeDisplayObj (e:CustomEvent):void
		{
			trace (e.oData.DATA, "is removed from stage")
			removeChild(e.oData.DATA)
		}
	}
}