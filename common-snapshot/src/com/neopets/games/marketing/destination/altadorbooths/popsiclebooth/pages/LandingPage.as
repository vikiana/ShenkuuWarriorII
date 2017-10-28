/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/Viviana Baldarelli
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.altadorbooths.common.CustomButton;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleboothInfo;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class LandingPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//icons
		public var game_btn:MovieClip;
		public var dailybonus_btn:MovieClip;
		public var nick_btn:MovieClip;
		public var downloads_btn:MovieClip;
		public var video_btn:MovieClip;
		//buttons
		public var play_btn:CustomButton;
		public var instructions_btn:CustomButton;
		public var explosion_btn:CustomButton;
		public var stadium_btn:CustomButton;
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
			addEventListener(DestinationView.SHOW, onShown);

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
		/**
		 *	Default is set to white glow around the display object when MouseOver.
		 *	For different effects, child class should override this function
		 *
		 *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		 * @NOTE: If the display Object has a "over" state (as frame lable) it'll stop at that state
		 **/
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target.parent as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				mc.gotoAndStop("over")
				mc.filters = [new GlowFilter(0x00CBFF,0.7, 16, 16, 2, 3)]
			}
		}
		
		
		
		/**
		 *	Default is set have no filter on the display object when MouseOut.
		 *	For different effects, child class should override this function
		 *
		 *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		 *	@NOTE: If the display Object has a "out" state (as frame lable) it'll stop at that state
		 **/
		override protected function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target.parent as MovieClip
				mc.gotoAndStop("out")
				mc.filters = null
			}
		}
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
		}
		
		
		

	}
	
}