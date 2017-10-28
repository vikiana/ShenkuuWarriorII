/* AS3
	Copyright 2010
*/

package com.neopets.util.assetloader {

	/**
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 7 October 2010
	*/	

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;

	
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
		internal class NPAssetData {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private const NPAL:NPAssetLoader = NPAssetLoader.instance;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var id:int;										// an unique id given to this data
		public var url:String;									// the url to this asset
		public var ident:String;								// a name for this asset - usually the filename
		public var loader:Loader;							// Loader object
		public var loaded:Number;							// Loading ratio of the asset. 1 when fully loaded.
		public var appdomain:ApplicationDomain;	// ApplicationDomain of this asset
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NPAssetData(p_id:int, p_url:String = "", p_ident:String = ""):void {
			id = p_id;
			url = p_url;
			ident = p_ident;
			loader = new Loader();
			loaded = 0;
			configListeners(loader.contentLoaderInfo);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Starts to load this asset
		*/ 		
		public function loadData():void {
			loader.load(new URLRequest(url));
		}
		
		public function getClassDef(p_class:String):Class {
			if (appdomain.hasDefinition(p_class)) return appdomain.getDefinition(p_class) as Class;
			return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

        private function completeHandler(e:Event):void {
			loaded = 1;
			removeListeners(loader.contentLoaderInfo);
			processLoadedAsset();
			NPAL.reportAssetLoaded(this);
        }

        private function httpStatusHandler(e:HTTPStatusEvent):void {
			//trace("httpStatusHandler: " + e);
        }

        private function initHandler(e:Event):void {
			//trace("initHandler: " + e);
        }

        private function ioErrorHandler(e:IOErrorEvent):void {
			trace("[NPAssetData] ioErrorHandler: " + e);
			NPAL.reportAssetFailed();
        }

        private function openHandler(e:Event):void {
			//trace("openHandler: " + e);
        }

        private function progressHandler(e:ProgressEvent):void {
			//trace("progressHandler: bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
			loaded = e.bytesLoaded / e.bytesTotal;
			NPAL.reportAssetLoadingProgress(ident, loaded);
        }

        private function unLoadHandler(e:Event):void {
			trace("[NPAssetData] unLoadHandler: " + e);
        }

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Handles whatever processing that needs to be done on this asset
		*/ 		
		private function processLoadedAsset():void {
			appdomain = loader.contentLoaderInfo.applicationDomain;
		}
		
		/**
		 * @Note: Adds all listeners
		*/ 		
		private function configListeners(p_dispatcher:IEventDispatcher):void {
			p_dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            p_dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            p_dispatcher.addEventListener(Event.INIT, initHandler);
            p_dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            p_dispatcher.addEventListener(Event.OPEN, openHandler);
            p_dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            p_dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }
		
		/**
		 * @Note: Removes all listeners
		*/ 		
		private function removeListeners(p_dispatcher:IEventDispatcher):void {
			p_dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            p_dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            p_dispatcher.removeEventListener(Event.INIT, initHandler);
            p_dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            p_dispatcher.removeEventListener(Event.OPEN, openHandler);
            p_dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            p_dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
		}

		/**
		 *	@Destructor
		 */
		public function destructor():void {
			loader.close();
			loader.unload();
			removeListeners(loader.contentLoaderInfo);
			url = "";
			ident = "";
			loader = null;
			loaded = 0;
			appdomain = null;
		}
	}
}

