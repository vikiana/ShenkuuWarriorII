
/* AS3
	Copyright 2008
*/

package com.neopets.examples.collisionExample
{
	import com.neopets.examples.gameEngineExample.gameObjects.SquareObject;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.util.collision.objects.CollisionSensor;
	import com.neopets.util.collision.geometry.RectangleArea;
	import com.neopets.examples.collisionExample.CollisionGameScreen;
	import flash.events.Event;
	
	/**
	 *	This is an extension of SquareObject which adds collision detection functionality through
	 *  the use of a CollisionProxy.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  10.21.2009
	 */
	 
	public class CollidableSquare extends SquareObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var proxy:CollisionProxy;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function CollidableSquare():void{
			super();
			// create our collision proxy
			proxy = new CollisionProxy(this);
			proxy.synchLevel = 3; // synch every frame due to near constant motion and animation
			// The following optional line can be used if you want the object's path of motion
			// factored into it's collision area.
			proxy.trailLevel = 1;
			// set up collision reactions
			proxy.addEventListener(CollisionSensor.COLLISION_STARTS,onCollisionEvent);
			proxy.addEventListener(CollisionSensor.COLLISION_ENDS,onCollisionEvent);
			// wait to be added to stage before finalizing the collision area
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @If we try setting up the collision area before the object is added to the stage it
		 * @may end up using the clip itself as the coordinate space.  The system normally tries 
		 * @to get a common container such as the stage for it's coordinate space, but it can't 
		 * @do so until the target object has been added to the stage.
		 */
		
		public function onAddedToStage(ev:Event):void {
			if(ev.target == this) {
				// now that we know we're on stage, go ahead and set up the collision area
				proxy.area = new RectangleArea(this);
				// "addTo" attaches a collision sensor to a named collision space, much like
				// how "addChild" attaches display objects to a container.  Collision sensors 
				// only check for collisions with objects that share their collision space.
				proxy.addTo(CollisionGameScreen.MAIN_SPACE);
				removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
		}
		
		public function onCollisionEvent(ev:Event):void {
			if(proxy.colliderList.length > 0) {
				// object is colliding with something else
				//trace(this+" colliding with "+proxy.colliderList.length+" objects");
				alpha = 0.5;
			} else {
				// no collisions
				//trace(this+" ended last collision");
				alpha = 1;
			}
		}
		
		//--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------

	}
	
}
