package com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages
{

	import com.neopets.games.marketing.destination.altadorbooths.common.widgets.ArrowButton;
	import com.neopets.games.marketing.destination.altadorbooths.common.widgets.PopsicleViewManager;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleDestinationControl;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleQuestText;
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.widgets.QuestListItem;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.users.vivianab.Scroller;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PopsicleQuestPage extends AbsPageWithBtnState
	{
		
		
		public var questlogo_btn:MovieClip;
		public var quest_meter:MovieClip;
		public var quest_board:MovieClip;
		public var popsicle_logo:MovieClip;
		public var quest_logo:MovieClip;
		//controls
		public var scroller_scrub:MovieClip;
		public var scrollUp_btn:MovieClip;
		public var scrollDown_btn:MovieClip;
		public var questinstructions_btn:MovieClip;
		//text
		public var title_txt:TextField;
		//items list
		public var mask_mc:MovieClip;
		public var items_list:MovieClip;
		
		private var _scroller:Scroller;
		
		private var _pages:Array = [];
		private var _result:Object;
		private var _currentWeek:Object;
		
		private const GAP:Number = 30;
		
		public var questclose_btn:MovieClip;

		public function PopsicleQuestPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			title_txt.text = "Week 1";
			
		}
		
		
		public function setResultsObj (msg:Object):void {
			_result = msg;
			_currentWeek = _result.stacksInfo.prizeConditions[_result.stacksInfo.prizeConditions.length-1];
			//
			var activities:Object = msg.stacksInfo.activities;
			var page:Sprite;
			var currIndex:int = 0;
			//if pages are not created yet, create week pages
			if (_pages.length<=0){
				if (activities.week1){
					page = createPage (activities.week1);
					_pages.push (page);
					currIndex = 0;
				}
				if (activities.week2){
					page = createPage (activities.week2);
					_pages.push (page);
				}
				if (activities.week3){
					page = createPage (activities.week3);
					_pages.push (page);
				}
				if (activities.week4){
					page = createPage (activities.week4);
					_pages.push (page);
				}
				
				//set up the navigation (thru ViewManager)
				setUpWeeksNav();
			} 

			//update pages 
			var item:QuestListItem;
			var wo:Object;
			var done:Boolean = true;
			var prizes:Object;
			//loop thru pages
			for (var i:int = 0; i< _pages.length; i++){
				//loop thru items
				wo = getWeekObject (activities, i+1);
				for (var j:int =0; j< wo.length; j++){
					item = QuestListItem(_pages[i].getChildAt(j));
					item.description_txt.text = wo[j].act_desc;
					if (wo[j].act_done >= wo[j].act_todo){
						item.checkMark_mc.gotoAndStop(2);
					} else{
						//if one activity is not done, set _done to false.
						item.checkMark_mc.gotoAndStop(1);
						done = false;
					}
				}
				//if all activities are done and there isn't an extra task on the bottom of the list, add one
				if (done){
					addHiddenTask (String("week"+String(i+1)));
				} 
			}
			
			//update meter:  +1 is becouse the empty value in the meter is 0 and there is no frame 0. Just adjust the Flash symbol to work with this
			quest_meter.gotoAndStop (msg.stacksInfo.sticks+1);
			
			//CLAIM PRIZES
			claimPrizes ();
		}
		
		public function reset():void {
			if (_scroller){
				_scroller.reset();
			}
		}
		
		public function addHiddenTask (weekid:String):void {
			var taskName:String;
			var index:int;
			var weekTasksArray:Array;
			switch (weekid){
				case "week1":
					taskName = PopsicleQuestText.HIDDEN_TASK1;
					weekTasksArray = _result.stacksInfo.activities.week1;
					index = 0;
					break;
				case "week2":
					taskName = PopsicleQuestText.HIDDEN_TASK2;
					weekTasksArray = _result.stacksInfo.activities.week2;
					index = 1;
					break;
				case "week3":
					taskName = PopsicleQuestText.HIDDEN_TASK3;
					weekTasksArray = _result.stacksInfo.activities.week3;
					index = 2;
					break;
				case "week4":
					taskName = PopsicleQuestText.HIDDEN_TASK4;
					weekTasksArray = _result.stacksInfo.activities.week4;
					index = 3;
					break;
			}
			//create additional item
			var page:Sprite = _pages[index];
			if (page.numChildren <= weekTasksArray.length){
				var item:QuestListItem = new QuestListItem ();
				var prevItem:QuestListItem = QuestListItem(page.getChildAt(page.numChildren-1));
				item.y = prevItem.y+GAP;
				item.description_txt.text = taskName;
				item.checkMark_mc.gotoAndStop(2);
				page.addChild (item);
				//add scroller
				addScroller(page.numChildren, page);
			}
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
		
		private function createPage (a:Array):MovieClip {
			var item:QuestListItem;
			var s:MovieClip = new MovieClip();
			//add items
			for (var i:int=0; i<a.length; i++){
				item = new QuestListItem ();
				s.addChild (item);
				if (i!=0){
					item.y = Sprite(s.getChildAt(i-1)).y+GAP;
				}
			}
			//add scroller
			addScroller(a.length, s);
			return s;
		}
		
		private function claimPrizes ():void {
			if (_result.stacksInfo.prizeConditions.length>0){
				//this will open the claim prize window for the LATEST week is completed. If other weeks prizes were not claimed, they will popup right after this or next time it reloads.
				//in fact th equestprizepopup , when it opens, it gets as current week the last available object on prizeConditions
				dispatchEvent(new Event (PopsicleDestinationControl.QUESTPRIZE_POPUP));
			}
		}
		
		private function addScroller(noItems:int, content:Sprite):void {
			if (!_scroller){
				var realHeight:Number = noItems * 29.4 + noItems*1;
				if (realHeight > mask_mc.height){
					_scroller = new Scroller (mask_mc.height);
					addChild(_scroller);
					_scroller.x = 425;
					_scroller.y = 88;
					_scroller.init(content);
				}
			} 
		}
	
		
		private function setUpWeeksNav():void {
			var next_btn:ArrowButton = new ArrowButton();
			var prev_btn:ArrowButton = new ArrowButton();
			next_btn.rotation = 180;
			var btnArray:Array = [next_btn, prev_btn];
			var buttonMenu:PopsicleViewManager = new PopsicleViewManager(_pages, btnArray, 1, 0);
			buttonMenu.x = items_list.x;
			buttonMenu.y = items_list.y;
			addChild(buttonMenu)
			//if (_pages.length>1){
				//adjust mask
				buttonMenu.scrollmask.height = mask_mc.height;
				//listener to current index
				buttonMenu.addEventListener(buttonMenu.CURRENT_INDEX, updatePageIndex ,false, 0, true);
				//if displaying more than one page scroll to the last available week (the current)
				buttonMenu.scrollTo(_pages.length-1);
			//}
		}
		
		private function updatePageIndex(e:CustomEvent):void {
			var currentIndex:int = e.oData.DATA;
			title_txt.text = "Week "+String(currentIndex+1);
			if (_scroller){
				_scroller.reset();
				_scroller.init( _pages[currentIndex]);
			}
		}
	}
}