/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import com.neopets.util.general.GeneralFunctions;
	
	/**
	 *	This class is a simple movie clip shell with special handling for pop up events.
	 *  The class is similiar to a singleton in that there should generally only be one
	 *  in existance at a time.  You can have more that one of these layers, but only
	 *  the currently active layer will pick up new pop up requests.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class PopUpLayer extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// static variables
		protected static var lastInstance:PopUpLayer;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PopUpLayer():void{
			lastInstance = this;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to add a new pop up to this movieclip.
		 * @param		type		String 		Class name of the new pop up
		 * @param		info		Object 		Initialization values for the pop up
		 * @param		id			String		Name of the pop up
		 */
		 
		public function buildPopUp(type:String,info:Object=null,id:String=null):PopUp {
			// check if we've already got this pop up
			var child:DisplayObject;
			if(id != null) child = getChildByName(id);
			var popup:PopUp;
			if(child == null) {
				// if not, create a new pop-up
				var inst:Object = GeneralFunctions.getInstanceOf(type);
				if(inst != null && inst is PopUp) {
					popup = inst as PopUp;
					if(id != null) popup.name = id;
					addChild(popup);
				}
			} else {
				// if so return the child if it's a pop up
				if(child is PopUp) popup = child as PopUp;
			}
			// initialize pop up
			if(popup != null) {
				if(info != null) popup.loadData(info);
			}
			return popup;
		}
		
		// Static Functions
		
		/**
		 * @This function tries to add a new pop up to the last pop up layer instance.
		 * @param		type		String 		Class name of the new pop up
		 * @param		info		Object 		Initialization values for the pop up
		 * @param		id			String		Name of the pop up
		 */
		 
		public static function requestPopUp(type:String,info:Object=null,id:String=null):PopUp {
			if(lastInstance != null) {
				return lastInstance.buildPopUp(type,info,id);
			} else return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}