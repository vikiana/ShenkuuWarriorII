
package com.neopets.games.inhouse.wheels {
	// required for flash file and output display
	import flash.display.MovieClip;
	import fl.events.*;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.text.TextFormat;


	
	import virtualworlds.lang.ITranslationManager;
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationManagerInfo;	
	

	// Flash CS3 Document Class. 
	public class WheelClass extends MovieClip {
		
		private var _testmode: Boolean = false;
		
		private var gateway:String = "/amfphp/gateway.php";
		private var connection:NetConnection;
		private var responder:Responder;
		public var popup: MovieClip;
		private var prizePopup: MovieClip;
		
		private var _result_reply: String;
		private var _result_image: String;
		private var _result_type: Number;
		private var _result_name: String;
		private var _result_spinagain: Boolean;
		private var _result_reaction: Number;
		private var _result_spFunction: String;
		private var _result_spHtml: String;
		
		private var _numSlots: Number = 16;
		
		private var _host_url: String;
		private var _wheelID: String;
		
		private var _soundOn: Boolean = true;
		private var _soundBtn: MovieClip;
				
		private var tManager:ITranslationManager;
		private var tData:TranslationData;
		
		//The fisrt value refers to the content text file ID (file ID is the game ID); 
		//the second value is a fixed value.
		private var mGame_ID:int = 123;
		private var mType_ID:int = TranslationManagerInfo.TYPE_ID_CONTENT;
		private var mServerURLLive:String = "http://www.neopets.com/"
		private var mServerURLDev:String = "http://dev.neopets.com/"
		
		//The TranslationManager class includes all language codes as static constants.
		//We set it to spanish for this particular example
		public var lang:String = "EN";
		
		public var mcWheel: WheelClipClass;
		//public var btnSound: soundIcon;
		var checkTimer: Timer;
		
		
		
		
		public function WheelClass() {
			
			super();						
			
			
		}
		
		public function init() {
			var paramList:Object = this.root.loaderInfo.parameters;
			if (paramList["lang"] != null) {
				lang = paramList["lang"].toUpperCase();
				trace("the lang is: "+paramList["lang"]); 
			}
			if (paramList["host_url"] != null) {
				_host_url = "http://" + paramList["host_url"];				
			} else {
				_host_url = "http://dev.neopets.com";
			}
			trace("LANG = " + lang + ":" +TranslationManagerInfo.TRANSLATION_DONE);
			tManager = TranslationManager.instance;
			tData = new TranslationData ();
			//get the translation
			tManager.addEventListener (TranslationManagerInfo.TRANSLATION_DONE, onTranslationComplete);
			tManager.init(lang, mGame_ID, mType_ID, tData, _host_url + "/");			
		}
		
		private function onTranslationComplete (e:Event):void {
			trace("ON TRANS COMPLETE");
			tManager.removeEventListener (TranslationManagerInfo.TRANSLATION_DONE, onTranslationComplete);
			trace ("***TranslationData:"+tData);
			goWheel();
		}
		
		public function setWheel(p_wheel: WheelClipClass):void {
			mcWheel = p_wheel;
			mcWheel.cacheAsBitmap = true;
		}
		
		public function setWheelID(p_wheelID: String):void {
			_wheelID = p_wheelID;
		}
		
		public function setSlots(p_num: Number): void {
			_numSlots = p_num;
		}
		
		public function setTransID(p_num: Number): void {
			mGame_ID = p_num;
		}
		
		public function setSoundButton(p_btn:MovieClip): void {
			_soundBtn = p_btn;
			_soundBtn.addEventListener(MouseEvent.CLICK, toggleSound);			
			_soundBtn.buttonMode = true;
		}
		
		public function setFlapper(p_flap: MovieClip): void {
			mcWheel.setFlapper(p_flap);
		}
		
		public function goWheel(): void {
			trace("GO WHEEL!");
			resetReaction();
			mcWheel.addEventListener(MouseEvent.CLICK, sendData);
			mcWheel.buttonMode = true;
			mcWheel.init(_numSlots);
			responder = new Responder(onResult, onFault);
			connection = new NetConnection;
			connection.connect(_host_url + gateway);
			popup = new popup1();
			this.addChild(popup);
			//set text format
			var tFormat:TextFormat = new TextFormat ();
			tFormat.color = "0x000000";
			tFormat.align = "center";
			var textVar = tData.IDS_INTROMESSAGE;						
			trace("TEXTVAR = " + textVar);
			tManager.setTextField(popup.txt, textVar, null, tFormat);
			popupPositioner();
		}
		
		
	
		// Method run when the "Send To Server" button is clicked. 
		public function sendData(e:MouseEvent):void {
			trace("Sending Data to AMFPHP");
			mcWheel.removeEventListener(MouseEvent.CLICK, sendData);
			mcWheel.buttonMode = false;
			// Get the data from the input field
			var _params = _wheelID;
			// Send the data to the remote server. 
			trace("PARAMS = " + _params);
			connection.call("WheelService.spinWheel", responder, _params);
			mcWheel.addEventListener( mcWheel.WHEEL_STOP, onWheelStop );
			// the following lines start a timer... if there's an uncaught error or no response from the backend in 8 seconds, display default error message.
			checkTimer = new Timer(8000,1);
			checkTimer.addEventListener(TimerEvent.TIMER, onTimeOut);
			checkTimer.start();
			mcWheel.startSpin();
			removeChild(popup);			
			ExternalInterface.call("NEOADS.resetTimers");

		}
		
		public function onTimeOut(e:TimerEvent):void {
			trace("ON TIMEOUT");
			checkTimer.removeEventListener(TimerEvent.TIMER, onTimeOut);
			popup = new popup1();
			this.addChild(popup);
			var tFormat:TextFormat = new TextFormat ();
			tFormat.color = "0x000000";
			tFormat.align = "center";
			tManager.setTextField(popup.txt, tData.IDS_ERRORMESSAGE, null, tFormat);
			negativeReaction();
			popupPositioner();
		}
		
		// Method run when the "Fault Server" button is pressed. 
		public function faultServer(e:MouseEvent):void {
			trace("Faulting AMFPHP");
			// Make a call to a service that does not exist. 
			connection.call("BadClass.noMethod", responder, "no paramaters");
		}
		
		// Handle a successful AMF call. This method is defined by the responder. 
		private function onResult(result:Object):void {
			checkTimer.removeEventListener(TimerEvent.TIMER, onTimeOut);
			if (result.error && !_testmode) {
				trace("ERROR!" + result.error);
				trace("ERROR: " + result.errmsg);
				onReturnError(result.error, result.errmsg);
			} else {
				trace("RESULT ERROR= " + result.error);			
				trace("RESULT SLOT= " + result.slot);			
				trace("RESULT REPLY= " + result.reply);			
				trace("RESULT REACTION= " + result.reaction);			
				trace("RESULT SPINAGAIN= " + result.spinagain);			
				if (result.superPrizeFunction != undefined) {
					trace("RESULT SUPERPRIZEFUNCTION = " + result.superPrizeFunction);
					trace("RESULT SUPERPRIZEHTML = " + result.superPrizeHTML);
				} else {
					trace("RESULT: NO SUPERPRIZE");
				}				
				//trace("RESULT PRIZE.type= " + result.prize.type);
				//trace("RESULT PRIZE.name= " + result.prize.name);
				//trace("RESULT PRIZE.url= " + result.prize.url);
				_result_reply = result.reply;
				_result_reaction = result.reaction;
				_result_spinagain = result.spinagain;
				_result_spFunction = result.superPrizeFunction;				
				_result_spHtml = result.superPrizeHTML;
				trace("  -  RESULT SUPERPRIZEFUNCTION = " + _result_spFunction);
				trace("  -  RESULT SUPERPRIZEHTML = " + _result_spHtml);
				//_result_image = result.prize.url;
				//_result_type = result.prize.type;
				//_result_name = result.prize.name;
				mcWheel.setSpin(result.slot);
			}
		}
		
		// Handle an unsuccessfull AMF call. This is method is dedined by the responder. 
		public function onFault(fault:Object):void {
			//response_txt.text = String(fault.description);
			trace("ON FAULT");
			popup = new popup1();
			this.addChild(popup);
			var tFormat:TextFormat = new TextFormat ();
			tFormat.color = "0x000000";
			tFormat.align = "center";
			tManager.setTextField(popup.txt, tData.IDS_ERRORMESSAGE, null, tFormat);
			popupPositioner();
		}
		
		public function onReturnError(p_error: Number, p_msg: String) {
			popup = new popup1();
			this.addChild(popup);
			var tFormat:TextFormat = new TextFormat ();
			tFormat.color = "0x000000";
			tFormat.align = "center";
			var tText: String = p_msg;
			trace("MSG = " + tText);
			tManager.setTextField(popup.txt, tText, null, tFormat);			
			popupPositioner();			
			negativeReaction();
		}
		
		private function onWheelStop(evt: Event)  {
			trace("ON WHEEL STOP");
			popup = new popup1();
			this.addChild(popup);
			//popup.txt.htmlText = "Click to reveal your prize!";						
			this.addEventListener(MouseEvent.CLICK, onPrizeDisplay);			
			//set text format
			var tFormat:TextFormat = new TextFormat ();
			tFormat.color = "0x000000";
			tFormat.align = "center";
			//set the variable to assign to the text field
			var textVar = tData.IDS_STOPMESSAGE;						
			trace("TEXTVAR = " + textVar);
			//Set and format the text field: you can use the third parameter to change the font, but the font will have to be already embedded in at least one textField on the game.
			tManager.setTextField(popup.txt, textVar, null, tFormat);
			switch (_result_reaction) {
				case 1: positiveReaction(); break;
				case 2: negativeReaction(); break;
				case 3: neutralReaction(); break;
			}
			popupPositioner();
		}
		
		
		
		private function onPrizeDisplay(evt: Event)  {
			removeEventListener(MouseEvent.CLICK, onPrizeDisplay);
			trace("ON WHEEL STOP");
			prizePopup = new popup2();
			this.addChild(prizePopup);
			tManager.setTextField(prizePopup.txt, _result_reply);			
			prizePopup.xbutton.buttonMode = true;
			prizePopup.xbutton.addEventListener(MouseEvent.CLICK, closePrizeDisplay);			
			if (_result_spinagain) {
				prizePopup.addEventListener(MouseEvent.CLICK, closePrizeDisplay);			
			}
			this.removeChild(popup);			
			if (_result_spFunction != null) {
				ExternalInterface.call(_result_spFunction, _result_spHtml);
			}
			//tManager.setTextField(prizePopup.txt2, _result_name);
			/*// Set properties on my Loader object
			var imageLoader = new Loader();
			imageLoader.load(new URLRequest(_result_image));
			imageLoader.x = 482;
			imageLoader.y = 111;
			//imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
			//imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			prizePopup.addChild(imageLoader);*/
			
		}
		
		private function closePrizeDisplay(evt: Event)  {
			prizePopup.removeEventListener(MouseEvent.CLICK, closePrizeDisplay);			
			prizePopup.xbutton.removeEventListener(MouseEvent.CLICK, closePrizeDisplay);			
			this.removeChild(prizePopup);
			if (_result_spinagain) {
				goWheel();
			} else {
				closingMessage();
			}
			
		}
		
		private function closingMessage():void {
			popup = new popup1();
			this.addChild(popup);
			//set text format
			var tFormat:TextFormat = new TextFormat ();
			tFormat.color = "0x000000";
			tFormat.align = "center";
			var textVar = tData.IDS_CLOSINGMESSAGE;						
			trace("TEXTVAR = " + textVar);
			tManager.setTextField(popup.txt, textVar, null, tFormat);
			popupPositioner();
		}
		
		
		public function toggleSound(e:MouseEvent):void {
			if (_soundOn) {
				_soundOn = false;
				e.target.gotoAndStop(2);
			} else {
				_soundOn = true;
				e.target.gotoAndStop(1);
			}
			mcWheel.setSound(_soundOn);
		}
		
		public function positiveReaction() {
			trace("PLACEHOLDER POSITIVE REACTION");
		}
		
		public function negativeReaction() {
			trace("PLACEHOLDER NEGATIVE REACTION");
		}
		
		public function neutralReaction() {
			trace("PLACEHOLDER NEGATIVE REACTION");
		}
		
		public function resetReaction() {
			trace("PLACEHOLDER RESET REACTION");
		}
		
		public function popupPositioner() {		
			trace("PLACEHOLDER POPUP POSITIONER");
		}
		
		
	}
}