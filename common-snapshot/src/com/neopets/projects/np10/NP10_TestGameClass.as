//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10
{
	import com.neopets.projects.np10.managers.NP10_GameManager;
	import com.neopets.projects.np10.statemachine.events.NP10_GamingSystemEvent;
	import com.neopets.projects.np10.statemachine.interfaces.INeopetsGame;
	import com.neopets.projects.np9.system.NP9_Evar;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Example of a game class to be integrated to the gaming system
	 * 
	 * @internal Minimum requirement for a game class is to be extending MovieClip, and to have an initGame and restart public methods.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NP10_TestGameClass extends MovieClip implements INeopetsGame
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */

		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		private var _buttonStartGame:Sprite;
		private var _buttonEndGame:Sprite;
		private var _buttonPassLevel:Sprite;
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class NP10_TestGameClass instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function NP10_TestGameClass()
		{
			trace ("Test Game has been created");
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function initGame ():void {
			trace ("Test Game has been initialized")
			loadingAssets();
		}
		
		public function restartGame ():void {
			for (var i:int = numChildren; i >= 0 ; i--){
				removeChildAt(i);
			}
			createGameDisplayObjects();
		}
		
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		protected function loadingAssets ():void {
			trace ("Test Game is loading assets");
			var t:Timer = new Timer (10, 100);
			t.addEventListener(TimerEvent.TIMER, showLoadingProgress, false, 0, true);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, doneLoading, false, 0, true);
			t.start();
		}
		
		
		
		protected function startGame(e:MouseEvent):void {
			var startGameEvent:NP10_GamingSystemEvent = new NP10_GamingSystemEvent (NP10_GamingSystemEvent.GAME_STARTED);
			dispatchEvent(startGameEvent);
		}
		
		protected function endGame (e:MouseEvent):void {
			var endGameEvent:NP10_GamingSystemEvent = new NP10_GamingSystemEvent (NP10_GamingSystemEvent.GAME_ENDED);
			endGameEvent.score = new NP9_Evar (1972);
			dispatchEvent(endGameEvent);
		}
		
		protected function passLevel (e:MouseEvent):void {	
			var passLevelEvent:NP10_GamingSystemEvent = new NP10_GamingSystemEvent (NP10_GamingSystemEvent.LEVEL_PASSED);
			passLevelEvent.levelNo = new NP9_Evar(38);
			dispatchEvent(passLevelEvent);
		}
		
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function createGameDisplayObjects():void {
			_buttonStartGame = createButton (100, 50, startGame);
			_buttonEndGame = createButton (100, 120, endGame);
			_buttonPassLevel = createButton (100, 190, passLevel);
		}
		
		private function createButton (X:Number, Y:Number, clickHandler:Function):Sprite {
			var mc:Sprite = new Sprite ();
			var s:Shape = new Shape();
			s.graphics.beginFill (0xff00cc);
			s.graphics.drawRect(0, 0, 200, 50);
			s.graphics.endFill(); 
			mc.addChild (s);
			mc.x = X;
			mc.y = Y;
			mc.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			addChild (mc);
			return mc;
		}
		
		
		
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		private function showLoadingProgress (e:TimerEvent):void {
			trace (this+" is loading");
			dispatchEvent (new NP10_GamingSystemEvent (NP10_GamingSystemEvent.PROGRESS_LOADING));
		}
		
		private function doneLoading (e:TimerEvent):void {
			trace (this+" is done loading");
			createGameDisplayObjects();
			dispatchEvent(new NP10_GamingSystemEvent (NP10_GamingSystemEvent.DONE_LOADING));
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}