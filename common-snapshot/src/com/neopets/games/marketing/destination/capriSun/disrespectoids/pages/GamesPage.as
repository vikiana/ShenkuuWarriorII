/**
 *	This class handles the destination's gaming room.
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
	import flash.net.SharedObject;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	
	public class GamesPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GamesPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			// check if this swf has been loaded previously
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
			var req_event:CustomEvent = new CustomEvent("GameArea",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("gameArea",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16126,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			dispatchEvent(req_event);
		}

	}
	
}