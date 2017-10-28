/**
 *	This class handles sending out ECards.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.ecard
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.net.Responder;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import com.neopets.util.servers.NeopetsServerFinder;
	
	public class ECardSender extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const INIT_TAB_INDEX:int = 1;
		public static const ECARD_RESULT:String = "ECard_result";
		public static const ECARD_FAULT:String = "ECard_fault";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// global variables
		public static var PROJECT_ID:String = "caprisun2010";
		// loacal variables
		protected var _senderNameField:TextField;
		protected var _targetNameField:TextField;
		protected var _targetEmailField:TextField;
		protected var _sendButton:InteractiveObject;
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ECardSender():void {
			super();
			// set up components
			senderNameField = getChildByName("sender_name_txt") as TextField;
			targetNameField = getChildByName("target_name_txt") as TextField;
			targetEmailField = getChildByName("target_email_txt") as TextField;
			sendButton = getChildByName("send_btn") as InteractiveObject;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// check our servers when added to stage
			addEventListener(Event.ADDED,onAdded);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get sendButton():InteractiveObject { return _sendButton; }
		
		public function set sendButton(btn:InteractiveObject) {
			// clear listeners
			if(_sendButton != null) {
				_sendButton.removeEventListener(MouseEvent.CLICK,onSendRequest);
				_sendButton.tabIndex = -1;
			}
			// set button
			_sendButton = btn;
			// set listeners
			if(_sendButton != null) {
				_sendButton.addEventListener(MouseEvent.CLICK,onSendRequest);
				_sendButton.tabIndex = INIT_TAB_INDEX + 3;
			}
		}
		
		public function get senderNameField():TextField { return _senderNameField; }
		
		public function set senderNameField(txt:TextField) {
			_senderNameField = txt;
			if(_senderNameField != null) {
				var tag:String = Parameters.userName;
				if(tag != null) _senderNameField.htmlText = tag;
				else _senderNameField.htmlText = "Guest";
				_senderNameField.tabIndex = INIT_TAB_INDEX;
			}
		}
		
		public function get targetNameField():TextField { return _targetNameField; }
		
		public function set targetNameField(txt:TextField) {
			_targetNameField = txt;
			if(_targetNameField != null) _targetNameField.tabIndex = INIT_TAB_INDEX + 1;
		}
		
		public function get targetEmailField():TextField { return _targetEmailField; }
		
		public function set targetEmailField(txt:TextField) {
			_targetEmailField = txt;
			if(_targetEmailField != null) _targetEmailField.tabIndex = INIT_TAB_INDEX + 2;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function sets up our server and amf-linkage when added to stage.
		
		protected function onAdded(ev:Event) {
			if(ev.target ==  this) {
				_servers = new NeopetsServerFinder(this);
				// set up communication with php
				_delegate = new AmfDelegate();
				_delegate.gatewayURL = _servers.scriptServer + "/amfphp/gateway.php";
				_delegate.connect();
				// remove listener
				removeEventListener(Event.ADDED,onAdded);
			}
		}
		
		/**
		 * Amf success for sendCard call
		*/
		public function onDataResult(msg:Object):void
		{
			trace("success: event: " + msg);
			dispatchEvent(new Event(ECARD_RESULT));
			broadcast(DestinationView.REPORTING_REQUEST,"Ecard");
			broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,16077);
			broadcast(DestinationView.SHOP_AWARD_REQUEST,"2");
		}
		
		/**
		 * Amf fault for sendCard call
		*/
		public function onDataFault(msg:Object):void
		{
			trace("fault: event: " + msg);
			dispatchEvent(new Event(ECARD_FAULT));
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordResult(msg:Object):void {
			trace("onRecordResult: " + msg);
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordFault(msg:Object):void {
			trace("onRecordFault: " + msg);
		}
		
		// This function handles sending the ecard info to php.
		
		public function onSendRequest(ev:Event) {
			// set up parameters
			// sendCard parameters: project_id, sender_name, rcpt_name, rcpt_email, extra
			var s_name:String;
			if(_senderNameField != null) s_name = _senderNameField.text;
			var t_name:String;
			if(_targetNameField != null) t_name = _targetNameField.text;
			var t_mail:String;
			if(_targetEmailField != null) t_mail = _targetEmailField.text;
			// call amf service
			var responder : Responder = new Responder(onDataResult, onDataFault);
			_delegate.callRemoteMethod("ECardService.sendCard",responder,PROJECT_ID,s_name,t_name,t_mail);
			// let php know we've taken a step to completing a task
			responder = new Responder(onRecordResult,onRecordFault);
			_delegate.callRemoteMethod("CapriSun2010Service.recordActivity",responder,"act9");
		}

	}
	
}