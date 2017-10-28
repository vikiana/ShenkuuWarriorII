/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.objects
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import com.neopets.util.collision.physics.PhysicsHandler;
	import com.neopets.util.collision.physics.MovementEvent;
	import com.neopets.util.collision.physics.drag.*;
	
	/**
	 *	Physic Proxies extend the functionality of collision proxies by linking them
	 *  to a Physics Handler.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.6.2009
	 */
	public class PhysicsProxy extends CollisionProxy
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _physics:PhysicsHandler;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PhysicsProxy(dobj:DisplayObject=null):void{
			super(dobj);
			_physics = new PhysicsHandler();
			_physics.addEventListener(PhysicsHandler.ON_MOVEMENT,onPhysicsMovement);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get physics():PhysicsHandler { return _physics; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Called whenever the physics system requests a movement.
		 */
		public function onPhysicsMovement(ev:MovementEvent) {
			var movement:Object = ev.movement;
			slideBy(movement.x,movement.y,movement.rotation);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
