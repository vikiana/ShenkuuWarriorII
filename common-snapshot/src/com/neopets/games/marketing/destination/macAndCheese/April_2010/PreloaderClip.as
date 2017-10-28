/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	
	/**
	 *	This class handle the preloader swf.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	public class PreloaderClip extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const USE_WAIT_VAR:String = "wait";
		public static const MS_WAIT:Number = 3000; // wait in milliseconds
		public static const LOAD_URL_VAR:String = "landing_swf";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _pageLoader:Loader;
		protected var _waitTimer:Timer;
		// component variables
		protected var _mainClip:MovieClip;
		protected var _skipButton:SimpleButton;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PreloaderClip():void{
			super();
			FlashVarManager.setDefault(USE_WAIT_VAR,true);
			FlashVarManager.setDefault(LOAD_URL_VAR,"destination_landing_page_v2.swf");
			FlashVarManager.initVars(root);
			// check for our skip button
			_mainClip = getChildByName("main_mc") as MovieClip;
			if(_mainClip != null) {
				_skipButton = _mainClip.getChildByName("skip_btn") as SimpleButton;
			}
			// start loading content
			var url:String = String(FlashVarManager.getVar(LOAD_URL_VAR));
			loadPage(url);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to disable and remove our wait timer.
		
		public function clearTimer():void {
			if(_waitTimer != null) {
				_waitTimer.removeEventListener(TimerEvent.TIMER,onWaitDone);
				_waitTimer = null;
			}
		}
		
		// Use this function to load a new page into this preloader shell.
		
		public function loadPage(url:String) {
			// clear previous loader
			if(_pageLoader != null) {
				removeChild(_pageLoader);
			}
			clearTimer();
			// set up new loader
			if(url != null) {
				_pageLoader = new Loader();
				// add anti-caching measures
				if(url.indexOf("http:") >= 0) url += "?r=" + int(Math.random() * 1000000);
				var req:URLRequest = new URLRequest(url);
				_pageLoader.load(req);
				// check if we want to let the preloader keep running after the page loads
				if(FlashVarManager.getVar(USE_WAIT_VAR)) {
					// push loader into background while preloader plays
					addChildAt(_pageLoader,0);
					// set up wait timer
					_waitTimer = new Timer(MS_WAIT,1);
					_waitTimer.addEventListener(TimerEvent.TIMER,onWaitDone);
					_waitTimer.start();
					// let clicks on preloader cut the wait short
					if(_skipButton != null) _skipButton.addEventListener(MouseEvent.CLICK,onWaitDone);
				} else {
					// push the loader to the foreground
					addChild(_pageLoader);
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onWaitDone(ev:Event=null) {
			// move the loader to the front
			if(_pageLoader != null) {
				setChildIndex(_pageLoader,numChildren-1);
			}
			// turn off listeners
			clearTimer();
			if(_skipButton != null) _skipButton.removeEventListener(MouseEvent.CLICK,onWaitDone);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
