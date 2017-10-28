/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics
{
	import flash.geom.Point;
	
	/**
	 *	This class simply adds a rotation value to a point.  This lets use package
	 *  rotational changes with changes in position.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.9.2009
	 */
	public class RotationPoint extends Point
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var rotation:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function RotationPoint(ix:Number=0,iy:Number=0,ir:Number=0):void{
			super(ix,ir);
			rotation = ir;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		// Derived values
		
		public function get isZeroed():Boolean {
			if(x != 0) return false;
			if(y != 0) return false;
			if(rotation != 0) return false;
			return true;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Mimics the "+=" operator using a second point.
		 * @param		other		Point 		Point to be added to this one.
		 */
		
		public function assignAdd(other:Point):void {
			if(other == null) return;
			x +=  other.x;
			y += other.y;
			if(other is RotationPoint) {
				var rp:RotationPoint = other as RotationPoint;
				rotation += rp.rotation;
			}
		}
		
		/**
		 * @Multiplies all values by the target number.
		 * @param		multiplier		Number 		Value to multiply by
		 */
		
		public function scaleBy(multiplier:Number):void {
			x *= multiplier;
			y *= multiplier;
			rotation *= multiplier;
		}
		
		/**
		 * @Resets alll our values back to zero.
		 */
		
		public function setToZero():void {
			x = 0;
			y = 0;
			rotation = 0;
		}
		
		/**
		 *	@Converts this object to a string representation.
		 */
		
		override public function toString():String {
			return "(x:" + x + ", y:" + y + ", r:" + rotation + ")";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
