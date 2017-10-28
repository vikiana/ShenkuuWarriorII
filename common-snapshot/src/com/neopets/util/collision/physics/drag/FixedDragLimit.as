/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	
	/**
	 *	This class adds a speed limit on top of the base class' fixed reduction per cycle.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.13.2009
	 */
	public class FixedDragLimit extends FixedDrag
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
		public function FixedDragLimit(rate:Number=100,max:Number=100):void{
			loss = rate;
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
			var reduced:Number;
			if(val >= 0) {
				if(val > _loss) {
					reduced = val + negLoss;
					if(reduced > _limit) return _limit;
					else return reduced;
				} else return 0;
			} else {
				if(val < negLoss) {
					reduced = val + _loss;
					if(reduced < negLimit) return negLimit;
					else return reduced;
				} else return 0;
			}
		}
		
		/**
		 * @This tries to set the reducer to drop the speed from an initial
		 * @speed to a final speed over a target number of seconds.
		 * @This function will be overriden by most sub-classes.
		 * @param		v_init		Number 		Initial value
		 * @param		v_final		Number 		Final value
		 * @param		sec			Number 		Time to final value
		 */
		
		override public function setDeceleration(v_init:Number,v_final:Number=0,sec:Number=1):void {
			var cycles:Number = secondsToCycles(sec);
			var delta:Number;
			// calculate our net change
			if(v_init > v_final) {
				delta = v_init - v_final;
				limit = v_init;
			} else {
				delta = v_final - v_init;
				limit = v_final;
			}
			// calculate change per cycle
			loss = delta / cycles;
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
				// acceleration is based on change in position / change in time squared
				_loss *= ratio * ratio;
				negLoss = -_loss;
			}
		}
		
	}
	
}
