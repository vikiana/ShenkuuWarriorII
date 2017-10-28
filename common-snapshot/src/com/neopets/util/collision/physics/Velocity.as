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
	public class Velocity extends ChangeOverTime
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _perCycle:RotationPoint;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Velocity(handler:PhysicsHandler=null):void{
			_perCycle = new RotationPoint();
			super(handler);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get perCycle():RotationPoint { return _perCycle; }
		
		// Per-Second values
		
		public function get x():Number { return toPerSecond(_perCycle.x); }
		
		public function set x(val:Number) { _perCycle.x = toPerCycle(val); }
		
		public function get y():Number { return toPerSecond(_perCycle.y); }
		
		public function set y(val:Number) { _perCycle.y = toPerCycle(val); }
		
		public function get rotation():Number { return toPerSecond(_perCycle.rotation); }
		
		public function set rotation(val:Number) { _perCycle.rotation = toPerCycle(val); }
		
		public function get speed():Number { return toPerSecond(_perCycle.length); }
		
		public function set speed(val:Number) { _perCycle.normalize(toPerCycle(val)); }
		
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
		
		public function changeBy(dx:Number,dy:Number,dr:Number=0):void {
			if(_target != null) {
				var time:Number = _target.secondsPerCycle
				_perCycle.x += dx * time;
				_perCycle.y += dy * time;
				_perCycle.rotation += dr * time;
			} else {
				_perCycle.x += dx;
				_perCycle.y += dy;
				_perCycle.rotation += dr;
			}
		}
		
		/**
		 * @Increases the x-axis component of change per cycle.
		 * @param		val		Number 		X-axis change
		 */
		
		public function addToX(val:Number):void {
			_perCycle.x += toPerCycle(val);
		}
		
		/**
		 * @Increases the y-axis component of change per cycle.
		 * @param		val		Number 		Y-axis change
		 */
		
		public function addToY(val:Number):void {
			_perCycle.y += toPerCycle(val);
		}
		
		/**
		 * @Increases the rotation component of change per cycle.
		 * @param		val		Number 		Rotation change
		 */
		
		public function addToRotation(val:Number):void {
			_perCycle.rotation += toPerCycle(val);
		}
		
		// Misc. Functions
		
		/**
		 *	@Converts this object to a string representation.
		 */
		
		public function toString():String {
			return _perCycle.toString();
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
