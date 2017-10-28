
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.flags
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.collision.physics.RotationPoint;
	
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.FlagsOfFrenzyGame;
	
	/**
	 *	This class handles the physics for flag movements.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class FloatingFlag extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_MOVEMENT:String = "on_movement";
		public static const FLAG_CAUGHT:String = "flag_caught";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _velocity:RotationPoint;
		protected var _driftSpeed:Number;
		protected var _spinSpeed:Number;
		protected var _maxSpeed:Number;
		protected var _maxSpin:Number;
		// physics variables
		protected var _gravity:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FloatingFlag():void{
			super();
			// initialize variables
			_velocity = new RotationPoint();
			_driftSpeed = 6;
			_maxSpeed = 30;
			_spinSpeed = 10;
			_maxSpin = 15;
			_gravity = 1;
			// set up listeners
			addParentListener(FlagsOfFrenzyGame,FlagsOfFrenzyGame.GAME_OVER,onGameOver);
			useParentDispatcher(FlagsOfFrenzyGame);
			// set up listeners
			addEventListener(Event.ENTER_FRAME,onMovementFrame);
			addEventListener(MouseEvent.MOUSE_DOWN,onClick);
			// show hand cursor
			buttonMode = true;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get velocity():RotationPoint { return _velocity; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to mimic the application of outside kinetic forces.
		
		public function applyForce(fx:Number,fy:Number,fr:Number=0) {
			if(fx != 0) _velocity.x += fx;
			if(fy != 0) _velocity.y += fy;
			if(fr != 0) _velocity.rotation += fr;
		}
		
		// Use this function to mimic reflection behaviour.
		
		public function reflectBy(x_ratio:Number,y_ratio:Number) {
			if(x_ratio > 0) {
				_velocity.x *= -Math.min(x_ratio,1);
			}
			if(y_ratio > 0) {
				_velocity.y *= -Math.min(y_ratio,1);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// This function handles any mouse clicks on this flag.
		
		protected function onClick(ev:MouseEvent) {
			// let the game engine know
			broadcast(FLAG_CAUGHT);
			// remove this flag from the stage
			if(parent != null) parent.removeChild(this);
		}
		
		// When the game ends, take this flag off screen.
		
		protected function onGameOver(ev:Event) {
			if(parent != null) parent.removeChild(this);
		}
		
		// This function is called each frame to keep the flag moving.
		
		protected function onMovementFrame(ev:Event):void {
			// apply random horizontal drift
			var accel:Number = GeneralFunctions.getRandom(-_driftSpeed,_driftSpeed);
			_velocity.x = Math.min(Math.max(-_maxSpeed,velocity.x + accel),_maxSpeed);
			// apply random spin
			accel = GeneralFunctions.getRandom(-_spinSpeed,_spinSpeed);
			_velocity.rotation = Math.min(Math.max(-_maxSpin,velocity.rotation + accel),_maxSpin);
			// apply gravity
			_velocity.y = Math.min(velocity.y + _gravity,_maxSpeed);
			// apply velocity
			x += _velocity.x;
			y += _velocity.y;
			rotation += _velocity.rotation;
			// let listeners know we moved
			dispatchEvent(new Event(ON_MOVEMENT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
