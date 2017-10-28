/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	
	/**
	 *	Line Segments handle a straight line connecting two given points.
	 *  This class stores a lot of precalculated values to speed up collision testing.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.2.2009
	 */
	public class AreaTransformation
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const RADIANS_PER_DEGREE:Number = Math.PI/180;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AreaTransformation():void{
			reset();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get radians():Number {
			return rotation * RADIANS_PER_DEGREE;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to return to our initial values
		 */
		 
		public function reset():void {
			x = 0;
			y = 0;
			rotation = 0;
		}	
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
