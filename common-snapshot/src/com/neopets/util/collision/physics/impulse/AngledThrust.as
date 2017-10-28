/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.impulse
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	import com.neopets.util.collision.physics.RotationPoint;
	import com.neopets.util.collision.geometry.AreaTransformation;
	
	/**
	 *	Angled Thrust is simply an impulse effect that can be rotated.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.9.2009
	 */
	public class AngledThrust extends Impulse
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _rotation:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AngledThrust(handler:PhysicsHandler,tag:String=null):void{
			_rotation = 0;
			super(handler,tag);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get rotation() { return _rotation; }
		
		public function set rotation(angle:Number) {
			if(_rotation != angle) {
				_rotation = angle;
				// set thrust to follow our target angle
				var acc:RotationPoint = _acceleration.perCycle;
				var spd:Number = acc.length;
				var rad:Number = _rotation * AreaTransformation.RADIANS_PER_DEGREE;
				acc.x = spd * Math.cos(rad);
				acc.y = spd * Math.sin(rad);
			}
		}
		
		public function get magnitude():Number { return _acceleration.speed; }
		
		public function set magnitude(val:Number) {
			// convert to per cycle rates
			var rate:Number = _acceleration.toPerCycle(val);
			// set thrust to follow our target angle
			var acc:RotationPoint = _acceleration.perCycle;
			var rad:Number = _rotation * AreaTransformation.RADIANS_PER_DEGREE;
			acc.x = rate * Math.cos(rad);
			acc.y = rate * Math.sin(rad);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to both set or direction and ensure there's at least one cycle left.
		 * @param		angle		Number 		Target direction
		 */
		
		public function anglePulse(angle:Number):void {
			rotation = angle;
			if(cyclesLeft <= 0) cyclesLeft = 1;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
