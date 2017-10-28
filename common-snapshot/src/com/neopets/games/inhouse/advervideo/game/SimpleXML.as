package com.neopets.games.inhouse.advervideo.game 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.errors.*;
	

	/**
	 * ...
	 * @author Bill Wetter
	 */
	public class SimpleXML extends EventDispatcher {
		public static var XML_LOADED:String = "xml_loaded";
		private var loader:URLLoader;
		public var xmlObj:XML;
		
		public function SimpleXML(pUrl:String):void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.onComplete);
			
			loader.load(new URLRequest(pUrl));
		}
		
		private function onComplete(e:Event):void {
			//trace(evt);
			try {
				xmlObj = new XML(this.loader.data);
				dispatchEvent(new Event(XML_LOADED, true));
			} catch (e:Error) {
				trace ("Error: " + e.message);
				return;
			}
		}
	}

}