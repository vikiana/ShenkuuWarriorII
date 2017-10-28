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

package com.neopets.games.inhouse.suteksTomb.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.games.inhouse.suteksTomb.SuteksTombEngine
	
	
	public class SutekTomb extends MovieClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//private var game:Game
		private var mRootMC:Object;	//main time line
		private var mEngine:SuteksTombEngine;	//SuteksTombEngine class, needed to call reset/restart game
		private var game:Game;	//bulk of main code for the game

		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function SutekTomb():void
		{

		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function setRoot(pRootMC:Object, pEngine:SuteksTombEngine):void
		{
			mRootMC = pRootMC;
			mEngine = pEngine;
		}
		
		/**
		*	Instantiate the game class and pass down the main time line and this class for reference
		**/
		public function setup():void
		{
			trace ("start game")
			game = new Game ();
			game.setupDoc(mRootMC);
			addChild(game)
			addEventListener (Event.ENTER_FRAME, run)
			addEventListener (MouseEvent.MOUSE_DOWN, onMouseClick);
			
		}
		
		/**
		*	start the game
		*	@PARAM		bTutorial		Boolean		If set true, start the game from tutorial other wise skip the tutorial and play the game
		**/
		public function startGame(pDifficulty:int, pZenMode:Boolean):void
		{
			game.init(pDifficulty, pZenMode);
		}
		
		/**
		 *	When the game's restart button is clicked this function is called and it calls restart game function in the suteks tomb engine class (just to switch to intro menu)
		 **/
		 public function restart():void
		 {
			mEngine.restartMyGame(); 
		 }
		 
		 
		 public function endGame():void
		 {
			mEngine.quitMyGame()
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
		
		/**
		*	handles mouse clicks on items on the grid (two swap them)
		**/
		protected function onMouseClick(e:MouseEvent):void
		{
			game.mouseClick();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}