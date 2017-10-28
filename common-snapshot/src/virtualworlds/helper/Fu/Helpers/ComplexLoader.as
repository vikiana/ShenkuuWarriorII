package virtualworlds.helper.Fu.Helpers
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	

	/**
	* A class that handles security sandbox access and application domain
	* management when loading assets in flash.
	* 
	* TODO: support sound files
	* 
	* @author Dan Johnston
	*/ 
	public class ComplexLoader
	{
		private var image_pattern:RegExp = new RegExp("^.+\.((jpg)|(gif)|(jpeg)|(png)|(tif))$","i");
		private var swf_pattern:RegExp = new RegExp("^.+\.((swf))$","i");
		private var xml_pattern:RegExp = new RegExp("^.+\.((xml))$","i");
		private var loader:Loader;
		private var url_loader:URLLoader;
		private var unc:String;
		private var type:String;
		private var asset_types:Dictionary;
		
		
		public function ComplexLoader(unc:String):void
		{
			//TODO: add more patterns for different kinds of assets
			
			asset_types = new Dictionary();
			asset_types["swf"] = swf_pattern;
			asset_types["image"] = image_pattern;
			asset_types["xml"] = xml_pattern;
			this.unc = unc;
			//var sub : String = this.unc.split("nullassets").join("assets");
			//
			//this.unc = sub;
			this.loader = new Loader();
			this.url_loader = new URLLoader();
			
			this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			
			determineAssetTypeToLoad();
			
			
		}//end Constructor
		
		
		/**
		 * Returns the contentLoaderInfo Object.
		 */ 
		public function get contentLoaderInfo():LoaderInfo
		{
			
			return this.loader.contentLoaderInfo;
						
		}//end contentLoaderInfo()
		
		
		/**
		 * Returns the Display Object content.
		 */ 
		public function get content():DisplayObject
		{
			return this.loader.content;
						
		}//end content()
		
		/**
		 * Determines the asset type given the UNC.
		 * 
		 * @private
		 */ 
		private function determineAssetTypeToLoad():void
		{
			for(var item:String in asset_types)
			{
				if(asset_types[item].exec(this.unc) != null)
				{
					this.type = item;
				}
				
			}//end for each
			
		
			
			
		}//end determineAssetTypeToLoad()
		
		/**	
		 * Loads the asset type.
		 * 
		 */ 
		public function load():void
		{
			switch(this.type)
			{
				case "swf":
					loadSwfOrImage();
				break;
				
				case "image":
					loadSwfOrImage();
				
				break;
				
				case "xml":
					loadXML();
				break;
				
				default:
					throw new Error("CompexLoader:: file type not supported for file "+this.unc);
			
					
				break;
				
				
			}//end switch
			
		}//end load()
		
		/**
		 * loads a swf or image file with proper security and app domain priviliges.
		 * @private
		 */ 
		private function loadSwfOrImage():void
		{
			var context:LoaderContext;
			
			
			switch(Security.sandboxType)
			{
				case Security.LOCAL_TRUSTED:
				
					context = new LoaderContext(true,ApplicationDomain.currentDomain);
				
				break;
				
				
				case Security.REMOTE:
				
					context = new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
				
				break;
				
				
				case Security.LOCAL_WITH_FILE:
				
					context = new LoaderContext(true,ApplicationDomain.currentDomain);
				
				break;
				
				case Security.LOCAL_WITH_NETWORK:
				
					//not quite sure what to do here??
					context = new LoaderContext(true,ApplicationDomain.currentDomain);
				
				break;
				
				
			}//end switch
			
			
			var url_request:URLRequest = new URLRequest(this.unc);
		 	
		 	if(context != null)
		 	{
		 		this.loader.load(url_request,context);	
		 	}else{
		 		this.loader.load(url_request);
		 	}
		 	
			
		}//end loadSwfOrImage()
		
		
		/**
		 * loads an XML file.
		 * @private
		 */ 
		private function loadXML():void
		{	
			var url_request:URLRequest = new URLRequest(this.unc);
		 	this.url_loader.load(url_request);
			
		}//end loadXML()
		
		/**
		 * Adds an event listener to the ComplexLoader.
		 * 
		 */ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			switch(this.type)
			{
				
				case "swf":
					this.loader.addEventListener(type,listener,useCapture,priority,useWeakReference);
				break;
				
				case "image":
					this.loader.addEventListener(type,listener,useCapture,priority,useWeakReference);
				
				break;
				
				case "xml":
					this.url_loader.addEventListener(type,listener,useCapture,priority,useWeakReference);
				break;
				
				
				
			}//end switch
			
			
		}//end addEventListener()
		
		
		/**
		 * Removes an event listener from the ComplexLoader.
		 * 
		 */ 
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			
			
			switch(this.type)
			{
				case "swf":
					this.loader.removeEventListener(type,listener,useCapture);
				break;
				
				case "image":
					this.loader.removeEventListener(type,listener,useCapture);
				
				break;
				
				case "xml":
					this.url_loader.removeEventListener(type,listener,useCapture);
				break;
				
				
				
			}//end switch
			
			
		}//end addEventListener()
		
		/**
		 * Handles all IO errors.
		 * 
		 * @private
		 * @param	e the error event
		 */
		private function handleIOError(e:IOErrorEvent):void 
		{
			throw new Error(this.unc +"::"+ e.toString() );			
			
		}//handleIOError()
		
		/**
		 * Wrapper method for loader object.
		 * 
		 * @param	var index
		 * @return A display object
		 */
		public function getChildAt(index:int):DisplayObject
		{
			return this.loader.getChildAt(index);
			
		}//getChildAt()
		
		

	}
}