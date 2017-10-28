/**
 *	Bridge class between FaerieBubblesAS3Engine and Game
 *	-The Game.as actually treats this class as main game MovieClip
 *	-The class is added in view container for the for "game screen" in engine class
 *	The main job of this class it instanciate the game class and run the "mainloop" function on enterframe
 *	Actual game core class is Game.as so please look at that class for more information
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  11.01.2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip
	import flash.events.Event;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class FaerieBubble extends MovieClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var game:Game
		private var mRootMC:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FaerieBubble():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function setRoot(pRootMC:Object):void
		{
			mRootMC = pRootMC
		}
		
		/**
		*	Instantiate the game class and pass down the main time line and this class for reference
		**/
		public function setup():void
		{
			trace ("start game")
			game = new Game ();
			addEventListener (Event.ENTER_FRAME, run)
			game.setupDoc(this, mRootMC);
		}
		
		/**
		*	start the game
		*	@PARAM		bTutorial		Boolean		If set true, start the game from tutorial other wise skip the tutorial and play the game
		**/
		public function startGame(bTutorial:Boolean = false):void
		{
			game.init(bTutorial)
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**
		*	run the mainloop function which "runs" the entire game
		**/
		protected function run (e:Event):void
		{
			game.mainLoop();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}