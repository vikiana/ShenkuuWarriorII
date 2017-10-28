/* AS3
	Copyright 2008
*/
package com.neopets.util.flashvars
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.util.flashvars.FlashVarManager
	
	/**
	 *	This class handles movie clips which set themselves to specific frame based on a target flash var.
	 *  By default, this class targets the "lang" var to support translated logos.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author 
	 *	@since  9.8.2009
	 */
	public class FlashVarClip extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _frameVar:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function FlashVarClip():void{
			super();
			_frameVar = "lang"; // default to the language flash var
			// set up listeners
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			addEventListener(Event.REMOVED,onRemoved);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get frameVar():String { return _frameVar; }
		
		public function set frameVar(id:String) {
			_frameVar = id;
			synchFrame();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function simply attempts to set our frame based on the target flash var
		 
		public function synchFrame():void {
			var frame_id:Object = FlashVarManager.instance.getVar(_frameVar);
			gotoAndStop(frame_id);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Try to synch our frames when we're added to the stage
		
		protected function onAddedToStage(ev:Event):void {
			if(root != null) {
				FlashVarManager.instance.initVars(root);
				synchFrame();
				removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
		}
		
		// Clear our listeners when taken off stage.
		
		protected function onRemoved(ev:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			removeEventListener(Event.REMOVED,onRemoved);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
