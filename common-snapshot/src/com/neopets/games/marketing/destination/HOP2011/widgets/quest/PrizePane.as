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
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.TextEvent;
	import flash.net.Responder;
	
	import com.neopets.util.display.ListPane;
	import com.neopets.util.display.BoundedIconRow;
	import com.neopets.util.display.BoundedImageRow;
	import com.neopets.util.servers.NeopetsServerManager;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.games.marketing.destination.HOP2011.pages.HubPage;
	
	public class PrizePane extends ListPane
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ICON_SIZE:Number = 80;
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var baseWidth:Number;
		protected var _pendingPrizes:Array;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PrizePane():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function reset():void {
			_pendingPrizes = null;
			clearItems();
		}
		
		// MESSAGE DISPLAY FUNCTIONS
		
		public function showPrizes(list:Array):void {
			_pendingPrizes = list;
			if(_pendingPrizes != null && _pendingPrizes.length > 0) {
				showPrize(_pendingPrizes[0]);
			}
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
				// update field text
				txt.htmlText = msg;
				// resize field
				txt.width = baseWidth;
				txt.height = txt.textHeight + 4; // add extra padding to make sure text shows
				// add shell to our pane
				addItemAt(shell,index);
			}
			return txt;
		}
		
		// Use this function to add a row of prize icons to our content pane.
		// param		list		String		This is an array of icon urls.
		// param		index		int			This is where in the list the item should be placed.
		
		public function loadPrizes(info:Object,index:int=-1):void {
			if(info == null) return;
			var list:Array = getPrizesIn(info);
			if(list == null || list.length < 1) return;
			// create the new icon row
			var row:BoundedImageRow = new BoundedImageRow();
			row.verticalAlignment = BoundedImageRow.TOP_ALIGN;
			// add a bounding area to the row
			var clip:MovieClip = getRowBacking();
			row.boundingObject = clip;
			// load images into the icon row
			var image:MovieClip;
			for(var i:int = 0; i < list.length; i++) {
				image = new PrizeClipMC();
				row.addImage(image);
				image.initFrom(list[i]);
			}
			// add the row to our content pane
			addItemAt(row,index);
		}
		
		// PRIZE PROCESSING FUNCTIONS
		
		// Extracts prize names into a list style string.
		// param	info			Object		Prize data entry
		// param	restriction		Number		If positive number, only use entries of a this type code.
		
		public function getPrizeNamesString(info:Object,restriction:Number=0):String {
			if(info == null) return null;
			// extract prize data
			var prizes:Array = info["prizes"] as Array;
			if(prizes == null) prizes = new Array(info);
			// cycle through all prize names
			var translator:TranslationManager = TranslationManager.instance;
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
						if(i < end_index) names_str += translator.getTranslationOf("IDS_LIST_BREAKER");
						else names_str += " " + translator.getTranslationOf("IDS_AND") + "  ";
						names_str += entry_name;
					}

				}
			}
			return names_str;
		}
		
		// Extracts prize data
		// param	info			Object		Prize data entry
		// param	restriction		Number		If positive number, only use entries of a this type code.
		
		public function getPrizesIn(info:Object,restriction:Number=0):Array {
			if(info == null) return null;
			// extract prize data
			var prizes:Array = info["prizes"] as Array;
			if(prizes == null) prizes = new Array(info);
			if(restriction <= 0) return prizes;
			// if we got this far, filter the list
			var entry:Object;
			var entry_type:Number;
			var sub_list:Array = new Array();
			for(var i:int = 0; i < prizes.length; i++) {
				entry = prizes[i];
				// apply type restrictions
				entry_type = Number(entry["type"]);
				if(entry_type == restriction) sub_list.push(entry);
			}
			return sub_list;
		}
		
		public function getRowBacking():MovieClip {
			var clip:MovieClip = new MovieClip();
			clip.graphics.beginFill(0x000000,0.01);
			clip.graphics.drawRect(0,0,baseWidth,ICON_SIZE);
			clip.graphics.endFill();
			return clip;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// MESSAGE DISPLAY FUNCTIONS
		
		// This function shows a prize after it's been claimed through an amf-php call.
		
		protected function showClaimedPrize(info:Object) {
			if(info == null) return;
			// clear existing messages
			clearItems();
			// Check if we gained inventory items
			var names:String;
			var prizes:Array = getPrizesIn(info,1); // filter out non-item awards
			var translator:TranslationManager = TranslationManager.instance;
			var prize_str:String;
			if(prizes != null && prizes.length > 0) {
				// set up "items added to inventory" text
				if(prizes.length > 1) prize_str = translator.getTranslationOf("IDS_ITEMS_CLAIMED");
				else prize_str = translator.getTranslationOf("IDS_ITEM_CLAIMED");
				// replace url
				var base_url:String = NeopetsServerManager.instance.scriptServer;
				prize_str = prize_str.replace("%url",base_url+"/objects.phtml?type=inventory");
				// add textfield
				addText(prize_str);
				// show icons
				loadPrizes(info);
			} else {
				// check for point prizes
				prizes = getPrizesIn(info,2);
				if(prizes != null && prizes.length > 0) {
					names = getPrizeNamesString(info,2);
					prize_str = translator.getTranslationOf("IDS_POINTS_CLAIMED");
					prize_str = prize_str.replace("%prize",names);
					addText(prize_str);
					// show icons
					loadPrizes(info);
				}
			}
			// check if more prizes are available
			if(_pendingPrizes != null && _pendingPrizes.length > 0) {
				prize_str = translator.getTranslationOf("IDS_ANOTHER_PRIZE");
				var txt:TextField = addText(prize_str);
				if(txt != null) txt.addEventListener(TextEvent.LINK,onNextPrizeRequest);
			}
		}
		
		// This function displays currently won but unclaimed prizes.
		
		protected function showPrize(info:Object):void {
			if(info == null) return;
			// clear existing message
			clearItems();
			// set up first text block
			var translator:TranslationManager = TranslationManager.instance;
			var prize_str:String = translator.getTranslationOf("IDS_SHOW_PRIZE");
			addText(prize_str);
			// add icon row to pane
			loadPrizes(info);
			// set up second text block
			var txt:TextField = addText(translator.getTranslationOf("IDS_CLAIM_PRIZE"));
			if(txt != null) txt.addEventListener(TextEvent.LINK,onClaimPrizeClick);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onClaimPrizeClick(ev:TextEvent) {
			if(_pendingPrizes == null || _pendingPrizes.length < 1) return;
			// get top entry
			var prize_data:Object = _pendingPrizes[0];
			// check if the top prize has a valid prize id
			var prize_id:String = String(prize_data["id"]);
			if(prize_id != null){
				var func_path:String = HubPage.SERVICE_ID + ".claim";
				var responder:Responder = new Responder(onClaimResult, onClaimFault);
				NeopetsConnectionManager.instance.callRemoteMethod(func_path,responder,prize_id);
			}
		}
		
		protected function onNextPrizeRequest(ev:TextEvent) {
			if(_pendingPrizes != null && _pendingPrizes.length > 0) {
				showPrize(_pendingPrizes[0]);
			}
		}
		
		// "getStatus" responder functions
		
		protected function onClaimResult(msg:Object):void {
			trace("claim success: " + msg);
			// get top entry
			var info:Object = _pendingPrizes.shift();
			showClaimedPrize(info);
		}
		
		protected function onClaimFault(msg:Object):void {
			trace("claim fault: " + msg);
			// show error message
			clearItems();
			var translator:TranslationManager = TranslationManager.instance;
			addText(translator.getTranslationOf("IDS_CLAIM_ERROR"));
		}

	}

	
}