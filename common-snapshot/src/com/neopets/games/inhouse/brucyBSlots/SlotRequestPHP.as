/**
 *	sends php requests to retrieve necessary data to play the slot
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.inhouse.brucyBSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
		
	public class SlotRequestPHP extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mMainGame:Object;	//MainGame class
		private var loader:URLLoader;	//loader that'll load php request results
		private var mResult:XML;	//string of outcome php returns
		private var mHash:String;	//is used for security purposes
		private const useFakeXML:Boolean =  false;
		
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
			var gameID:String = "&game_id=1121"
			var url:String = server+ phpScript+ method + gameID
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
			var randomAddOn:String = "&r="+ Math.ceil(Math.random() * 1000000000000).toString() //for brower cache
			var gameID:String = "&game_id=1121"
			var url:String = server + phpScript + method + randomAddOn + gameID
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
			if(useFakeXML)
			{
				// fake xml
				mResult = XML (<slotsSpin><username>arokan</username><user_np>20030478</user_np><np_won>142</np_won><jackpot_won>1</jackpot_won><reels><reel id="1"><symbol pos="1">3</symbol><symbol pos="2">4</symbol><symbol pos="3">4</symbol></reel><reel id="2"><symbol pos="1">5</symbol><symbol pos="2">7</symbol><symbol pos="3">1</symbol></reel><reel id="3"><symbol pos="1">8</symbol><symbol pos="2">4</symbol><symbol pos="3">1</symbol></reel><reel id="4"><symbol pos="1">1</symbol><symbol pos="2">5</symbol><symbol pos="3">4</symbol></reel><reel id="5"><symbol pos="1">6</symbol><symbol pos="2">2</symbol><symbol pos="3">5</symbol></reel></reels><lines_won><line id="2" match="3"/><line id="7" match="4"/></lines_won><jackpot>123</jackpot><pawkeet_bonus>3</pawkeet_bonus><treasure_bonus type="np" np="1500"><message>You won 1500 Neopoints!</message></treasure_bonus></slotsSpin>)
			
			}
			else
			{
				// XML from server
				mResult = XML(evt.target.data);
			}
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
			
			if (useFakeXML)
			{
				//fake XML
				mResult = XML(<slotsStartup><username>arokan</username><user_np>230478</user_np><jackpot>123938921</jackpot><hash>6d0cb9f5f16ef7d386fae903619198382cc3d534</hash></slotsStartup>)
			}
			else
			{
				//XML from server
				mResult = XML(evt.target.data);
			}
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