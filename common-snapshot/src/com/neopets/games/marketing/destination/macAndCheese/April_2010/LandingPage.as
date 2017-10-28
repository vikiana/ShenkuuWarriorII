/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010
{
	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	import com.neopets.marketing.collectorsCase.DebugTracer;
	
	import com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets.countdown.CountDownDisplay;
	import com.neopets.util.servers.NeopetsServerFinder;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.ListPane;
	
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	/**
	 *	This class handle the teaser swf.  It mostly just sets up flash var defaults.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  3.23.2010
	 */
	public class LandingPage extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const HUNT_STATUS_RESULT:String = "huntStatus_Result";
		public static const CLAIM_PRIZE:String = "claimPrize";
		public static const REDIRECT_URL:String = "redirectURL";
		public static const FINAL_PIECE_ID:int = 15;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _instructionsButton:InteractiveObject;
		protected var _linkButton:InteractiveObject;
		protected var _aboutButton:InteractiveObject;
		protected var _altadorButton:InteractiveObject;
		protected var _popUpClip:MovieClip;
		protected var _translationData:LandingPageTranslation;
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		protected var _userLoggedIn:Boolean;
		protected var _huntStatus:Object; // retrieved with amf-php call
		protected var _prizeList:Array; // extracted from hashmap in huntstatus
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LandingPage():void{
			super();
			//DebugTracer.addTextfieldTo(this,800,600); // add in to enable debug overlay
			_servers = new NeopetsServerFinder(this);
			// check flash vars
			FlashVarManager.setDefault(CountDownDisplay.DAYS_LEFT,3);
			FlashVarManager.setDefault(REDIRECT_URL,_servers.scriptServer + "/loginpage.phtml");
			FlashVarManager.initVars(root);
			// set up text data
			_translationData = new LandingPageTranslation();
			// set up default component linkages
			_popUpClip = getChildByName("popup_mc") as MovieClip;
			instructionsButton = getChildByName("instructions_btn") as InteractiveObject;
			linkButton = getChildByName("link_btn") as InteractiveObject;
			aboutButton = getChildByName("about_btn") as InteractiveObject;
			altadorButton = getChildByName("altador_btn") as InteractiveObject;
			// set up communication with php
			_delegate = new AmfDelegate();
			_delegate.gatewayURL = _servers.scriptServer + "/amfphp/gateway.php";
		    _delegate.connect();
			// get user data
			_prizeList = new Array();
			var responder : Responder = new Responder(onDataResult, onDataFault);
			_delegate.callRemoteMethod("MacAndCheese2010Service.huntStatus",responder);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get aboutButton():InteractiveObject { return _aboutButton; }
		
		public function set aboutButton(btn:InteractiveObject) {
			// clear previous listeners
			if(_aboutButton != null) {
				_aboutButton.removeEventListener(MouseEvent.CLICK,onAboutRequest);
			}
			// set up new button
			_aboutButton = btn;
			if(_aboutButton != null) {
				_aboutButton.addEventListener(MouseEvent.CLICK,onAboutRequest);
				if(_aboutButton is Sprite) Sprite(_aboutButton).buttonMode = true;
			}
		}
		
		public function get altadorButton():InteractiveObject { return _altadorButton; }
		
		public function set altadorButton(btn:InteractiveObject) {
			// clear previous listeners
			if(_altadorButton != null) {
				_altadorButton.removeEventListener(MouseEvent.CLICK,onAltadorClick);
			}
			// set up new button
			_altadorButton = btn;
			if(_altadorButton != null) {
				_altadorButton.addEventListener(MouseEvent.CLICK,onAltadorClick);
				if(_altadorButton is Sprite) Sprite(_altadorButton).buttonMode = true;
			}
		}
		
		public function get huntStatus():Object { return _huntStatus; }
		
		public function set huntStatus(info:Object) {
			_huntStatus = info;
			// wipe previous prize list
			while(_prizeList.length > 0) _prizeList.pop();
			// extract prizes into array
			if(_huntStatus != null) {
				var prizes:Object = _huntStatus["prizes"];
				if(prizes != null) {
					var val:int;
					for(var i in prizes) {
						val = int(prizes[i]);
						if(!isNaN(val)) _prizeList.push(val);
					}
				}
			}
			showPrize();
		}
		
		public function get instructionsButton():InteractiveObject { return _instructionsButton; }
		
		public function set instructionsButton(btn:InteractiveObject) {
			// clear previous listeners
			if(_instructionsButton != null) {
				_instructionsButton.removeEventListener(MouseEvent.CLICK,onInstructionRequest);
			}
			// set up new button
			_instructionsButton = btn;
			if(instructionsButton != null) {
				_instructionsButton.addEventListener(MouseEvent.CLICK,onInstructionRequest);
				if(_instructionsButton is Sprite) Sprite(_instructionsButton).buttonMode = true;
			}
		}
		
		public function get linkButton():InteractiveObject { return _linkButton; }
		
		public function set linkButton(btn:InteractiveObject) {
			// clear previous listeners
			if(_linkButton != null) {
				_linkButton.removeEventListener(MouseEvent.CLICK,onLinkRequest);
			}
			// set up new button
			_linkButton = btn;
			if(linkButton != null) {
				_linkButton.addEventListener(MouseEvent.CLICK,onLinkRequest);
				if(_linkButton is Sprite) Sprite(_linkButton).buttonMode = true;
			}
		}
		
		public function get translationData():LandingPageTranslation { return _translationData; }
		
		public function get userLoggedIn():Boolean { return _userLoggedIn; }
		
		public function set userLoggedIn(bool:Boolean) {
			_userLoggedIn = bool;
			// if we're not logged in let the user know
			if(_userLoggedIn) {
				if(_popUpClip != null) _popUpClip.locked = false;
			} else {
				if(_popUpClip != null) {
					// insert script server in login url
					var popup_text:String = _translationData.loggedOutText;
					var login_url:String = FlashVarManager.getVar(REDIRECT_URL) as String;
					popup_text = popup_text.replace("%login",login_url);
					// show "please login" message
					_popUpClip.setText(_translationData.loggedOutHeader,popup_text);
					_popUpClip.locked = true;
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getPieceData(id:int):Object {
			if(_huntStatus == null) return null;
			var pieces:Object = _huntStatus["pieces"];
			if(pieces != null) {
				var piece:Object;
				for(var i in pieces) {
					piece = pieces[i];
					if(piece != null && piece["id"] == id) return piece;
				}
			}
			return null;
		}
		
		public function setPopUpText(header:String,body:String) {
			if(_popUpClip != null) _popUpClip.setText(header,body);
		}
		
		public function showPrize():void {
			if(_huntStatus == null) return;
			// get the prize list
			if(_prizeList.length > 0) {
				// retrieve the piece data
				var p_id:int = _prizeList[0];
				var p_data:Object = getPieceData(p_id);
				// convert the data to a pop-up message
				if(p_data != null) {
					if(_popUpClip != null) {
						// insert piece number in award text
						var txt_str:String;
						if(p_id != FINAL_PIECE_ID) {
							txt_str = _translationData.pieceFoundText1;
							//txt_str = txt_str.replace("%pn",p_id); // piece number no longer displayed
						} else txt_str = _translationData.finalPieceFoundText;
						// show piece found text
						_popUpClip.setText(_translationData.pieceFoundHeader,txt_str);
						_popUpClip.addText(_translationData.pieceFoundText2);
						// add prize image
						var item_url:String = p_data["item_url"] as String;
						_popUpClip.addImage(item_url);
						// add item name entry
						var item_name:String = p_data["item_name"] as String;
						if(item_name != null) _popUpClip.addText(item_name);
						// add "claim prize" link
						txt_str = _translationData.claimPrize;
						txt_str = txt_str.replace("%event","event:" + CLAIM_PRIZE + "_" + p_id);
						var txt:TextField = _popUpClip.addText(txt_str);
						if(txt != null) addEventListener(TextEvent.LINK,onClaimPrizeClick);
						// lock pop up until prize is claimed
						//_popUpClip.locked = true;
					}
				} // end of data check
			} // end of list check
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// AMF Events
		
		/**
		 * Amf success for getMonthList call
		*/
		public function onClaimResult(msg:Object):void
		{
			trace("success: event: " + msg);
			// try notifying the pop up system
			if(_popUpClip != null) {
				if(msg) {
					// check for prize data
					if(_prizeList.length > 0) {
						// retrieve the piece data
						var p_id:int = _prizeList.shift();
						var p_data:Object = getPieceData(p_id);
						// convert the data to a pop-up message
						var txt_str:String
						if(p_data != null) {
							// insert piece name and inventory url
							txt_str = _translationData.claimSuccessText;
							var item_name:String = p_data["item_name"] as String;
							var inv_url:String = _servers.scriptServer + "/objects.phtml?type=inventory";
							txt_str = txt_str.replace("%prize",item_name);
							txt_str = txt_str.replace("%url",inv_url);
							_popUpClip.setText(_translationData.claimSuccessHeader,txt_str);
							// push item image above text
							var item_url:String = p_data["item_url"] as String;
							_popUpClip.addImage(item_url,0);
						}
						// if there are still entries in the list
						if(_prizeList.length > 0) {
							txt_str = _translationData.anotherPrize;
							txt_str = txt_str.replace("%event","event:nextPrize");
							var txt:TextField = _popUpClip.addText(txt_str);
							if(txt != null) addEventListener(TextEvent.LINK,onNextPrizeRequest);
						}
					} // end of prize list check
				} else {
					_popUpClip.setText(_translationData.claimErrorHeader,_translationData.claimErrorText);
				} // end of msg check
			}
		}
		
		/**
		 * Amf fault for getMonthList call
		*/
		public function onClaimFault(msg:Object):void
		{
			trace("fault: event: " + msg);
		}
		
		/**
		 * Amf success for getMonthList call
		*/
		public function onDataResult(msg:Object):void
		{
			trace("success: event: " + msg);
			if(msg != null) {
				// skip log in check offline to ease testing
				if(_servers.isOnline) userLoggedIn = Boolean(msg["logged_in"]);
				huntStatus = msg;
			}
			var broadcast_event:Event = new CustomEvent(msg,HUNT_STATUS_RESULT);
			dispatchEvent(broadcast_event);
		}
		
		/**
		 * Amf fault for getMonthList call
		*/
		public function onDataFault(msg:Object):void
		{
			trace("fault: event: " + msg);
		}
		
		// Button Events
		
		protected function onAltadorClick(ev:Event) {
			var url:String = _servers.scriptServer + "/sponsors/altadoralley/macandcheese.phtml";
			var req:URLRequest = new URLRequest(url);
			navigateToURL(req);
		}
		
		protected function onAboutRequest(ev:Event) {
			setPopUpText(_translationData.aboutHeader,_translationData.aboutText);
		}
		
		protected function onInstructionRequest(ev:Event) {
			setPopUpText(_translationData.instructionHeader,_translationData.instructionText);
		}
		
		protected function onLinkRequest(ev:Event) {
			var url:String = _servers.scriptServer + "/process_click.phtml?item_id=15924";
			var req:URLRequest = new URLRequest(url);
			navigateToURL(req);
		}
		
		// Link Events
		
		protected function onClaimPrizeClick(ev:TextEvent) {
			var txt_params:Array = ev.text.split("_");
			if(txt_params.length > 1) {
				// make claim prize call
				var p_id:int = int(txt_params[1]);
				var responder : Responder = new Responder(onClaimResult, onClaimFault);
				_delegate.callRemoteMethod("MacAndCheese2010Service.claimPrize",responder,p_id);
			}
		}
		
		protected function onNextPrizeRequest(ev:TextEvent) {
			showPrize();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
