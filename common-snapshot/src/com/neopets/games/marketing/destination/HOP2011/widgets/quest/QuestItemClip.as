/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets.quest
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.CustomEvent;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.games.marketing.destination.HOP2011.pages.AbsPage;
	import com.neopets.games.marketing.destination.HOP2011.pages.HubPage;
	import com.neopets.games.marketing.destination.HOP2011.widgets.MessagePopUp;
	
	public class QuestItemClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _itemID:String;
		protected var _itemData:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestItemClip():void {
			super();
			// figure out which item we should be associated with by default
			_itemID = name;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			addParentListener(AbsPage,HubPage.GET_STATUS_RESULT,onStatusResult);
			// set up mouse listeners
			addEventListener(MouseEvent.CLICK,onMouseClick);
			buttonMode = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get completed():Boolean {
			if(_itemData == null) return false;
			var completions:Number = 0;
			if("times_done" in _itemData) completions = Number(_itemData["times_done"]);
			var requires:Number = 0;
			if("times_total" in _itemData) requires = Number(_itemData["times_total"]);
			return (completions >= requires);
		}
		
		public function get hint():String {
			if(_itemData == null) return null;
			if("hint" in _itemData) return String(_itemData.hint);
			return null;
		}
		
		public function get itemData():Object { return _itemData; }
		
		public function set itemData(info:Object) {
			_itemData = info;
			if(_itemData != null) {
				// check if we've hit the require number of completions
				if(completed) gotoAndPlay("collected");
				else gotoAndPlay("released");
			} else {
				// item must be unreleased
				gotoAndPlay("unreleased");
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
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
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onMouseClick(ev:MouseEvent) {
			var msg_str:String;
			// check if this item has been completed
			if(completed) {
				var translator:TranslationManager = TranslationManager.instance;
				msg_str = translator.getTranslationOf("IDS_ITEM_FOUND");
			} else {
				msg_str = hint;
			}
			// send out the message if we have it.
			if(msg_str != null) {
				broadcast(MessagePopUp.MESSAGE_REQUEST,msg_str);
			}
		}
		
	}

	
}