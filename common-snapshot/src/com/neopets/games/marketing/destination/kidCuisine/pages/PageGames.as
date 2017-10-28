/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.external.ExternalInterface;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.NeoTracker
	import com.neopets.util.events.CustomEvent;
	
	
	public class PageGames extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageGames(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage ()
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
		
		protected override function setupPage():void
		{
			addImage("GamesPage", "gamesPage");
		}
		
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndPlay("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 5), new GlowFilter(0x3399FF, 1, 8, 8, 5, 5)]
			}
		}		
		
		
		override protected function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				MovieClip(mc.parent).filters = null
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		// 14520 
		
	
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "tools":
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211986;15177704;h?http://www.neopets.com/games/play.phtml?game_id=1116")
					NeoTracker.processClickURL(14520);
					break;
				
				case "gunSuit":
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216212074;15177704;w?http://www.neopets.com/games/play.phtml?game_id=1115")
					NeoTracker.processClickURL(14521);
					break;
				
				//Phase 2
				case "gun":
					NeoTracker.processClickURL(14992);
					//Omniture
					runJavaScript ("Kid Cuisine Hot Dog Game");
					//PhaseII
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;218112152;15177704;u?http://www.neopets.com/games/play.phtml?game_id=1141");
					break;
					
				case "map":
					//link to the planet51 microsite
					NeoTracker.processClickURL(15274);
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;219135265;15177704;f?http://kidcuisine.eprize.net/planet51")
					//NeoTracker.sendTrackerID(14531);
					break;
				
				case "shelf":
					//link to game 1165
					NeoTracker.processClickURL(15278);
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;219135235;15177704;c?http://www.neopets.com/games/play.phtml?game_id=1165")
					runJavaScript2 ("Rocket Ship Race");
					//NeoTracker.sendTrackerID(14531);
				break;
				
				case "backpack":
					//link to PDF
					NeoTracker.processClickURL(15037);
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216212101;15177704;n?http://www.kidcuisine.com/realFun/promotions/index.jsp")
					//NeoTracker.sendTrackerID(14531);
					break;
			}
		}
		
		/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		private function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("sendADLinkCall", scriptID) 
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
				}
			}
		}
		
		private function runJavaScript2(scriptID:String):void
		{

			trace (this+" run javascript"+scriptID);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("sendReportingCall", scriptID,"Kid Cuisine");
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JaraScript")
				}
			}
		}
	}
	
}