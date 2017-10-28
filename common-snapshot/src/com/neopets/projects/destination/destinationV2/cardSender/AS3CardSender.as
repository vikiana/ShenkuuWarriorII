/**
 *	AS3 Challenge Card for Neopets Gaming System
 *	Version 1.0
 *	Author: Koh Peng Chuan
 *	Date: 29 September 2008
 *
 *	MODIFIED BY: Abraham Lee
 *	@playerversion Flash 9.0 
 *	@since  06.01.2009
 *	
 *	@NOTE:	Made minimal change possible to make greeding card to work.
 *			Main changes are:
 *			1. CCARDSEND_URL
 *			2. _profile_data.picid = "1399";
 *			3. _profile_data.sendemail = "support@neopets.com"
 *			4. sendCCardRequest function to form a correct url request string
 *		
 **/



package com.neopets.games.marketing.destination.kidCuisine.challengeCard {
		
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import com.neopets.projects.destination.destinationV2.NeoTracker

	
	public class AS3CardSender extends MovieClip {
		
		private const VERSION:String = "v1.0";
		private const PROFILE_URL:String = "http://www.neopets.com/high_scores/fg_get_info.phtml?&type=8;9&game_id=";
		private const CCARDSEND_URL:String = "/process_sendgreeting.phtml"
		private const NEOCONTENT_URL_NOREDIRECT:String = "http://www.neopets.com/process_click.phtml?noredirect=1&item_id=";
		
		// Text variables required in the Challenge Card. Assign new values to them before calling init();
		public var IDS_CCARD_TITLE:String = "<b>CHALLENGE CARD</b>";
		public var IDS_MESSAGE:String = "<font size='14'>Think you are the best scavenger in space? Challenge your friends to give you a run for your money! Fill out the fields below and get your friends hunting, too!</font>";
		public var IDS_SENDER_NAME:String = "<b>SENDER NAME</b>";
		public var IDS_SENDER_EMAIL:String = "<b>SENDER EMAIL</b>";
		public var IDS_RECEIPIENT_NAME:String = "<b>RECEIPIENT NAME</b>";
		public var IDS_RECEIPIENT_EMAIL:String = "<b>RECEIPIENT EMAIL</b>";
		public var IDS_SEND_TXT:String = "<b>Send</b>";
		public var IDS_CANCEL_TXT:String = "<b>Cancel</b>";
		public var IDS_OK_TXT:String = "<b>Ok</b>";
		public var IDS_PROCESSING_TXT:String = "Processing...";
		public var IDS_SENDSUCCESS_TXT:String = "Send Successful!";
		public var IDS_SENDFAILURE_TXT:String = "Sending Failed.";
		
		// if a value is given, the neocontent tracker will be triggered when Send is clicked, and returned successful
		public var NEOCONTENT_ID:String = "";
		
		// internal variables
		private var _GAMINGSYSTEM:Object;
		private var _myparent:Object;
		private var _myx:int;
		private var _myy:int;
		private var _under13:Boolean;
		private var _req:URLRequest;
		private var _loader:URLLoader;
				
		private const REQUEST_PROFILE:int = 0;
		private const REQUEST_CCARD:int = 1;
		private var _request_state:int;
		
		private var _profile_data:Object;
		private var _initiated:Boolean;
		
		public function AS3CardSender():void {
			_profile_data = new Object();
			_profile_data.gameid = "";
			_profile_data.picid = "1399";		//hard coded since it's project particular
			_profile_data.sendemail = "support@neopets.com"	//it's hardcoded user can't change this info.
			
			_req = new URLRequest();
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, requestCompleteHandler, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
		}
		
		//////////////// Initializer ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Run this after instantiation and assigning new values to IDS text variables
		// @p_obj - pass in "this" from main timeline, usually refers to the GameControl class
		// @p_gameid - Game ID
		// @p_score - Score obtained by the player; Challenge card will be inactive if score = 0
		// @p_x - x coordinate of challenge card (see reference point)
		// @p_y - y coordinate of challenge card (see reference point)
		// @p_under13 - under 13 flag; Apparantly not used anymore. Sent Challenge card email does not include sender's email anymore
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function init(p_obj:Object, p_x:int = 0, p_y:int = 0, p_under13:Boolean = false, p_gameid:int= 999, p_score:int = 1):void {
			if (p_score > 0) {
				_myparent = p_obj;
				try {
					_GAMINGSYSTEM = _myparent.getGamingSystem();
				} catch (e:Error) {}
				_myx = p_x;
				_myy = p_y;
				_under13 = p_under13;
				GAMEID = p_gameid;
				SCORE = p_score;
				addEventListener(Event.ENTER_FRAME, checkInit, false, 0, true);
			} else {
				output("Score = 0");
			}
		}
		
		private function initOK():Boolean { // checks if all display objects are initialized and ready for referencing
			var i:int = 0;
			while (i < numChildren) {
				if (!getChildAt(i)) return false;
				i ++;
			}
			return true;
		}		
		
		private function checkInit(e:Event):void { // check poller
			_initiated = initOK();
			if (_initiated) {
				removeEventListener(Event.ENTER_FRAME, checkInit);
				output("Initiated");
				sendInfoRequest();
				processingmc.visible = false;
				_myparent.addChild(this);
				x = _myx;
				y = _myy;
				buttonAssignments();
				textAssignment();
			}
		}
		
		public function set GAMEID(p_val:int):void {_profile_data.gameid = p_val.toString();}
		public function set SCORE(p_val:int):void {_profile_data.gamescore = p_val.toString();}
		
		private function buttonAssignments():void { // assigns functions to all buttons
			//blocker.addEventListener(MouseEvent.CLICK, idleHandler, false, 0, true);
			//blocker.tabEnabled = false;
			//blocker.useHandCursor = false;
			close_btn.addEventListener(MouseEvent.CLICK, closeBtnHandler, false, 0, true);
			interfacebuttons.send_btn.addEventListener(MouseEvent.CLICK, sendBtnHandler, false, 0, true);
			interfacebuttons.cancel_btn.addEventListener(MouseEvent.CLICK, closeBtnHandler, false, 0, true);
			processingmc.ok_btn.addEventListener(MouseEvent.CLICK, okHandler, false, 0, true);
			interfacebuttons.send_btn.tabEnabled = false;
			interfacebuttons.cancel_btn.tabEnabled = false;
			processingmc.ok_btn.tabEnabled = false;
			close_btn.tabEnabled = false;
		}
		
		private function sendInfoRequest():void { // requests for user profile
			if (_profile_data.gameid != "") {
				_request_state = REQUEST_PROFILE;
				_req.url = PROFILE_URL + _profile_data.gameid;
				_req.method = URLRequestMethod.POST;
				_loader.load(_req);
				output("Sending Profile Request");
			}
		}
		
		private function sendCCardRequest():void { // sends the challenge card request
			if (dataIsComplete()) {
				_request_state = REQUEST_CCARD;
				var sVars:String = "?";
				sVars += "flash=1";
				sVars += "&sender_name=" + escape(String(_profile_data.sendname));
				sVars += "&sender_email=" + escape(String(_profile_data.sendemail));
				sVars += "&recipient_name=" + escape(String(_profile_data.toname));
				sVars += "&recipient_email=" + escape(String(_profile_data.toemail));
				sVars += "&picture_id=" + escape (String(_profile_data.picid));
				
				output("Sending Challenge Card Request: sVars - " + sVars);
				
				_req.url = CCARDSEND_URL + sVars;
				_req.method = URLRequestMethod.POST;
				
				trace ("request url \n", _req.url)
				NeoTracker.sendTrackerID(14570);
				_loader.load(_req);
			} else {
				processingmc.visible = false;
				inputmc.visible = true;
				interfacebuttons.visible = true;
				output("Data is incomplete. Send request failed.");
			}
		}
		
		private function dataIsComplete():Boolean { // checks if all data is valid. nothing complex here
			_profile_data.sendname = inputmc.sendname_input.text;
			//_profile_data.sendemail = inputmc.sendemail_input.text;
			_profile_data.toname = inputmc.toname_input.text;
			_profile_data.toemail = inputmc.toemail_input.text;
			
			if ((!_profile_data.picid) || (_profile_data.picid == "")) return false;
			if ((!_profile_data.sendname)|| (_profile_data.sendname == "")) return false;
			if ((!_profile_data.sendemail) || (_profile_data.sendemail == "")) return false;
			if ((!_profile_data.toname) || (_profile_data.toname == "")) return false;
			if ((!_profile_data.toemail) || (_profile_data.toemail == "")) return false;
			
			return true;
		}
		
		private function requestCompleteHandler(e:Event):void { // complete handler for load() function
			switch (_request_state) {
				case REQUEST_PROFILE:
													processProfileData(e.target.data);
													break;
				case REQUEST_CCARD:
													processChallengeCardData(e.target.data);
													break;
			}
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {output("Security Error: " + e);}
		
		private function processProfileData(p_data:Object):void { // processes retrieved user name and email, then display on appropriate fields
			output("Profile received");
			var aResult:Array = String(p_data).split("&");
			var aVars:Array = new Array();
			for (var i:int = 0; i < aResult.length; i ++) {
				var aPair:Array = aResult[i].split("=");
				aVars[aPair[0]] = aPair[1];
				output("DATA: " + aPair[0] + " = " + aVars[aPair[0]]);
			}
			populateFields(aVars);
		}
		
		private function populateFields(p_vars:Array):void {
			if (p_vars["username"]) inputmc.sendname_input.text = p_vars["username"];
			if (!_under13) {
				if (p_vars["user_email"]) inputmc.sendemail_input.text = p_vars["user_email"];
			} else {
				inputmc.sendemail_txt.visible = false;
				inputmc.sendemail_input.visible = false;
			}
		}
		
		private function processChallengeCardData(p_data:Object):void { // processes data retrieved from challenge card send request
			output("Send Successful");
			var aResult:Array = String(p_data).split("&");
			var aVars:Array = new Array();
			for (var i:int = 0; i < aResult.length; i ++) {
				var aPair:Array = aResult[i].split("=");
				aVars[aPair[0]] = aPair[1];
				output("DATA: " + aPair[0] + " = " + aVars[aPair[0]]);
			}
			if ((aVars["success_str"] == "1") && (aVars["error_str"] == "Your+submission+was+successful%21")) 
			{
				setText(processingmc.processing_txt, IDS_SENDSUCCESS_TXT);
				NeocontentTracker();
			} else {
				setText(processingmc.processing_txt, IDS_SENDFAILURE_TXT);
			}
			processingmc.runningdots.visible = false;
			processingmc.ok_txt.visible = true;
			processingmc.ok_btn.visible = true;
			processingmc.visible = true;
		}
		
		private function output(p_out:*):void {trace("[AS3ChallengeCard " + VERSION + "] - " + p_out.toString());}
		
		private function closeBtnHandler(e:MouseEvent):void {
			close_btn.removeEventListener(MouseEvent.CLICK, closeBtnHandler);
			interfacebuttons.cancel_btn.removeEventListener(MouseEvent.CLICK, closeBtnHandler);
			destructor();
		}
		
		private function sendBtnHandler(e:MouseEvent):void {
			inputmc.visible = false;
			interfacebuttons.visible = false;
			setText(processingmc.processing_txt, IDS_PROCESSING_TXT);
			processingmc.runningdots.visible = true;
			processingmc.ok_txt.visible = false;
			processingmc.ok_btn.visible = false;
			processingmc.visible = true;
			sendCCardRequest();
		}
		
		private function okHandler(e:MouseEvent):void {
			processingmc.visible = false;
			setText(processingmc.processing_txt, "");
			processingmc.runningdots.visible = true;
			inputmc.visible = true;
			interfacebuttons.visible = true;
		}
		
		private function idleHandler(e:MouseEvent):void {} // do nothing. for background to prevent clicks on main menu
		
		private function textAssignment():void {
			setText(cc_txt, IDS_CCARD_TITLE);
			setText(inputmc.message_txt, IDS_MESSAGE);
			setText(inputmc.sendname_txt, IDS_SENDER_NAME);
			setText(inputmc.sendemail_txt, IDS_SENDER_EMAIL);
			setText(inputmc.toname_txt, IDS_RECEIPIENT_NAME);
			setText(inputmc.toemail_txt, IDS_RECEIPIENT_EMAIL);
			setText(interfacebuttons.send_txt, IDS_SEND_TXT);
			setText(interfacebuttons.cancel_txt, IDS_CANCEL_TXT);
			setText(processingmc.ok_txt, IDS_OK_TXT);
			
			inputmc.sendname_input.tabIndex = 0;
			inputmc.sendemail_input.tabIndex = 1;
			inputmc.toname_input.tabIndex = 2;
			inputmc.toemail_input.tabIndex = 3;
		}
		
		private function NeocontentTracker():void { // sends request to neocontent
			if (NEOCONTENT_ID != "") {
				var req:URLRequest = new URLRequest(NEOCONTENT_URL_NOREDIRECT + NEOCONTENT_ID);
				var lv:URLLoader = new URLLoader();
				lv.addEventListener(Event.COMPLETE, onNeocontentTracker, false, 0, true);
				try {
					lv.load(req);
				} catch (e:Error) {
				}
			}
		}
		
		private function onNeocontentTracker(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, onNeocontentTracker);
		}
		
		private function setText(p_tf:TextField, p_txt:String):void {
			p_tf.tabEnabled = false
			p_tf.mouseEnabled = false;
			p_tf.x = int(p_tf.x);
			p_tf.y = int(p_tf.y);
			if (_GAMINGSYSTEM) { // if gaming system is found
				_GAMINGSYSTEM.setTextField(p_tf, p_txt);
			} else { // DIY
				p_tf.htmlText = p_txt;
			}
		}
		
		public function destructor():void {
			if (_myparent) _myparent.removeChild(this);
			if (!_initiated) {
				removeEventListener(Event.ENTER_FRAME, checkInit);
			}
			_req.url = null;
			try {
				_loader.close();
			} catch (e:Error) {}
			processingmc.ok_btn.removeEventListener(MouseEvent.CLICK, okHandler);
			_loader.removeEventListener(Event.COMPLETE, requestCompleteHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//blocker.removeEventListener(MouseEvent.CLICK, idleHandler);
			output("Destroyed");
		}
	}
}
