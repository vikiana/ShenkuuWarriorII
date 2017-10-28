package virtualworlds.helper.Fu.Helpers
{	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import virtualworlds.helper.Fu.BaseClasses.BasicClass;
	import virtualworlds.helper.Fu.BaseEvents.ConnectorEvent;

	public class ClassConnector extends BasicClass
	{
		public static var urlList:Array = [];
		public static var loaderStorage:Dictionary = new Dictionary(true);
		
		protected var tempLoader:Object;
		
		protected var loadIndex:int;
		protected var totalLoaded:int;
		
		protected var swfVersions:Object;
		protected var urlRewriteOn:Boolean;
		
		protected var numberOfFiles:int; 
		
		public function set newLoadingScheme(value:Boolean):void { _newLoadingScheme = value; }
		public function get newLoadingScheme():Boolean { return _newLoadingScheme; };
		private var _newLoadingScheme:Boolean;
		
		public function set assetBaseURL(value:String):void { _assetBaseURL = value; }
		public function get assetBaseURL():String { return _assetBaseURL; }
		private var _assetBaseURL:String; 
		
		public function ClassConnector(swfVersions:Object = null, urlRewriteOn:Boolean = false)
		{
			if(!swfVersions)
				this.swfVersions = {};
			else
				this.swfVersions = swfVersions;
				
			this.urlRewriteOn = urlRewriteOn; 

		}
		
		/**
		 * Sets up the ClassConnector to load all swfs. Then starts loading. 
		 */		
		public function connect(loadUrls:Array):void
		{
			var bPending:Boolean = (urlList.length > 0)
			addToList(loadUrls)
			
				
			loadIndex = 0;
			totalLoaded = 0;
			
			
			if(!_newLoadingScheme || !bPending)
				loadNextItem();
		}
		
		public function addToList(loadUrls:Array):void
		{
			for each(var item:* in loadUrls)
			{
				var url:String = item is String ? item : item.url;
				
				if(urlList.indexOf(url) == -1  && !loaderStorage[url])
					urlList.push(url);
			}
			numberOfFiles = urlList.length;
		}
		
		/**
		 * Checks to see if all items are loaded. If they are not, it starts loading the next swf.
		 * If all items are loaded, dispatch an all items loaded ConnectorEvent.
		 */		
		protected function loadNextItem():void 
		{
			if(urlList.length != 0)
			{
				var newUrl:String = assetBaseURL + getVersionOf(currentObjectURL);
				var urlReq:URLRequest = new URLRequest(newUrl);
				
				if(currentObjectSuffix == "swf" || currentObjectSuffix == "jpg" || currentObjectSuffix == "png")
				{
					tempLoader = new Loader();
				}
				else if(currentObjectSuffix == "wav" || currentObjectSuffix == "mp3")
				{
					tempLoader = new Sound();
				}
				else if(currentObjectSuffix == "xml")
				{
					tempLoader = new URLLoader();
				}
				
				addHandlers();
				tempLoader.load(urlReq);
			}
			else
			{
				if(urlList.length != 0)
					loadNextItem();
				
				var event:ConnectorEvent = new ConnectorEvent(
				ConnectorEvent.ALLITEMSLOADED, 
				null, 
				loadIndex, 
				urlList.length);
	
				this.dispatchEvent(event);	
			}
		}
		
		/**
		 * When the loading is complete, store the loader, increment the load counts and dispatch
		 * an item loaded ConnectorEvent.
		 */		
		protected function completeHandler(event:Event):void
		{
			removeHandlers();
			
			loaderStorage[currentObjectURL] = tempLoader;
			
			totalLoaded++;
			loadIndex++;
			
			;
			
			var connEvent:ConnectorEvent = new ConnectorEvent(
			ConnectorEvent.ITEMLOADED, 
			tempLoader,
			loadIndex,
			urlList.length);
			
			this.dispatchEvent(connEvent);
			
			urlList.shift();
			
			loadNextItem();
		}
		
		/**
		 * Add all event listeners based on loader type 
		 */		
		protected function addHandlers():void
		{
			if(tempLoader.hasOwnProperty("contentLoaderInfo"))
			{
				tempLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				tempLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			}
			else
			{
				tempLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				tempLoader.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				tempLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			}
		}
		
		/**
		 * Remove all event listeners based on loader type 
		 */		
		protected function removeHandlers():void
		{
			if(tempLoader.hasOwnProperty("contentLoaderInfo"))
			{
				tempLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				tempLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				tempLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
			else
			{
				tempLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				tempLoader.removeEventListener(Event.COMPLETE, completeHandler);
				tempLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
		}
		
		/**
		 * On IOError continue to next item. 
		 */		
		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			loadIndex++;
			loadNextItem();
			
			throw(new Error("file load: " + currentObjectURL));
		
			;
		}
		
		/**
		 * Redispatches the ProgressEvent as a ConnectorEvent. 
		 */		
		protected function progressHandler(event:ProgressEvent):void 
		{
			var connEvent:ConnectorEvent = new ConnectorEvent(
			ConnectorEvent.ITEMPROGRESS, 
			null,
			event.bytesLoaded,
			event.bytesTotal, 
			numberOfFiles - urlList.length + 1, numberOfFiles);
			
			this.dispatchEvent(connEvent);
		}
		
		/**
		 * Modifies the url if multiple versions exist. 
		 */		
		public function getVersionOf(url:String):String
		{
			var urlSuffix:String = url.substr(url.length-3, 3).toLowerCase();
			
			;
			;
			
			if(urlRewriteOn && swfVersions[url]) 
			{
				// Rewrite Url
				var indexOfSwf:int = url.indexOf(urlSuffix);
				var rewriteUrl:String = url.substring(0, indexOfSwf)+"R"+swfVersions[url]+"."+urlSuffix;
				;
				url = rewriteUrl;
			} 
			
			return url;
		}
		
		/**
		 *  Returns the content of the LoaderInfo object.
		 */		
		public function getSwf(swfName:String):DisplayObject
		{
			loaderStorageDebug();
			
			return getLoader(swfName).contentLoaderInfo.content;
		}
		
		/**
		 *  Returns the content of the Loader object.
		 */	
		public function getContentFromSwf(swfName:String):Object
		{
			return getLoader(swfName).content;
		}
		
		/**
		 * Returns the typed content of the Loader object. 
		 */		
		public function getClassFromSwf(swfName:String, className:String):Class
		{
			try
			{
				var classToReturn:Class;
				var loader:Loader = getLoader(swfName);
					
				classToReturn = loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
				
				return classToReturn;
			}
		  	catch(error:*) { return null }
		  	
		  	return null;
		}
		
		/**
		 * The URL of the current load index. 
		 */		
		protected function get currentObjectURL():String
		{
			return urlList[0];
		}
		
		/**
		 * The suffix of the current load index. 
		 */		
		protected function get currentObjectSuffix():String
		{
			return currentObjectURL.substr(currentObjectURL.length-3, 3).toLowerCase();
		}
		
		/**
		 * Returns the loader for the given name.
		 */		
		protected function getLoader(swfName:String):Loader
		{
			return Loader(loaderStorage[swfName]);
		}
		
		/**
		 * Calls unloadAndStop on the loader and deletes all local references. 
		 */		
		public function deleteSwf(swfName:String):void
		{
			if(!loaderStorage[swfName])
				return;
			
			if(loaderStorage[swfName].hasOwnProperty("unloadAndStop"))
				loaderStorage[swfName].unloadAndStop();
			
			loaderStorage[swfName] = null;
			delete loaderStorage[swfName];
		}
		
		/************************************
		 * ResourceLoader Stuff
		 ************************************/
		
		/**
		 * Returns a raw Object from the loaderStorage.
		 */	       
		public static function getObject(key:String):Object {
			return loaderStorage[key];
		}
		
		/**
		 * Checks if the keyed value exists in the loaderStorage.
		 */	
		public static function isResourceLoaded(key:String):Boolean {
			return loaderStorage[key];
		}	
		
		/**
		 * Returns a typed object from the keyed swf.
		 */	
		public static function getLibraryResource(linkage:String, key:String):*
		 {
		  	try
		  	{
		  		var source:Loader = Loader(getObject(key));
			  	var appDomain:ApplicationDomain = source.contentLoaderInfo.applicationDomain;
			  	var classRef:Class = Class(appDomain.getDefinition(linkage));
			  	
			  	return new classRef();
		  	}
		  	catch(error:*) { return null }
		  	
		  	return null;
		}
		
		/**
		 * Returns a Sound from the loaderStorage.
		 */	
		public static function getSound(key:String):Sound {
			return Sound(getObject(key));
		}        
		
		/**
		 * Returns a Bitmap from the loaderStorage.
		 */	
		public static function getBitmap(key:String):Bitmap {
			return new Bitmap(getObject(key).content.bitmapData);
		}        
		
		/**
		 * Returns a MovieClip from the loaderStorage.
		 */	
		public static function getMovieClip(key:String):MovieClip {
				return MovieClip(getObject(key).content);
		}
		
		public function loaderStorageDebug():void
		{
			;
			
			for(var key:* in loaderStorage)
			{
				;
			}
		}
		
		public function swfVersionsDebug():void
		{
			;
			
			for(var key:* in swfVersions)
			{
				;
			}
		} 
	}
}