/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	
	/**
	 *	This class add a minimum speed value to linear drag, allowing the speed to drop to 0
	 *  when it gets low enough.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.18.2009
	 */
	public class LinearDragLimit extends LinearDrag
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _limit:Number;
		protected var negLimit:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LinearDragLimit(rate:Number=0.1,min:Number=1):void{
			super(rate);
			limit = min;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get limit():Number { return toPerSecond(_limit); }
		
		public function set limit(val:Number) {
			var abs:Number = Math.abs(val);
			_limit = toPerCycle(abs);
			negLimit = -_limit;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function returns a scaled down version of the target value.
		 * @param		val		Number 		Value to be reduced
		 */
		
		override public function reduce(val:Number):Number {
			// apply multiplier
			var product:Number = val * _multiplier;
			// check if the product is below our min speed
			if(product >= 0) {
				if(product > _limit) return product;
				else return 0;
			} else {
				if(product < negLimit) return product;
				else return 0;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Multiplies change rates by the given multiplier.
		 */
		
		override protected function scalePacing(ratio:Number):void {
			if(isNaN(ratio)) return;
			if(ratio != 1) {
				// If time scales up by x, x of the previous cylces would have been called
				// in the same time period.
				multiplier = Math.pow(_multiplier,ratio);
				// scale our min speed
				_limit *= Math.pow(ratio,2);
				negLimit = -_limit;
			}
		}
		
	}
	
}
