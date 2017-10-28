/**
 *	sends php requests to retrieve necessary data to play the slot
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pcCollectionQuest
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	
		
		
	public class PHPRequest extends Sprite
	{
		//----------------------------------------
		//	CONSTANT
		//----------------------------------------
		public const RESULT_RECEIVED:String = "result_is_in"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var loader:URLLoader;	//loader that'll load php request results
		private var mResult:XML;	//string of outcome php returns
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function PHPRequest(pMainGame:Object = null):void
		{
			trace ("phpRequest init")
			loader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, onResultIn, false, 0, true)	//where to place & when to clean this....
			loader.addEventListener(IOErrorEvent.IO_ERROR, processError, false, 0, true)
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get xmlData():XML
		{
			return mResult;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function processURL(pURL:String):void
		{
			trace ("URL for set up", pURL)
			loader.load(new URLRequest(pURL))			
		}
		
		public function cleanup():void
		{
			//loader.removeEventListener(
		}
		
		//----------------------------------------
		//	EVENT LISTENER
		//----------------------------------------
		
		private function onResultIn (evt:Event):void
		{
			mResult = XML(evt.target.data)
			dispatchEvent (new Event (RESULT_RECEIVED));
		}
		
		private function processError(evt:IOErrorEvent):void
		{
			trace ("php request url error")
		}
	}
	
}