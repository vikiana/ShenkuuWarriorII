
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.game.objects
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Timer;
	
	import com.neopets.util.collision.geometry.RectangleArea;
	
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
	 
	public class FallingEntity extends MovableEntity
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function FallingEntity():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to tie the our physics to given collision space and timer.
		
		override public function initPhysicsFor(world:GameWorld):void {
			_proxy.addTo(world.name);
			_proxy.area = new RectangleArea(this,world);
			_proxy.physics.timer = world.physicsTimer;
			_proxy.physics.setGravity(0,400);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to apply a counter force that damps out velocity in the provided direction.
		
		protected function counterVelocity(cx:Number,cy:Number):void {
			if(cx != 0) _proxy.physics.velocity.x = 0;
			if(cy != 0) _proxy.physics.velocity.y = 0;
		}
		
	}
	
}
