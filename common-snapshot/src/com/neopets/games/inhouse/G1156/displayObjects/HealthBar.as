/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.G1156.displayObjects
{
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 *	This is for the Health Bar
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Game G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.19.2009
	 */
	 
	public class HealthBar extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const STARTING_HEALTH:int = 100;
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var mSharedEventDispatcher:MultitonEventDispatcher;

		protected var mCurrentHealth:int;
		
		public var redline:MovieClip 			//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function HealthBar():void{
			super();
			registerEventDispatcher(GameCore.KEY);
	
			mCurrentHealth = HealthBar.STARTING_HEALTH;
		}
		
		
		 
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set health(pHealth:int):void
		{
			mCurrentHealth = 	pHealth;
		}
		
		public function get health():int
		{
			return mCurrentHealth;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note Resets the Health Bar
		 */
		 
		 public function reset():void
		 {
		 	gotoAndStop(1);

			mCurrentHealth = HealthBar.STARTING_HEALTH;
		 }
		 
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: This updates the Bar
		 * @param			evt.oData.changeAmount			int				The Section Just Completed		
		 */
		 
		protected function updateBar(evt:CustomEvent):void
		{
			mCurrentHealth -= evt.oData.changeAmount;
			var tFrame:int;

			if (mCurrentHealth > HealthBar.STARTING_HEALTH)
			{
				mCurrentHealth = HealthBar.STARTING_HEALTH;
				tFrame = 1;	
			}
			else if (0 >= mCurrentHealth)
			{
				mSharedEventDispatcher.dispatchEvent(new Event(GameEvents.PLAYER_DIED));	
				tFrame = 100;
			}
			else
			{
			tFrame = HealthBar.STARTING_HEALTH - mCurrentHealth;
			}
			
			
			gotoAndStop(tFrame);	
			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This sets up the EventDispatcher
		 * @param		pKey			String 		The Key to use for the EventDispatcher
		 */
		 

		protected function registerEventDispatcher(pKey:String):void
		{
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(pKey);
			mSharedEventDispatcher.addEventListener(GameEvents.HEALTH_CHANGE, updateBar, false, 0, true);
		}
		
	
		
	}
	
}
