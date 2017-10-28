/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	
	/**
	 *	Speed limits simply place a maximum cap on the absolute value of the target number.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.13.2009
	 */
	public class SpeedLimit extends SpeedReducer
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
		public function SpeedLimit(max:Number=100):void{
			limit = max;
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
			if(val >= 0) {
				if(val > _limit) return _limit;
				else return val;
			} else {
				if(val < negLimit) return negLimit;
				else return val;
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
				_limit *= ratio;
				negLimit = -_limit;
			}
		}
		
	}
	
}
