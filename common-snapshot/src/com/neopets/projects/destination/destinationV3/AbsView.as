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
  * 2) D.view should instantiate DestinationControl(D.control) class
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
  * OTHER PAGES
  *	-Each "page" must extend AbstractClass or one of its children
  *	-Each page should set up its components ex. introPage should set up it's own background, buttons, etc.
  * -Small actions can be managed within page itself
  **/
 
package com.neopets.projects.destination.destinationV3
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarsFinder;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	
	//"http://images50.neopets.com"
		
	public class AbsView extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//Events
		public static const OBJ_CLICKED:String = "obj_clicked"	//dispatch evt when any objs are clicked
		public static const SETUP_READY:String = "setup_ready"  //dispatch evt when AbsView is setup
		public static const ADD_DISPLAY_OBJ:String = "add Display Object"
		public static const REMOVE_DISPLAY_OBJ:String = "remove Display object"
		public static const USER_NAME_SET:String = "connected_to_server_and_retrieved_user_name"
		public static const GUEST_USER:String = "GUEST_USER_ACCOUNT"	// user not logged in
			
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		public function AbsView():void
		{
			trace("\n ===== 1. DESTINATION STARTED ===== \n");
			Parameters.view = this;
		
			addEventListener(AbsView.ADD_DISPLAY_OBJ, addDisplayObj, false, 0, true)
			addEventListener(AbsView.REMOVE_DISPLAY_OBJ, removeDisplayObj, false, 0, true)
			addEventListener(MouseEvent.MOUSE_DOWN, handleClick, false, 0, true)
		}
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	For this project to work smoothly offline, online and between dev and live
		 *	We need to retrieve correct base url (dev.neopet.com vs www.neopets.com)
		 *	@PARAM		pBaseURL		String		this should be determined between you and php person
		 *	@NOTE:	Please note that base URL must return either: 
		 *
		 *			"http://dev.neopets.com" (not "dev.neopets.com" or "http://dev.neopets.com/")
		 *					or
		 *			"http://www.neopets.com" (not "www.neopets.com" or "http://www.neopets.com/")
		 **/
		protected function setBaseURLs(pBaseURL:String):void
		{
			trace ("If you have not done so already, please contact your php person and be sure that the baseurl returned value is either 'http://www.neopets.com' or 'http://dev.neopets.com'")
			var baseURL:String = FlashVarsFinder.findVar(this.stage.root, pBaseURL);
			if (baseURL == null)
			{
				trace ("ERROR: [setBaseURL() in AbsView.as]   flashvar", pBaseURL, "is not valid")
				trace ("By default the base url will be set to 'http://dev.neopets.com'")
				baseURL = "http://dev.neopets.com"
			}
			else if (baseURL != "http://dev.neopets.com" && baseURL != "http://www.neopets.com")
			{
				trace ("what's my base url??", baseURL)
				trace ("ERROR: [setBaseURL() in AbsView.as]   retuned value is invalid")
				trace ("Contact your php person and be sure that the returned value is either 'http://www.neopets.com' or 'http://dev.neopets.com'")
				trace ("By default the base url will be set to 'http://dev.neopets.com'")
				baseURL = "http://dev.neopets.com"
			}
			Parameters.baseURL = baseURL;
			Parameters.imageURL = (baseURL == "http://dev.neopets.com") ? "http://images50.neopets.com": "http://images.neopets.com";
		}
		
		/**
		 *	Once both view and control classes' instances have been created, 
		 *	retrieve user data and set up params
		 *	@PARAM		pType		int		unless told otherwise use 14 for all destination
		 *	@PARAM		pItem		int 	For destination use neocontend project ID
		 **/
		protected function init(pControl:Object, pItem:String, pGroupMode:Boolean, pOnlineMode:Boolean):void
		{
			Parameters.control = pControl;
			Parameters.projectID = pItem;
			Parameters.groupMode = pGroupMode;
			Parameters.onlineMode = pOnlineMode;
			retrieveUserInfo();
		}
		
		/**
		*	connects to amfphp 
		**/
		protected function retrieveUserInfo():void
		{
			trace("\n ===== 3. RETRIEVE USER DATA ===== \n");
			Parameters.connection = new NetConnection();
			Parameters.connection.objectEncoding = ObjectEncoding.AMF0;
			Parameters.connection.connect(Parameters.baseURL+"/amfphp/gateway.php");
			getUsername();
		}
		
		/**
		*	Check the log in status by retrieving user name via feedAPet...
		**/
		protected function getUsername():void
		{
			var responder:Responder = new Responder(returnUsername, usernameError);
			Parameters.connection.call("FeedAPet.getUsername", responder);
		}
		
		/**
		*	Returns the user name if successfully connected.
		*	@Note:	String "false" will be returned if user is not logged in
		**/
		protected function returnUsername(p:String):void 
		{
			if (p == "false")
			{
				Parameters.userName = AbsView.GUEST_USER
				Parameters.loggedIn = false;
			}
			else 
			{
				Parameters.userName = p
				Parameters.loggedIn = true;
			}
			readyForSetup();
		}
		
		
		/**
		*	return error if retrieving name was unsuccessful
		**/
		protected function usernameError(f:Object) :void
		{
			trace("AbsView.as, usernameError, USERNAME ERROR: " + f.description);
		}
		
		
		/**
		*	When initial parameters are ready, dispatch event so control can do its setup
		**/
		protected function readyForSetup():void
		{
			trace("\n ===== 4. READY FOR SETUP ===== \n");
			trace ("   VIEW      :", Parameters.view);
			trace ("   CONTROL   :",Parameters.control);
			trace ("   PROJ ID   :",Parameters.projectID);
			trace ("   USER NAME :",Parameters.userName);
			trace ("   LOGGED IN :",Parameters.loggedIn);
			trace ("   GROUP	 :",Parameters.groupMode);
			trace ("   ONLINE	 :",Parameters.onlineMode);
			trace ("   BASE URL	 :",Parameters.baseURL);
			trace ("   IMAGE URL :",Parameters.imageURL, "\n");
			setupReady();
			dispatchEvent(new Event (AbsView.SETUP_READY))
		}
		
		/**
		*	in case view needs to do anything before dispatching an event, override it (by its child)
		**/
		protected function setupReady():void {}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		// when a obj is clicked from, report the cliecked obj to destination control (or its child)
		private function handleClick(e:Event):void 
		{
			dispatchEvent(new CustomEvent({DATA:e.target},AbsView.OBJ_CLICKED))
		}
		
		// add created page (or scene) to the stage 
		private function addDisplayObj (e:CustomEvent):void
		{
			trace (e.oData.DATA, "was added to stage - AbsView")
			addChild(e.oData.DATA)
		}
		
		// removes a designated page (or scene) from the stage 
		private function removeDisplayObj (e:CustomEvent):void
		{
			trace (e.oData.DATA, "was removed from stage - AbsView")
			removeChild(e.oData.DATA)
		}
	}
}