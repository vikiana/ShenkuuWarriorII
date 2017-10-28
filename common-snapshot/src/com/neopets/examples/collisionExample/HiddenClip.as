
/* AS3
	Copyright 2008
*/
package com.neopets.examples.collisionExample
{
	import flash.display.MovieClip;
	
	/**
	 *	HiddenClips are simply MovieClips that are invisible when created.  They are usually used to 
	 *  set up hidden bounding areas and sentry points.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  10.21.2009
	 */
	 
	public class HiddenClip extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public static var SHOW_HIDDEN:Boolean = false;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function HiddenClip():void
		{
			visible = SHOW_HIDDEN;
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
		 
	}
	
}