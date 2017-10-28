/**
 *	This class handles the "kitchen" location in the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*;
	import com.neopets.games.marketing.destination.kidCuisine2.DestinationData;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.kidCuisine2.utils.DebugTracer;
	
	public class BreakPage extends AbsPageWithTracking
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// protected variables
		protected var _backButton:MovieClip;
		protected var _memoryLink:MovieClip;
		protected var _rescueLink:MovieClip;
		protected var _jukeboxClip:MovieClip;
		protected var _violatorClip:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function BreakPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			// finish loading
			DisplayUtils.cacheImages(this);
			neoContentID = 15624;
			//DebugTracer.addTextfieldTo(this,width,height);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get backButton():MovieClip { return _backButton; }
		
		public function set backButton(clip:MovieClip) {
			_backButton = clip;
			if(_backButton != null) _backButton.page = null;
		}
		
		public function get jukeboxClip():MovieClip { return _jukeboxClip; }
		
		public function set jukeboxClip(clip:MovieClip) {
			// clear previous jukebox
			if(_jukeboxClip != null) _jukeboxClip.helpPopUp = null;
			// set new jukebox
			_jukeboxClip = clip;
			if(_jukeboxClip != null) {
				_jukeboxClip.helpPopUp = getChildByName("popup_mc") as MovieClip;
			}
		}
		
		public function get memoryLink():MovieClip { return _memoryLink; }
		
		public function set memoryLink(clip:MovieClip) {
			_memoryLink = clip;
			if(_memoryLink != null) {
				_memoryLink.dartURL = "http://ad.doubleclick.net/clk;221572323;15177704;y?http://www.neopets.com/games/play.phtml?game_id=1183";
				_memoryLink.neoContentID = 15616;
			}
		}
		
		public function get rescueLink():MovieClip { return _rescueLink; }
		
		public function set rescueLink(clip:MovieClip) {
			_rescueLink = clip;
			if(_rescueLink != null) {
				_rescueLink.dartURL = "http://ad.doubleclick.net/clk;221572372;15177704;c?http://www.neopets.com/games/play.phtml?game_id=1184";
				_rescueLink.neoContentID = 15617;
			}
		}
		
		public function get violatorClip():MovieClip { return _violatorClip; }
		
		public function set violatorClip(clip:MovieClip) {
			_violatorClip = clip;
			if(_violatorClip != null) {
				_violatorClip.dartURL = "http://ad.doubleclick.net/clk;221572695;15177704;k?http://kidcuisine.promo.eprize.com/krazycombos";
				_violatorClip.neoContentID = 15618;
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			// set up component linkages
			memoryLink = getChildByName("guitar_btn") as MovieClip;
			rescueLink = getChildByName("mask_btn") as MovieClip;
			jukeboxClip = getChildByName("jukebox_mc") as MovieClip;
			backButton = getChildByName("back_btn") as MovieClip;
			violatorClip = getChildByName("violator_mc") as MovieClip;
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}