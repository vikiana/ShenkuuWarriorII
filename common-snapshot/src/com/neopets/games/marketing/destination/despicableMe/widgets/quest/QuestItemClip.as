/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.quest
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.despicableMe.pages.QuestPage;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.events.CustomEvent;
	
	public class QuestItemClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ITEM_SELECTED:String = "QuestItem_selected";
		public static const ITEM_DESELECTED:String = "QuestItem_deselected";
		public static const STATUS_ID_PREFIX:String = "act";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _itemID:String;
		protected var _itemData:Object;
		// extracted variables
		protected var _hint:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestItemClip():void {
			super();
			// figure out which item we should be associated with by default
			_itemID = name;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up listeners
			addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get hint():String { return _hint; }
		
		public function get itemData():Object { return _itemData; }
		
		public function set itemData(info:Object) {
			_itemData = info;
			if(_itemData != null) {
				_hint = _itemData["hint"] as String;
				// check if we've hit the require number of completions
				var completions:Number = 0;
				if("times_done" in _itemData) completions = Number(_itemData["times_done"]);
				var requires:Number = 0;
				if("times_total" in _itemData) requires = Number(_itemData["times_total"]);
				if(completions >= requires) gotoAndPlay("collected");
				else gotoAndPlay("released");
			} else {
				// item must be unreleased
				gotoAndPlay("unreleased");
			}
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(QuestPage.QUEST_STATUS_RESULT,onStatusResult);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(QuestPage.QUEST_STATUS_RESULT,onStatusResult);
			}
		}
		
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
		
		// Select this tab when rolled over.
		
		protected function onMouseOver(ev:MouseEvent) {
			broadcast(ITEM_SELECTED);
		}
		
		// Deselect this tab when rolled off.
		
		protected function onMouseOut(ev:MouseEvent) {
			broadcast(ITEM_DESELECTED);
		}
		
		// Clean up our listeners when we're removed from the stage.
		
		protected function onRemoved(ev:Event) {
			if(ev != null && ev.target == this) {
				sharedDispatcher = null;
				removeEventListener(MouseEvent.CLICK,onMouseOver);
				removeEventListener(MouseEvent.CLICK,onMouseOut);
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			}
		}
		
		// When there's a status event, extract the data.
		
		protected function onStatusResult(ev:CustomEvent) {
			var info:Object = ev.oData;
			// search the amf response's progress list for our entry
			var progess_list:Object = info["progress"];
			if(progess_list != null) {
				var entry:Object;
				var entry_id:String;
				var prefix_index:int;
				var entry_suffix:String;
				for(var i in progess_list) {
					entry = progess_list[i];
					entry_id = entry["id"] as String;
					// if the entry uses our target ID, treat is as our item data.
					if(entry_id == _itemID) {
						itemData = entry;
						break;
					}
				} // end of entry loop
			} // end of list check
		}

	}
	
}