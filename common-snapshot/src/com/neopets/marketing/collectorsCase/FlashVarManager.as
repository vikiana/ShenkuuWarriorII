/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.LoaderInfo;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 *	This class provides global access to all flash vars while also letting you set
	 *  default values for any of those vars.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class FlashVarManager
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_INIT:String = "initialized";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected static var flashVars:Object;
		protected static var _dispatcher:EventDispatcher;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function FlashVarManager():void{
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get dispatcher():EventDispatcher {
			if(_dispatcher == null) _dispatcher = new EventDispatcher();
			return _dispatcher;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to find the target server string and covert it to a full url.
		 * @The function also makes sure subdirectories are separated by a slash so they don't
		 * @run into the the server url.
		 * @param		server			String 		Name of the flash var
		 * @param		directory		String 		URL to be appended to our base URL
		 */
		
		public static function getURL(server:String,directory:String=null):String {
			// get the base path
			if(flashVars != null && server in flashVars) {
				var full_path:String = flashVars[server];
				// check if our server already starts with http
				if(full_path.indexOf("http://") < 0) full_path = "http://" + full_path;
				// check if we were given a valid directory
				if(directory != null && directory.length > 0) {
					// check what our path ends with
					var last_char:String = full_path.charAt(full_path.length-1);
					// check what the target directory starts with
					if(directory.charAt(0) == "/") {
						// check if our path ends in a '/'
						if(last_char == "/") full_path += directory.substr(1);
						else full_path += directory;
					} else {
						// check if our path ends in a '/'
						if(last_char == "/") full_path += directory;
						else full_path += "/" + directory;
					}
				}
				return full_path;
			} else return directory;
		}
		
		/**
		 * @Use this function to try finding the target variable.
		 * @param		id			String 		Name of the flash var
		 */
		 
		public static function getVar(id:String):Object {
			if(flashVars == null) return null;
			if(id in flashVars) return flashVars[id];
			else return null;
		}
		
		/**
		 * @Use this function extracts values from the root object.
		 * @param		root_obj	Object 		Refernce to the root level
		 */
		 
		public static function initVars(root_obj:Object):void {
			if(flashVars == null) flashVars = new Object();
			// get the root loader
			var prop:Object;
			if("loaderInfo" in root_obj) {
				prop = root_obj.loaderInfo;
				if(prop is LoaderInfo) {
					var info:LoaderInfo = prop as LoaderInfo;
					// extract the loader parameters
					var params:Object = info.parameters;
					if(params != null) {
						for(var i:String in params) {
							flashVars[i] = params[i];
						} // end of parameter loading loop
					} // end of parameters check
				}
			} // end of loader check
			dispatcher.dispatchEvent(new Event(ON_INIT));
		}
		
		/**
		 * @Use this function to set up a default value for the variable.
		 * @param		id			String 		Name of the flash var
		 * @param		val			Object 		Value being assigned to the variable
		 */
		 
		public static function setDefault(id:String,val:Object):void {
			if(flashVars == null) flashVars = new Object();
			// check if the value has already been set
			if(!(id in flashVars)) flashVars[id] = val;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}