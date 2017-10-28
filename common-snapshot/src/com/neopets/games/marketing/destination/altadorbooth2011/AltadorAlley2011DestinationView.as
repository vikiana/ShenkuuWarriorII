/**
 *	Popsicle Destination Document Class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooth2011
{
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.util.flashvars.FlashVarManager;
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
	
	public class AltadorAlley2011DestinationView extends AbsView
	{
		//----------------------------------------
		// 	CONSTANTS
		//-----------------------------------------
		//customize these parameters in your destination subclass
		private const NEOCONTENT_ID:String = "1710";
		private const LIB_PATH:String = "sponsors/altadoralley/2011/altadoralley_assets.swf";
		
		
		
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
		public function AltadorAlley2011DestinationView():void
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
			init (new AltadorAlley2011DestinationControl(), NEOCONTENT_ID, true, mServers.isOnline)
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
			e.target.removeEventListener (Event.COMPLETE, onLibLoaded);
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
			var ls:Preloader = new Preloader ();
			ls.name = "preloader";
			addChild(ls);
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

		
	}
}