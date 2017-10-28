
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.HeroHeist.classes
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	/**
	 *	This class is imported from the flash 6 version of the game.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  2.18.2010
	 */
	 
	public class SpriteClass extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SpriteClass(pX:Number,pY:Number) {
			this.initPosition(pX, pY);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//-------------------------------------------------------
		
		public function initPosition(pX, pY) {
			x = pX;
			y = pY;
		}
		
		//-------------------------------------------------------
		
		public function setRGBColor(colorObj) {
			//var c = new Color(this);
			//c.setRGB(colorObj);
			var color_trans:ColorTransform = new ColorTransform();
			color_trans.color = colorObj;
			transform.colorTransform = color_trans;
		}
		
		//-------------------------------------------------------
		
		public function setTransformColor(colorObj) {
			//var c = new Color(this);
			//c.setTransform(colorObj);
			var color_trans:ColorTransform;
			if(colorObj != null) {
				color_trans = new ColorTransform(colorObj.ra,colorObj.ga,colorObj.ba,colorObj.aa,colorObj.rb,colorObj.gb,colorObj.bb,colorObj.ab);
			}
			transform.colorTransform = color_trans;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}