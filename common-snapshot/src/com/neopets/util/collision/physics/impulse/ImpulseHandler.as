/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.impulse
{
	import com.neopets.util.collision.physics.PhysicsHandler;
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
	public class ImpulseHandler
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _target:PhysicsHandler;
		protected var _impulses:Array;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ImpulseHandler(handler:PhysicsHandler=null):void{
			_impulses = new Array();
			target = handler;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get target():PhysicsHandler { return _target; }
		
		public function set target(handler:PhysicsHandler) {
			if(_target != handler) {
				_target = handler;
				// update our impulse list
				for(var i:int = 0; i < _impulses.length; i++) {
					_impulses[i].target = _target;
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Increases all components of change per cycle.
		 * @param		impulse		Impulse 		Impulse to be added
		 * @param		replace		Boolean 		If we already have an impulse with the
		 * @										same name, should we replace it?
		 */
		
		public function addImpulse(impulse:Impulse,replace:Boolean=false):void {
			if(impulse == null) return; // make sure we have something to add
			// check if this is a named impulse
			var match:Impulse;
			var id:String = impulse.name;
			if(id != null) {
				// check if we already have an impulse by that name
				match = getNamedImpulse(id);
				if(match != null) {
					// if we do, check if we want that impulse replaced
					if(replace) {
						var index:int = _impulses.indexOf(match);
						impulse.target = _target;
						_impulses[index] = impulse;
					}
				} else {
					impulse.target = _target;
					_impulses.push(impulse);
				}
			} else {
				// If the impulse is unnamed, make sure we don't already have the impulse
				if(_impulses.indexOf(impulse) < 0) {
					impulse.target = _target;
					_impulses.push(impulse);
				}
			} // end of name check
		}
		
		/**
		 * @In sub-classes, this function should reduce velocity and rotation accordingly.
		 */
		public function applyImpulses() {
			if(_target != null) {
				for(var i:int = _impulses.length - 1; i >= 0; i--) {
					_impulses[i].applyImpulse();
				}
			}
		}
		
		/**
		 * @Multiplies all values by the target number.
		 * @param		id		String 		Name of the impulse we're looking for
		 */
		
		public function getNamedImpulse(id:String):Impulse {
			var impulse:Impulse;
			for(var i:int = 0; i < _impulses.length; i++) {
				impulse = _impulses[i];
				if(impulse.name == id) return impulse;
			}
			return null;
		}
		
		/**
		 * @Multiplies all values by the target number.
		 * @param		id		String 		Name of the impulse we're looking for
		 */
		
		public function removeImpulse(impulse:Impulse):void {
			var entry:Impulse;
			for(var i:int = _impulses.length - 1; i >= 0; i--) {
				entry = _impulses[i];
				if(entry == impulse) _impulses.splice(i,1);
			}
			impulse.target = null; // clear our linkage to the target
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
