/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.despicableMe.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------/**/
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.flashvars.FlashVarManager;
	import virtualworlds.net.AmfDelegate;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	public class QuestPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const QUEST_STATUS_RESULT:String = "questService_getStatus_result";
		public static const QUEST_STATUS_FAULT:String = "questService_getStatus_fault";
		public static const CLAIM_PRIZE_REQUEST:String = "questService_claimPrize";
		public static const CLAIM_PRIZE_RESULT:String = "questService_claimPrize_result";
		public static const CLAIM_PRIZE_FAULT:String = "questService_claimPrize_fault";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _servers:NeopetsServerFinder;
		protected var _delegate:AmfDelegate;
		
		private var instructionsPop:InstructionsPopup = new InstructionsPopup;
		private var hintPop:HintPopup = new HintPopup;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// finish loading
			DisplayUtils.cacheImages(this);
			// dispatch tracking when shown by preloader
			addEventListener(DestinationView.SHOW,onShown);
			
			logo_mc.addEventListener(MouseEvent.CLICK, goToSite);
			logo_mc.addEventListener(MouseEvent.CLICK, logoTracking);
			logo_mc.buttonMode = true;
			
			instructions_mc.buttonMode = true;
			instructions_mc.text.mouseEnabled = false;
			instructions_mc.addEventListener(MouseEvent.MOUSE_DOWN, openPopup);
	
			back_mc.addEventListener(MouseEvent.CLICK, backMCTracking);
			
			//initGadgets();
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		public function get servers():NeopetsServerFinder { return _servers; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected function setupAMFPHP():void
		{
			_servers = new NeopetsServerFinder(this);
			// set up communication with php
			_delegate = new AmfDelegate();
			_delegate.gatewayURL = _servers.scriptServer + "/amfphp/gateway.php";
			_delegate.connect();
			
		}
		
		protected override function setupPage():void {
			// set up amf-php
			setupAMFPHP();
			// set up broadcast listeners
			addEventListener(CLAIM_PRIZE_REQUEST,onClaimRequest);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/*private function initGadgets():void
		{
			gadget_1.buttonMode = true;
			gadget_2.buttonMode = true;
			gadget_3.buttonMode = true;
			gadget_4.buttonMode = true;
			gadget_5.buttonMode = true;
			gadget_6.buttonMode = true;
			
			trace("Label: "+gadget_1.currentLabel);
				
				
			// TODO - the popups shouldn't appear if the tasks have been completed 
			// temporary solution - work on a better version later if time permits
			if(gadget_1.currentLabel == "unreleased" || gadget_1.currentLabel == "released")
			{
			 gadget_1.addEventListener(MouseEvent.ROLL_OVER, hintPopup);
			 gadget_1.addEventListener(MouseEvent.ROLL_OUT, removeHint);
			}
			
			if(gadget_2.currentLabel == "unreleased" || gadget_2.currentLabel == "released")
			{
			 gadget_2.addEventListener(MouseEvent.ROLL_OVER, hintPopup);
			 gadget_2.addEventListener(MouseEvent.ROLL_OUT, removeHint);
			}
			
			if(gadget_3.currentLabel == "unreleased" || gadget_3.currentLabel == "released")
			{
			 gadget_3.addEventListener(MouseEvent.ROLL_OVER, hintPopup);
			 gadget_3.addEventListener(MouseEvent.ROLL_OUT, removeHint);
			}
			
			if(gadget_4.currentLabel == "unreleased" || gadget_4.currentLabel == "released")
			{
			 gadget_4.addEventListener(MouseEvent.ROLL_OVER, hintPopup);
			 gadget_4.addEventListener(MouseEvent.ROLL_OUT, removeHint);
			}
			
			if(gadget_5.currentLabel == "unreleased" || gadget_5.currentLabel == "released")
			{
			 gadget_5.addEventListener(MouseEvent.ROLL_OVER, hintPopup);
			 gadget_5.addEventListener(MouseEvent.ROLL_OUT, removeHint);
			}
			
			if(gadget_6.currentLabel == "unreleased" || gadget_6.currentLabel == "released")
			{
			 gadget_6.addEventListener(MouseEvent.ROLL_OVER, hintPopup);
			 gadget_6.addEventListener(MouseEvent.ROLL_OUT, removeHint);
			}
			
		}*/
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Collection Quest','DespicableMe2010')");
				ExternalInterface.call("window.top.urchinTracker('DespicableMe2010/CollectionQuest')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
			// Metric tracking
			var rand:int = Math.floor(Math.random() * 1000000);
			var url:String = "http://ad.doubleclick.net/ad/N4518.Neopets/B4526503.23;sz=1x1;ord="+rand+"?";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			// dispatch tracking requests
			//req_event = new CustomEvent(16128,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			//dispatchEvent(req_event);
			
			// get quest status
			var responder : Responder = new Responder(onStatusResult, onStatusFault);
			_delegate.callRemoteMethod("DespicableMe2010Service.getStatus",responder);
		}
		
		// AMF Handlers
		
		// Use this function to try sending out a feed request to php.
		
		protected function onClaimRequest(ev:CustomEvent) {
			trace("sending claim request for prize " + ev.oData);
			var responder:Responder = new Responder(onClaimResult, onClaimFault);
			//VIV - old
			//_delegate.callRemoteMethod("DespicableMe2010Service.claimPrize",responder,ev.oData);
			//VIV - gets both prizes
			_delegate.callRemoteMethod("DespicableMe2010Service.claimPrize",responder);
		}
		
		/**
		 * Amf success for claimPrize call
		*/
		public function onClaimResult(msg:Object):void
		{
			trace("claimPrize success: " + msg);
			// broadcast status
			var transmission:CustomEvent = new CustomEvent(msg,CLAIM_PRIZE_RESULT);
			dispatchEvent(transmission);
		}
		
		/**
		 * Amf fault for claimPrize call
		*/
		public function onClaimFault(msg:Object):void
		{
			trace("claimPrize fault: " + msg);
			dispatchEvent(new Event(CLAIM_PRIZE_FAULT));
		}
		
		/**
		 * Amf success for getStatus call
		*/
		public function onStatusResult(msg:Object):void
		{
			trace("getStatus success: " + msg);
			// broadcast status
			var transmission:CustomEvent = new CustomEvent(msg,QUEST_STATUS_RESULT);
			dispatchEvent(transmission);
		}
		
		/**
		 * Amf fault for getStatus call
		*/
		public function onStatusFault(msg:Object):void
		{
			trace("getStatus fault: " + msg);
			dispatchEvent(new Event(QUEST_STATUS_FAULT));
		}
		
		private function goToSite(e:Event):void 
		{
			var req_event:CustomEvent = new CustomEvent(16255,DestinationView.NEOCONTENT_LINK_REQUEST);
			dispatchEvent(req_event);
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;225101386;48963468;p";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
		}
		private function backMCTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224982524;15177704;j?http://www.neopets.com/sponsors/despicableme/index.phtml";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
		}
		
		private function logoTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224982580;15177704;l?http://www.despicable.me/";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Destination Collection Quest to Despicable.Me Microsite')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
			
		}
		
		private function openPopup(e:MouseEvent):void
		{
			//trace('open popup');
			addChild(instructionsPop);
			instructionsPop.x = 50;
			instructionsPop.y = 50;
			instructionsPop.close_btn.addEventListener(MouseEvent.MOUSE_DOWN, closePopup);
		}
		
		private function closePopup(e:MouseEvent):void
		{
			//trace('close popup');
			removeChild(instructionsPop);
		}
	
		
	
		private function hintPopup(e:MouseEvent):void
		{
			// set up a boolean to see if they've already found the gadget - only show popup if it hasn't been found?
			// if(!gadgetFound)
			addChild(hintPop);
			hintPop.x = 150;
			hintPop.y = 150;
			
			switch(e.target.name)
			{
				
				// Fast Eye game - g1222
				case "gadget_1":
					 hintPop.hint_txt.text = "Having minions is great, isn't it? Just remember to keep a close eye on them...";
					 break;
				
				// Break In Game - g1220
				case "gadget_2":
					hintPop.hint_txt.text = "Now that you have some minions, it's time to break them in a bit. Maybe have them do your dirty work for you?";
					break;
				
				// Video Gallery
				case "gadget_3":
					hintPop.hint_txt.text = "If you can't believe your eyes at first, look again!";
					break;
				
				// Feed a Pet
				case "gadget_4":
					hintPop.hint_txt.text = "Never try to make plans to steal the moon on an empty stomach.";
					break;
				
				// Client Website
				case "gadget_5":
					hintPop.hint_txt.text = "A mad genius's lab is his castle, so why not take a closer look around?";
					break;
				
				//Image Gallery
				case "gadget_6":
					hintPop.hint_txt.text = "Look out! You never know when you'll be caught on camera!";
					break;
				
				default:
					trace ("hintPopup() error");
				
			}
				
		}
		
		private function removeHint(e:MouseEvent):void
		{
			if(hintPop != null)
			{
			  removeChild(hintPop);	
			}
		}
		
		
		
	}
	
}