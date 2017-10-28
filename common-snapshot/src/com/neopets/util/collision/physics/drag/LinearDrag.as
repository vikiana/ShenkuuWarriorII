/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	
	/**
	 *	This class use a multiplier to reduce the target's speed by a given percentage each cycle.
	 *  Note that this form of drag will not reduce speed to 0.  Instead the target slows to an
	 *  increasingly small speed indefinately.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.17.2009
	 */
	public class LinearDrag extends SpeedReducer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _multiplier:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function LinearDrag(rate:Number=0.1):void{
			_multiplier = rate;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get multiplier():Number {
			// apply time scaling if applicable
			if(_target != null) {
				// get cycles in one second
				var cycles:Number = 1 / _target.secondsPerCycle;
				// apply multiplier once per cycle
				return Math.pow(_multiplier,cycles);
			} else return _multiplier;
		}
		
		public function set multiplier(val:Number) {
			var constrained:Number = Math.min(Math.max(0,val),1);
			// apply time scaling if applicable
			if(_target != null) {
				// If time scales up by x, x of the previous cylces would have been called
				// in the same time period.
				var sec:Number = _target.secondsPerCycle;
				_multiplier = Math.pow(_multiplier,sec);
			} else _multiplier = constrained;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function returns a scaled down version of the target value.
		 * @param		val		Number 		Value to be reduced
		 */
		
		override public function reduce(val:Number):Number {
			return val * _multiplier;
		}
		
		/**
		 * @This tries to set the reducer to drop the speed from an initial
		 * @speed to a final speed over a target number of seconds.
		 * @param		v_init		Number 		Initial value
		 * @param		v_final		Number 		Final value
		 * @param		sec			Number 		Time to final value
		 */
		
		public function setDeceleration(v_init:Number,v_final:Number=1,sec:Number=1):void {
			var max:Number;
			var min:Number;
			// find high and low values
			if(v_init > v_final) {
				max = v_init;
				min = v_final;
			} else {
				max = v_init;
				min = v_final;
			}
			// find the multiplier needed
			// assume min = max * multiplier ^ cycles
			// solving for the multiplier gives us: multiplier = (min/max)^(1/cycles)
			// since 1/cycles ~= seconds per cycle..
			if(_target != null) {
				_multiplier = Math.pow((min/max),_target.secondsPerCycle);
			} else _multiplier = min / max;
		}
		
		/**
		 * @This function sets our multiplier so that speed caps at the target value 
		 * @for a given acceleration.
		 * @param		acc		Number 		Target acceleration
		 * @param		max		Number 		Target speed cap
		 */
		
		public function setMaxSpeedAt(acc:Number,max:Number):void {
			if(_target != null) {
				// convert to absolute values per cycle
				var sec:Number = _target.secondsPerCycle;
				var apc:Number = Math.abs(acc) * Math.pow(sec,2);
				var vpc:Number = Math.abs(max) * sec;
				// calculate our multiplier
				_multiplier = vpc / (apc + vpc);
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
			}
		}
		
	}
	
}
