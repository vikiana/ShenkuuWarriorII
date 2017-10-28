
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.game.objects
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.geom.Point;
	
	import com.neopets.util.collision.objects.PhysicsProxy;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.util.collision.geometry.RectangleArea;
	import com.neopets.util.display.BroadcasterClip;
	
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	
	/**
	 *	This class just lays out child clips in a horizontal line.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.26.2010
	 */
	 
	public class PhysicsEntity extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _proxy:PhysicsProxy;
		protected var _initialState:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PhysicsEntity():void{
			super();
			_proxy = new PhysicsProxy(this);
			_proxy.synchLevel = CollisionProxy.POSITION_SYNCH;
			_proxy.physics.timer.stop();
			_initialState = new Object();
			recordState();
			// add parent listeners
			addParentListener(GameWorld,GameWorld.RESET_GAME,onReset);
			addParentListener(GameWorld,GameWorld.SET_INITIAL_STATE,onSetState);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to tie the our physics to given collision space and timer.
		
		public function initPhysicsFor(world:GameWorld):void {
			_proxy.addTo(world.name);
			_proxy.area = new RectangleArea(this,world);
			_proxy.physics.timer = world.physicsTimer;
		}
		
		// Use this function to store our starting state for later reference.
		
		public function recordState():void {
			_initialState.x = x;
			_initialState.y = y;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// When the game resets, reload from our initial state.
		
		protected function onReset(ev:Event) {
			//_proxy.moveTo(_initialState.x,_initialState.y);
			x = _initialState.x;
			y = _initialState.y;
			// zero out speed
			_proxy.physics.velocity.speed = 0;
		}
		
		// When the world makes a save state request, record our current state.
		
		protected function onSetState(ev:Event) {
			recordState();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
