/* AS3
	Copyright 2010
*/

package com.neopets.util.assetloader {

	/**
	 *	A controller used for loading external SWF resource files for Neopets gaming engine
	 * Modified on 25 October 2010 - Made this library independent of the gaming system
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 6 October 2010
	*/	

	//import com.neopets.projects.np9.system.NP9_BIOS;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class NPAssetLoader extends EventDispatcher {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		public static const ASSETS_LOADED:String = "NPAssetLoader.ASSETS_LOADED";
		public static const ASSETS_FAILED:String = "NPAssetLoader.ASSETS_FAILED";
		
		public static const instance:NPAssetLoader = new NPAssetLoader(SingletonEnforcer);
		
		private const VERSION:String = "1.0";	
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _configxml:XML;
		protected var _assetlist:Array;
		//protected var _bios:NP9_BIOS;
		protected var _root:MovieClip;
		
		protected var _assetid:int;
		
		private var _loaderdisplay:NPAssetLoaderDisplay;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NPAssetLoader(singletonEnforcer:Class = null):void {
			if (singletonEnforcer != SingletonEnforcer) {
				throw new Error( "[NPAssetLoader] Invalid Singleton access. Use NPAssetLoader.instance." ); 
			}
			trace("\n[NPAssetLoader] v" + VERSION + " started\n");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Parses the XML contents for asset files
		 * @param		p_config				XML 				The XML containing the list of asset files to load
		 * @param		p_root					MovieClip		The document object
		 * @param		p_width					int				The width of the flash document
		 * @param		p_height				int				The height of the flash document
		 * @param		p_pathway			String			The path to the resource files
		*/ 		
		public function processAssets(p_config:XML, p_root:MovieClip, p_width:int, p_height:int, p_pathway:String):void {
			_configxml = p_config;
			_root = p_root;
			//_bios = _root.mcBIOS;
			if (!_assetlist) _assetlist = [];
			var i:int = 0;
			if (_configxml.hasOwnProperty("ASSETS")) {
				for each (var asset in _configxml.ASSETS.*) {
					_assetlist.push(new NPAssetData(i, p_pathway + asset.toString(), asset.toString()));
					i ++;
				}
			}
			if (_assetlist.length > 0) {
				_loaderdisplay = new NPAssetLoaderDisplay(p_width, p_height, _root);
				_loaderdisplay.updateProgress();
				loadAsset(0);
			} else {
				trace("[NPAssetLoader] Nothing to load");
				announceEvent(ASSETS_LOADED); // nothing to load.
			}
		}
		
		/**
		 * @Note: Reports the loading progress of an asset file from NPAssetData class
		 * @param		p_asset				String 				The filename of the asset file (the ident var)
		 * @param		p_loaded			Number				The loaded ratio of the file
		*/ 		
		public function reportAssetLoadingProgress(p_asset:String, p_loaded:Number):void {
			_loaderdisplay.updateProgress(getAssetId(p_asset), _assetlist.length, p_loaded);
		}
		
		/**
		 * @Note: Reports when an asset file has completely loaded
		 * @param		p_assetdata			NPAssetData 			The reporting NPAssetData object
		*/ 		
		public function reportAssetLoaded(p_assetdata:NPAssetData):void {
			if (p_assetdata.id < (_assetlist.length - 1)) {
				loadAsset(p_assetdata.id + 1); // load the next asset in the queue
			} else {
				_loaderdisplay.clearProgress();
			}
		}
		
		/**
		 * @Note: Reports when an asset file has failed loading
		*/ 		
		public function reportAssetFailed():void {
			announceEvent(ASSETS_FAILED);
		}
		
		public function reportDisplayAnimDone():void {
			announceEvent(ASSETS_LOADED);			
			_loaderdisplay.destructor();
			_loaderdisplay = null;
		}
		
		/**
		 * @Note: Returns the loaded SWF object as a MovieClip object
		 * @param		p_assetident			String 			The String ident of the asset file - usually the filename
		 * @return									MovieClip 		The loaded SWF object
		*/ 		
		public function getAssetMc(p_assetident:String):MovieClip {
			for (var i:int = 0; i < _assetlist.length; i ++) {
				if (_assetlist[i].ident == p_assetident) {
					if (_assetlist[i].loader.content) {
						return _assetlist[i].loader.content as MovieClip;
					} else {
						return null;
					}
				}
			}
			return null;
		}
		
		/**
		 * @Note: Obtains a Class object from the loaded SWF resource's library
		 * @param		p_asset			String 			The String ident of the asset file - usually the filename
		 * @param		p_class			String 			The class name of the object residing in the library of the loaded SWF file
		 * @return							Class	 		The class reference of the library object
		*/ 		
		public function getClassFromAssetLib(p_asset:String, p_class:String):Class {
			var id:int = getAssetId(p_asset);
			if (id > -1) {
				var data:NPAssetData = _assetlist[id];
				if (data.appdomain) return data.getClassDef(p_class);
			}
			return null;
		}
		
		/**
		 * @Note: Clears all assets
		*/ 		
		public function flushAssets():void {
			for (var i:int = 0; i < _assetlist.length; i ++) {
				_assetlist[i].destructor();
				_assetlist[i] = null;
			}
			_assetlist.length = 0;
			_assetlist = null;
			_configxml = null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Initiates the loading of an asset file
		 * @param		p_id			int 			The id of the file entry in _assetlist
		*/ 		
		protected function loadAsset(p_id:int):void {
			trace("[NPAssetLoader] Loading asset file: " + _assetlist[p_id].url);
			_assetlist[p_id].loadData();
		}
		
		/**
		 * @Note: Announces an event to listeners
		 * @param		p_evt			String 			The event to announce
		*/ 		
		protected function announceEvent(p_evt:String):void {
			dispatchEvent(new Event(p_evt));
		}
		
		/**
		 * @Note: Searches the _assetlist for the ID of the asset file in question
		 * @param		p_asset			String 			The String ident of the asset file - usually the filename
		 * @return							int		 		The ID of the asset in _assetlist
		*/ 		
		protected function getAssetId(p_asset:String):int {
			for (var i:int = 0; i < _assetlist.length; i ++) {
				if (p_asset == _assetlist[i].ident) return i;
			}
			return -1;
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			flushAssets();
			//_bios = null;
		}
	}
}


/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}


