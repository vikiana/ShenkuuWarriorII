/**
 *	This class handles the first page users should see on entering the destination.
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.despicableMe.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.despicableMe.DestinationControl;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.sound.SoundObj;
	import com.neopets.util.support.BaseObject;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.*;
	import flash.net.*;
	import flash.net.SharedObject;
	import flash.external.ExternalInterface;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class LandingPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var aboutPop:AboutPopup = new AboutPopup;
		public var songPlaying:Boolean;
		public var musicEnabled:Boolean;
		public var allAudioOn:Boolean;
		protected var delegate:AmfDelegate;
		
		// Sound
		private var mSoundManager = SoundManager.instance;
		public static const THEME_SONG:String = "ThemeSong";
		public static const BTN_SOUND:String = "BtnSound";
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LandingPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage();
			
			// Sound
			loadAudio();
			//playThemeSong(); 	// moved into "onShown" event
		    musicToggleBtn.addEventListener(MouseEvent.CLICK, toggleThemeSong,false,0,true);
			soundToggleBtn.addEventListener(MouseEvent.CLICK, toggleAllSounds,false,0,true);
			
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// finish loading
			DisplayUtils.cacheImages(this);
			
			// temporary simple version - use Dave's BasicPopUp class later?
			logo_mc.buttonMode = true;
			logo_mc.addEventListener(MouseEvent.MOUSE_DOWN, openPopup);
			logo_mc.addEventListener(MouseEvent.MOUSE_DOWN, processTracking);
			
			/*breakInGame_mc.addEventListener(MouseEvent.CLICK, goToGameOne);
			breakInGame_mc.buttonMode = true;
			
			breakInGame_mc.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			breakInGame_mc.addEventListener(MouseEvent.ROLL_OUT, rollOut);*/
			
			minionGame_mc.addEventListener(MouseEvent.CLICK, goToGameTwo);
			minionGame_mc.buttonMode = true;
			
			minionGame_mc.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			minionGame_mc.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			//Other rollovers
			feedPet_mc.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			feedPet_mc.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			//gru_mc.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			//gru_mc.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			gallery_mc.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			gallery_mc.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			trailer_mc.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			trailer_mc.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			trailer_mc.addEventListener(MouseEvent.CLICK,  turnOffTheme);
			
			trailer_mc.buttonMode = true;
			musicToggleBtn.buttonMode = true;
			
			// dispatch tracking when shown by preloader
			this.addEventListener(DestinationView.SHOW,onShown);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void {
			// set up amf delegate for quest notifications
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function loadAudio():void
		{
			mSoundManager.loadSound(THEME_SONG,SoundObj.TYPE_INTERNAL);	
			mSoundManager.loadSound(BTN_SOUND,SoundObj.TYPE_INTERNAL);
			allAudioOn = true;
			musicEnabled = true;
		}
		
		private function playThemeSong():void
		{
			if(musicEnabled) {
				mSoundManager.soundPlay(LandingPage.THEME_SONG,true);
				songPlaying = true;
			}
		}
		
		// Theme song
		private function toggleThemeSong(evt:MouseEvent):void
		{
			if(songPlaying)
			{
				mSoundManager.stopSound(LandingPage.THEME_SONG); 
				songPlaying = false;
				musicEnabled = false;
				musicToggleBtn.gotoAndStop('selected');
			}
			else
			{
				mSoundManager.soundPlay(LandingPage.THEME_SONG); 
				songPlaying = true;
				musicEnabled = true;
				musicToggleBtn.gotoAndStop('off');
			}
		}
		
		// Sound fx
		private function toggleAllSounds(evt:MouseEvent):void
		{
			if(allAudioOn)
			{
			//trace('turn off sfx');
			 mSoundManager.changeSoundVolume(LandingPage.BTN_SOUND,0); // hack
			 //mSoundManager.stopSound(LandingPage.THEME_SONG);
			 allAudioOn = false;
			}
		   else
			{
				allAudioOn = true;
			}
		}
		
		private function openPopup(e:MouseEvent):void
		{
			//trace('open popup');
			addChild(aboutPop);
			aboutPop.x = 50;
			aboutPop.y = 50;
			aboutPop.close_btn.addEventListener(MouseEvent.MOUSE_DOWN, closePopup);
		}
		
		private function closePopup(e:MouseEvent):void
		{
			//trace('close popup');
			removeChild(aboutPop);
		}
		
		private function rollOver(e:Event):void
		{
			MovieClip(e.target).gotoAndStop("on");
			if(allAudioOn)
			{
			  mSoundManager.soundPlay(LandingPage.BTN_SOUND);
			}
		}
		
		private function rollOut(e:Event):void
		{
			MovieClip(e.target).gotoAndStop("off");
		}
		
		// Turn off sound when going to video page
		private function turnOffTheme(event:MouseEvent):void
		{
			//trace('turn off');
			if(songPlaying)
			{
			 // Turn off sound
			 mSoundManager.stopSound(LandingPage.THEME_SONG); 
			 songPlaying = false;
			 //musicToggleBtn.gotoAndStop('selected');
			}
		
		}
		
		//----------------------------------------
		//	Tracking 
		//----------------------------------------
		
		protected function onShown(ev:Event) {
			if(!songPlaying) playThemeSong();
			
			// Metric tracking
			var rand:int = Math.floor(Math.random() * 1000000);
			var url:String = "http://ad.doubleclick.net/ad/N4518.Neopets/B4526503.19;sz=1x1;ord="+rand+"?";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Main','DespicableMe2010')");
				ExternalInterface.call("window.top.urchinTracker('DespicableMe2010/Main')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
		}
		
        // Break In game
		private function goToGameOne(e:Event):void 
		{
			trace('game 1');
			var req_event:CustomEvent = new CustomEvent(16251,DestinationView.NEOCONTENT_LINK_REQUEST);
			dispatchEvent(req_event);
			
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224982326;15177704;j?http://www.neopets.com/games/play.phtml?game_id=1220";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//turnOffTheme(null); // set to null since you're not doing a mouse event
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Main to Game - Break in'");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
			// let php know we've taken a step to completing a task
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("DespicableMe2010Service.recordActivity",responder,"game1220");
			
		}
		// Fast Eye game
		private function goToGameTwo(e:Event):void 
		{
			trace('game 2');
			
			// Trigger neocontent link
			var ids:Object = {au:16677,fr:16678,de:16679,nl:16680,nz:16681,es:16682,uk:16683,us:16250};
			var target_id:Object = DestinationView.getEntryByCC(ids);
			var req_event:CustomEvent = new CustomEvent(target_id,DestinationView.NEOCONTENT_LINK_REQUEST);
			dispatchEvent(req_event);
			
			// Metric tracking
			ids = {au:1253,fr:1254,de:1255,nl:1256,nz:1257,es:1258,uk:1259,us:1222};
			target_id = DestinationView.getEntryByCC(ids);
			var url:String = "http://ad.doubleclick.net/clk;224982272;15177704;j?http://www.neopets.com/games/play.phtml?game_id="+target_id;
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//turnOffTheme(null);
			
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Main to Game - Minion'");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
			// let php know we've taken a step to completing a task
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("DespicableMe2010Service.recordActivity",responder,"game1222");

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
		
		private function processTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224982414;15177704;h?http://www.despicable.me/";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//
			//omniture, google tracking
			/*if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Destination About to Despicable.Me Microsite')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}*/
			
		}
		
	}
	
}