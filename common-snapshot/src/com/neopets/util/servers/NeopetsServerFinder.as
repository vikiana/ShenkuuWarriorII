/* AS3
	Copyright 2009
*/
package com.neopets.util.servers
{
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.servers.ServerGroup;
	
	import flash.display.DisplayObject;
	
	/**
	 *	This class extracts the script server and image server from a display object's root url.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  4.12.2010
	 */
	public class NeopetsServerFinder extends ServerFinder 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const IMAGE_SERVER_DEV:String = "http://images50.neopets.com";
		public const IMAGE_SERVER_LIVE:String =  "http://images.neopets.com";
		public const SCRIPT_SERVER_DEV:String = "http://dev.neopets.com";
		public const SCRIPT_SERVER_LIVE:String = "http://www.neopets.com";
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NeopetsServerFinder(dobj:DisplayObject=null):void{
			super();
			_groups = new Array();
			_groups.push(new ServerGroup(SCRIPT_SERVER_DEV,IMAGE_SERVER_DEV));
			_groups.push(new ServerGroup(SCRIPT_SERVER_DEV,IMAGE_SERVER_LIVE));
			// if a display object is provided, initialize our server from that object.
			if(dobj != null) findServersFor(dobj);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function loads default values.
		
		override public function useDefaults():void {
			_isOnline = false;
			_foundGroup = _groups[0];
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
