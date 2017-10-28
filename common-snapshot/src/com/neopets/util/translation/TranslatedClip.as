/* AS3
	Copyright 2008
*/
package com.neopets.util.translation
{
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	
	/**
	 *	This class handles movie clips which display separate images for different languages.
	 *  This is primarily used for translated logos.
	 *  NP9_Prize_Pop_Up indirectly uses this as it's onTranslatedImageLoaded function tries to 
	 *  set the language property of the loaded movieclip.
	 *
	 *  Note: This class has been outdated by com.neopets.util.flashvars.FlashVarClip.
	 *  However, older code such as the prize pop up may still use this.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	public class TranslatedClip extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _language:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TranslatedClip():void{
			language = "en";
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get language():String { return _language; }
		
		public function set language(lang:String) {
			if(_language != lang) {
				_language = lang;
				synchFrames(this,_language);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries setting the target clip and it's descendants to the same frame
		 * @if possible.  Recursion is used to synch the descendants.
		 * @param		clip		MovieClip 		Clip being synched
		 * @param		frame		String 			Name of the target frame
		 */
		 
		public static function synchFrames(target:DisplayObjectContainer,frame:String) {
			if(target == null || frame == null) return;
			var i:int;
			// try to go to the target frame
			if(target is MovieClip) {
				var clip:MovieClip = target as MovieClip;
				// cycle through the frame labels list so we don't try an invalid goto
				var labels:Array = clip.currentLabels;
				var cur_label:FrameLabel;
				frame = frame.toLowerCase();
				for(i = 0; i < labels.length; i++) {
					cur_label = labels[i];
					if(cur_label.name == frame) {
						clip.gotoAndStop(cur_label.frame);
						break;
					}
				} // end of list checking cycle
			}
			// cycle through all children
			var child:DisplayObject;
			for(i = 0; i < clip.numChildren; i++) {
				child = clip.getChildAt(i);
				if(child is DisplayObjectContainer) {
					synchFrames(child as DisplayObjectContainer,frame);
				}
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
