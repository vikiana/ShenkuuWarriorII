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
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationView;
	import com.neopets.games.marketing.destination.sixFlags2010.SixFlagsConstants;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.tracker.NPStatsTracker;
	import com.neopets.util.tracker.NeoTracker;


	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class SixFlags2010DestinationView extends SixFlags2010AbsDestinationView
	{
		//----------------------------------------
		// 	CONSTANTS
		//-----------------------------------------

		private const NEOCONTENT_ID:String = "1704";
		

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var _servers:NeopetsServerFinder;
		private var _statsTracker:NPStatsTracker;
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		*	instantiate control class and set up project ID
		**/
		public function SixFlags2010DestinationView():void
		{
			super();
			_statsTracker = new NPStatsTracker (SixFlagsConstants.EXTTRACKING_PROJECT_ID);
			Parameters.assetPath = SixFlagsConstants.LIB_PATH_BASE;
			_servers = new NeopetsServerFinder(this);
			Parameters.baseURL = _servers.scriptServer;
			Parameters.imageURL = _servers.imageServer;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		

		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		//this tracking is still a mix between Bill Wetter tracking class and the Tracking proxy. This will need to be combined in the next destination code revamp.
		public function trackPageViews (pName:String):void {
			var pageId:String;
			var ncid:int = 0;
			switch (pName){
				case "landing":
					pageId = "Main Landing";
					ncid = 15953;
					break;
				case "video":
					pageId = "Video Gallery";
					ncid = 16358;
					break;
				case "info":
					pageId = "Info Booth";
					ncid = 16346;
					break;
				case "souvenir":
					pageId = "Souvenir Shop";
					ncid = 15976;
					break;
				case "feedaPet":
					pageId = "Feed-a-Pet";
					ncid = 15962;
					break;
				case "flags":
					pageId = "Flags of Fun Competition";
					ncid = 15991;
					break;
			}
			TrackingProxy.sendReportingCall(pageId, "SixFlags2010");
			_statsTracker.sendGooglePageView(pageId);
			if (ncid>0){
				NeoTracker.instance.trackNeoContentID(ncid);
			}
		}

		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		override protected function initialize ():void {
			init (new SixFlags2010DestinationControl(), NEOCONTENT_ID, true, mServers.isOnline)
		}
		
		/**
		 *	additional setup?
		 **/
		/*override protected function customSetup ():void {
			//add code here, then call this
			super.customSetup();
		}*/
		
		override protected function createLoadingSign():void{
			var ls:SixFlagsPreloader = new SixFlagsPreloader();
			ls.name = "preloader";
			addChild(ls);
		}
		
		
	
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
				
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

		
	}
}