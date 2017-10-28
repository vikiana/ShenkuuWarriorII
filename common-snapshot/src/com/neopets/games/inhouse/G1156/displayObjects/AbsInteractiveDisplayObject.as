
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.G1156.displayObjects 
{

	import com.coreyoneil.collision.CollisionList;
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.games.inhouse.G1156.managers.CollisionListModified;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *	Basic Class for Interactive Display Objects
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Game Engine G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.05.2009
	 */
	 
	public class AbsInteractiveDisplayObject extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const EVENT_DISPLAYOBJ_COLLISION:String = "DisplayObjectHit";
		
		public static const EVENT_ACTIVATED:String = "DisplayObjectActivated";
		public static const EVENT_DEACTIVATED:String = "DisplayObjectDeActivated";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mCollisionDisplayArray:Array;
		protected var mId:String;
		protected var mType:String;
		protected var mLockDown:Boolean;
		
		public var mCollisionList:CollisionListModified;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function AbsInteractiveDisplayObject():void
		{
			super();
			absSetupVars();
		}
		

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get collisionDisplayList():Array
		{
			return mCollisionDisplayArray;
		}
		
		
		public function get id():String
		{
			return mId;	
		}
		
		public function set id(pId:String):void
		{
			mId = pId;	
		}
		
		public function get collisionType():String
		{
			return mType;
		}
		
		public function get lockdown():Boolean
		{
			return mLockDown;
		}
		
		public function set lockdown(pFlag:Boolean):void
		{
			mLockDown = pFlag;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This sets up the List of Objects that it will listen to for Collision Events
		 * @param		pDisplayObject			DisplayObject			The Graphic to be checked against 
		 * @param		pDisplayObjArray		Array							Array of Graphic Items to be checked against	
		 */
		 
		public function setCollisionList(pDisplayObject:DisplayObject, pDisplayObjArray:Array = null):void
		{
			mCollisionDisplayArray = (pDisplayObjArray != null) ? pDisplayObjArray : mCollisionDisplayArray;
			
			mCollisionList = new CollisionListModified (pDisplayObject, mCollisionDisplayArray);
		}
		
		/**
		 * @Note: This sets up the EventDispatcher
		 * @param		pKey			String 		The Key to use for the EventDispatcher
		 */
		 

		public function registerEventDispatcher(pKey:String):void
		{
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(pKey);
		 	mSharedEventDispatcher.addEventListener(GameEvents.SEND_ACTIVATE_EVENT, activateItemEvent, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.SEND_DEACTIVATE_EVENT, deActivateItemEvent, false, 0, true);	
			mSharedEventDispatcher.addEventListener(GameEvents.GAME_CLEANUP_MEMORY, killLocalListeners, false,0,true);
		
		}
		
		/**
		 * @Note Starts the Items Events
		 */
		 
		 public function activateItem ():void
		 {
		 
		 		if (GameCore.USE_TIMER)
		 		{
		 			mSharedEventDispatcher.addEventListener(GameEvents.GAME_TIMER_EVENT, checkCollision, false, 0, true);
		 		}
		 		else
		 		{
		 			this.addEventListener(Event.ENTER_FRAME,checkCollision, false, 0, true);	
		 		}
		 		
		 		dispatchEvent(new CustomEvent({useTimer: GameCore.USE_TIMER}, AbsInteractiveDisplayObject.EVENT_ACTIVATED));
		 }
		 
		 /**
		 * @Note: Turns off an Interactive Item
		 */
		 
		 public function deActivateItem():void
		 {
		 
		 		if (this.hasEventListener(Event.ENTER_FRAME))
		 		{
		 			this.removeEventListener(Event.ENTER_FRAME,checkCollision);	
		 		}
		 		else
		 		{
		 			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, checkCollision);	
		 		}
				
				dispatchEvent(new Event( AbsInteractiveDisplayObject.EVENT_DEACTIVATED));
		 		
		 		if (mCollisionList != null)
		 		{
		 			mCollisionList.dispose();
		 			mCollisionList = null;	
		 		}
		 	
		 		
		 }
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note Checks to see if a collision has occured
		 */
		 
		protected function checkCollision(evt:Event):void
		{
			if (mCollisionList != null)
			{
					var tArray:Array = mCollisionList.checkCollisions();

			
				if (tArray.length > 0)
				{
					mSharedEventDispatcher.dispatchEvent(new CustomEvent({collisionArray:tArray,id:mId, type:mType, object:this}, AbsInteractiveDisplayObject.EVENT_DISPLAYOBJ_COLLISION));
				}		
			}
		
		}
		
		/**
		 * @Note Starts the Map Section Processes
		 *	@param		evt.oData.id					String 				The Name of the MapSection or "all"
		  *	@param		evt.oData.useTimer			Boolean 			True use timer / False use EnterFrame
		 */
		 
		 protected function activateItemEvent (evt:CustomEvent):void
		 {
		 	if (evt.oData.id == mId || evt.oData.id == "all")
		 	{
		 		if (GeneralFunctions.convertBoolean(evt.oData.useTimer))
		 		{
		 			mSharedEventDispatcher.addEventListener(GameEvents.GAME_TIMER_EVENT, checkCollision, false, 0, true);
		 		}
		 		else
		 		{
		 			this.addEventListener(Event.ENTER_FRAME,checkCollision, false, 0, true);	
		 		}
		 		
		 		dispatchEvent(new CustomEvent({useTimer: evt.oData.useTimer}, AbsInteractiveDisplayObject.EVENT_ACTIVATED));
				
				if (evt.oData.id == mId)
				{
					evt.stopImmediatePropagation();	
				}
		 	}
		 }
		 
		 /**
		 * @Note: Turns off an Interactive Item
		 */
		 
		 protected function deActivateItemEvent(evt:CustomEvent):void
		 {
		 	if (evt.oData.id == mId || evt.oData.id == "all")
		 	{
		 		
		 		if (this.hasEventListener(Event.ENTER_FRAME))
		 		{
		 			this.removeEventListener(Event.ENTER_FRAME,checkCollision);	
		 		}
		 		else
		 		{
		 			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, checkCollision);	
		 		}
				
				dispatchEvent(new Event( AbsInteractiveDisplayObject.EVENT_DEACTIVATED));
		 		
		 		mCollisionDisplayArray = [];
		 		
		 		if (mCollisionList != null)
		 		{
		 			mCollisionList.dispose();
		 			mCollisionList = null;	
		 		}
		 		
		 		if (evt.oData.id == mId)
				{
					evt.stopImmediatePropagation();	
				}
		 	}
		 }
		 
		 /**
		 * @Note: removes the DisplayObject is in its DisplayList
		 *	@param			evt.oData.object				DisplayObject			The DisplayObject to Remove
		 */
		 
		 protected function removeDisplayObject (evt:CustomEvent):void
		 {
		 	if (contains(evt.oData.object))
		 	{
		 		var tDisplayObj:DisplayObject = evt.oData.object;
		 		
		 		removeChild(tDisplayObj);
		 		
		 		
		 		tDisplayObj = null;
				evt.stopImmediatePropagation();
		 	}
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Clears Memory
		 **/
		 
		protected function killLocalListeners(evt:Event):void
		{
			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_CLEANUP_MEMORY, killLocalListeners);
			mSharedEventDispatcher.removeEventListener(GameEvents.SEND_ACTIVATE_EVENT, activateItemEvent);
			mSharedEventDispatcher.removeEventListener(GameEvents.SEND_DEACTIVATE_EVENT, deActivateItemEvent);	
		
			if (this.hasEventListener(Event.ENTER_FRAME))
		 		{
		 			this.removeEventListener(Event.ENTER_FRAME,checkCollision);	
		 		}
		 		else
		 		{
		 			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, checkCollision);	
		 		}
		}
		
		protected function absSetupVars():void
		{
			mCollisionDisplayArray = [];	
			mLockDown = false;
			}
	}
	
}
