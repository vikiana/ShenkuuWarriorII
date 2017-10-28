
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.G1156.displayObjects
{
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.describeType;

	
	/**
	 *	This is the Code for A walled Section
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Game Engine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.23.2009
	 */
	 
	public class MapSection extends AbsInteractiveDisplayObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const COLLISION_TYPE:String = "WallPanel";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var leftWall:MovieClip;		//On Stage
		public var rightWall:MovieClip;		//On Stage
		
		public var mBaseClass:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MapSection():void
		{
			super();
			setupVars();
			
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
		 * @Note Items been activated so all the children need to be turned on
		 *	@param		evt.oData.id			String 			The Name of the MapSection or "all"
		 */
		 
		 protected function activateItemChildren (evt:CustomEvent):void
		 {
		 	var tNumberChidren:int = this.numChildren;
		 	
		 	for (var z:int = 0; z < tNumberChidren; z++)
		 	{
		 		var tDisplayObject:DisplayObject = getChildAt(z);	
		 		
		 		if (tDisplayObject is AbsInteractiveDisplayObject)
		 		{
		 			AbsInteractiveDisplayObject(tDisplayObject).activateItem();		
		 		}
		 	
		 	}
		 }
		 
		 /**
		 * @Note Items been deactivated so all the children need to be turned off
		 */
		 
		 protected function deActivateItemChildren(evt:Event):void
		 {
		 	var tNumberChidren:int = this.numChildren;
		 	
		 	for (var z:int = 0; z < tNumberChidren; z++)
		 	{
		 		var tDisplayObject:DisplayObject = getChildAt(z);	
		 		
		 		if (tDisplayObject is AbsInteractiveDisplayObject)
		 		{
		 			AbsInteractiveDisplayObject(tDisplayObject).deActivateItem();	
		 		}
		 	}
		 	
		 	//Kill the Wall and its listeners
		 	this.removeEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChildren);
		    this.removeEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChildren);
		    mSharedEventDispatcher.removeEventListener(GameEvents.REMOVE_DISPLAYOBJECT, removeDisplayObject);
		    mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, checkCollision);	
		 }
		 
		 /**
		 * @Note:Clears Listeners
		 */
		 
		protected function killListeners(evt:Event):void
		{
			mSharedEventDispatcher.removeEventListener(GameEvents.REMOVE_DISPLAYOBJECT, removeDisplayObject);
			removeEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChildren);
			removeEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChildren);
			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mCollisionDisplayArray = [leftWall,rightWall];
			mType = MapSection.COLLISION_TYPE;
			registerEventDispatcher(GameCore.KEY);
			mSharedEventDispatcher.addEventListener(GameEvents.REMOVE_DISPLAYOBJECT, removeDisplayObject, false,0,true);
			addEventListener( AbsInteractiveDisplayObject.EVENT_ACTIVATED, activateItemChildren, false, 0, true);
			addEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChildren, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners, false,0,true);
		}
	}
	
}
