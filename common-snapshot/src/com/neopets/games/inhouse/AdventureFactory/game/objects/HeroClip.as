
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.game.objects
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.neopets.util.input.KeyManager;
	import com.neopets.util.input.KeyCommand;
	import com.neopets.util.collision.geometry.PointArea;
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.objects.CollisionSensor;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.util.collision.objects.PhysicsProxy;
	import com.neopets.util.collision.physics.PhysicsHandler;
	import com.neopets.util.collision.CollisionSpace;
	
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
	 
	public class HeroClip extends FallingEntity
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const WALK_LEFT:String = "walk_left_command";
		public static const WALK_RIGHT:String = "walk_right_command";
		public static const JUMP:String = "jump_command";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var walkSpeed:Number = 8;
		protected var _jumpForce:Number = 600;
		// keyboard inputs
		protected var _walkLeftCmd:KeyCommand;
		protected var _walkRightCmd:KeyCommand;
		protected var _jumpCmd:KeyCommand;
		// action tracking
		protected var _groundPoint:PointArea;
		protected var _isOnGround:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function HeroClip():void{
			super();
			// create point area for ground detection
			_groundPoint = new PointArea();
			// add proxy listeners
			_proxy.addEventListener(CollisionSensor.POSITION_CHANGED,onMovement);
			_proxy.physics.addEventListener(PhysicsHandler.ON_PHYSICS_CYCLE,onPhysicsCheck);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isOnGround():Boolean { return _isOnGround; }
		
		public function get walkVelocity():Number {
			if(_walkLeftCmd == null || _walkRightCmd == null) return 0;
			// check if left walk key is down
			if(_walkLeftCmd.keyIsDown) {
				if(_walkRightCmd.keyIsDown) return 0;
				else return -walkSpeed;
			}
			// check if right walk key is down
			if(_walkRightCmd.keyIsDown) {
				if(_walkLeftCmd.keyIsDown) return 0;
				else return walkSpeed;
			}
			return 0;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to tie the our physics to given collision space and timer.
		
		override public function initPhysicsFor(world:GameWorld):void {
			super.initPhysicsFor(world);
			updateGround();
			// get keyboard input from the game world
			initKeysFrom(world.keys);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Make sure our ground sensor moves when we do.
		
		protected function onMovement(ev:Event) { updateGround(); }
		
		// Each physics cycle, let the character move.
		
		protected function onPhysicsCheck(ev:Event) {
			// do ground check
			var cspace:CollisionSpace = _proxy.space;
			if(cspace != null) {trace("pre..");
				var grounds:Array = cspace.getSensorsIn(_groundPoint,checkGround);trace("%"+grounds);
				_isOnGround = (grounds.length > 0);
			} else _isOnGround = false;
			// check for walking
			var dx:Number = walkVelocity
			_proxy.physics.velocity.x = dx;
			// check if we're on the ground
			if(_isOnGround) {
				if(_jumpCmd != null && _jumpCmd.keyIsDown) {
					_proxy.physics.velocity.y = -_jumpForce;
				} else {
					if(dx != 0) _proxy.physics.velocity.y = -4;
				}
			}
			updatePose();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// This function test if a given collision sensor can serve as a walkable surface.
		
		protected function checkGround(sensor:CollisionSensor) {
			if(sensor is PhysicsProxy) {
				var target_proxy:PhysicsProxy = PhysicsProxy(sensor);
				var proxy_owner:DisplayObject = target_proxy.owner;
				if(proxy_owner == this) return false;
				if(proxy_owner is PhysicsEntity) return true;
			}
			return false;
		}
		
		// Use this function to revers our current facing
		
		protected function flipFacing():void {
			scaleX = -scaleX;
			_proxy.synch();
		}
		
		// Use this function to set up keyboard listeners.
		
		protected function initKeysFrom(keys:KeyManager):void {
			if(keys == null) return;
			_walkLeftCmd = keys.getCommand(WALK_LEFT);
			_walkRightCmd = keys.getCommand(WALK_RIGHT);
			_jumpCmd = keys.getCommand(JUMP);
		}
		
		// Use this to set the direction the character is facing.
		
		protected function setFacing(dir:Number):void {
			if(scaleX > 0) {
				if(dir < 0) flipFacing();
			} else {
				if(dir > 0) flipFacing();
			}
		}
		
		// This function keeps our ground sensor at the right point relative to our proxy area.
		
		protected function updateGround():void {
			var proxy_area:BoundedArea = _proxy.area;
			if(proxy_area != null) {
				_groundPoint.x = proxy_area.center.x;
				_groundPoint.y = proxy_area.bounds.y + 4;
			}
		}
		
		// This function synchs up the character animation with their actions.
		
		protected function updatePose():void {
			var dx:Number = _proxy.physics.velocity.x;
			if(isOnGround) {
				if(dx != 0) gotoAndStop("walk");
				else gotoAndStop("idle");
			} else gotoAndStop("jump");
			// set facing direction
			setFacing(dx);
		}
		
	}
	
}
