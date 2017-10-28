/**
 *	This class handles sending out ECards.
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
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	import com.neopets.games.marketing.destination.despicableMe.widgets.TriviaCallButton;
	import com.neopets.games.marketing.destination.despicableMe.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.despicableMe.LogInMessage;
	import com.neopets.games.marketing.destination.despicableMe.widgets.InstructionCallButton;
	import com.neopets.games.marketing.destination.despicableMe.pages.QuestPage;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.ListPane;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.display.BoundedIconRow;
	
	public class QuestPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ICON_SIZE:Number = 80;
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// global variables
		public static var INSTRUCTION_HEADER:String = "Instructions:"; 
		public static var INSTRUCTION_TEXT:String = "It looks like the pouches have gotten fed up with being disrespected and have hidden throughout the Disrespectoids Clubhouse. Can you find each wayward pouch?  All you have to do is check your Task List for hints of each pouch's location. Once you've cracked the clue and found the pouch, you'll be awarded Neopoints. Completing more tasks will earn you extra prizes. Plus, an extra-special virtual prize awaits those who can finish the quest.  Now show those pouches some respect and get going!";
		public static var LOGIN_HEADER:String = "Please Log In:";
		public static var PRIZE_HEADER:String = "Congratulations!"; 
		public static var POINT_PRIZE_TEXT:String = "Congratulations, you have completed the task and earned %prize!";
		public static var CLAIM_PRIZE_TEXT:String = "Click <a href='event:claimPrize'><u>here</u></a> to claim your prize!";
		public var CLAIM_SUCCESS_POINTS:String = "%prize has been added to your total.";
		public var CLAIM_SUCCESS_ONE_ITEM:String = "%prize has been added to your <a href='%url'><u>inventory</u></a>.";
		public var CLAIM_SUCCESS_MANY_ITEMS:String = "%prizes have been added to your <a href='%url'><u>inventory</u></a>.";
		public var ANOTHER_PRIZE:String = "Hey! There's another <a href='event:nextPrize'><u>prize</u></a> waiting for you...";
		public var CLAIM_ERROR_HEADER:String = "Prize Error";
		public var CLAIM_ERROR_TEXT:String = "Hmm, there seems to have been some kind of error claiming your prize. Reload the page and try again!";
		// components
		protected var _titleField:TextField;
		protected var _messageField:TextField;
		protected var _messagePane:ListPane;
		// local variables
		protected var _loggedIn:Boolean;
		protected var _pendingPrizes:Array;
		protected var _servers:NeopetsServerFinder;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestPopUp():void {
			super();
			// set up components
			_titleField = getChildByName("title_txt") as TextField;
			messageField = getChildByName("main_txt") as TextField;
			// check login status
			var tag:String = Parameters.userName;
			//tag = "Grue"; // comment in to test logged in status locally 
			loggedIn = (tag != null && tag != AbsView.GUEST_USER);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get loggedIn():Boolean { return _loggedIn; }
		
		public function set loggedIn(bool:Boolean) {
			_loggedIn = bool;
			if(!_loggedIn) showLogin();
		}
		
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
				_sharedDispatcher.removeEventListener(QuestPage.QUEST_STATUS_RESULT,onStatusResult);
				_sharedDispatcher.removeEventListener(QuestPage.CLAIM_PRIZE_RESULT,onClaimResult);
				_sharedDispatcher.removeEventListener(POPUP_SHOWN,onPopUpShown);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(InstructionCallButton.BROADCAST_EVENT,onPopUpRequest);
				_sharedDispatcher.addEventListener(QuestPage.QUEST_STATUS_RESULT,onStatusResult);
				_sharedDispatcher.addEventListener(QuestPage.CLAIM_PRIZE_RESULT,onClaimResult);
				_sharedDispatcher.addEventListener(POPUP_SHOWN,onPopUpShown);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
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
		
		public function addText(msg:String,index:int=-1):TextField {
			var shell:MovieClip = new PrizeTextMC();
			// find text field in shell
			var child:DisplayObject;
			var txt:TextField;
			for(var i:int = 0; i < shell.numChildren; i++) {
				child = shell.getChildAt(i);
				if(child is TextField) {
					txt = child as TextField;
					break;
				}
			}
			// if we found text, resize it and add the shell
			if(txt != null) {
				// get the target text width
				var txt_width:Number;
				if(_messageField != null) {
					txt_width = _messageField.width;
				} else {
					if(_titleField != null) txt_width = _titleField.width;
					else txt_width = width;
				}
				// update field text
				txt.htmlText = msg;
				// resize field
				txt.width = txt_width;
				txt.height = txt.textHeight + 4; // add extra padding to make sure text shows
				// add shell to our pane
				_messagePane.addItemAt(shell,index);
			}
			return txt;
		}
		
		// Extracts prize names into a list style string.
		// param	info			Object		Prize data entry
		// param	restriction		Number		If positive number, only use entries of a this type code.
		
		public function getPrizeNamesString(info:Object,restriction:Number=0):String {
			if(info == null) return null;
			// extract prize data
			var prizes:Array = info["prizes"] as Array;
			if(prizes == null) prizes = new Array(info);
			//if(prizes == null) return null; // abort if there are no prizes
			var entry:Object;
			var entry_type:Number;
			var entry_name:String;
			var names_str:String;
			var end_index:int = prizes.length - 1;
			for(var i:int = 0; i < prizes.length; i++) {
				entry = prizes[i];
				// apply type restrictions
				entry_type = Number(entry["type"]);
				if(restriction <= 0 || entry_type == restriction) {
					// extract prize names
					entry_name = String(entry["name"]);
					if(names_str == null) names_str = entry_name;
					else {
						if(i < end_index) names_str += ", ";
						else names_str += " and  ";
						names_str += entry_name;
					}
				}
			}
			return names_str;
		}
		
		// Extracts prize icon urls.
		// param	info			Object		Prize data entry
		// param	restriction		Number		If positive number, only use entries of a this type code.
		
		public function getPrizeURLS(info:Object,restriction:Number=0):Array {
			if(info == null) return null;
			// extract prize data
			var prizes:Array = info["prizes"] as Array;
			if(prizes == null) prizes = new Array(info);
			//if(prizes == null) return null; // abort if there are no prizes
			var entry:Object;
			var entry_type:Number;
			var entry_url:String;
			var urls:Array = new Array();
			for(var i:int = 0; i < prizes.length; i++) {
				entry = prizes[i];
				// apply type restrictions
				entry_type = Number(entry["type"]);
				if(restriction <= 0 || entry_type == restriction) {
					// extract icon
					entry_url = String(entry["url"]);
					if(entry_url != null) urls.push(entry_url);
				}
			}
			return urls;
		}
		
		// Use this function to add a row of icons to our content pane.
		// param		urls		String		This is an array of icon urls.
		// param		index		int			This is where in the list the item should be placed.
		// imported from NP9_Prize_Pop_Up
		
		public function loadIcons(urls:Array,index:int=-1):void
		{
			if(urls == null) return;
			// create the new icon row
			var row:BoundedIconRow = new BoundedIconRow();
			// add a bounding area to the row
			var clip:MovieClip = new MovieClip();
			clip.graphics.beginFill(0x000000,0.01);
			clip.graphics.drawRect(0,0,width,ICON_SIZE);
			clip.graphics.endFill();
			row.addChild(clip);
			row.setBoundingObj(clip);
			// load images into the icon row
			var backing:MovieClip;
			var offset:Number = ICON_SIZE / -2;
			for(var i:int = 0; i < urls.length; i++) {
				backing = new MovieClip();
				backing.graphics.beginFill(0xFFFFFF,1);
				backing.graphics.drawRect(offset,offset,ICON_SIZE,ICON_SIZE);
				backing.graphics.endFill();
				row.loadIconFrom(urls[i],backing);
			}
			// add the row to our content pane
			_messagePane.addItemAt(row,index);
		}
		
		// If not logged in show login text.
		
		public function showLogin():void {
			var msg:LogInMessage = new LogInMessage("earn Neopoints and win prizes");
			showMessage(LOGIN_HEADER,msg.toString());
		}
		
		// Use this function to send to show a specified text message with header.
		
		public function showMessage(header:String,msg:String):void {
			if(_titleField != null) _titleField.htmlText = header;
			if(_messageField != null) _messageField.htmlText = msg;
			_messagePane.clearItems();
			visible = true;
		}
		
		// This function shows the current top entry in our pending prize list.
		
		public function showPrize():void {
			if(_pendingPrizes == null || _pendingPrizes.length < 1) return;
			// set title
			if(_titleField != null) _titleField.htmlText = PRIZE_HEADER;
			// clear existing messages
			if(_messageField != null) _messageField.htmlText = "";
			_messagePane.clearItems();
			// get top entry
			var prize_data:Object = _pendingPrizes[0];
			// set up first text block
			var names_str = getPrizeNamesString(prize_data);
			var prize_str:String = POINT_PRIZE_TEXT.replace("%prize",names_str);
			addText(prize_str);
			// add icon row to pane
			var urls:Array = getPrizeURLS(prize_data);
			if(urls != null && urls.length > 0) loadIcons(urls);
			// set up second text block
			var txt:TextField = addText(CLAIM_PRIZE_TEXT);
			if(txt != null) txt.addEventListener(TextEvent.LINK,onClaimPrizeClick);
			// show pop up
			visible = true;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this to add an area for loading answer lines.
		
		public function initMessagePane():void {
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
			} else {
				// move over our center
				var bounds:Rectangle = getBounds(this);
				_messagePane.x = (bounds.left + bounds.right) / 2;
				_messagePane.y = bounds.top;
			}
		}
		
		// This function shows a prize after it's been claimed through an amf-php call.
		
		protected function showClaimedPrize(info:Object) {
			if(info == null) return;
			// set title
			if(_titleField != null) _titleField.htmlText = PRIZE_HEADER;
			// clear existing messages
			if(_messageField != null) _messageField.htmlText = "";
			_messagePane.clearItems();
			// Find out how many items we have
			var names:String;
			var urls:Array = getPrizeURLS(info,1);
			if(urls != null && urls.length > 0) {
				// show inventory
				names = getPrizeNamesString(info,1);
				var prize_str:String;
				if(urls.length > 1) prize_str = CLAIM_SUCCESS_MANY_ITEMS.replace("%prizes",names);
				else prize_str = CLAIM_SUCCESS_ONE_ITEM.replace("%prize",names);
				// replace url
				var base_url:String = Parameters.baseURL;
				if(base_url == null) base_url = "http://dev.neopets.com";
				prize_str = prize_str.replace("%url",base_url+"/objects.phtml?type=inventory");
				// add textfield
				addText(prize_str);
				// show icons
				loadIcons(urls);
			} else {
				// check for point prizes
				urls = getPrizeURLS(info,2);
				if(urls != null && urls.length > 0) {
					names = getPrizeNamesString(info,2);
					prize_str = CLAIM_SUCCESS_POINTS.replace("%prize",names);
					addText(prize_str);
					// show icons
					loadIcons(urls);
				}
			}
			// check if more prizes are available
			if(_pendingPrizes != null && _pendingPrizes.length > 0) {
				var txt:TextField = addText(ANOTHER_PRIZE);
				if(txt != null) txt.addEventListener(TextEvent.LINK,onNextPrizeRequest);
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function is triggered when a claim prize call is successfully made to php.
		
		public function onClaimResult(ev:CustomEvent) {
			var info:Object;
			// check if the claim was a success
			if(ev.oData == true) {
				// pop the top entry off our pending list
				if(_pendingPrizes == null) return;
				info = _pendingPrizes.shift();
				showClaimedPrize(info);
			} 
		}
		
		// This function is triggered when a character selection event is broadcast.
		
		override protected function onPopUpRequest(ev:Event) {
			showMessage(INSTRUCTION_HEADER,INSTRUCTION_TEXT);
			broadcast(POPUP_SHOWN);
		}
		
		// When there's a status event, extract the data.
		
		protected function onStatusResult(ev:CustomEvent) {
			// extract prize list
			var info:Object = ev.oData;
			_pendingPrizes = info["prizeConditions"] as Array;
			showPrize();
		}
		
		// Link Events
		
		protected function onClaimPrizeClick(ev:TextEvent) {
			if(_pendingPrizes == null || _pendingPrizes.length < 1) return;
			// get top entry
			var prize_data:Object = _pendingPrizes[0];
			// check if the top prize has a valid prize id
			var prize_id:String = String(prize_data["id"]);
			if(prize_id != null){
				//PRE-HACK
				//broadcast(QuestPage.CLAIM_PRIZE_REQUEST,prize_id);
				//VIV - HACK do not reuse!
				if (prize_id != 2000){
					//broadcast(QuestPage.CLAIM_PRIZE_REQUEST,prize_id);
				} else {
					if(_pendingPrizes == null) return;
					var info:Object = _pendingPrizes.shift();
					showClaimedPrize(info);
				}
			} 
		}
		
		protected function onNextPrizeRequest(ev:TextEvent) {
			showPrize();
		}

	}
	
}