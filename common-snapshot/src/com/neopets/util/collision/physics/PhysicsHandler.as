/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.neopets.util.collision.physics.impulse.*;
	import com.neopets.util.collision.physics.drag.DragHandler;
	
	/**
	 *	Physics handlers can be used to attach physics behaviour to an object.
	 *  The physics handler uses a timer to simulate things like motion and velocity 
	 *  and dispatches event which can be used to update linked objects.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.6.2009
	 */
	public class PhysicsHandler extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const CYCLE_RATE_CHANGED:String = "cycle_rate_changed";
		public static const ON_PHYSICS_CYCLE:String = "on_physics_cycle";
		public static const ON_MOVEMENT:String = "on_movement";
		public static const GRAVITY_TAG:String = "gravity";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _timer:Object; // usually a Timer, but can also be a FrameTimer
		protected var _secondsPerCycle:Number;
		// physics properties
		protected var _mass:Number;
		protected var _velocity:Velocity;
		// sub-systems
		protected var _impulses:ImpulseHandler;
		protected var _drag:DragHandler;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		// global variables
		public static var PHYSICS_SPEED:int = 100; // milliseconds per update cycle
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PhysicsHandler():void{
			_mass = 1;
			_secondsPerCycle = 1;
			_impulses = new ImpulseHandler(this);
			_drag = new DragHandler(this);
			_velocity = new Velocity(this);
			timer = new Timer(PHYSICS_SPEED);
			_timer.start();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get drag():DragHandler { return _drag; }
		
		public function get impulses():ImpulseHandler { return _impulses; }
		
		public function get mass():Number { return _mass; }
		
		public function get secondsPerCycle():Number { return _secondsPerCycle; }
		
		public function set secondsPerCycle(val:Number) {
			var prev:Number = _secondsPerCycle;
			_secondsPerCycle = val;
			dispatchEvent(new NumberChangeEvent(prev,_secondsPerCycle,CYCLE_RATE_CHANGED));
		}
		
		public function get timer():Object { return _timer; }
		
		public function set timer(clock:Object) {
			// clear previous timer
			if(_timer != null) {
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
			}
			// set up new timer
			_timer = clock;
			if(_timer != null) {
				secondsPerCycle = _timer.delay / 1000;
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
			} else secondsPerCycle = 1;
		}
		
		public function get velocity():Velocity { return _velocity; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to have a force accelerate this object.
		 * @param		fx		Number 		X-axis force
		 * @param		fy		Number 		Y-axis force
		 * @param		fr		Number 		Angular force
		 */
		
		public function addForce(fx:Number,fy:Number,fr:Number=0):void {
			_velocity.changeBy(fx/mass,fy/mass,fr/mass);
		}
		
		/**
		 * @This function add a reuseable impulse source to this object.
		 * @param		force		Number 		Magnitude of our impulse force
		 * @param		angle		Number 		Initial direction of our force
		 * @param		tag			Number 		Unique identifier for the thruster
		 */
		
		public function addThruster(force:Number=10,angle:Number=0,tag=null):AngledThrust {
			var impulse:Impulse;
			var thrust:AngledThrust;
			// we can't add the trhuster if the name is already taken
			if(tag != null) {
				impulse = _impulses.getNamedImpulse(tag);
				if(impulse != null) return null;
			}
			// create the thruster
			thrust = new AngledThrust(this,tag);
			thrust.rotation = angle;
			thrust.magnitude = force/mass;
			// turn the thruster off, but make sure doing so does drop the handler from our list
			thrust.removeWhenDone = false;
			thrust.cyclesLeft = 0;
			// add it to our impulse list
			_impulses.addImpulse(thrust);
			return thrust;
		}
		
		/**
		 * @This function sets up the gravitational acceleration associated with this object.
		 * @param		ax		Number 		X-axis acceleration
		 * @param		ay		Number 		Y-axis acceleration
		 */
		
		public function setGravity(ax:Number,ay:Number):void {
			var gravity:Impulse = _impulses.getNamedImpulse(GRAVITY_TAG);
			// if gravity has not been added, do so now
			if(gravity == null) {
				gravity = new Impulse(this,GRAVITY_TAG);
				gravity.duration = Infinity;
				_impulses.addImpulse(gravity);
			}
			// adjust gravitatonal acceleration
			var acc:Velocity = gravity.acceleration;
			acc.x = ax;
			acc.y = ay;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Updates time based effects.
		 */
		
		public function onTimer(ev:TimerEvent) {
			// apply any ongoing impulse effects
			_impulses.applyImpulses();
			// do we want have any pending movement?
			if(!_velocity.perCycle.isZeroed) {
				// apply drag
				if(_drag != null) _drag.applyDrag();
				// If we want to move, let our listeners know it.
				var disp:RotationPoint = _velocity.perCycle;
				if(!disp.isZeroed) {
					var move_event:MovementEvent = new MovementEvent(disp,ON_MOVEMENT);
					dispatchEvent(move_event);
				} // end of notification
			}
			// let listeners know we've had a timer update
			dispatchEvent(new Event(ON_PHYSICS_CYCLE));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
