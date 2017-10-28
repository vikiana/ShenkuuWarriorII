/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.G1156.displayObjects 
{
	import caurina.transitions.*;
	
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.games.inhouse.G1156.managers.CollisionListModified;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.events.Event;
	
	/**
	 *	Basic Class for Obstacle that Does Damage for a Player and Moves across the screen.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Game Engine G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.05.2009
	 */
	 
	public class MovingObstacle extends AbsInteractiveDisplayObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const COLLISION_TYPE:String = "MovingObstacle";
		public const MOVEMENT_Y:int = 20;
		
		public const LEFT:String = "left";
		public const RIGHT:String = "right";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mVecX:int;
		protected var mVecY:int;
		protected var mDirectionX:int;

		protected var mMap:String;
		protected var mWallCollisionList:CollisionListModified;
		protected var mDirectionFlag:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MovingObstacle():void
		{
			super();
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set yVec (pNum:int):void
		{
			mVecY = pNum;
		}
		
		public function get yVec():int
		{
			return mVecY;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This sets up the List of Objects that it will listen to for Collision Events
		 * @param		pDisplayObject			DisplayObject			The Graphic to be checked against 
		 * @param		pDisplayObjArray		Array							Array of Graphic Items to be checked against	
		 */
		 
		public function setWallCollisionList(pDisplayObjArray:Array = null):void
		{
			mWallCollisionList = new CollisionListModified (this, pDisplayObjArray);
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		/**
		 * @Note This Moves the Object in a Random Speed in X Direction
		 * */
		 
		 protected function moveObject(evt:Event):void
		 {
		 	var tArray:Array = mWallCollisionList.checkCollisions();
		 	
		 	if (tArray.length > 0)
			{
				var collision:Object = tArray[0];
				var dx:Number = Math.cos(collision.angle) * this.width;

				mDirectionX = mDirectionX * -1;
				
				
				
				var tNewX:Number = this.x - dx;
			
				Tweener.addTween
				(
	           		this, 
	           		{
	           			x:tNewX, 
	           			time:.75, 
	           			transition:"easeInOutQuad"
	           		}
				);  		
			}
			else
			{
				if (mDirectionX == 1 && scaleX == 1)
				{
					scaleX = -1;	
				}
				else if (mDirectionX == -1 && scaleX == -1)
				
				{
					scaleX = 1;
				}
				
				x += 	mVecX * mDirectionX;
				y -= 	mVecY;
			}
		 }
		
		
		/**
		 * @Note Items been activated
		 *	@param		evt.oData.id			String 			The Name of the MapSection or "all"
		 */
		 
		 protected function activateItemChild (evt:CustomEvent):void
		 {
		 	if (GeneralFunctions.convertBoolean(evt.oData.useTimer))
	 		{
	 			mSharedEventDispatcher.addEventListener(GameEvents.GAME_TIMER_EVENT, moveObject, false, 0, true);
	 		}
	 		else
	 		{
	 			this.addEventListener(Event.ENTER_FRAME,moveObject, false, 0, true);	
	 		}
	 		
		 }
		 
		 /**
		 * @Note: Items been deactivated
		 */
		 
		 protected function deActivateItemChild(evt:Event):void
		 {
		 		mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, moveObject);	
		 	
		 		if (this.hasEventListener("GameEvents.GAME_TIMER_EVENT"))
		 		{
		 			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, moveObject);	
		 		}
		 		else
		 		{
		 			this.removeEventListener(Event.ENTER_FRAME,moveObject);	
		 		}
		 		
		 		Tweener.addTween
				(
	           		this, 
	           		{
	           			alpha:0, 
	           			time:.5, 
	           			transition:"easeInOutQuad",
	           			onComplete:removeObject
	           		}
				); 
				
			removeEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChild);
			removeEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChild);
			
			if (mWallCollisionList != null)
			{
				mWallCollisionList.dispose();	
			}
			
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mCollisionDisplayArray = [this];
			mType = MovingObstacle.COLLISION_TYPE;
			registerEventDispatcher(GameCore.KEY);
			mVecX = Math.round((Math.random() * 5)+ 1);
			mVecY = 0;
			var tRandomSwitch:int = Math.floor(Math.random() *2);
			
			mDirectionX = (tRandomSwitch == 1) ? 1 : -1;
			if (mDirectionX == 1)
				{
					scaleX *= -1;	
				}
				else
				{
					Math.abs(scaleX);	
				}	
			
			addEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChild, false, 0, true);
			addEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChild, false, 0, true);
		}
		
		protected function removeObject():void
		{
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({object:this},GameEvents.REMOVE_DISPLAYOBJECT));
		}
	}
	
}
