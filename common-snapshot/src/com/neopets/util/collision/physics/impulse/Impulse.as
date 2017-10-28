/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.impulse
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	import com.neopets.util.collision.physics.Acceleration;
	import com.neopets.util.collision.physics.RotationPoint;
	
	/**
	 *	Impulses handle application of force over time to a given target.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.9.2009
	 */
	public class Impulse
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _name:String; // optional identifier to mark forces as unique
		protected var _acceleration:Acceleration;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var cyclesLeft:Number;
		public var removeWhenDone:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Impulse(handler:PhysicsHandler,tag:String=null):void{
			_name = tag;
			_acceleration = new Acceleration(handler);
			cyclesLeft = 1;
			removeWhenDone = true;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get acceleration():Acceleration { return _acceleration; }
		
		public function get duration():Number {
			if(cyclesLeft != Infinity) {
				return _acceleration.cyclesToSeconds(cyclesLeft);
			}
			return cyclesLeft;
		}
		
		public function set duration(val:Number) {
			if(val != Infinity) cyclesLeft = _acceleration.secondsToCycles(val);
			else cyclesLeft = val;
		}
		
		public function get name():String { return _name; }
		
		public function get target():PhysicsHandler { return _acceleration.target; }
		
		public function set target(handler:PhysicsHandler) {
			var cur_target:PhysicsHandler = _acceleration.target;
			if(cur_target != handler) {
				// check if mass scaling is needed
				if(cur_target != null && handler != null) {
					var ratio:Number = cur_target.mass / handler.mass;
					if(ratio != 1) _acceleration.perCycle.scaleBy(ratio);
				}
				_acceleration.target = handler;
			}
			
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Adds the values of another impulse to this one.
		 * @param		other		Impulse 		Impulse to be added to this one.
		 */
		
		public function add(other:Impulse):void {
			if(other == null) return;
			// make sure the added impulse lasts our full duration
			if(other.cyclesLeft >= cyclesLeft) {
				// make the other impulse share our target
				other.target = target;
				// combine accelerations per second
				_acceleration.perCycle.assignAdd(other.acceleration.perCycle);
			}
		}
		
		/**
		 * @This function uses up one of the impulses cycles to accelerate the target.
		 */
		
		public function applyImpulse():void {
			// make sure we have a target and at least one cycle left
			var cur_target:PhysicsHandler = _acceleration.target;
			if(cur_target != null && cyclesLeft > 0) {
				var disp:RotationPoint = cur_target.velocity.perCycle;
				// check if there's a full cycleleft
				if(cyclesLeft >= 1) {
					// accelerate our target
					disp.assignAdd(_acceleration.perCycle);
					// if this isn't an endless acceleration (like gravity) decrement our cycles
					if(cyclesLeft != Infinity) cyclesLeft--;
				} else {
					// apply partial acceleration to our target
					var apc:RotationPoint = _acceleration.perCycle;
					disp.x += apc.x * cyclesLeft;
					disp.y += apc.y * cyclesLeft;
					disp.rotation += apc.rotation * cyclesLeft;
					// clear the remaining cycle
					cyclesLeft = 0;
				}
				// check if we should remove ourselves now
				if(removeWhenDone && cyclesLeft <= 0) cur_target.impulses.removeImpulse(this);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
