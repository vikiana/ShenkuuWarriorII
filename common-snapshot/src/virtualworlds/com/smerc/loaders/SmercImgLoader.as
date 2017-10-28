package virtualworlds.com.smerc.loaders
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import virtualworlds.com.smerc.loaders.events.ImageLoadingEvent;
	
	/**
	* A loader that explicitly loads SWF files or image (JPG, PNG, or GIF) files.
	* 
	* @author Bo
	*/
	public class SmercImgLoader extends Sprite
	{
		/**
		 * Dispatched from this when the specified url is completely loaded, and its image was extracted.
		 * @eventType SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT
		 */
		public static const IMAGE_LOADING_COMPLETE_EVT:String = "ImageLoadingCompleteEvent";
		
		/**
		 * Dispatched from here if an error occurs loading the image file.
		 * @eventType SmercImgLoader.IMAGE_LOADING_ERROR_EVT
		 */
		public static const IMAGE_LOADING_ERROR_EVT:String = "ImageLoadingErrorEvent";
		
		/**
		 * The internal loader that loads the ByteArray returned from the URLLoader.
		 */
		protected var _loader:Loader;
		
		protected var _urlLoader:URLLoader;
		
		/**
		 * The image that was successfully loaded.
		 */
		protected var _loadedImg:DisplayObject;
		
		protected var _loadedBytes:ByteArray;
		
		/**
		 * Is this loader currently in use?
		 */
		protected var _bInUse:Boolean = false;
		
		/**
		 * The saved url location of the image file.
		 */
		protected var _urlToLoad:String;
		
		protected var _loaderContext:LoaderContext;
		
		/**
		 * Whether or not to force-reload the file.
		 */
		protected var _bForceReload:Boolean = false;
		
		/**
		 * Global force-reload for all instances of this class, 
		 * regardless of the a_bForceReload argument of load().
		 */
		protected static var _bGlobalForceReload:Boolean = false;
		
		/**
		 * By default, this calls this.init().
		 */
		public function SmercImgLoader()
		{
			this.init();
			
		}//end SmercImgLoader() constructor.
		
		/**
		 * Constructs a new Loader and configures listeners on its contenttLoaderInfo.
		 * @param	...args
		 */
		protected function init(...args):void
		{
			_loader = new Loader();
			_urlLoader = new URLLoader();
			this.configureListeners(_loader.contentLoaderInfo);
			this.configureURLLoader(_urlLoader);
			
		}//end init()
		
		/**
		 * Getter/setter for the global force-reload for all instances of this class, 
		 * regardless of the a_bForceReload argument of load().
		 */
		public static function set globalForceReload(a_bool:Boolean):void
		{
			SmercImgLoader._bGlobalForceReload = a_bool;
			
		}//end set globalForceReload()
		public static function get globalForceReload():Boolean
		{
			return SmercImgLoader._bGlobalForceReload;
			
		}//end get globalForceReload()
		
		/**
		 * This starts the loading of a image file.
		 * 
		 * @param	a_url:				String url of the image file to load.
		 * @param	a_loaderContext:	The LoaderContext for the file to load.  This is useful for changing the ApplicationDomain of the loaded swf, should
		 * 								This image swf have class definitions.
		 */
		
		/**
		 * This starts the loading of a image file.
		 * 
		 * @param	a_url:				String url of the image file to load.
		 * @param	a_loaderContext:	The LoaderContext for the file to load.  This is useful for changing the ApplicationDomain of the loaded swf, should
		 * 								This image swf have class definitions.
		 * @param	a_bForceReload:		If set to 'true', this url is always loaded anew (instead of possibly relying on a
		 * 								browser-cached version. @default false. 
		 * 								<BR/><BR/><b>NOTE: If SmercImgLoader._bGlobalForceReload == true, this is always set.</b>
		 */
		public function load(a_url:String, a_loaderContext:LoaderContext = null, 
								a_bForceReload:Boolean = false, a_bUseOnlyLoader:Boolean = false):void
		{
			if (_bInUse)
			{
				throw new Error("SmercImgLoader::load(): this is currently in use, use a new instance of a SmercImgLoader!");
			}
			
			_urlToLoad = a_url;
			var urlReq:URLRequest = new URLRequest(a_url);
			
			_bForceReload = a_bForceReload || SmercImgLoader._bGlobalForceReload;
			
			if (_bForceReload)
			{
				var urlVars:URLVariables = new URLVariables();
				
				urlVars.forceReload = getTimer() + Math.random();
				
				urlReq.data = urlVars;
				
				/**
				var noCacheHeader0:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
				var noCacheHeader1:URLRequestHeader = new URLRequestHeader("Cache-Control", "no-cache");
				var noCacheHeader2:URLRequestHeader = new URLRequestHeader("expires", "0");
				var noCacheHeader3:URLRequestHeader = new URLRequestHeader("Cache-Control", "no-store");
				var noCacheHeader4:URLRequestHeader = new URLRequestHeader("Cache-Control", "must-revalidate");
				urlReq.requestHeaders.push(noCacheHeader0);
				urlReq.requestHeaders.push(noCacheHeader1);
				urlReq.requestHeaders.push(noCacheHeader2);
				urlReq.requestHeaders.push(noCacheHeader3);
				urlReq.requestHeaders.push(noCacheHeader4);
				/**/
				
				// is the url of a swf?
				var swfStrLocation:int = a_url.indexOf(".swf", 0);
				
				// We're loading a swf if the '.swf' is the last 4 characters of the url.
				if (swfStrLocation == (a_url.length - 4))
				{
					urlReq.method = URLRequestMethod.POST;
				}
			}
			
			_bInUse = true;
			
			// save our copy of the requested LoaderContext.
			_loaderContext = a_loaderContext;
			
			if (!a_bUseOnlyLoader)
			{
				// Remove the url-loader's progress event, and just use the
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				//
				_urlLoader.load(urlReq);
			}
			else
			{
				_loader.load(urlReq, _loaderContext);
			}
			
		}//end load()
		
		public function loadBytes(a_byteArr:ByteArray, a_loaderContext:LoaderContext = null):void
		{
			if (_bInUse)
			{
				throw new Error("SmercImgLoader::loadBytes(): this is currently in use, use a new instance of a SmercImgLoader!");
			}
			
			_loaderContext = a_loaderContext;
			
			_loadedBytes = a_byteArr;
			
			_bInUse = true;
			
			//
			_loader.loadBytes(a_byteArr, _loaderContext);
			
		}//end loadBytes()
		
		protected function configureURLLoader(a_urlLoader:URLLoader):void
		{
			a_urlLoader.addEventListener(Event.COMPLETE, urlLoadingComplete, false, 0, true);
			a_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			a_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			a_urlLoader.addEventListener(Event.OPEN, openHandler, false, 0, true);
            a_urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
            a_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			
		}//end configureURLLoader()
		
		protected function unConfigureURLLoader(a_urlLoader:URLLoader):void
		{
			a_urlLoader.removeEventListener(Event.COMPLETE, urlLoadingComplete);
			a_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			a_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			a_urlLoader.removeEventListener(Event.OPEN, openHandler);
            a_urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            a_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
		}//end unConfigureURLLoader()
		
		/**
		 * Configures the listeners for our _loader.
		 * 
		 * @param	dispatcher:	IEventDispatcher, generally, our _loader.contentLoaderInfo.
		 */
		protected function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }//end configureListeners()
		
		/**
		 * Un-Configures the listeners for our _loader.
		 * 
		 * @param	dispatcher:	IEventDispatcher, generally, our _loader.contentLoaderInfo.
		 */
		protected function unConfigureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(Event.INIT, initHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
			
		}//end unConfigureListeners()
		
		protected function urlLoadingComplete(a_evt:Event):void
		{
			_loadedBytes = _urlLoader.data as ByteArray;
			
			//
			_loader.loadBytes(_loadedBytes, _loaderContext);
			
		}//end urlLoadingComplete()
		
		/**
		 * The internal handler of the swf file that was completely loaded.
		 * This dispatches a SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT.
		 * At the time this event is dispattched, our _urlToLoad is filled in with the loaded DisplayObject that was loaded.
		 * 
		 * @param	a_evt
		 */
		protected function completeHandler(a_evt:Event):void
		{
			var dispObj:DisplayObject = _loader.content;
			_loadedImg = dispObj;
			
			this.addChild(_loadedImg);
			this.dispatchEvent(new ImageLoadingEvent(SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT, true, dispObj));
			
			// So that this fulfills the basic requirement for a listening LoadingBar
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}//end completeHandler()
		
		protected function httpStatusHandler(a_httpStatusEvt:HTTPStatusEvent):void
		{
			
		}//end httpStatusHandler()
		
		protected function initHandler(a_evt:Event):void
		{
			
		}//end initHandler()
		
		protected function ioErrorHandler(a_ioErrEvt:IOErrorEvent):void
		{
			_bInUse = false;
			
			this.dispatchEvent(new ImageLoadingEvent(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, false, null, 
														(a_ioErrEvt + " loading " + _urlToLoad)));
			
		}//end ioErrorHandler()
		
		protected function securityErrorHandler(a_securityErr:SecurityErrorEvent):void
		{
			_bInUse = false;
			
			this.dispatchEvent(new ImageLoadingEvent(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, false, null, (a_securityErr 
																										+ " loading " + _urlToLoad)));
			
		}//end securityErrorHandler()
		
		protected function openHandler(a_evt:Event):void
		{
			
		}//end openHandler()
		
		/**
		 * This re-dispatches the ProgressEvent of the Loading image, should anyone want to know the progress of the image that's loading.
		 * 
		 * @param	a_progressEvt:	ProgressEvent of the internally loaded image.
		 */
		protected function progressHandler(a_progressEvt:ProgressEvent):void
		{
			this.dispatchEvent(a_progressEvt);
		}//end progressHandler()
		
		protected function unLoadHandler(a_evt:Event):void
		{
			
		}//end unLoadHandler()
		
		/**
		 * Getter to determine if this SmercImgLoader is available for calling load().
		 */
		public function get isInUse():Boolean
		{
			return _bInUse;
		}//end get isInUse()
		
		/**
		 * Returns the last loaded image, as long as it has completed loading. This DisplayObject is also dispatched in the
		 * SmerrcImgLoader.IMAGE_LOADING_COMPLETE_EVT.
		 */
		public function get loadedImg():DisplayObject
		{
			return _loadedImg;
			
		}//end get loadedImg()
		
		public function get loadedBytes():ByteArray
		{
			return _loadedBytes;
		}//end get loadedBytes()
		
		/**
		 * Getter for the last url to load.
		 */
		public function get urlToLoad():String
		{
			return _urlToLoad;
			
		}//end get urlToLoad()
		
		/**
		 * Makes this ready to load a new Image, regardless of if it's currently loading another swf or whatever, yo.
		 * 
		 * @param	...args
		 */
		public function reset(...args):void
		{
			this.destroy();
			this.init();
		}//end reset()
		
		/**
		 * Use this for proper clean-up when this loader is no longer used!
		 * 
		 * @param	...args
		 */
		public function destroy(...args):void
		{
			//
			//
			
			if(_loadedImg && _loadedImg.parent && (this == _loadedImg.parent) )
			{
				this.removeChild(_loadedImg);
			}
			
			if (_loader)
			{
				try { _loader.close();}catch(e:Error){}
			}
			
			if (_urlLoader)
			{
				try { _urlLoader.close(); } catch (e:Error) { }
				this.unConfigureURLLoader(_urlLoader);
				_urlLoader = null;
			}
			
			if (_loader && _loader.contentLoaderInfo)
			{
				this.unConfigureListeners(_loader.contentLoaderInfo);
			}
			
			if (_loader && _loadedImg && _loadedImg.parent && (_loadedImg.parent == _loader) )
			{
				_loader.unload();
			}
			
			_loader = null;
			
			_loadedImg = null;
			
			_loadedBytes = null;
			
			_bInUse = false;
			
			_urlToLoad = null;
			
			_loaderContext = null;
			
		}//end destroy()
		
	}//end class SmercImgLoader
	
}//end package com.smerc.loaders
