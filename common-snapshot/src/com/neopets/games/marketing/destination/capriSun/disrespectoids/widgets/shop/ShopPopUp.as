/**
 *	This class handles sending out ECards.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.shop
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.net.navigateToURL;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.InstructionCallButton;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.shop.ShopItemClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.display.ListPane;
	import com.neopets.util.servers.ServerFinder;
	import com.neopets.util.servers.NeopetsAmfManager;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class ShopPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// global variables
		public static var INSTRUCTION_HEADER:String = "Instructions:"; 
		public static var INSTRUCTION_TEXT:String = "<p align='left'>Earn prizes when you Respect the Pouch!<br/><br/>Can you fill up your Experience Points meter?  Earn Experience Points when you interact with the Capri Sun Disrespectoids Clubhouse and see if you can earn up to 10,000 Experience Points!<br/><br/>Earn Experience Points when you:<ul><li>Visit RespectthePouch.com</li><li>Visit Capri Sun on Nick</li><li>Read character bios</li><li>Send an e-card to a friend</li><li>Feed your Neopet</li><li>Watch a webisode</li><li>Play the daily trivia game</li><li>Play any of the Capri Sun games</li><li>Complete a task on the Task List</li></ul><br/>Earn BONUS Points when you:<ul><li>Reach a score of at least 10,000 in any of the Capri Sun games</li><li>Complete the Task List</li><li>Watch all 10 webisodes (be sure to check back, as we will roll out two webisodes per week!)</li><li>Answer at least 20 daily trivia questions</li><li>Feed your Neopet(s) 10 days in a row</li></ul><br/>Each time you complete one of these activities, you will see text that tells you how many Experience Points you earned for completing it.  *You will see the text when you click from the Clubhouse to one of the Capri Sun games, but you will not recieve your Experience Points until you send your score.*<br/><br/>You have until August 15th to drive up the Experience Points meter, and can begin redeeming your points for prizes on August 16th!  Redeem all of your points by August 30th.<br/><br/>Good luck!</p>";
		public static var PURCHASE_HEADER:String = "Buy %1?";
		public static var PURCHASE_QUERY:String = "Are you sure you want to redeem %1 points for this prize?";
		public static var BIG_YES:String = "<font size='40'>Yes</font>";
		public static var BIG_NO:String = "<font size='40'>No</font>";
		public static var ITEM_PURCHASED:String = "Item Purchased";
		public static var PRIZE_IN_INVENTORY:String = "This prize is in your inventory.";
		public static var INVENTORY:String = "Inventory";
		public static var ERROR_HEADER:String = "Error";
		public static var PURCHASE_FAILED:String = "The purchase could not be completed, please try again later.";
		// components
		protected var _titleField:TextField;
		protected var _messageField:TextField;
		protected var _messagePane:ListPane;
		protected var _messageBar:Object; // UIScrollBar
		// local variables
		protected var _paneBounds:Rectangle;
		protected var _itemData:Object;
		protected var _itemNumber:Number;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ShopPopUp():void {
			super();
			// set up components
			_titleField = getChildByName("title_txt") as TextField;
			messageField = getChildByName("main_txt") as TextField;
			_messageBar = getChildByName("main_bar");
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get messageField():TextField { return _messageField; }
		
		public function set messageField(txt:TextField) {
			_messageField = txt;
			// create message pane
			initMessagePane();
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(InstructionCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.removeEventListener(ShopItemClip.PURCHASE_REQUEST,onPurchaseRequest);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(InstructionCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.addEventListener(ShopItemClip.PURCHASE_REQUEST,onPurchaseRequest);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to load a list of display object into an evenly spaced row.
		
		public function addDisplayRow(list:Array,index:int=-1) {
			if(list == null || list.length < 1) return;
			// create new row
			var row:MovieClip = new MovieClip();
			// load entries into row
			var spacing:Number = _paneBounds.width / (list.length + 1);
			var mid_x:Number = _paneBounds.x + spacing;
			var entry:DisplayObject;
			for(var i:int = 0; i < list.length; i++) {
				entry = list[i];
				entry.x = mid_x;
				row.addChild(entry);
				mid_x += spacing;
			}
			// add row to pane
			_messagePane.addItemAt(row,index);
		}
		
		// This function appends a section of text to the end of our content.
		// param	url			String		Server independant path to target image. 
		// param	index		int			Position in the list to load text.
		
		public function addImage(url:String,index:int=-1):Loader {
			if(url == null || url.length <= 0) return null;
			// create loader
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(url);
			loader.load(req);
			_messagePane.addItemAt(loader,index);
			return loader;
		}
		
		// Use this function to add a line of text to our message list pane.
		// param	msg			String		Text to load into the textfield.
		// param	index		int			Position in the list to load text.
		
		public function addText(msg:String,index:int=-1):MovieClip {
			var shell:MovieClip = createTextClip(msg);
			_messagePane.addItemAt(shell,index); // add shell to pane
			return shell;
		}
		
		// Use this function to create a textblock with button like behaviours.
		
		public function createTextButton(msg:String,click_func:Function=null):MovieClip {
			var btn:MovieClip = createTextClip(msg);
			// check for text field
			var txt:TextField = btn.mainField;
			var overlay:MovieClip;
			var canvas:Graphics;
			if(txt != null) {
				// scale down text bounds
				txt.width = txt.textWidth + 8;
				// draw click zone on top of text
				overlay = new MovieClip();
				canvas = overlay.graphics;
				canvas.beginFill(0xFFFFFF,0.1);
				canvas.drawRect(txt.x,txt.y,txt.width,txt.height);
				canvas.endFill();
				btn.addChild(overlay);
			}
			// add click function
			if(click_func != null) {
				btn.addEventListener(MouseEvent.CLICK,click_func);
				btn.buttonMode = true;
			}
			return btn;
		}
		
		// This function wraps an interactive movieclip around the target text string.
		
		public function createTextClip(msg:String):MovieClip {
			// check for valid message
			if(msg == null || msg.length < 1) return null;
			// create shell
			var shell:MovieClip = new PrizeTextMC();
			// find text field in shell
			var txt:TextField = DisplayUtils.getDescendantInstance(shell,TextField) as TextField;
			// if we found text, apply our message to it
			if(txt != null) {
				// update field text
				txt.htmlText = msg;
				txt.width = _paneBounds.width;
				// resize field
				txt.height = txt.textHeight + 8; // add extra padding to make sure text shows
			}
			// store txt reference
			shell.mainField = txt;
			return shell;
		}
		
		// Use this function to send to show a specified text message with header.
		
		public function showMessage(header:String,msg:String):void {
			if(_titleField != null) _titleField.htmlText = header;
			if(_messageField != null) _messageField.htmlText = msg;
			if(_messageBar != null) {
				_messageBar.update();
				_messageBar.scrollPosition = 0;
				_messageBar.visible = true;
			}
			_messagePane.clearItems();
			visible = true;
		}
		
		// Use this function to display a completed purchase
		
		public function showPurchaseDone():void {
			// set header
			_titleField.htmlText = ITEM_PURCHASED;
			// clear basic text
			if(_messageField != null) _messageField.htmlText = "";
			if(_messageBar != null) _messageBar.visible = false;
			_messagePane.clearItems();
			// show item image
			if("url" in _itemData) {
				addImage(_itemData.url);
			}			
			// show purchase question
			addText(PRIZE_IN_INVENTORY);
			// add inventory button
			var inv_clip:MovieClip = createTextButton(INVENTORY,onInventoryClick);
			_messagePane.addItem(inv_clip);
			// show pop up
			visible = true;
		}
		
		// Use this function to display a purchase request.
		
		public function showPurchaseRequest(info:Object):void {
			if(info == null) return;
			_itemData = info; // store data
			// set header
			if(_titleField != null) {
				if("name" in _itemData) _titleField.htmlText = PURCHASE_HEADER.replace("%1",_itemData.name);
				else _titleField.htmlText = PURCHASE_HEADER;
			}
			// clear basic text
			if(_messageField != null) _messageField.htmlText = "";
			if(_messageBar != null) _messageBar.visible = false;
			_messagePane.clearItems();
			// show item image
			if("url" in _itemData) {
				addImage(_itemData.url);
			}			
			// show purchase question
			var query:String;
			if("value" in _itemData) query = PURCHASE_QUERY.replace("%1",_itemData.value);
			else query = PURCHASE_QUERY.replace("%1","");
			addText(query);
			// create "yes" button
			var yes_clip:MovieClip = createTextButton(BIG_YES,onPurchaseConfirmed);
			// create "no" button
			var no_clip:MovieClip = createTextButton(BIG_NO,onCloseRequest);
			// add both buttons to message pane
			addDisplayRow([yes_clip,no_clip]);
			// show pop up
			visible = true;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this to add an area for loading answer lines.
		
		protected function initMessagePane():void {
			// creat pane if it doesn't exist
			if(_messagePane == null) {
				_messagePane = new ListPane();
				_messagePane.alignment = ListPane.CENTER_ALIGN;
				addChild(_messagePane);
			}
			// if there's a message textfield, reposition over that text
			if(_messageField != null) {
				_messagePane.x = _messageField.x + (_messageField.width / 2);
				_messagePane.y = _messageField.y;
				_paneBounds = new Rectangle(_messageField.x,_messageField.y,_messageField.width,_messageField.height);
			} else {
				// move over our center
				_paneBounds = getBounds(this);
				_messagePane.x = (_paneBounds.left + _paneBounds.right) / 2;
				_messagePane.y = _paneBounds.top;
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When the inventory button is clicked on, call up the inventory link.
		
		protected function onInventoryClick(ev:Event) {
			// get inventory path
			var path:String;
			var servers:ServerFinder = NeopetsAmfManager.instance.servers;
			if(servers != null) path = servers.scriptServer + "/objects.phtml?type=inventory";
			else path = "http://www.neopets.com/objects.phtml?type=inventory";
			// get up link
			var req:URLRequest = new URLRequest(path);
			navigateToURL(req);
		}
		
		// This function is triggered when a character selection event is broadcast.
		
		override protected function onPopUpRequest(ev:BroadcastEvent) {
			showMessage(INSTRUCTION_HEADER,INSTRUCTION_TEXT);
			broadcast(POPUP_SHOWN);
		}
		
		// When the user confirms a purchase send the request out to php.
		
		protected function onPurchaseConfirmed(ev:Event) {
			if(_itemData != null && "id" in _itemData) {
				var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
				var responder:Responder = new Responder(onPurchaseResult,onPurchaseFault);
				delegate.callRemoteMethod("CapriSun2010Service.prizeShopBuyItem",responder,_itemData.id);
			}
		}
		
		// When the user tries to purchase a shop item, show this pop up.
		
		protected function onPurchaseRequest(ev:BroadcastEvent) {
			// extract data from sending shop item
			_itemNumber = ev.sender.IDNumber;
			showPurchaseRequest(ev.sender.itemData);
		}
		
		// "Item Info" Response Listeners
		
		protected function onPurchaseResult(msg:Object):void {
			trace("onPurchaseResult: " + msg);
			if(msg) {
				showPurchaseDone();
				// dispatch tracking request
				broadcast(DestinationView.ADLINK_REQUEST,"Caprisun2010 Prize " + _itemNumber + " redeemed");
				broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,16088 + _itemNumber);
			} else showMessage(ERROR_HEADER,PURCHASE_FAILED);
		}
		
		protected function onPurchaseFault(msg:Object):void {
			trace("onPurchaseFault: " + msg);
		}

	}
	
}