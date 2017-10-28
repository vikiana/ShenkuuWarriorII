/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics
{
	
	/**
	 *	Use this as a base class for objects whos values are dependant on the cycle 
	 *  rate of a phyics handler.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  11.13.2009
	 */
	public class ChangeOverTime
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _target:PhysicsHandler;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ChangeOverTime(handler:PhysicsHandler=null):void{
			target = handler;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get target():PhysicsHandler { return _target; }
		
		public function set target(handler:PhysicsHandler) {
			if(_target != handler) {
				// clear previous target
				if(_target != null) {
					_target.removeEventListener(PhysicsHandler.CYCLE_RATE_CHANGED,onTimeChange);
					// find timing ratio
					if(handler != null) scalePacing(handler.secondsPerCycle / _target.secondsPerCycle);
					else scalePacing(1 / _target.secondsPerCycle);
				} else {
					// find timing ratio
					if(handler != null) scalePacing(handler.secondsPerCycle);
				}
				// set up new target
				_target = handler;
				if(_target != null) {
					_target.addEventListener(PhysicsHandler.CYCLE_RATE_CHANGED,onTimeChange);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Converts a value per cycle into the corresponding value per second.
		 * @param		cycles		Number 		Value to be converted
		 */
		
		public function cyclesToSeconds(cycles:Number):Number {
			if(_target != null) return cycles * _target.secondsPerCycle;
			return cycles;
		}
		
		/**
		 * @Converts a value per second into the corresponding value per cycle.
		 * @param		sec		Number 		Value to be converted
		 */
		
		public function secondsToCycles(sec:Number):Number {
			if(_target != null) return sec / _target.secondsPerCycle;
			return sec;
		}
		
		/**
		 * @Converts a change per cycle into the corresponding value per second.
		 * @param		per_cycle		Number 		Value to be converted
		 */
		
		public function toPerSecond(per_cycle:Number):Number {
			if(_target != null) return per_cycle / _target.secondsPerCycle;
			return per_cycle;
		}
		
		/**
		 * @Converts a change per second into the corresponding value per cycle.
		 * @param		per_sec		Number 		Value to be converted
		 */
		
		public function toPerCycle(per_sec:Number):Number {
			if(_target != null) return per_sec * _target.secondsPerCycle;
			return per_sec;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Called when the target's physics rate changes
		 */
		
		public function onTimeChange(ev:NumberChangeEvent) {
			scalePacing(ev.currentValue / ev.previousValue);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Multiplies change rates by the given multiplier.
		 * @This function will be overriden by most sub-classes.
		 */
		
		protected function scalePacing(ratio:Number):void {
			if(isNaN(ratio)) return;
			//if(ratio != 1) ;
		}
		
	}
	
}
