package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;	
	import flash.text.TextField;
	
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.servers.ServerFinder;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.external.ExternalInterface;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.Loader;
	
	import com.neopets.users.vivianab.LibraryLoader;
	
	
	public class PrizeScreenClass extends GenericScreenClass {
		
		//debug::::(no need to change these when testing online, offline or on live)::::::::::::::::::::::::::::::::::::::::::::::
		public const LANG:String = "EN";
		public const SCRIPT_SERVER:String = "http://www.neopets.com/"
		public const IMAGES_SERVER:String = "http://images.neopets.com/"
			//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		
		
		//AMFPHP vars:
		private var gateway:String = "/amfphp/gateway.php";
		private var connection:NetConnection;
		private var responder:Responder;		
		private var _host_url: String;		
		private var _image_url: String;
		
		//server finder
		private var sv:NeopetsServerFinder;
		
		public var crown1_mc: MovieClip;	//on stage
		public var crown2_mc: MovieClip;	//on stage
		public var bonus_mc: MovieClip;	//on stage
		public var diceicon1_mc: MovieClip;	//on stage
		public var diceicon2_mc: MovieClip;	//on stage
		public var mcTransBonus:MovieClip; //on stage
		public var shieldHi_mc:MovieClip; //on stage
		public var mc_tooltip:MovieClip; //on stage
		
		public var btn_claim_prize: SimpleButton; //on stage
		
		public var txt_top: TextField;	//on stage
		public var txt_middle: TextField;	//on stage
		public var txt_btn_claim_prize: TextField;	//on stage
		
		private var array_tier1: Array;
		private var array_tier2: Array;
		private var array_tier3: Array;
		private var array_tier4: Array;
		
		private var currHi1: MovieClip;
		private var currHi2: MovieClip;
		
		private var selBtn1:SimpleButton;
		private var selBtn2: SimpleButton;
		
		public const PRIZEBUTTON_PRESSED:String = "PRIZEButtonPressed";
		
		public var dData: Object;
		
		//var imageLoader: Loader;
		
		public function PrizeScreenClass() {			
			super();						
			dData = DiceData.instance;
			
			//sv = new NeopetsServerFinder ();
			//sv.findServersFor(this);
		}
		
		public function init() {			
			//btn_back.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			crown1_mc.gotoAndStop(1);		
			crown2_mc.gotoAndStop(1);		
			bonus_mc.gotoAndStop(1);
			phpSetup();			
			//trace("PRIZE SCREEN DICE REMAINING = " + dData.diceRemaining);
			tManager.setTextField(txt_btn_claim_prize, tData.IDS_BTN_CLAIM_PRIZE);			
			txt_btn_claim_prize.mouseEnabled = false;
			txt_btn_claim_prize.textColor = 0xCCCCCC;
			btn_claim_prize.alpha = 0.5;
			btn_claim_prize.mouseEnabled = false;
			mcTransBonus.gotoAndStop(dData.lang);
			setResult(dData.tier);
		}
		
		
		protected function phpSetup(): void {
			/*var paramList:Object = this.root.loaderInfo.parameters;
			if (paramList["host_url"] != null) {
				_host_url = "http://" + paramList["host_url"];				
			} else {
				_host_url = "http://www.neopets.com";
			}	*/	
			sv = new NeopetsServerFinder ();
			sv.findServersFor(this);
			if (sv.isOnline){
				trace("is online");
				_host_url = sv.scriptServer;
				_image_url = sv.imageServer;
			} else {				
				trace("is offline");
				_host_url = SCRIPT_SERVER;
				_image_url = IMAGES_SERVER;
			}
			trace("   _host_url = " + _host_url);
			trace("   _image_url = " + _image_url);
			responder = new Responder(onPrizeShopResult, onPrizeShopFault);
			connection = new NetConnection;
			connection.connect(_host_url + gateway);
			//connection.call("WheelService.spinWheel", responder, "2");
			connection.call("BlumarollService.prizeShop", responder, dData.rollID);
		}
		
		private function onPrizeShopResult(result:Object):void {
			for (var i in result) {
				//trace("[Prize shop] AMFPHP RESULT: " + i + " :: " + result[i]);
				for (var j in result[i]) {
					for (var k in result[i][j]) {
						for (var l in result[i][j][k]) {
							//trace("   [Prize shop] AMFPHP RESULT: " + i + " :: " + j + " :: " +  k + " :: "+  l + " :: " + result[i][j][k][l]);
						}
					}
				}
			}
			//trace("[onPrizeShopResult 1a]");
			/*array_tier1 =  result.prizeShop.tier1;
			//trace("[onPrizeShopResult 2]");
			array_tier2 =  result.prizeShop.tier2;
			//trace("[onPrizeShopResult 3]");
			array_tier3 =  result.prizeShop.tier3;
			//trace("[onPrizeShopResult 4]");
			array_tier4 =  result.prizeShop.tier4;
			//trace("[onPrizeShopResult 5]");
			dData.prizeBname = result.prizeShop.bonus[0].name;
			//trace("[onPrizeShopResult 6]");
			dData.prizeBoii = result.prizeShop.bonus[0].oii;
			//trace("[onPrizeShopResult 7]");
			dData.prizeBurl = result.prizeShop.bonus[0].img;
			//trace("[onPrizeShopResult 8]");*/
			array_tier1 =  result.tier1;
			//trace("[onPrizeShopResult 2a]");
			array_tier2 =  result.tier2;
			//trace("[onPrizeShopResult 3a]");
			array_tier3 =  result.tier3;
			//trace("[onPrizeShopResult 4a]");
			array_tier4 =  result.tier4;
			//trace("[onPrizeShopResult 5]");
			dData.prizeBname = result.bonus[0].name;
			//trace("[onPrizeShopResult 6]");
			dData.prizeBoii = result.bonus[0].oii;
			//trace("[onPrizeShopResult 7]");
			dData.prizeBurl = result.bonus[0].img;
			//trace("[onPrizeShopResult 8]");
			////trace("ARRAY TIER 1 = " + array_tier1.length);
			// Prize shop setup here
			buildShop();
			
			//trace("[onPrizeShopResult 9]");
		}
		
		private function onPrizeShopFault(result:Object):void {
			for (var i in result) {
				//trace("[FAULT] AMFPHP RESULT: " + i + " :: " + result[i]);
			}
			//proceedThruStatusFault()
		}
		
		//this is a placeholder function that ignores status fault and just goes to the intro screen. Should be deleted once AMFPHP is up and running
		/*private function proceedThruStatusFault(): void {
		}*/
		
		public function buildShop() {
			var superArray: Array = new Array(array_tier1, array_tier2, array_tier3, array_tier4);
			
			for (var j in superArray) {
				for (var i in superArray[j]) {
					//var temp = new MovieClip();
					var spacer: Number = 6;
					var imageLoader = new Loader();
					imageLoader.x = (i * (80 + spacer)) + ((510 + spacer/2) - ((40 + spacer/2) * superArray[j].length));
					imageLoader.y = 160 + (j * 100);
					if (j==3) {
						imageLoader.y -= 6;
					}
					var imageBg:MovieClip;
					imageBg = LibraryLoader.createElement("prize_bg",imageLoader.x, imageLoader.y);
					addChild(imageBg);					
					imageLoader.load(new URLRequest(_image_url + "/items/" + superArray[j][i].img + ".gif"));
					imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);				
					addChild(imageLoader);					
	///*DELETE THIS */ dData.tier = 6;
					if ( dData.tier==j+1 || (dData.tier==5 && j==3) || dData.tier==6) {
						//adds a button to make all allowable items clickable:
						var imageHighlight:MovieClip;
						imageHighlight = LibraryLoader.createElement("prize_btn",imageLoader.x, imageLoader.y);
						imageHighlight.name = "prizeItemBtn" + j + "_" + i;
						imageHighlight.prizeName = superArray[j][i].name;
						imageHighlight.prizeOii = superArray[j][i].oii;
						imageHighlight.prizeUrl = superArray[j][i].img;
						/*imageHighlight.tooltip = new TextField();
						imageHighlight.tooltip.text = "*" + imageHighlight.prizeName;
						imageHighlight.tooltip.textColor = 0xFFFFFF;
						imageHighlight.tooltip.x = 80;
						imageHighlight.tooltip.y = -10;
						imageHighlight.addChild(imageHighlight.tooltip);
						//trace("5. imageHighlight.tooltip.length = " + imageHighlight.tooltip.width);*/
						imageHighlight.the_btn.addEventListener(MouseEvent.CLICK, prizeItemClicked ,false,0,true);
						imageHighlight.the_btn.addEventListener(MouseEvent.MOUSE_OVER, prizeItemRollover ,false,0,true);						
						imageHighlight.the_btn.addEventListener(MouseEvent.MOUSE_OUT, prizeItemRollout ,false,0,true);
						addChild(imageHighlight);					
					   // Adds the "selected" highlight to all clickable items:
						var imageSelected:MovieClip;
						imageSelected = LibraryLoader.createElement("prize_selected",imageLoader.x, imageLoader.y);
						imageSelected.name = "prizeItemBtn" + j + "_" + i + "_selected";					
						addChild(imageSelected);					
						imageSelected.visible = false;
						imageHighlight.selectHigh = imageSelected;
					} else {
						//Adds a grayed-out overlay to all unselectable items
						var imageGray:MovieClip;
						imageGray = LibraryLoader.createElement("prize_gray",imageLoader.x, imageLoader.y);
						addChild(imageGray);					
					}
					
				}
			}
			mc_tooltip = LibraryLoader.createElement("mcTooltip",0, 0);
			mc_tooltip.visible = false;
			addChild(mc_tooltip);
			stage.addEventListener(PRIZEBUTTON_PRESSED,onPrizeButtonPressed,false,0,true);
		}
		
		function imageLoaded(e:Event):void {
			// Load Image
			//trace("image loaded");
			//addChild(imageLoader);		
		}
		 
		function imageLoading(e:ProgressEvent):void {
		
		// Use it to get current download progress
		// Hint: You could tie the values to a preloader :)
		
		}
		
		public function setResult(p_result: Number) {
			var resultArray: Array = new Array("","wood","bronze","silver","gold","bonus","double");
			var str_result_var: String = "";
			var str_result_full: String = "";
			//trace("P_RESULT = " + p_result);
			diceicon1_mc.gotoAndStop(resultArray[p_result]);			
			diceicon2_mc.gotoAndStop(resultArray[p_result]);			
			shieldHi_mc.gotoAndStop(p_result);
			//if (p_result=="double") {
			if (p_result==6) {	
				crown1_mc.play();		
				crown2_mc.play();		
			}
			//if (p_result=="bonus") {
			if (p_result==5) {	
				bonus_mc.gotoAndStop(2);		
			} else {
				bonus_mc.gotoAndStop(1);		
			}
			switch (p_result) {
				case 4: //"gold" : 
					str_result_var = tData.IDS_ROLL_RESULT_GOLD; 
					tManager.setTextField(txt_top, tData.IDS_PRIZE_PAGE_TOP_1);
					break;
				case 3: //"silver" : 
					str_result_var = tData.IDS_ROLL_RESULT_SILVER; 
					tManager.setTextField(txt_top, tData.IDS_PRIZE_PAGE_TOP_1);
					break;
				case 2: // "bronze" : 
					str_result_var = tData.IDS_ROLL_RESULT_BRONZE; 
					tManager.setTextField(txt_top, tData.IDS_PRIZE_PAGE_TOP_1);
					break;
				case 1: // "wood" : 
					str_result_var = tData.IDS_ROLL_RESULT_WOOD; 					
					tManager.setTextField(txt_top, tData.IDS_PRIZE_PAGE_TOP_1);
					break;
				case 6: //"double" : 
					str_result_var = tData.IDS_ROLL_RESULT_DOUBLE; 					
					tManager.setTextField(txt_top, tData.IDS_PRIZE_PAGE_TOP_2);
					break;
				case 5:// "bonus" : 
					str_result_var = tData.IDS_ROLL_RESULT_BONUS; 					
					tManager.setTextField(txt_top, tData.IDS_PRIZE_PAGE_TOP_B);
					break;									
				default : 
					str_result_var = "ERROR"; 
					break;									
			}		
			//trace("2. PRIZE SCREEN RESULT VAR = " + str_result_var);
			str_result_full = tData.IDS_PRIZE_PAGE_ROLL_RESULT.replace("%1",str_result_var);
			tManager.setTextField(txt_middle, str_result_full);		
			// reposition txt_top:
			//trace("txt_top.textHeight = " + txt_top.textHeight);
			if (txt_top.textHeight < 20) {				
				txt_top.y = 12;
			} else {				
				txt_top.y = 3;
			}
		}
		
		protected function prizeItemClicked(evt:Event):void
		{			
			//trace("PRIZE ITEM CLICKED :: " + evt.currentTarget.parent.name);
			//stage.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.parent.name},PRIZEBUTTON_PRESSED));				
			evt.currentTarget.parent.selectHigh.visible = true;
			if (dData.tier < 6) { //if only one prize selectable
				if (currHi1) {
					//trace("Making " + currHi1.name + " invisible");
					currHi1.visible = false;				
					selBtn1.mouseEnabled = true;
				}
				//trace("Setting " + evt.currentTarget.parent.selectHigh.name + " to CurrHi1.");				
				currHi1 = evt.currentTarget.parent.selectHigh;
				selBtn1 = evt.currentTarget as SimpleButton;
				selBtn1.mouseEnabled = false;
				dData.prize1name = evt.currentTarget.parent.prizeName;
				dData.prize1oii = evt.currentTarget.parent.prizeOii;
				dData.prize1url = evt.currentTarget.parent.prizeUrl;
				activateClaimButton();
			} else { //if two prizes are selectable
				if (currHi2) {
					currHi1.visible = false;									
					selBtn1.mouseEnabled = true;
					currHi1 = currHi2;
					selBtn1 = selBtn2;
					dData.prize1name = dData.prize2name;
					dData.prize1oii = dData.prize2oii;
					dData.prize1url = dData.prize2url;
					currHi2 = evt.currentTarget.parent.selectHigh;					
					selBtn2 = evt.currentTarget as SimpleButton;
					selBtn2.mouseEnabled = false;
					dData.prize2name = evt.currentTarget.parent.prizeName;
					dData.prize2oii = evt.currentTarget.parent.prizeOii;
					dData.prize2url = evt.currentTarget.parent.prizeUrl;
				} else if (currHi1) {
					currHi2 = evt.currentTarget.parent.selectHigh;
					selBtn2 = evt.currentTarget as SimpleButton;
					selBtn2.mouseEnabled = false;
					dData.prize2name = evt.currentTarget.parent.prizeName;
					dData.prize2oii = evt.currentTarget.parent.prizeOii;
					dData.prize2url = evt.currentTarget.parent.prizeUrl;
					activateClaimButton();
				} else {
					currHi1 = evt.currentTarget.parent.selectHigh;
					selBtn1 = evt.currentTarget as SimpleButton;
					selBtn1.mouseEnabled = false;
					dData.prize1name = evt.currentTarget.parent.prizeName;
					dData.prize1oii = evt.currentTarget.parent.prizeOii;
					dData.prize1url = evt.currentTarget.parent.prizeUrl;
				}
			}
		}
		
		private function activateClaimButton():void {			
			txt_btn_claim_prize.textColor = 0x000000;
			btn_claim_prize.alpha = 1;
			btn_claim_prize.mouseEnabled = true;
			btn_claim_prize.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
		}
		
		private function onPrizeButtonPressed(evt:CustomEvent):void {
			//trace("ON PRIZE BTN PRESSED: " + evt.oData.TARGETID);
		}
		
		protected function prizeItemRollover(evt:Event):void
		{		
			//trace("2. rollover");
			mc_tooltip.visible = true;
			mc_tooltip.x = evt.currentTarget.parent.x;
			mc_tooltip.y = mouseY;
			mc_tooltip.txt.text = evt.currentTarget.parent.prizeName;
			mc_tooltip.bg.width = mc_tooltip.txt.textWidth + 7;
				
		}
		
		protected function prizeItemRollout(evt:Event):void
		{		
			//trace("rollout");
			mc_tooltip.visible = false;
		}
		
		
		
		
	
	
	
	
	}
}

