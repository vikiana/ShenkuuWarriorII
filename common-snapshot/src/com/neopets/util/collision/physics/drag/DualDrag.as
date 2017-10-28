/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	
	/**
	 *	This class combines a proportional speed loss (LinearDrag) with fixed loss per cycle
	 *  (FixedDrag).  This makes the class good for modeling both the drag and friction of
	 *  a medium in low turbulence conditions.  It is one of the most complicated speed
	 *  reduction classes, though the proccessing cost is only slightly higher than for LinearDrag.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.18.2009
	 */
	public class DualDrag extends LinearDrag
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
		public function DualDrag(rate:Number=0.1,min:Number=1):void{
			super(rate);
			loss = min;
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
			// apply multiplier
			var product:Number = val * _multiplier;
			// apply flat loss rate
			if(product >= 0) {
				if(product > _loss) return product + negLoss;
				else return 0;
			} else {
				if(product < negLoss) return product + _loss;
				else return 0;
			}
		}
		
		/**
		 * @This tries to set the reducer to drop the speed from an initial
		 * @speed to a final speed over a target number of seconds.
		 * @param		v_init		Number 		Initial value
		 * @param		v_final		Number 		Final value
		 * @param		sec			Number 		Time to final value
		 */
		
		override public function setDeceleration(v_init:Number,v_final:Number=1,sec:Number=1):void {
			var max:Number;
			var min:Number;
			// find high and low values
			if(v_init > v_final) {
				max = v_init;
				min = v_final;
			} else {
				max = v_final;
				min = v_init;
			}
			if(max != min) {
				// Start by figuring out what the max speed would have to be if the multiplier
				// was 1 and the loss equalled our min speed.
				var cycles:Number = secondsToCycles(sec);
				var v_low:Number = (cycles + 1) * min;
				// If that value is at least equal to our actual max speed, we'd need a multiplier
				// of 1 or more.  In that case, let's use the average of the given speed as our
				// target speed.
				if(v_low >= max) v_low = (max + min) / 2;
				// Now let's try to figure the multiplier needed to hit the target speed if fixed
				// loss were 0.  Our parent class gives us..
				// solving for the multiplier gives us: multiplier = (min/max)^(1/cycles)
				_multiplier = Math.pow((v_low/max),1/cycles);
				// Now we just need to find the fixed loss
				// Each cycle: vn = vp * m - l, where m is the multiplier and l is the fixed loss
				// For a given number of cycles this becomes: vc = vi*m^c - l * (m^(c-1) + m^(c-2) + .. + 1)
				// That last part is a geometric sum, so we get: vc = vi*m^c - l * (m^c - 1) / (m - 1)
				// Solved for l we get: l = (vi*m^c - vc)(m - 1) / (m^c - 1)
				var pow:Number = Math.pow(_multiplier,cycles);
				_loss = (max*pow - min)*(_multiplier - 1)/(pow - 1);
			} else {
				// no decceleration took place
				_multiplier = 1;
				_loss = 0;
				negLoss = 0;
			}
		}
		
		/**
		 * @This function sets our multiplier so that speed caps at the target value 
		 * @for a given acceleration.
		 * @param		acc		Number 		Target acceleration
		 * @param		max		Number 		Target speed cap
		 */
		
		override public function setMaxSpeedAt(acc:Number,max:Number):void {
			// get the valid version of our parameters
			var abs_acc:Number = Math.abs(acc);
			var abs_max:Number = Math.abs(max);
			// make sure we're gaining speed faster than we're loosing it.
			if(abs_acc > _loss) {
				// assuming: vf = (vi + acc) * _multiplier - _loss
				// solve for multiplier when vf = vi
				_multiplier = (abs_max + loss) / (abs_max + abs_acc);
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
				// acceleration is based on change in position / change in time squared
				_loss *= ratio * ratio;
				negLoss = -_loss;
			}
		}
		
	}
	
}
