package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.Loader;
	
	
	
	public class InventoryPopupClass extends GenericScreenClass {
		
		public var btn_inventoryAgain: SimpleButton; //on stage
		public var btn_inventoryPurchase: SimpleButton; //on stage
		
		public var txt_btn_purchasedice: TextField; //on stage
		public var txt_btn_playagain: TextField; //on stage
		public var txt_confirm_prize: TextField; //on stage		
		public var txt_dice_remaining: TextField; //on stage
		
		public var txt_prize_left: TextField; //on stage	
		public var txt_prize_right: TextField; //on stage		
		public var txt_prize_center: TextField; //on stage
		
		public var crown1_mc: MovieClip;	//on stage
		public var crown2_mc: MovieClip;	//on stage
		public var diceicon1_mc: MovieClip;	//on stage
		public var diceicon2_mc: MovieClip;	//on stage
		
		public var dData: Object;
		
		public const PRIZEY:Number = 360;
		public const PRIZEX_LEFT:Number = 306;
		public const PRIZEX_RIGHT:Number = 561;
		public const PRIZEX_CENTER:Number = 433;
		
		
		
		
		public function InventoryPopupClass() {			
			super();						
			dData = DiceData.instance;
		}
		
		public function init() {
			//trace("init ConfirmPopup");
			txt_prize_left.text="";			
			txt_prize_right.text="";			
			txt_prize_center.text="";
			var resultArray: Array = new Array("","wood","bronze","silver","gold","bonus","double");
			if (dData.diceRemaining > 0 ) {//if there's dice remaining, give the option to play again.
				btn_inventoryAgain.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);						
				tManager.setTextField(txt_btn_playagain, tData.IDS_BTN_PLAYAGAIN);						
			} else { //hide the option to play again
				btn_inventoryPurchase.x -=177;
				txt_btn_purchasedice.x -=177;
				btn_inventoryAgain.visible = false;
				txt_btn_playagain.htmlText = "";
			}
			var numDiceRemaining: Number = dData.diceRemaining;
			tManager.setTextField(txt_dice_remaining, tData.IDS_DICE_REMAINING + String(numDiceRemaining));			
			btn_inventoryPurchase.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			tManager.setTextField(txt_btn_purchasedice, tData.IDS_BTN_PURCHASEDICE);			
			txt_btn_playagain.mouseEnabled = false;
			txt_btn_purchasedice.mouseEnabled = false;
			var str_confirm:String = "";
			var str_prize:String = "";
			var imageLoader = new Loader();
			var imageLoader2 = new Loader();
			crown1_mc.gotoAndStop(1); crown2_mc.gotoAndStop(1);
			diceicon1_mc.gotoAndStop(resultArray[dData.tier]);			
			diceicon2_mc.gotoAndStop(resultArray[dData.tier]);
			if (dData.tier < 5) {								
				//trace("TIER = " + dData.tier);
				//str_confirm = tData.IDS_INVENTORY1.replace("%1",dData.prize1name);
				//tManager.setTextField(txt_confirm_prize, str_confirm);	
				tManager.setTextField(txt_confirm_prize, tData.IDS_INVENTORY1);
				str_prize = tData.IDS_PRIZES1.replace("%1",dData.prize1name);
				tManager.setTextField(txt_prize_center, str_prize);
				imageLoader.x = PRIZEX_CENTER;
				imageLoader.y = PRIZEY;
				imageLoader.load(new URLRequest("http://images.neopets.com/items/" + dData.prize1url + ".gif"));
				imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);				
				addChild(imageLoader);					
			} else if (dData.tier==5) {
				//trace("TIER = 5 *");
				//str_confirm = tData.IDS_INVENTORYB.replace("%1",dData.prize1name);
				//str_confirm = str_confirm.replace("%2",dData.prizeBname);
				//tManager.setTextField(txt_confirm_prize, str_confirm);					
				tManager.setTextField(txt_confirm_prize, tData.IDS_INVENTORYB);
				str_prize = tData.IDS_PRIZES1.replace("%1",dData.prize1name);
				tManager.setTextField(txt_prize_left, str_prize);
				str_prize = tData.IDS_PRIZES1.replace("%1",dData.prizeBname);
				tManager.setTextField(txt_prize_right, str_prize);
				imageLoader2.x = PRIZEX_RIGHT;
				imageLoader2.y = PRIZEY;
				imageLoader.load(new URLRequest("http://images.neopets.com/items/" + dData.prize1url + ".gif"));
				imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);				
				addChild(imageLoader);					
				imageLoader.x = PRIZEX_LEFT;
				imageLoader.y = PRIZEY;
				imageLoader2.load(new URLRequest("http://images.neopets.com/items/" + dData.prizeBurl + ".gif"));
				imageLoader2.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
				imageLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);				
				addChild(imageLoader2);					
			} else if (dData.tier==6) {				
				crown1_mc.play();
				crown2_mc.play();
				//trace("TIER = 6 *");
				//str_confirm = tData.IDS_INVENTORY2.replace("%1",dData.prize1name);
				//str_confirm = str_confirm.replace("%2",dData.prize2name);
				//tManager.setTextField(txt_confirm_prize, str_confirm);					
				tManager.setTextField(txt_confirm_prize, tData.IDS_INVENTORY2);
				str_prize = tData.IDS_PRIZES1.replace("%1",dData.prize1name);
				tManager.setTextField(txt_prize_left, str_prize);
				str_prize = tData.IDS_PRIZES1.replace("%1",dData.prize2name);
				tManager.setTextField(txt_prize_right, str_prize);
				imageLoader2.x = PRIZEX_LEFT;
				imageLoader2.y = PRIZEY;
				imageLoader2.load(new URLRequest("http://images.neopets.com/items/" + dData.prize1url + ".gif"));
				imageLoader2.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
				imageLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);				
				addChild(imageLoader2);					
				imageLoader.x = PRIZEX_RIGHT;
				imageLoader.y = PRIZEY;
				imageLoader.load(new URLRequest("http://images.neopets.com/items/" + dData.prize2url + ".gif"));
				imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);				
				addChild(imageLoader);					
			}
		}
		
		function imageLoaded(e:Event):void {
			// Load Image
			////trace("image loaded");
			//addChild(imageLoader);		
		}
		 
		function imageLoading(e:ProgressEvent):void {
		
		// Use it to get current download progress
		// Hint: You could tie the values to a preloader :)
		
		}
	
	
	
	
	}
}

