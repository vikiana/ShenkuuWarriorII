
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.SuperSearch.classes.util
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	import com.neopets.util.general.GeneralFunctions;
	
	/**
	 *	This class contains a single duplicate instance of the target display object.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@author David Cary
	 *	@since  05.24.2010
	 */
	 
	public class ClipCopier extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		protected var _content:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ClipCopier():void {
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to try duplicating the target display object.
		
		public function copy(dobj:DisplayObject):void {
			// clear previous content
			if(_content != null) {
				removeChild(_content);
			}
			// load new cloned object
			_content = GeneralFunctions.cloneObject(dobj) as DisplayObject;
			if(_content != null) {
				addChild(_content);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
