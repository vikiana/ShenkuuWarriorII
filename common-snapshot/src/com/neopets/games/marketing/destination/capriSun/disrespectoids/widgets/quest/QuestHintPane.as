﻿/**
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
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.QuestPage;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	
	public class QuestHintPane extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _hintField:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestHintPane():void {
			super();
			// set up components
			_hintField = getChildByName("hint_txt") as TextField;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(QuestItemClip.ITEM_SELECTED,onItemSelected);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(QuestItemClip.ITEM_SELECTED,onItemSelected);
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
		
		// When there's a status event, extract the data.
		
		protected function onItemSelected(ev:BroadcastEvent) {
			if(_hintField != null) {
				var hint:String = ev.sender.hint;
				if(hint != null) _hintField.htmlText = hint;
				else _hintField.htmlText = "";
			}
		}

	}
	
}