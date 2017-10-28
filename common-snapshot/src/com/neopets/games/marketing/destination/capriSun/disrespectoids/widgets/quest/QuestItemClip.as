/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.quest
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
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.QuestPage;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.events.CustomEvent;
	
	public class QuestItemClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ITEM_SELECTED:String = "QuestItem_selected";
		public static const STATUS_ID_PREFIX:String = "act";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _IDSuffix:String;
		protected var _itemData:Object;
		// extracted variables
		protected var _hint:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestItemClip():void {
			super();
			// figure out which item we should be associated with by default
			findID();
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up listeners
			addEventListener(MouseEvent.CLICK,onClick);
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
		
		// This function tries to determine which item we should be associated with by default
		
		public function findID():void {
			// if this object just uses the default "instance" name, check our parent
			var full_id:String;
			if(parent != null && name.indexOf("instance") >= 0) {
				full_id = parent.name;
			} else full_id = name;
			// use last part of name as identifier
			var segments:Array = parent.name.split("_");
			if(segments.length > 0) {
				_IDSuffix = segments[segments.length - 1];
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Select this tab when clicked on.
		
		protected function onClick(ev:MouseEvent) {
			broadcast(ITEM_SELECTED);
		}
		
		// Clean up our listeners when we're removed from the stage.
		
		override protected function onRemoved(ev:Event) {
			if(ev != null && ev.target == this) {
				sharedDispatcher = null;
				removeEventListener(MouseEvent.CLICK,onClick);
				removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			}
		}
		
		// When there's a status event, extract the data.
		
		protected function onStatusResult(ev:CustomEvent) {
			var info:Object = ev.oData;
			// search the amf response's progress list for our entry
			var progess_list:Array = info["progress"] as Array;
			if(progess_list != null) {
				var entry:Object;
				var entry_id:String;
				var prefix_index:int;
				var entry_suffix:String;
				for(var i:int = 0; i < progess_list.length; i++) {
					entry = progess_list[i];
					entry_id = entry["id"] as String;
					if(entry_id != null) {
						prefix_index = entry_id.indexOf(STATUS_ID_PREFIX);
						entry_suffix = entry_id.substr(prefix_index+STATUS_ID_PREFIX.length);
						if(entry_suffix == _IDSuffix) {
							itemData = entry;
							break;
						}
					}
				} // end of entry loop
			} // end of list check
		}

	}
	
}