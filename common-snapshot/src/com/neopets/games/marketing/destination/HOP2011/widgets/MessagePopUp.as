/**
 *	This class handle most of the text messages within a given container.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.display.ListPane;
	import com.neopets.util.display.BoundedImageRow;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.SingletonEventDispatcher;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.games.marketing.destination.HOP2011.pages.AbsPage;
	import com.neopets.games.marketing.destination.HOP2011.pages.HubPage;
	import com.neopets.games.marketing.destination.HOP2011.widgets.quest.PrizePane;
	import com.neopets.games.marketing.destination.HOP2011.widgets.downloads.DownloadableData;
	
	public class MessagePopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const MESSAGE_REQUEST:String = "MessagePopUp_requested";
		public static const QUEUE_MESSAGE:String = "MessagePopUp_queue_message";
		public static const ON_MESSAGE_SHOWN:String = "MessagePopUp_message_shown";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// components
		public var closeButton:SimpleButton;
		public var hiddenItem:MovieClip;
		public var mainField:TextField;
		// added elements
		protected var _messagePane:PrizePane;
		// misc. variables
		protected var _currentMessage:Object;
		protected var _messageQueue:Array = new Array();
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MessagePopUp():void {
			super();
			// set up broadcaster listeners
			addParentListener(AbsPage,MESSAGE_REQUEST,onPopUpRequest);
			addParentListener(AbsPage,QUEUE_MESSAGE,onQueueRequest);
			addParentListener(AbsPage,POPUP_CLOSED,onPopUpClosed);
			// set up children
			if(closeButton != null) closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			// create message pane
			initMessagePane();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		override public function show():void {
			super.show();
			// broadcast event for tracking
			var sed:EventDispatcher = SingletonEventDispatcher.instance;
			var transmission:CustomEvent = new CustomEvent(_currentMessage,ON_MESSAGE_SHOWN);
			sed.dispatchEvent(transmission);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// INITIALIZATION FUNCTIONS
		
		// Use this to add an area for loading text and image displays.
		
		public function initMessagePane():void {
			// creat pane if it doesn't exist
			if(_messagePane == null) {
				_messagePane = new PrizePane();
				_messagePane.alignment = ListPane.CENTER_ALIGN;
				addChild(_messagePane);
			}
			// if there's a message textfield, reposition over that text
			if(mainField != null) {
				_messagePane.x = mainField.x + (mainField.width / 2);
				_messagePane.y = mainField.y;
				_messagePane.baseWidth = mainField.width;
			} else {
				// move over our center
				var bounds:Rectangle = getBounds(this);
				_messagePane.x = (bounds.left + bounds.right) / 2;
				_messagePane.y = bounds.top;
				_messagePane.baseWidth = width;
			}
		}
		
		// DISPLAY FUNCTIONS
		
		protected function reset():void {
			if(mainField != null) mainField.htmlText = "";
			if(_messagePane != null) _messagePane.reset();
		}
		
		protected function showDownloadables(list:Array) {
			if(list == null) return;
			// trim the list down to downloadable data only
			var info:Object;
			var dd_list:Array = new Array();
			var i:int;
			for(i = 0; i < list.length; i++) {
				info = list[i];
				if(info is DownloadableData) dd_list.push(info);
			}
			if(dd_list.length <= 0) return;
			// set up row
			var row:BoundedImageRow = new BoundedImageRow();
			row.verticalAlignment = BoundedImageRow.TOP_ALIGN;
			var backing:MovieClip = _messagePane.getRowBacking();
			row.addChild(backing);
			row.boundingObject = backing;
			// convert that data into download buttons
			var clip:MovieClip;
			for(i = 0; i < dd_list.length; i++) {
				info = dd_list[i];
				clip = new DownloadableButtonMC();
				clip.initFrom(info);
				row.addImage(clip);
			}
			// push buttons to list pane
			reset();
			_currentMessage = dd_list;
			_messagePane.addItem(row,16);
			show();
		}
		
		protected function showMessage(msg:Object):void {
			if(msg == null) return;
			// check info type
			if(msg is String) showText(String(msg));
			else {
				// check if this is a prize message
				if(HubPage.PRIZE_DATA in msg) showPrizes(msg);
				else {
					if(msg is Array) showDownloadables(msg as Array);
				}
			}
		}
		
		protected function showPrizes(info:Object):void {
			var prizes:Array = info[HubPage.PRIZE_DATA] as Array;
			if(prizes != null && prizes.length > 0) {
				reset();
				_currentMessage = info;
				_messagePane.showPrizes(prizes);
				show();
			}
		}
		
		protected function showText(msg:String):void {
			if(msg != null) {
				reset();
				_currentMessage = msg;
				if(mainField != null) mainField.htmlText = msg;
				// check if the message trips our hidden item
				if(hiddenItem != null) {
					var translator:TranslationManager = TranslationManager.instance;
					hiddenItem.visible = (msg == translator.getTranslationOf("IDS_ABOUT_HOP"));
				}
				show();
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When a pop up closes, check if we have anything left in our queue.
		
		protected function onPopUpClosed(ev:Event) {
			if(_messageQueue.length > 0) showMessage(_messageQueue.shift());
		}
		
		// This function is triggered when a pop up request is broadcast through the pop up's parent.
		
		override protected function onPopUpRequest(ev:Event) {
			// load message
			if(ev is CustomEvent) {
				var cust:CustomEvent = ev as CustomEvent;
				showMessage(cust.oData);
			}
		}
		
		// Add messages to the queue as needed
		
		protected function onQueueRequest(ev:CustomEvent) {
			if(ev.oData != null) _messageQueue.push(ev.oData);
		}

	}

	
}