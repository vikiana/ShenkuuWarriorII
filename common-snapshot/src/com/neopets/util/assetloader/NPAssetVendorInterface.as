/* AS3
	Copyright 2010
*/

package com.neopets.util.assetloader {
	
	/**
	 *	A very basic XML loader interface for the vendor shell
	 * Only used for vendor shell because config.xml file is not loaded by the vendor shell, so we use this to help.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 11 October 2010
	*/	
		
	import com.neopets.examples.vendorShell.document.VendorDocumentClass;
	import flash.display.MovieClip;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class NPAssetVendorInterface {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _root:MovieClip;
		private var _bios:NP9_BIOS;
		
		private var _xmlloader:URLLoader;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NPAssetVendorInterface(p_root:MovieClip):void {
			_root = p_root;
			_bios = _root.mcBIOS;
			loadConfig();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function xmlLoadComplete(e:Event):void {
			XML.ignoreWhitespace = true;
			var data:XML = new XML(e.target.data);
			//trace("[NPAssetVendorInterface] XML Loaded:\n" + data);
			NPAssetLoader.instance.processAssets(data, _root);
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		private function loadConfig():void {
			var loc:String = _bios.finalPathway;
			if (_bios.configFileVersion == 0) {
				loc += "config.xml";
			} else {
				loc += "config_v" + _bios.configFileVersion.toString() + ".xml";
			}
			trace("[NPAssetVendorInterface] Loading config file: " + loc);
			
			_xmlloader = new URLLoader();
			_xmlloader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			_xmlloader.load(new URLRequest(loc));
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}