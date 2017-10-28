
package   com.neopets.games.inhouse.Diceroll{
	// required for flash file and output display
	import com.neopets.games.inhouse.Diceroll.DiceData;
	import com.neopets.games.inhouse.Diceroll.TranslationManagerInfo;
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.util.loading.LoadingManager;
	import com.neopets.util.loading.LoadingManagerConstants;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.servers.ServerFinder;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import virtualworlds.lang.ITranslationManager;
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
		

	// Flash CS3 Document Class. 
	public class DiceRollDocumentClass extends MovieClip {
		
		
		//debug::::(no need to change these when testing online, offline or on live)::::::::::::::::::::::::::::::::::::::::::::::
		public const LANG:String = "EN";
		public const SCRIPT_SERVER:String = "http://dev.neopets.com/"
		public const IMAGES_SERVER:String = "http://images50.neopets.com/"
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
		//assets to be loaded
		private var _assets:Array = ["anim_die_sides_wood.png", "anim_die_sides_bronze.png","anim_die_sides_silv.png", "anim_die_sides_gold.png", "anim_die_sides_star.png", "anim_die_sides_crown.png", "tablecloth_large.jpg" , "shadow.png", "diceroll_assets_v7.swf" ] 
		private var dicerollBitmaps:Array = [];
			
		//server finder
		private var sv:NeopetsServerFinder;
		
		//AMFPHP vars:
		private var gateway:String = "/amfphp/gateway.php";
		private var connection:NetConnection;
		private var responder:Responder;
		
		
		// Screens and popups:
		private var introScreen: MovieClip; 
		private var instructionScreen: MovieClip; 
		private var prizeScreen: MovieClip; 
		private var rollScreen:Blumaroll_rollingpage;
		private var currPopup: MovieClip;		
		private var formerScreen: MovieClip; 
		private var currentScreen: MovieClip; 		
		private var hideScreen: MovieClip;
		
		private var _rollScreenOpen:Boolean = false;
		
		//Translation Manager Vars:
		public var tManager:ITranslationManager;
		public var tData:TranslationData;
		private var mGame_ID:int = 850;
		private var mType_ID:int = TranslationManagerInfo.TYPE_ID_CONTENT;	
		public var lang:String = "EN";
		private var _host_url: String;
		
		public var dData: Object;
		
		private var preloader:MovieClip;
		
		
		public const BUTTON_PRESSED:String = "MenuButtonPressed";
		
		
		public function DiceRollDocumentClass() {			
			super();
			dData = DiceData.instance;
			//trace(" * dData.diceRemaining = " + dData.diceRemaining)
			//
			preloader = new LoadingSign ();
			addChild(preloader);
			preloader.x = stage.width/2 - preloader.width/2;
			preloader.y = stage.height/2 - preloader.height/2;
			//
			sv = new NeopetsServerFinder ();
			sv.findServersFor(this);
			//LibraryLoader.loadLibrary("http://images50.neopets.com/games/g1291/diceroll_assets.swf", onLibLoaded);	
			loadAssets();

			///LibraryLoader.loadLibrary("http://images50.neopets.com/games/g1291/diceroll_assets.swf", onLibLoaded);								
			//LibraryLoader.loadLibrary("diceroll_assets.swf", onLibLoaded);			

		}
		

		
		private function loadAssets ():void {
			LoadingManager.instance.addEventListener(LoadingManagerConstants.LOADING_COMPLETE, parseBitmaps);
			var bpath:String = "games/g1291/";
			if (sv.isOnline){
				LoadingManager.instance.init(sv.imageServer+"/", !sv.isOnline);
			} else {
				LoadingManager.instance.init("", !sv.isOnline);
			}
			for (var i:int=0; i<_assets.length; i++){
				LoadingManager.instance.addItemToLoad (bpath+_assets[i], "asset_"+i);
			}
			LoadingManager.instance.startLoadingList();
		}
		
		private function parseBitmaps(e:Event):void {
			var loaded:Array = LoadingManager.instance.loadedItems;
			for (var i:int=0; i< loaded.length; i++){
				if (LoadedItem(loaded[0][i]).objItem is Bitmap){
					dicerollBitmaps.push(Bitmap(LoadedItem(loaded[0][i]).objItem).bitmapData);
				}
			}
			onLibLoaded();
		}
		
		protected function onLibLoaded():void {
			//trace ("Library  is loaded.");
			//removing loader sign
			if (getChildByName("preloader") != null) removeChild(getChildByName("preloader"));
			init();			
		};		
		
		public function init() {			
			////trace("init document class");
			loadTranslation();
		}

		
		private function loadTranslation() {
			var paramList:Object = this.root.loaderInfo.parameters;
			if (paramList["lang"] != null) {
				lang = paramList["lang"].toUpperCase();
				//trace("passed LANG = " + lang);
			} else {
				lang = LANG;
				//trace("default LANG = " + lang);
			}
			
			if (sv.isOnline){
				_host_url = sv.scriptServer;
			} else {
				_host_url = SCRIPT_SERVER;
			}
			dData.lang = lang;
			tManager = TranslationManager.instance;
			tData = new TranslationData ();
			//get the translation
			//tManager.addEventListener (TranslationManagerInfo.TRANSLATION_DONE, onTranslationComplete);
			tManager.addEventListener (Event.COMPLETE, onTranslationComplete);
			tManager.init(lang, mGame_ID, mType_ID, tData, _host_url + "/");			
		}
		
		private function onTranslationComplete (e:Event):void {
			//trace("ON TRANS COMPLETE");
			tManager.removeEventListener (Event.COMPLETE, onTranslationComplete);
			//trace ("***TranslationData:"+tData);
			for (var i in tData) {
				//trace(" ---> " + i + " :: " + tData[i]);
			}			
			phpSetup();
		}
		
//--------------------------------------------------------------------------------------------------------------------------		
		
		protected function phpSetup(): void {
			responder = new Responder(onStatusResult, onStatusFault);
			connection = new NetConnection;
			connection.connect(_host_url + gateway);
			//connection.call("WheelService.spinWheel", responder, "2");
			connection.call("BlumarollService.getStatus", responder);
		}
		
		private function onStatusResult(result:Object):void {
			for (var i in result) {
				//trace("AMFPHP RESULT: " + i + " :: " + result[i]);
				for (var j in result[i]) {
					//trace("   AMFPHP RESULT: " + i + " :: " + j + " :: " + result[i][j]);
				}
			}
			if (result.activeDie) {
				dData.rollID = result.activeDie.rollId;
				dData.tier = result.activeDie.tier;
			}
			if (result.user) {
				dData.diceRemaining = result.user.diceRemaining;			
			}
			stage.addEventListener(BUTTON_PRESSED,onButtonPressed,false,0,true);			
					
			if (result.error) {
				//trace("error: " + result.error.message);
				//trace("tManager = " + tManager);
				displayError(result.error.message);
			} else if (!result.user) {
				displayError(tData.IDS_ERROR_NOTLOGGEDIN);
			} else {
				if (result.user.diceRemaining > 0 && !result.activeDie) {
					//trace("INTRO SCREEN");
					displayScreen("intro");
				} else if (result.activeDie) {
					if (result.activeDie.rolled) {
						if (result.activeDie.claiming) {
							//trace("PRIZE SCREEN");
							displayScreen("prize"); 
						} else {
							//trace("POST-ROLL SCREEN");						
							displayScreen("rollResult"); //post-roll
							displayPopup("rollResult");
						}
					} else {
						//trace("PRE-ROLL SCREEN");					
						displayScreen("roll"); //pre-roll					
					}
				} else if (result.user.diceRemaining <= 0) {	// throw an error because you shouldn't be here, because you have no dice.				
					displayError(tData.IDS_ERROR_NODICE);
				} else {	// throw an error because you shouldn't be here, for some reason I haven't thought of.				
					displayError(tData.IDS_ERROR_MSG);
				}			
				//displayScreen("prize");
			}
		}
		
		private function onStatusFault(result:Object):void {
			for (var i in result) {
				//trace("[FAULT] AMFPHP RESULT: " + i + " :: " + result[i]);
			}
			displayError(tData.IDS_ERROR_MSG);
			//proceedThruStatusFault()
		}
		
		
//-------------------------------------------------------------------------------------------------------------------------
		
		
		protected function advanceToRoll(): void {			
			//trace("[AMFPHP]AdvanceToRoll called");
			responder = new Responder(onAdvanceResult, onAdvanceFault);
			connection = new NetConnection;
			connection.connect(_host_url + gateway);
			//connection.call("WheelService.spinWheel", responder, "2");
			connection.call("BlumarollService.advanceToRoll", responder);
			hideScreenFunction();
		}
		
		private function onAdvanceResult(result:Object):void {
			for (var i in result) {
				//trace("AMFPHP RESULT: " + i + " :: " + result[i]);
				for (var j in result[i]) {
					//trace("   AMFPHP RESULT: " + i + " :: " + j + " :: " + result[i][j]);
				}
			}
			if (result.error) {
				displayError(result.error.errormsg);
			} else {
				dData.diceRemaining = result.user.diceRemaining;
				dData.rollID = result.activeDie.rollId;
				dData.tier = result.activeDie.tier;
				displayScreen("roll");
				removeChild(currPopup)
			}
		}
		
		private function onAdvanceFault(result:Object):void {
			for (var i in result) {
				//trace("[FAULT - onAdvance] AMFPHP RESULT: " + i + " :: " + result[i]);
			}
			displayError(tData.IDS_ERROR_MSG);
			//proceedThruStatusFault()
		}
		
//-------------------------------------------------------------------------------------------------------------------------

		protected function advanceToClaim(): void {
			//trace("[AMFPHP]AdvanceToClaim called");
			responder = new Responder(onAdvanceToClaimResult, onAdvanceToClaimFault);
			connection = new NetConnection;
			connection.connect(_host_url + gateway);
			//connection.call("WheelService.spinWheel", responder, "2");
			connection.call("BlumarollService.advanceToClaim", responder, dData.rollID);
			hideScreenFunction();
		}
		
		private function onAdvanceToClaimResult(result:Object):void {
			for (var i in result) {
				//trace("AMFPHP RESULT: " + i + " :: " + result[i]);
				for (var j in result[i]) {
					//trace("   AMFPHP RESULT: " + i + " :: " + j + " :: " + result[i][j]);
				}
			}
			if (result.error) {
				displayError(result.error.errormsg);
			} else {
				dData.diceRemaining = result.user.diceRemaining;
				dData.rollID = result.activeDie.rollId;			
				dData.tier = result.activeDie.tier;
				displayScreen("prize");
				prizeScreen.setResult(result.activeDie.tier);
				removeChild(currPopup);
			}
		}
		
		private function onAdvanceToClaimFault(result:Object):void {
			for (var i in result) {
				//trace("[FAULT - onAdvance] AMFPHP RESULT: " + i + " :: " + result[i]);
			}
			displayError(tData.IDS_ERROR_MSG);
			//proceedThruStatusFault()
		}




//--------------------------------------------------------------------------------------------------------------------------
		
		protected function startRoll(): void {
			//trace("[AMFPHP]RollWasShown called");
			responder = new Responder(onRollResult, onRollFault);
			connection = new NetConnection;
			connection.connect(_host_url + gateway);
			//connection.call("WheelService.spinWheel", responder, "2");
			connection.call("BlumarollService.rollWasShown", responder, dData.rollID);
		}
		
		private function onRollResult(result:Object):void {
			//trace("ROLL RESULT");
			for (var i in result) {
				//trace("AMFPHP RESULT: " + i + " :: " + result[i]);
				for (var j in result[i]) {
					//trace("   AMFPHP RESULT: " + i + " :: " + j + " :: " + result[i][j]);
				}
			}
			if (result.error) {
				displayError(result.error.errormsg);
			} else {
				dData.diceRemaining = result.user.diceRemaining;
				dData.rollID = result.activeDie.rollId;
				displayScreen("rollResult");
				displayPopup("rollResult");
				//removeChild(currPopup);
			}
		}
		
		private function onRollFault(result:Object):void {
			for (var i in result) {
				//trace("[FAULT - onRoll] AMFPHP RESULT: " + i + " :: " + result[i]);
			}
			displayError(tData.IDS_ERROR_MSG);
			//proceedThruStatusFault()
		}
		
		
		//this is a placeholder function that ignores status fault and just goes to the intro screen. Should be deleted once AMFPHP is up and running
		private function proceedThruStatusFault(): void {
			//trace("[STATUS FAULT] - going to Intro because Flash doesn't know what to do.");
			displayScreen("rollResult");
			displayPopup("rollResult");
			dData.diceRemaining = 3;
			stage.addEventListener(BUTTON_PRESSED,onButtonPressed,false,0,true);
		}

		
		
		
		private function hideScreenFunction():void {
			hideScreen = LibraryLoader.createElement("mcBlankScreen",0, 0);
			addChild(hideScreen);
		}
				
		
		private function displayScreen(p_screen:String):void {
			//trace("DISPLAY SCREEN: [" + p_screen + " screen]");
			if (hideScreen!=null) {
				removeChild(hideScreen);
				hideScreen=null;
			}
			formerScreen = currentScreen;
			switch( p_screen ) {
				case "intro": 
					//introScreen = new mcIntroScreen();					
					introScreen = LibraryLoader.createElement("mcIntroScreen",0, 0);
					addChild(introScreen);
					currentScreen = introScreen;
					break;
				case "instructions":
					//instructionScreen = new mcInstructionScreen();
					instructionScreen = LibraryLoader.createElement("mcInstructionScreen",0, 0);
					addChild(instructionScreen);
					currentScreen = instructionScreen;
					break;
				case "prize":
					prizeScreen = LibraryLoader.createElement("mcPrizeScreen",0, 0);
					//prizeScreen = new mcPrizeScreen();
					addChild(prizeScreen);
					currentScreen = prizeScreen;
					break;
				case "roll":
					//rollScreen = LibraryLoader.createElement("mcRollScreen",0, 0);
					rollScreen = new Blumaroll_rollingpage ();
					//trace ("WINNING FACE:", dData.tier);
					rollScreen.init(dicerollBitmaps, this.stage, startRoll, dData.tier);
					addChild(rollScreen);
					currentScreen = rollScreen;
					_rollScreenOpen = true;
					break;
				case "rollResult":
					if (!_rollScreenOpen){
						//rollScreen = LibraryLoader.createElement("mcRollScreen",0, 0);
						//addChild(rollScreen);
						//currentScreen = rollScreen;
						rollScreen = new Blumaroll_rollingpage ();
						addChild(rollScreen);
						//trace ("WINNING FACE:", dData.tier);
						rollScreen.init(dicerollBitmaps, this.stage, startRoll, dData.tier, true);
						currentScreen = rollScreen;
						_rollScreenOpen = true;
					}
					break;	
			}
			//trace("currentScreen = " + currentScreen);
			if (formerScreen!=null && formerScreen!=currentScreen && p_screen!="rollResult") {
				//trace("remove former screen");
				removeChild(formerScreen);
				if (formerScreen == rollScreen){
					_rollScreenOpen = false;
				}
			}
			currentScreen.setTrans(tManager, tData);
			if (currentScreen != rollScreen){
				currentScreen.init();
			}
		}
		

		
		
		private function displayPopup(p_screen:String):void {
			//trace("DISPLAY POPUP: [" + p_screen + " screen]");
			switch( p_screen ) {
				case "confirmRoll": 
					currPopup = LibraryLoader.createElement("mcConfirmPopup",0, 0);					
					break;
				case "rollResult":
					currPopup = LibraryLoader.createElement("mcResultPopup",0, 0);					
					currPopup.setTrans(tManager, tData);
					currPopup.setResult(dData.tier); // take this out when we get real results
					break;
				case "confirmPrize":
					currPopup = LibraryLoader.createElement("mcPrizeConfirmPopup",0, 0);										
					break;
				case "inventory":
					currPopup = LibraryLoader.createElement("mcInventoryPopup",0, 0);										
					break;	
				case "error":
					
					break;
			}
			addChild(currPopup);
			currPopup.setTrans(tManager, tData);
			currPopup.init();
		}
		
			
		private function onButtonPressed(evt:CustomEvent):void {
			//trace("ON BTN PRESSED: " + evt.oData.TARGETID);
			switch (evt.oData.TARGETID)
			{
				case "btn_roll":  
					displayPopup("confirmRoll");
					break;				
				case "btn_confirmYes":  
					advanceToRoll()
					//displayScreen("roll");
					//removeChild(currPopup);
					break;					
				case "btn_confirmNo":  
					removeChild(currPopup);
					break;						
				case "btn_toPrizePage":  
					advanceToClaim();
					//displayScreen("prize");
					//prizeScreen.setResult(evt.oData.VALUEID);
					//removeChild(currPopup);
					break;							
				case "btn_instructions":  
					displayScreen("instructions");
					break;						
				case "btn_back":  
					displayScreen("intro");
					break;							
				case "btn_purchase":  
					//btn_inventoryPurchase
					//trace("----> go to purchase screen");
					navigateToURL(new URLRequest("http://ncmall.neopets.com/mall/shop.phtml?page=&cat=99"),"_self");
					break;
				//case "btn_rollanim":  
					////trace("fakes a roll");
					//startRoll();
				//	break;									
				case "btn_claim_prize":  
					//trace("claim a prize(s)");
					displayPopup("confirmPrize")
					break;									
				case "btn_confirmPrizeYes":  
					removeChild(currPopup);
					claimPrize();
					break;					
				case "btn_confirmPrizeNo":  
					removeChild(currPopup);
					break;												
				case "btn_inventoryAgain":  
					removeChild(currPopup);
					hideScreenFunction();
					phpSetup();
					break;																					
				case "btn_inventoryPurchase":  
					//trace("----> go to purchase screen");
					navigateToURL(new URLRequest("http://ncmall.neopets.com/mall/shop.phtml?page=&cat=99"),"_self");
					break;									
			}	
		}
		
		private function claimPrize() {
			//trace("[Doc class] claimPrize 1");
			responder = new Responder(onClaimResult, onClaimFault);
			//trace("[Doc class] claimPrize 2");
			connection = new NetConnection;
			//trace("[Doc class] claimPrize 3");
			connection.connect(_host_url + gateway);
			//trace("[Doc class] claimPrize 4");
			var _params: Array = new Array();
			//trace("[Doc class] claimPrize 5 " + dData.rollID); 
			//connection.call("WheelService.spinWheel", responder, "2");
			if (dData.tier < 5) {				
				_params.push(dData.prize1oii);
			} else if (dData.tier==5) {
				_params.push(dData.prize1oii);
				_params.push(dData.prizeBoii);
			} else if (dData.tier==6) {
				_params.push(dData.prize1oii);
				_params.push(dData.prize2oii);
			}
			//trace("[Doc class] claimPrize 6 " + _params);
			connection.call("BlumarollService.claimPrize", responder, dData.rollID, _params);
			//trace("[Doc class] claimPrize 7");			
			hideScreenFunction();
		}
		
		private function onClaimResult(result:Object):void {
			//trace("****CLAIM RESULT");
			for (var i in result) {
				//trace("AMFPHP RESULT: " + i + " :: " + result[i]);
				for (var j in result[i]) {
					//trace("   AMFPHP RESULT: " + i + " :: " + j + " :: " + result[i][j]);
				}
			}
			displayPopup("inventory");
		}
		
		private function onClaimFault(result:Object):void {
			for (var i in result) {
				//trace("[FAULT - onClaim] ****AMFPHP RESULT: " + i + " :: " + result[i]);
			}
			//proceedThruStatusFault()
		}
		
//------------------------------------------------------------------------------------------------------------

		private function onErrorCall(evt:CustomEvent):void {
			//trace("CALL ERROR");
			displayError(tData.IDS_ERROR_MSG);
		}
		
		private function displayError(p_str:String=null):void {
			//trace("Display ERROR");
			currPopup = LibraryLoader.createElement("mcErrorPopup",0, 0);										
			addChild(currPopup)
			currPopup.setTrans(tManager, tData);
			currPopup.init();
			currPopup.setErrorMsg(p_str);
		}
		
			
		
		
	}
}