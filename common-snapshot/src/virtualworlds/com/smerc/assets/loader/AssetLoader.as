package virtualworlds.com.smerc.assets.loader
{				
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;

	
	import virtualworlds.com.smerc.assets.Assets;
	import virtualworlds.com.smerc.loaders.SmercImgLoader;
	import virtualworlds.com.smerc.loaders.events.ImageLoadingEvent;
	import virtualworlds.com.smerc.utils.FileLoader;
	import virtualworlds.com.smerc.utils.events.UrlLoadedFileEvent;
	
	/**
	* ...
	* @author Sam
	*/
	public class AssetLoader extends EventDispatcher
	{
		protected static const log:Logger = LogContext.getLogger(AssetLoader);

		protected static const DEFAULT_CONFIG_FILEPATH:String = "./asset-config.xml";
		
		/**
		 * A ProgressEvent specifying total bytes loaded so far and total bytes to load.
		 * The event dispatched's class is ProgressEvent.
		 */
		public static const ASSETS_LOADED_PROGRESS_EVT:String = "AssetsLoadedProgressEvent";
		
		/**
		 * An Event notifying that all assets specified in the AssetLoaderConfig.xml have been loaded.
		 * The event dispatched's class is Event.
		 */
		public static const ASSETS_LOADING_COMPLETE_EVT:String = "AssetsLoadingCompleteEvent";
		
		private var _configLoader:FileLoader;
		
		/**
		 * An array of loaders, one for each file to load.
		 */
		protected var _assetFileLoaders:Array;
		
		/**
		 * An array of Sounds, all loading simultaneously.
		 */
		protected var _loadingSounds:Array;
		
		private var _totalBytesLoaded:uint;
		private var _totalBytesToLoad:uint;
		private var _loaderProgressArr:Dictionary;
		
		private var _assets:Assets;
		
		private var assetBaseURL:String;
		/**
		 * @constructor
		 */
		public function AssetLoader(p_assetBaseURL:String = "")
		{
			//
			assetBaseURL = p_assetBaseURL;
			
			_assetFileLoaders = new Array();
			
			_loadingSounds = new Array();
			
			_loaderProgressArr = new Dictionary(true);
			
			_assets = Assets.instance;
			
		}//end AssetLoader() constructor.
		
		/**
		 * The self-destructor.  This is called upon loading completion and when errors are caught.
		 */
		protected function cleanUp():void
		{
			if(_configLoader)
			{
				_configLoader.removeEventListener(FileLoader.FILE_LOADER_ERROR_EVT, fileLoadingErrorHandler);
				_configLoader.destroy();
			}
			
			_assetFileLoaders = null;
			_loadingSounds = null;
			_loaderProgressArr = null;
			_assets = null;
			
		}//end cleanUp()
		
		/**
		 * This function is the driving force of this class.  Any listeners to this class should be added
		 * before this function is called.
		 * 
		 * @param	confPathAndFileName:	String that represents the file-path relative to the main swf to where the 
		 * 									assets to load are relative to. Ex: "../config/asset-config.xml
		 * 									@default "./asset-config.xml"
		 */
		public function init( confPathAndFileName:String = null ):void
		{
			var fullPath:String = confPathAndFileName;
			
			if (!fullPath)
			{
				fullPath = DEFAULT_CONFIG_FILEPATH;
			}
			
			_configLoader = new FileLoader();
			_configLoader.addEventListener(FileLoader.FILE_LOADER_ERROR_EVT, fileLoadingErrorHandler, false, 0, true);
			
			//
			
			_configLoader.addEventListener(FileLoader.FILE_LOADING_COMPLETE_EVT, parseConfig, false, 0, true);
			_configLoader.load(fullPath);
			
		}//end init()
		
		/**
		 * Error handler for if we fail to load our config file.
		 * 
		 * @param	a_fileLoaderEvt
		 */
		protected function fileLoadingErrorHandler(a_fileLoaderEvt:Event):void
		{			
			_configLoader.removeEventListener(FileLoader.FILE_LOADER_ERROR_EVT, fileLoadingErrorHandler);
			
			
			
		}//end fileLoadingErrorHandler()
		
		/**
		 * Initialize this AssetLoader from a pre-loaded or code-built XMLList.
		 * 
		 * @param	a_configXml:	<XMLList> The XMLList that represents an assets config file.
		 */
		public function initFromXml(a_configXml:XMLList):void
		{
			processAssets( a_configXml.assets );
			processSoundAssets(a_configXml.soundAssets);
			
		}//end initFromXml()
		
		/**
		 * The handler for when we successfully load our config file.
		 * 
		 * @param	fileLoadedEvt: A UrlLoadedFileEvent containing our url-loaded file.
		 */
		protected function parseConfig( fileLoadedEvt:UrlLoadedFileEvent):void
		{
			var config:Object = fileLoadedEvt.fileObj;
			_configLoader.removeEventListener(FileLoader.FILE_LOADING_COMPLETE_EVT, parseConfig);
			_configLoader.removeEventListener(FileLoader.FILE_LOADER_ERROR_EVT, fileLoadingErrorHandler);
			
			var assetLoaderConfig:XML = new XML( config );
			
			/** The config file no longer needs to be called assetLoaderCfg, it only needs to have nodes 'assets' and/or 'soundAssets'.
			if ( !assetLoaderConfig || (assetLoaderConfig.name() != "assetLoaderCfg") )
			{
				throw new Error("AssetLoader::parseConfig(): Corrupt config file! Loaded config=" + config);
			}
			/**/
			
			processAssets( assetLoaderConfig.assets );
			processSoundAssets(assetLoaderConfig.soundAssets);
			
		}//end configFileLoaded()
		
		/**
		 * Add a swf-asset to load from this AssetLoader.  
		 * This is called internally from processAssets() if a config file was used to load the assets.
		 * 
		 * @param	a_url:			<String> of the url where the swf exists.
		 * @param	a_context:		<String @default null> Key the ApplicationDomain where this swf's class definitions are to reside.  
		 * 							If null (the default), then the ApplicationDomain.currentDomain is used.
		 * @param	a_bForceReload:	<Boolean @default false> Force-reload the swf (prevent browser caching).
		 */
		public function addSwfAssetToLoad(a_url:String, a_context:String = null, a_bForceReload:Boolean = false):void
		{
			var appDomain:ApplicationDomain;
			
			if ( a_context && a_context != "" )
			{
				//
				appDomain = new ApplicationDomain();
				appDomain = _assets.addNewContext(a_context, appDomain);
			}
			else
			{
				//
				appDomain = ApplicationDomain.currentDomain;
			}
			
			var ldrContext:LoaderContext = new LoaderContext();
			ldrContext.applicationDomain = appDomain;
			
			var ldr:SmercImgLoader = new SmercImgLoader();
			_assetFileLoaders.push(ldr);
			
			ldr.addEventListener( Event.COMPLETE, onAssetFileLoadComplete )
			this.configureListeners(ldr);
			
			ldr.load(a_url, ldrContext, a_bForceReload);
			
		}//end addSwfAssetToLoad()
		
		private function processAssets( assets:XMLList ):void
		{		
			//
			
			// Will we be force-reloading our listed assets?
			var bForceReload:Boolean = false;
			
			// The assets' 'forceReload' attribute, should it exist.
			var forceReloadStr:String = assets.@forceReload;
			if (forceReloadStr.length && (!(forceReloadStr == "0" || forceReloadStr.toLowerCase() == "false")))
			{
				// Something was entered in the forceReload attribute, and it was *not* 0, false, or FALSE.
				bForceReload = true;
			}
			
			for each ( var asset:XML in assets.children() )
			{
				var relPath:String = asset.@fileName;
				
				var appDomain:ApplicationDomain;
				
				var context:String = asset.@context;
				
				addSwfAssetToLoad(assetBaseURL + relPath, context, bForceReload);
			}
			
		}//end processAssets()
		
		/**
		 * This adds an mp3-asset to load as a Sound.  
		 * This is called internally from processSoundAssets().
		 * 
		 * @param	a_url:			<String> The url of the mp3 to load as a Sound.
		 * @param	a_bForceReload:	<Boolean @default false> 
		 */
		public function addMp3AssetToLoad(a_url:String, a_bForceReload:Boolean = false):void
		{
			var snd:Sound = new Sound();
			_loadingSounds.push(snd);
			Assets.instance.addSound(a_url, snd);
			
			snd.addEventListener(Event.COMPLETE, onAssetFileLoadComplete);
			
			this.configureListeners(snd);
			
			var urlReq:URLRequest = new URLRequest(a_url);
			
			if (a_bForceReload)
			{
				var urlVars:URLVariables = new URLVariables();
				
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
				
				// urlVars.forceReload = getTimer() + Math.random();
				
				urlReq.data = urlVars;
				urlReq.method = URLRequestMethod.POST;
			}
			
			snd.load(urlReq);
			
		}//end addMp3AssetToLoad()
		
		private function processSoundAssets( a_soundAssets:XMLList ):void
		{
			if (!a_soundAssets)
			{
				return;
			}
			
			// Will we be force-reloading our listed assets?
			var bForceReload:Boolean = false;
			
			// The assets' 'forceReload' attribute, should it exist.
			var forceReloadStr:String = a_soundAssets.@forceReload;
			if (forceReloadStr.length && (!(forceReloadStr == "0" || forceReloadStr.toLowerCase() == "false")))
			{
				// Something was entered in the forceReload attribute, and it was *not* 0, false, or FALSE.
				bForceReload = true;
			}
			
			for each(var soundAsset:XML in a_soundAssets.children())
			{
				//
				
				var relPath:String = soundAsset.@fileName;
				
				addMp3AssetToLoad(assetBaseURL + relPath, bForceReload);
			}
			
		}//end processSoundAssets()
		
		/**
		 * Handler for each utility asset that's loaded.
		 * When all assets are loaded, dispatches the AssetLoader.ASSETS_LOADING_COMPLETE_EVT.
		 * 
		 * @param	evt
		 */
		protected function onAssetFileLoadComplete( evt:Event = null):void
		{
			//
			
			var evtDispatcher:IEventDispatcher = evt ? evt.target as IEventDispatcher : null;
			if (evtDispatcher)
			{
				// Remove the listener that got us here.
				evtDispatcher.removeEventListener(Event.COMPLETE, onAssetFileLoadComplete);
			}
			
			var ldr:SmercImgLoader = evt ? evt.target as SmercImgLoader : null;
			var loadedSnd:Sound =  evt ? evt.target as Sound : null;
			
			if (ldr)
			{
				// A swf/image was loaded.
				
				var indexOfLoaderToRemove:int = _assetFileLoaders.indexOf(ldr);
				if (indexOfLoaderToRemove >= 0)
				{
					_assetFileLoaders.splice(indexOfLoaderToRemove, 1);
				}
			}
			else if (loadedSnd)
			{
				// A sound was loaded.
				var indexOfSndToRemove:int = _loadingSounds.indexOf(loadedSnd);
				if (indexOfSndToRemove >= 0)
				{
					_loadingSounds.splice(indexOfSndToRemove, 1);
				}
			}
			
			// Check to see if our loading is complete.
			if (!_assetFileLoaders.length && !_loadingSounds.length)
			{
				//
				
				this.dispatchEvent(new Event(AssetLoader.ASSETS_LOADING_COMPLETE_EVT));
				this.dispatchEvent(new Event(Event.COMPLETE));
				
				this.cleanUp();
			}
			
		}//end onAssetFileLoadComplete()
		
		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingError);
			
		}//end configureListeners()
		
		private function removeListeners(a_dispatcher:IEventDispatcher):void
		{
			a_dispatcher.removeEventListener( ProgressEvent.PROGRESS, progressHandler);
            a_dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            a_dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			a_dispatcher.removeEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingError);
			
		}//end removeListeners()
		
		private function progressHandler(a_progressEvt:ProgressEvent):void
		{
            var ldr:SmercImgLoader = a_progressEvt.target as SmercImgLoader;
			var snd:Sound = a_progressEvt.target as Sound;
			
			if(ldr)
			{
				setProgressForLoader(a_progressEvt.bytesLoaded, a_progressEvt.bytesTotal, ldr);
			}
			else if(snd)
			{
				setProgressForLoader(a_progressEvt.bytesLoaded, a_progressEvt.bytesTotal, snd);
			}
			
        }//end progressHandler()
		
		/**
		 * This dispatches the AssetLoader.ASSETS_LOADED_PROGRESS_EVT specifying total bytes to load so far, 
		 * and total bytes loaded so far.
		 * 
		 * @param	a_bytesLoaded:	uint number of bytes loaded for a particular file.
		 * @param	a_bytesTotal:	uint number of bytes total for a particular file.
		 * @param	a_loadedObj:	The SmercImgLoader for a particular file that's loading, *OR* a loading Sound.
		 */
		protected function setProgressForLoader(a_bytesLoaded:uint, a_bytesTotal:uint, a_loadedObj:*):void
		{
			// The dictonary reference to the loading object inside of the _loaderProgressArr (dictionary)
			var tmpObj:Object;
			
			// Update our dictionary reference, should it exist.
			if (a_loadedObj && _loaderProgressArr[a_loadedObj] != undefined)
			{
				tmpObj = _loaderProgressArr[a_loadedObj] as Object;
				tmpObj.bytesLoaded = a_bytesLoaded;
				tmpObj.bytesTotal = a_bytesTotal;
			}
			
			if (!tmpObj && a_loadedObj)
			{
				// We haven't registered this loader in the array, yet.  Add it.
				tmpObj = {bytesLoaded:a_bytesLoaded, bytesTotal:a_bytesTotal };
				_loaderProgressArr[a_loadedObj] = tmpObj;
			}
			
			checkTotalProgress();
			
		}//end setProgressForLoader()
		
		private function checkTotalProgress():void
		{
			// Clear our values before tallying.
			_totalBytesLoaded = 0;
			_totalBytesToLoad = 0;
			
			// Tally totals
			for each(var element:Object in _loaderProgressArr)
			{
				_totalBytesLoaded += (element.bytesLoaded as uint);
				_totalBytesToLoad += (element.bytesTotal as uint);
			}
			
			// Dispatch the current value of all total bytes loaded so far.
			this.dispatchEvent(new ProgressEvent(AssetLoader.ASSETS_LOADED_PROGRESS_EVT, false, false, _totalBytesLoaded, _totalBytesToLoad));
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _totalBytesLoaded, _totalBytesToLoad));
			
		}//end checkTotalProgress()
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			
			
			log.warn("AssetLoader::securityErrorHandler()");
			
            var evtDispatcher:IEventDispatcher = event.target as IEventDispatcher;
			
			this.removeListeners(evtDispatcher);
			
			removeFromList(event.target);
			
        }//end securityErrorHandler()
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
            
			
			log.warn("AssetLoader::ioErrorHandler()");
			
			var evtDispatcher:IEventDispatcher = event.target as IEventDispatcher;
			
			this.removeListeners(evtDispatcher);
			
			removeFromList(event.target);
			
        }//end ioErrorHandler()
		
		private function imageLoadingError(a_imgLoadingEvt:ImageLoadingEvent):void
		{
			
			
			log.warn("AssetLoader::imageLoadingError(): Error loading img=\n" 
												+ a_imgLoadingEvt.getErrorStr());
			
			var evtDispatcher:IEventDispatcher = a_imgLoadingEvt.target as IEventDispatcher;
			
			this.removeListeners(evtDispatcher);
			
			removeFromList(a_imgLoadingEvt.target);
			
		}//end imageLoadingError()
		
		private function removeFromList(a_obj:Object):void
		{
			var snd:Sound = a_obj as Sound;
			var ldr:SmercImgLoader = a_obj as SmercImgLoader;
			
			var indexToRemove:int = -1;
			
			if (ldr)
			{
				indexToRemove = _assetFileLoaders.indexOf(ldr);
				if (indexToRemove >= 0)
				{
					_assetFileLoaders.splice(indexToRemove, 1);
				}
			}
			
			if (snd)
			{
				indexToRemove = _loadingSounds.indexOf(snd);
				if (indexToRemove >= 0)
				{
					_loadingSounds.splice(indexToRemove, 1);
				}
			}
			
			if (_loaderProgressArr[a_obj] != undefined)
			{
				delete _loaderProgressArr[snd];
			}
			
			// Finally, if the loading item was the last in the list, then we may be complete, 
			// pretend that the image dispatched a complete my calling its complete-handler.
			onAssetFileLoadComplete();
			
		}//end removeFromList()
		
	}//end class AssetLoader
	
}//end com.smerc.loaders
