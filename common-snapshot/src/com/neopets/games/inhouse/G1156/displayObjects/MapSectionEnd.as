
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.G1156.displayObjects
{
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.games.inhouse.G1156.managers.CollisionListModified;
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
	 
	public class MapSectionEnd extends MapSection 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var mcMapFloor:MapFloor; //On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MapSectionEnd():void
		{
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		 /**
		 * @Note: This sets up the List of Objects that it will listen to for Collision Events
		 * @param		pDisplayObject			DisplayObject			The Graphic to be checked against 
		 * @param		pDisplayObjArray		Array							Array of Graphic Items to be checked against	
		 */
		 
		public override function setCollisionList(pDisplayObject:DisplayObject, pDisplayObjArray:Array = null):void
		{
			mCollisionDisplayArray = (pDisplayObjArray != null) ? pDisplayObjArray : mCollisionDisplayArray;
			
			mCollisionList = new CollisionListModified (pDisplayObject, mCollisionDisplayArray);
			
			mcMapFloor.setCollisionList(pDisplayObject);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
	}
	
}
