/**
* ...
* @author Bo
* @version 0.1
*/

package virtualworlds.com.smerc.utils
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	import virtualworlds.com.smerc.utils.events.UrlLoadedFileEvent;
	
	public class FileLoader extends EventDispatcher
	{
		protected static const log:Logger = LogContext.getLogger(FileLoader);
		private var name:String;
		private static var _constructionCnt:int = 0;
		
		/**
		 * All-encompassing error to load files of type Event.
		 * 
		 * @eventType com.smerc.utils.file.FileLoader.FILE_LOADER_ERROR_EVT
		 */
		public static const FILE_LOADER_ERROR_EVT:String = "FileLoaderErrorEvent";
		
		/**
		 * Dispatched on completion of the file to load, the file (as an Object) is stored within this UrlLoadedFileEvent.
		 * 
		 * @eventType com.smerc.utils.file.FileLoader.FILE_LOADER_ERROR_EVT
		 */
		public static const FILE_LOADING_COMPLETE_EVT:String = "FileLoaderUrlFileLoadingCompleteEvent";
		
		/**
		 * The constituient loader that this class uses.
		 */
		protected var _loader:URLLoader;
		
		protected var _loadedData:Object;
		
		/**
		 * Constructor. Doesn't do anything worth mentioning.
		 */
		public function FileLoader()
		{
			this.name = "FileLoader_" + _constructionCnt;
			_constructionCnt++;
			
		}//end FileLoader() constructor
		
		/**
		 * Deprecated Function for when this class used to be a singleton.
		 */
		public static function get instance():FileLoader
		{
			throw new Error("FileLoader::get instance(): DEPRECATED function! use the constructor, instead!");
			return null;
			
		}//end get instance()
		
		/**
		 * For proper clean-up and re-use of this class.
		 */
		public function destroy():void
		{
			if(_loader)
			{
				this.removeListeners(_loader);
			}
			
			_loader = null;
			
			_loadedData = null;
			
		}//end destroy()
		
		/**
		 * Deprecated Function for when this class used to be a singleton.
		 */
		public static function destroyInstance():void
		{
			
			
		}//end destroyInstance()
		
		/**
		 * 
		 * @param	a_url:				URL of the text, binary data, or link to return URL-encoded variables.
		 * @param	a_bForceReload:		If true and a_urlVars == null, this forces the file to be re-loaded even
		 * 								if it has been cached by the browser, by randomizing the URLVariables that are sent.
		 * @param	a_urlVars:			Any URLVariables that the user may wish to send in the request.
		 * @return
		 */
		public function load(a_url:String, a_bForceReload:Boolean = true, a_urlVars:URLVariables = null):void
		{
			//
			
			if(_loader)
			{
				//throw new Error(this.name + ".load(): Already in use! destroy() this or create a new FileLoader to load().");
				log.warn(this.name 
									+ ".load(): Already in use! destroy() this or create a new FileLoader to load().");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
				return;
			}
			
			_loader = new URLLoader();
			
			configureListeners(_loader);
			
            var request:URLRequest = new URLRequest(a_url);
			
			if (a_urlVars)
			{
				request.data = a_urlVars;
				request.method = URLRequestMethod.POST;
			}
			else if (a_bForceReload)
			{
				// we make a forceReload URL-variable that is always different (based on time plus a random number)
				// This makes sure the request is always different.
				var urlVars:URLVariables = new URLVariables();
				//urlVars.forceReload = getTimer() + Math.random();
				
				request.data = urlVars;
				request.method = URLRequestMethod.POST;
			}
			
			try
			{
                //
				_loader.load(request);
            }
			catch (error:Error)
			{
                //
				//throw new Error(this.name + ".load(): Unable to load \"" + a_url + "\" configuration document.");
				log.warn(this.name 
									+ ".load(): failed to call _loader.load(" + request + "), caught error=" + error);
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
				return;
            }
			
		}//end load()
		
		/**
		 * DEPRECATED!
		 * 	Instead, listen on your FileLoader instance for the UrlLoadedFileEvent FileLoader.FILE_LOADING_COMPLETE_EVT
		 * 	along with your FileLoader's instance.load().
		 * 
		 */
		public function loadFile(a_url:String, a_callback:Function = null, a_urlVars:URLVariables = null):IEventDispatcher
		{
			throw new Error("FileLoader::loadFile(): DEPRECATED function! use FileLoader.load(), instead!");
			
			return null;
			
		}//end loadFile()
		
		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			//
			
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
		}//end configureListeners()
		
		private function removeListeners(a_dispatcher:IEventDispatcher):void
		{
			//
			
			a_dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            a_dispatcher.removeEventListener(Event.OPEN, openHandler);
            a_dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            a_dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            a_dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            a_dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
		}//end removeListeners()
		
		/**
		 * Upon loading complete, this is the same data sent in the FILE_LOADING_COMPLETE_EVT.
		 */
		public function get loadedData():Object
		{
			return _loadedData;
		}//end get loadedData()
		
		private function completeHandler(event:Event):void
		{
            var loader:URLLoader = event.target as URLLoader;
			
			if(!loader)
			{
				//throw new Error(this.name + "::completeHandler(): WARNING -- loader=" + loader);
				log.warn(this.name + ".completeHandler(): event.target=" + event.target 
													+ " is *NOT* a URLLoader!!!");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
			}
			
			this.removeListeners(loader);
			//
			_loadedData = loader.data;
			this.dispatchEvent(new UrlLoadedFileEvent(FileLoader.FILE_LOADING_COMPLETE_EVT, loader.data));
			
        }//end completeHandler()
		
		private function openHandler(event:Event):void
		{
            var loader:URLLoader = event.target as URLLoader;
			
			if(!loader)
			{
				//throw new Error(this.name + ".openHandler(): event.target is *NOT* a URLLoader!!!");
				log.warn(this.name + ".openHandler(): event.target=" + event.target 
													+ " is *NOT* a URLLoader!!!");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
			}
			
			//
			
        }//end openHandler()
		
        private function progressHandler(event:ProgressEvent):void
		{
            //
			
			var loader:URLLoader = event.target as URLLoader;
			
			if(!loader)
			{
				//throw new Error(this.name + ".progressHandler(): event.target is *NOT* a URLLoader!!!");
				log.warn(this.name + ".progressHandler(): event.target=" + event.target 
													+ " is *NOT* a URLLoader!!!");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
			}
			
			this.dispatchEvent(event);
			
        }//end progressHandler()
		
        private function securityErrorHandler(event:SecurityErrorEvent):void
		{
            //
			
			var loader:URLLoader = event.target as URLLoader;
			
			if(!loader)
			{
				//throw new Error(this.name + ".securityErrorHandler(): event.target is *NOT* a URLLoader!!!");
				log.warn(this.name + ".securityErrorHandler(): event.target=" + event.target 
													+ " is *NOT* a URLLoader!!!");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
			}
			
			this.removeListeners(loader);
			
			//throw new Error(this.name + ".securityErrorHandler(): Error loading file!!!");
			this.dispatchEvent(event);
			
        }//end securityErrorHandler()
		
        private function httpStatusHandler(event:HTTPStatusEvent):void
		{
            //
			
			var loader:URLLoader = event.target as URLLoader;
			
			if(!loader)
			{
				//throw new Error(this.name + ".httpStatusHandler(): event.target is *NOT* a URLLoader!!!");
				log.warn(this.name + ".httpStatusHandler(): event.target=" + event.target 
													+ " is *NOT* a URLLoader!!!");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
			}
			
        }//end httpStatusHandler()
		
        private function ioErrorHandler(event:IOErrorEvent):void
		{
            //
			
			var loader:URLLoader = event.target as URLLoader;
			
			if(!loader)
			{
				//throw new Error(this.name + ".ioErrorHandler(): event.target is *NOT* a URLLoader!!!");
				log.warn(this.name + ".ioErrorHandler(): event.target=" + event.target 
													+ " is *NOT* a URLLoader!!!");
				this.dispatchEvent(new Event(FILE_LOADER_ERROR_EVT));
			}
			
			this.removeListeners(loader);
			
			//throw new Error(this.name + ".ioErrorHandler(): Error loading file!!!");
			this.dispatchEvent(event);
			
        }//end ioErrorHandler()
		
	}//end class FileLoader
	
}//end package com.smerc.utils.File
