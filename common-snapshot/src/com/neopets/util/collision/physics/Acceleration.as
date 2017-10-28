/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics
{
	
	/**
	 *	This class tracks changes in position over time based on the target's cycle rate.
	 *  The class provides heavy support for inputting values in rates per second and having 
	 *  them automatically converted to rates per cycle.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.9.2009
	 */
	public class Acceleration extends Velocity
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
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Acceleration(handler:PhysicsHandler=null):void{
			super(handler);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Increment Functions
		
		/**
		 * @Increases all components of change per cycle.
		 * @param		dx		Number 		X-axis change
		 * @param		dy		Number 		Y-axis change
		 * @param		dr		Number 		Y-axis change
		 */
		
		override public function changeBy(dx:Number,dy:Number,dr:Number=0):void {
			if(_target != null) {
				// acceleration is based on change in position / change in time squared
				var time_squared:Number = Math.pow(_target.secondsPerCycle,2);
				_perCycle.x += dx * time_squared;
				_perCycle.y += dy * time_squared;
				_perCycle.rotation += dr * time_squared;
			} else {
				_perCycle.x += dx;
				_perCycle.y += dy;
				_perCycle.rotation += dr;
			}
		}
		
		/**
		 * @Converts a change per cycle into the corresponding value per second.
		 * @param		per_cycle		Number 		Value to be converted
		 */
		
		override public function toPerSecond(per_cycle:Number):Number {
			if(_target != null) {
				// acceleration is based on change in position / change in time squared
				var time_squared:Number = Math.pow(_target.secondsPerCycle,2);
				return per_cycle / time_squared;
			}
			return per_cycle;
		}
		
		/**
		 * @Converts a change per second into the corresponding value per cycle.
		 * @param		per_sec		Number 		Value to be converted
		 */
		
		override public function toPerCycle(per_sec:Number):Number {
			if(_target != null) {
				// acceleration is based on change in position / change in time squared
				var time_squared:Number = Math.pow(_target.secondsPerCycle,2);
				return per_sec * time_squared;
			}
			return per_sec;
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
			if(ratio != 1) _perCycle.scaleBy(ratio);
		}
		
	}
	
}
