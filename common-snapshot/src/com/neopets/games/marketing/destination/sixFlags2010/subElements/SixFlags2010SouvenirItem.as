package com.neopets.games.marketing.destination.sixFlags2010.subElements
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class SixFlags2010SouvenirItem extends Sprite
	{
		public var _text:String;
		public var _id:int;
		public var _price:int;
		public var _url:String;
		public var _location:int;
		
		public var adLink:String;
		
		protected var _loader:Loader;
		protected var _Image:Bitmap;
		
		public function SixFlags2010SouvenirItem() {}
		
		public function init(item_id:int = 0, location:int = 0, price:int = 0, url:String = null, text:String = null, AdLink:String=""):void
		{
			_id = item_id;
			_location = location;
			_price = price;
			_url = url;
			_text = text;
			
			adLink = AdLink;
			
			if (_url != null)
			{
				setUpPicture();	
			}	
		}
		
		public function setUpPicture():void
		{
			_loader = new Loader();
			var tURLRequest:URLRequest = new URLRequest(_url);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
			_loader.load(tURLRequest);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/** 
		 * IMAGE LOADED
		 */
		
		protected function imageLoaded(evt:Event):void
		{
			_Image = Bitmap(_loader.content);
			_Image.x = 0;
			_Image.y = 0;
			addChild(_Image);
		}
		
		/**
		 *	@onError handles when a Loader has an Error
		 *  @param			evt			Event		From Event.ERROR	
		 **/
		
		protected function onError(error:IOErrorEvent):void {
			trace("Error on Load Icon >" + error);
		}
	}
}