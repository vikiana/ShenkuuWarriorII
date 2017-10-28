/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	
	public class LandingPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LandingPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// finish loading
			DisplayUtils.cacheImages(this);
			// dispatch tracking when shown by preloader
			addEventListener(DestinationView.SHOW,onShown);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			// dispatch tracking requests
			var req_event:CustomEvent = new CustomEvent("Main",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("main",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16124,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			dispatchEvent(req_event);
		}

	}
	
}