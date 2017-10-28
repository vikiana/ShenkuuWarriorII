package virtualworlds.helper.Fu.Helpers
{	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import virtualworlds.helper.Fu.BaseClasses.BasicClass;
	import virtualworlds.helper.Fu.BaseEvents.ConnectorEvent;
	
	public class SwfLoader extends BasicClass
	{
		
		private var _listOfConnectorLocations:Array
		private var _contentDictionary:Dictionary = new Dictionary()
		private var _index:uint
		private var _loaded:uint
		private var loader:Loader
		
		private var assetBaseURL:String;
		private var swfVersions:Object;
		private var urlRewriteOn:Boolean;
		
		public function SwfLoader(p_assetBaseUrl:String, p_swfVersions:Object, p_urlRewriteOn:Boolean)
		{
			output("New ClassConnector")
			assetBaseURL = p_assetBaseUrl;
			swfVersions = p_swfVersions;
			urlRewriteOn = p_urlRewriteOn;
		}
		
		public function get contentDictionary():Dictionary
		{
			return _contentDictionary;
		}
		
		// use this function to get a copy of the timeline you want
		public function getContentTimelineClass(aContentName:String):Class{
			output("Returning timeline class")
			if(_contentDictionary[aContentName])
			{
				return _contentDictionary[aContentName].loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(_contentDictionary[aContentName]))
			}else{
				error("There is no swf of that name")
			}
			return null
		}
		
		public function getLoaderContent(aContentName:String):MovieClip 
		{
			if(_contentDictionary[aContentName])
			{
				return _contentDictionary[aContentName]	
			}
			else
			{
				error("There is no swf of that name" + aContentName);
			}
			return null;
		}
		// use this function to get a library item 
		public function getContentFromLibrary(aContentName:String, aLibraryItem:String):Class{
			output("Returning interal class from: " + _contentDictionary[aContentName])
			if(_contentDictionary[aContentName])
			{
				return _contentDictionary[aContentName].loaderInfo.applicationDomain.getDefinition(aLibraryItem)
			}else{
				error("There is no swf of that name" + aContentName + ":" + aLibraryItem)
			}
			return null
		}
		
		// removes a loaded content object
		public function deleteContent(aContentName:String):void{
			output("Deleting loader: " + _contentDictionary[aContentName])
			
			if(_contentDictionary[aContentName]){
				var mc:MovieClip = _contentDictionary[aContentName]
				delete _contentDictionary[aContentName]
			}else{
				error("There is no swf of that name")
			}
		}
		
		// loads an array of strings baby
		public function connect(aListOfConnectorLocations:Array):void
		{
			_listOfConnectorLocations = aListOfConnectorLocations
			_index = 0
			_loaded = 0
			loadNextItem()
		}
		
		private function loadNextItem():void{
			if(_listOfConnectorLocations[_index]){
				loader = new Loader();
				
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true)

				var url:String = _listOfConnectorLocations[_index]
				
				// Added by Sean Wylie (Feb 2 2009)
				// Intercept and Append Version
				var newUrl:String = assetBaseURL + getVersionOf(url);
				
				var urlReq:URLRequest = new URLRequest(newUrl);
				var separateDefinitions:LoaderContext = new LoaderContext();
				separateDefinitions.applicationDomain = new ApplicationDomain();				
				
				loader.load(urlReq, separateDefinitions);
				
			}else{
				var event:ConnectorEvent = new ConnectorEvent(ConnectorEvent.ALLITEMSLOADED, null, _index, _listOfConnectorLocations.length)
				this.dispatchEvent(event)			
			}

		}
		
		
		public function getVersionOf(url:String):String
		{
			if (urlRewriteOn && swfVersions[url]) 
			{
				// Rewrite Url
				var indexOfSwf:int = url.indexOf("swf");
				var rewriteUrl:String = url.substring(0, indexOfSwf)+"R"+swfVersions[url]+".swf";
				;
				url = rewriteUrl;
			}
			return url;
		}
		
		private function completeHandler(e:Event):void{
			_contentDictionary[_listOfConnectorLocations[_index]] = loader.content
			_loaded++
			_index++
			var event:ConnectorEvent = new ConnectorEvent(ConnectorEvent.ITEMLOADED, loader.content,_index,_listOfConnectorLocations.length)
			this.dispatchEvent(event)
			loadNextItem()
		}
		
		
		
		private function ioErrorHandler(e:IOErrorEvent):void{
			output(e + " ERROR LOADING SWF: " + _listOfConnectorLocations[_index] + " TRYING AGAIN!");
			error(e + " ERROR LOADING SWF: " + _listOfConnectorLocations[_index] + " TRYING AGAIN!");
			_index++;
			loadNextItem();
		}
		
		private function progressHandler(e:ProgressEvent):void{
			var event:ConnectorEvent = new ConnectorEvent(ConnectorEvent.ITEMPROGRESS, loader.content,_index,_listOfConnectorLocations.length)
			this.dispatchEvent(event)
		}
	}
}