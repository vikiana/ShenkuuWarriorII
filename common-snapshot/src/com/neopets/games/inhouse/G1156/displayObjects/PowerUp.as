
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
	 *	Basic Class for a PowerUp
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Game Engine G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.06.2009
	 */
	 
	public class PowerUp extends AbsInteractiveDisplayObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const COLLISION_TYPE:String = "PowerUpCollision";
		
		public static const POWERUP_TYPE_1:String = "Health";		// Heal
		public static const POWERUP_TYPE_2:String = "Points";	 	//  Points
		public static const POWERUP_TYPE_3:String = "Time";		// Time

		public static const POWERUP_TYPE_RUBY_S:String = "RubyS";		// Heal
		public static const POWERUP_TYPE_RUBY_L:String = "RubyL";	 	//  Points
		public static const POWERUP_TYPE_EMERALD_S:String = "EmeraldS";		// Time
		public static const POWERUP_TYPE_EMERALD_L:String = "EmeraldL";		// Heal
		public static const POWERUP_TYPE_DIAMOND_S:String = "DiamondS";	 	//  Points
		public static const POWERUP_TYPE_DIAMOND_L:String = "DiamondL";		// Time
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mPowerUpType:String;
		
		public var mBaseClass:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function PowerUp():void
		{
			super();
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get powerUpType():String
		{
			return mPowerUpType;
		}
		
		public function set powerUpType(pString:String):void
		{
			mPowerUpType = pString;	
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		 
		 /**
		 * @Note: Items been deactivated
		 */
		 
		 protected function deActivateItemChild(evt:Event):void
		 {
	
		 		Tweener.addTween
				(
	           		this, 
	           		{
	           			alpha:0, 
	           			time:.5, 
	           			onComplete:removeObject
	           		}
				);  		
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mCollisionDisplayArray = [this];
			mType = PowerUp.COLLISION_TYPE;
			registerEventDispatcher(GameCore.KEY);
		
			addEventListener( AbsInteractiveDisplayObject.EVENT_DEACTIVATED, deActivateItemChild, false, 0, true);
		}
		
		protected function removeObject():void
		{
			mSharedEventDispatcher.dispatchEvent(new CustomEvent({object:this},GameEvents.REMOVE_DISPLAYOBJECT));
		}
		
		
	}
	
}
