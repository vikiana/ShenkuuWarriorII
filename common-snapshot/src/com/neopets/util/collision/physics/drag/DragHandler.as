/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.drag
{
	import com.neopets.util.collision.physics.PhysicsHandler;
	import com.neopets.util.collision.physics.RotationPoint;
	
	/**
	 *	Drag Handlers are wrappers for air resistance formulae.  They precalculate 
	 *  and store as many values as possible to speed later calculations.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.6.2009
	 */
	public class DragHandler
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _target:PhysicsHandler;
		protected var _speed:SpeedReducer;
		protected var _rotation:SpeedReducer;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var splitSpeed:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function DragHandler(handler:PhysicsHandler):void{
			splitSpeed = false;
			_speed = new LinearDragLimit();
			//_rotation = new FixedDragLimit(360,720);
			target = handler;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get rotation():SpeedReducer { return _rotation; }
		
		public function set rotation(reducer:SpeedReducer) {
			if(_rotation != reducer) {
				// clear previous reducer
				if(_rotation != null) _rotation.target = null;
				// set up new reducer
				_rotation = reducer;
				if(_rotation != null) _rotation.target = _target;
			}
		}
		
		public function get speed():SpeedReducer { return _speed; }
		
		public function set speed(reducer:SpeedReducer) {
			if(_speed != reducer) {
				// clear previous reducer
				if(_speed != null) _speed.target = null;
				// set up new reducer
				_speed = reducer;
				if(_speed != null) _speed.target = _target;
			}
		}
		
		public function get target():PhysicsHandler { return _target; }
		
		public function set target(handler:PhysicsHandler) {
			_target = handler;
			if(_speed != null) _speed.target = _target;
			if(_rotation != null) _rotation.target = _target;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function modifies all elements of the target's velocity
		 */
		 
		public function applyDrag():void {
			if(target == null) return;
			var vel:RotationPoint = _target.velocity.perCycle;
			// apply speed reduction
			if(_speed != null) {
				// apply reduction separately to x and y components?
				if(splitSpeed) {
					if(vel.x != 0) vel.x = _speed.reduce(vel.x);
					if(vel.y != 0) vel.y = _speed.reduce(vel.y);
				} else {
					var spd:Number = vel.length;
					if(spd != 0) {
						spd = _speed.reduce(spd);
						vel.normalize(spd);
					}
				}
			}
			// apply rotation reduction
			if(_rotation != null) {
				if(vel.rotation != 0) vel.rotation = _rotation.reduce(vel.rotation);
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
