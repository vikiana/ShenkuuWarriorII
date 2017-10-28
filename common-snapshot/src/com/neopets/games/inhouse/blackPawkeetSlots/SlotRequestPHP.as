/**
 *	sends php requests to retrieve necessary data to play the slot
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.inhouse.blackPawkeetSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.MovieClip;	
		
	public class SlotRequestPHP extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mMainGame:Object;	//MainGame class
		private var loader:URLLoader;	//loader that'll load php request results
		private var mResult:XML;	//string of outcome php returns
		private var mHash:String;	//is used for security purposes
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		
		////
		//	sends requests and wait's for server reply
		////
		public function SlotRequestPHP(pMainGame:Object = null):void
		{
			mMainGame = pMainGame;
			loader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, initialSetup)
			loader.addEventListener(IOErrorEvent.IO_ERROR, processError)
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function get slotResult():XML
		{
			return mResult;
		}
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		////
		//	When game first starts, it asks for minimal info necessary to start the game, which are
		//		>user name
		//		>uer np
		//		>jackpot
		//		>hash
		////
		public function requestStartupStats():void
		{
			var server:String = mMainGame.system.getScriptServer()
			var phpScript:String = "games/pirate_slots.php"
			var method:String = "?method=startup"
			var url:String = server+ phpScript+ method
			trace ("URL for set up", url)
			loader.load(new URLRequest(url))
			
		}
		
		
		////
		//	Every time "play" or "max bet" is clicked, this request for a slot result
		//	
		//	@PARAM	bet		current bet amount
		//	@PARAM	line	current lines
		////
		public function returnResult(bet:int = 0, line:int = 0):void
		{
			var server:String = mMainGame.system.getScriptServer()
			var phpScript:String = "games/pirate_slots.php"
			var method:String = "?method=spin&bet=" + bet +"&lines=" + line + "&hash=" + mHash
			//for brower cache issue, add random number
			var randomAddOn:String = "&r="+ Math.ceil(Math.random() * 1000000000000).toString() 
			var url:String = server + phpScript + method + randomAddOn
			trace ("URL for result", url)
			loader.load(new URLRequest (url))
		}
		
		
		//clean up the php request
		public function cleanup()
		{
			loader.removeEventListener(Event.COMPLETE, processURL)
			mMainGame = null;
			loader = null;
			mResult = null;
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		// when server result is in, it dispatched an event (Slotmachien core listens for it)
		private function processURL(evt:Event):void
		{
			mResult = XML(evt.target.data);
			dispatchEvent(new Event ("phpReqeustIsIn"))
		}
		
		// 	when server result is in (called only once when starts, 
		// 	it dispatched an event (Slotmachien core listens for it)
		// 	it has a very week error (login) checking system because user shouldn't 
		//	even come to this point when not logged in
		private function initialSetup(evt:Event):void
		{
			trace ("=====initial setup data")
			trace (evt.target.data)
			
			mResult = XML(evt.target.data);
			dispatchEvent(new Event ("phpReqeustIsIn"))
			if (mResult.localName() == "slotsStartup") 
			{
				mHash = mResult.hash
				loader.removeEventListener(Event.COMPLETE, initialSetup)
				loader.removeEventListener(IOErrorEvent.IO_ERROR, processError)
				loader.addEventListener(Event.COMPLETE, processURL)
			}
			else 
			{
				trace ("hash has to be reset")
			}
			
			
		}
		
		private function processError(evt:IOErrorEvent):void
		{
			trace ("error occured", evt) 
		}
		
	}
	
}