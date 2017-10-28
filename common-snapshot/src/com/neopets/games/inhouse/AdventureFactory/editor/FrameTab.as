
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor
{
	import flash.display.MovieClip;
	
	import com.neopets.games.inhouse.AdventureFactory.editor.GameScreenTab;
	
	/**
	 *	This tab button subclass uses an image nested in a single frame of a child movieclip.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  03.10.2010
	 */
	 
	public class FrameTab extends GameScreenTab
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _frameClip:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FrameTab():void{
			super();
			// make mouse cursor change on roll over
			buttonMode = true;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get frameClip():MovieClip { return _frameClip; }
		
		public function set frameClip(clip:MovieClip) {
			_frameClip = clip;
			if(_frameClip != null) _frameClip.gotoAndStop(1);
		}
		
		public function get targetFrame():int {
			if(_frameClip != null) return _frameClip.currentFrame;
			else return 0;
		}
		
		public function set targetFrame(frame:int) {
			if(_frameClip != null) _frameClip.gotoAndStop(frame);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}