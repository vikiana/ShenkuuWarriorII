package com.neopets.games.marketing.destination.altadorbooth2011.pages
{


	import com.neopets.games.marketing.destination.altadorbooth2011.AltadorAlley2011DestinationControl;
	import com.neopets.games.marketing.destination.altadorbooth2011.PopsicleBoothText;
	import com.neopets.games.marketing.destination.altadorbooths.common.widgets.PopsicleViewManager;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.users.vivianab.Scroller;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PopsicleHuntPage extends AbsPageWithBtnState
	{
		
		public var huntinstructions_btn:MovieClip;
		public var logo_btn:MovieClip;
		public var nick_btn:MovieClip;
		public var enterCode_mc:MovieClip
		public var sticksBox_mc:MovieClip;
		
		public var stick1:MovieClip;
		public var stick2:MovieClip;
		public var stick3:MovieClip;
		public var stick4:MovieClip;
		public var stick5:MovieClip;
		public var stick6:MovieClip;

		private var _result:Object;
		private var _currentWeek:Object;
		
		//public var huntback_btn:MovieClip;

		public function PopsicleHuntPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			trace ("created");
		}
		
		
		public function setResultsObj (msg:Object):void {
			_result = msg;
			//TODO: parse according to returning object
			_currentWeek = _result.stacksInfo.prizeConditions[_result.stacksInfo.prizeConditions.length-1];
			//
			var activities:Object = msg.stacksInfo.activities;
			var page:Sprite;
			var currIndex:int = 0;
			
			//update stickbox
			//quest_meter.gotoAndStop (msg.stacksInfo.sticks+1);
			
			//CLAIM PRIZES
			claimPrizes ();
		}
		
		
		public function get currentWeek ():Object{
			return _currentWeek;
		}
		

		private function getWeekObject(activities:Object, index:int):Object{
			var wo:Object;
			switch(index){
				case 1:
					wo = activities.week1;
					break;
				case 2:
					wo = activities.week2;
					break;
				case 3:
					wo = activities.week3;
					break;
				case 4:
					wo = activities.week4;
					break;
			}
			return wo;
		}
		

		
		private function claimPrizes ():void {
			if (_result.stacksInfo.prizeConditions.length>0){
				//this will open the claim prize window for the LATEST week is completed. If other weeks prizes were not claimed, they will popup right after this or next time it reloads.
				//in fact th equestprizepopup , when it opens, it gets as current week the last available object on prizeConditions
				dispatchEvent(new Event (AltadorAlley2011DestinationControl.HUNTPRIZE_POPUP));
			}
		}
	}
}