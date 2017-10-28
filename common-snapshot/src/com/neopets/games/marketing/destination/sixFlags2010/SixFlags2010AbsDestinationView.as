/**
 *	Popsicle Destination Document Class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.sixFlags2010
{
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader_v2;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.loading.LibraryLoader;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.vendor.gamepill.novastorm.render.sprite;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.Responder;

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class SixFlags2010AbsDestinationView extends AbsView
	{
		//----------------------------------------
		// 	CONSTANTS
		//-----------------------------------------
		//customize these parameters in your destination subclass
		private const NEOCONTENT_ID:String = "";
		private const LIB_PATH:String = "";
		
		
		
		//EVENTS
		public static var LIB_LOADED:String = "library_loaded";
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var mServers:NeopetsServerFinder;
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		*	instantiate control class and set up project ID
		**/
		public function SixFlags2010AbsDestinationView():void
		{
			super();
			Parameters.assetPath = LIB_PATH;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		

		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		public function setUp ():void {
			//createGradientBkg();
			createLoadingSign();
			//
			FlashVarManager.instance.initVars(root);
			// figure out our servers
			mServers = new NeopetsServerFinder(this);
			Parameters.baseURL = mServers.scriptServer;
			Parameters.imageURL = mServers.imageServer;
			//initialize with custom control class.
			initialize();
		}

		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
	
		
		
		//created the control class
		protected function initialize ():void {
			trace ("Abstract initialize (). Override this");
		}
		
		/**
		 *	This version doesn't need an username so it just checks if it is logged in
		 **/
		
		override protected function getUsername():void
		{
			var responder:Responder = new Responder(returnLoggedIn, usernameError);
			Parameters.connection.call("FeedAPet.getUsername", responder);
			//Parameters.connection.call("AltadorAlley2010Service.macStatus", responder);
		}
		
		/**
		 *	Returns the user name if successfully connected.
		 *	@Note:	Object - it contains a userInfo obj that has a String (auth) indicating the user status
		 **/
		protected function returnLoggedIn(p:Object):void 
		{
			if (p.toString() == AbsView.GUEST_USER)
			{
				Parameters.userName = AbsView.GUEST_USER
				Parameters.loggedIn = false;
			}
			else 
			{
				Parameters.userName = p.toString();
				Parameters.loggedIn = true;
			}
			readyForSetup();
		}
		
		/**
		 *	This is called after inital prameters are set (view, control, user name and project ID)
		 *	remove spinning arrow or do other things as you please
		 **/
		protected override function  setupReady ():void
		{
			//Load the library
			var libPath:String
			Parameters.onlineMode ? libPath = Parameters.imageURL+"/"+Parameters.assetPath : libPath = Parameters.assetPath;
			trace("path:"+libPath, "online?", Parameters.onlineMode, "image url:", Parameters.imageURL, "asset path:", Parameters.assetPath);
			LibraryLoader.loadLibrary(libPath, onLibLoaded);
		}
		
		protected function onLibLoaded(e:Event):void {
			trace ("Library "+Parameters.assetPath+" is loaded.");
			//removing loader sign
			if (getChildByName("preloader") != null) removeChild(getChildByName("preloader"));
			customSetup();
		};
			
		
		/**
		 *	override this if there are additional set up to do. Otherwise it calls the control to build the pages
		 **/
		protected function customSetup ():void {
			//trace (this, "customSetup()");
			//trace ("Username: ", Parameters.userName);
		  	dispatchEvent(new Event (LIB_LOADED));
		}
		
	
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		
		protected function createLoadingSign ():void {
			trace ("Abstract createLoadingSign: overide with custom preloader");
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

		
	}
}