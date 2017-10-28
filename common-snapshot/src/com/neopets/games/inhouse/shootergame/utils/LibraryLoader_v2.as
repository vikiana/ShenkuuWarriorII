package com.neopets.games.inhouse.shootergame.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 *	Class to load the library file. Tipically, this is done in the outer game shell. It includes a static method to extract symbols from any loaded swf.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  12.26.2006
	 */
	public class LibraryLoader_v2 extends EventDispatcher
	{
		public static const LIB_LOADED:String = "libraryLoaded";
		
		private var _thisObj:LibraryLoader_v2;
		
		
		/**
		* 
		* Constructor
		* 
		* @param	target  The location where to load the library file. 
		* 
		*/
		public function LibraryLoader_v2(target:IEventDispatcher=null)
		{
			super(target);
			_thisObj = this;
		}
		
		
		
		//For Neopets games, the loading will happen in the outer shell
		public static function loadLibrary(path:String, loadComplete:Function):void {
			//graphical indication: not used----------------------------------------------------------
			//var rect:Shape = new Shape();
			//rect.graphics.beginFill(0xFFFFFF);
			//rect.graphics.drawRect(0, 0, 100, 100);
			//addChild(rect);
			var lcontext:LoaderContext = new LoaderContext (false, ApplicationDomain.currentDomain);
			var ldr:Loader = new Loader ();
			//ldr.mask = rect;
			var url:String = path;
			var urlReq:URLRequest = new URLRequest(url);
			ldr.load (urlReq, lcontext);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		private function loadComplete (e:Event):void{
			dispatchEvent (new Event (LIB_LOADED));
		}
		
		//Static. Can be invoked anytime I have to extract symbols from a loaded library swf.
		public static function getLibrarySymbol (symbolClass:String):Class {
			//trace ("GETTING LIBRARY SYMBOL "+symbolClass);
			var sclass:Class;
			//trace ("app domain:"+ApplicationDomain.currentDomain+", "+symbolClass);
			if (ApplicationDomain.currentDomain.hasDefinition(symbolClass)){
				sclass = ApplicationDomain.currentDomain.getDefinition (symbolClass) as Class;
			} else {
				trace ("Symbol "+symbolClass+" doesn't exist in the library or error loading the library");
			}
			return sclass;
		};
	}
}