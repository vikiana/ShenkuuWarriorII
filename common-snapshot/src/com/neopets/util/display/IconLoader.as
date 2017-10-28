// This class loads images from an external source and automatically resizes them to the target
// dimensions when they're loaded.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.util.display
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class IconLoader extends MovieClip {
		// constants
		public static const ICON_LOADED:String = "icon_loaded";
		// variables
		protected var _loader:Loader;
		protected var _req:URLRequest;
		protected var _imgHeight:Number;
		protected var _imgWidth:Number;
		
		public function IconLoader() {
			_imgHeight = 32;
			_imgWidth = 32;
		}
		
		// Accessor Functions
		
		public function get iconHeight():Number { return _imgHeight; }
		
		public function set iconHeight(val:Number):void {
			_imgHeight = val;
			updateIcon();
		}
		
		public function get iconWidth():Number { return _imgWidth; }
		
		public function set iconWidth(val:Number):void {
			_imgWidth = val;
			updateIcon();
		}
		
		public function get loader():Loader { return _loader; }
		
		// Loader Functions
		
		// Use this function to load from the specified url.
		public function loadFrom(path:String):void {
			if(path == null) return;
			// clear previous icon
			clearIcon();
			// load new icon
			_req = new URLRequest(path);
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImgLoaded);
			addChild(_loader);
			_loader.load(_req);
		}
		
		// Use this function to unload images.
		public function clearIcon():void {
			_req = null;
			if(_loader != null) {
				removeChild(_loader);
				_loader = null;
			}
		}
		
		// Resize and reposition assets as they're loaded.
		protected function onImgLoaded(ev:Event):void {
			updateIcon();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImgLoaded);
			dispatchEvent(new Event(ICON_LOADED));
		}
		
		// Misc. Functions
		
		// This function ensures the loader is properly scaled and positioned.
		public function updateIcon():void {
			if(_loader != null) {
				// rescale image
				_loader.scaleX = Math.min(_imgHeight/_loader.height,_imgWidth/_loader.width);
				_loader.scaleY = _loader.scaleX;
				// center image
				var bbox:Rectangle = _loader.getBounds(this);
				_loader.x = -(bbox.left + (bbox.width/2));
				_loader.y = -(bbox.top + (bbox.height/2));
			}
		}
	}
}