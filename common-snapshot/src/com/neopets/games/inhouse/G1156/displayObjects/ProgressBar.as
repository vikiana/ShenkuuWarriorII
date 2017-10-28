
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
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Game G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.19.2009
	 */
	 
	public class ProgressBar extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mId:String;
		protected var mTotalStageWidth:int;
		
		public var redline:MovieClip 			//On Stage
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ProgressBar():void{
			super();
			registerEventDispatcher(GameCore.KEY);
		}
		
		
		 
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set totalStageWidth(pWidth:int):void
		{
			mTotalStageWidth = 	pWidth;
		}
		
		public function get totalStageWidth():int
		{
			return mTotalStageWidth;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note Resets the Progress Bar
		 */
		 
		 public function reset():void
		 {
		 	gotoAndStop(1);
		 }
		 
		/**
		 * @Note: Turns On an Interactive Item
		 */
		 
		
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Resets the Bar
		 */
		 
		protected function resetBar(evt:CustomEvent):void
		{
			gotoAndStop(1);	
		}
		
		/**
		 * Resets the Bar
		 */
		 
		protected function killListeners(evt:Event):void
		{
			mSharedEventDispatcher.removeEventListener(GameEvents.SECTION_COMPLETE, updateBar);
			mSharedEventDispatcher.removeEventListener(GameEvents.LEVEL_RESET, resetBar);
			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners);	
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
			mSharedEventDispatcher.addEventListener(GameEvents.SECTION_COMPLETE, updateBar, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.LEVEL_RESET, resetBar, false, 0, true);
			mSharedEventDispatcher.addEventListener(GameEvents.GAME_CLEANUP_MEMORY, killListeners, false,0,true);
		}
		
		/**
		 * @Note: This updates the Bar
		 * @param			evt.oData.sections							int				The Number of Sections
		 * @param			evt.oData.sectionCompleted			int				The Section Just Completed		
		 */
		 
		protected function updateBar(evt:CustomEvent):void
		{
			var tFrame:int = Math.round((evt.oData.sectionCompleted / evt.oData.sections) *100);
			
			gotoAndStop(tFrame);
		}
		
	}
	
}
