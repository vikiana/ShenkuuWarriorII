/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	
	/**
	 *	Fixed drag reduces the target speed by a set amount each cycle.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.13.2009
	 */
	public class FixedDrag extends SpeedReducer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _loss:Number;
		protected var negLoss:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function FixedDrag(rate:Number=100):void{
			loss = rate;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get loss():Number {
			return toPerSecond(_loss);
		}
		
		public function set loss(val:Number) {
			var abs:Number = Math.abs(val);
			// acceleration is based on change in position / change in time squared
			if(_target != null) {
				var time_squared:Number = Math.pow(_target.secondsPerCycle,2);
				_loss = val * time_squared;
			} else _loss = abs;
			negLoss = -_loss;
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
				if(val > _loss) return val + negLoss;
				else return 0;
			} else {
				if(val < negLoss) return val + _loss;
				else return 0;
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
		
		public function setDeceleration(v_init:Number,v_final:Number=0,sec:Number=1):void {
			var cycles:Number = secondsToCycles(sec);
			var delta:Number;
			// calculate our net change
			if(v_init > v_final) delta = v_init - v_final;
			else delta = v_final - v_init;
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
				// acceleration is based on change in position / change in time squared
				_loss *= ratio * ratio;
				negLoss = -_loss;
			}
		}
		
	}
	
}
