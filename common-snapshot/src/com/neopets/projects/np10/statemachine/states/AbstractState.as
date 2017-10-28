//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.statemachine.states
{
	import com.neopets.projects.np10.statemachine.interfaces.IGameState;
	import com.neopets.projects.np10.managers.NP10_GameManager;
	import com.neopets.projects.np10.util.EncryptedVar;
	import com.neopets.projects.np10.data.vo.GameShellConfigVO;
	import com.neopets.projects.np10.data.vo.PreloaderConfigVO;
	import com.neopets.projects.np10.data.vo.PrizeVO;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * public class AbstractState implements IGameState
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class AbstractState implements IGameState
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
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * References to all singletons managers. 
		 * 
		 * @internal  keeping all references to singletons in the abstract class helps me manage them and cleaning them properly 
		 * 
		 */
		protected var _CM:NeopetsConnectionManager = NeopetsConnectionManager.instance;
		protected var _GM:NP10_GameManager = NP10_GameManager.instance;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class AbstractState implements IGameState instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function AbstractState()
		{
		}
		
		public function enter():void {
		
		}
		
		public function exit ():void {
			_GM.nextState();
		}
		
		/*public function getShellConfig():void
		{
		}
		
		public function loadTranslation(gameID:int):void
		{
		}
		
		public function setupPreloader(config:PreloaderConfigVO):void
		{
		}
		
		public function setupGame(gameClass:Class):void
		{
		}
		
		public function loadGameConfig(URL:String):void
		{
		}
		
		public function loadAssets(assetsUrls:Array):void
		{
		}
		
		public function startGame():void
		{
		}
		
		public function endGame():void
		{
		}
		
		public function sendScore(score:EncryptedVar):void
		{
		}
		
		public function loadGame(URL:String):void
		{
		}
		
		public function displayScoreResult(prize:PrizeVO):void
		{
		}
		
		public function loadExtraState(url1:String, url2:String="", url3:String=""):void
		{
		}
		
		public function extraState1(param:Object):void
		{
		}
		
		public function extraState2(param:Object):void
		{
		}
		
		public function extraState3(param:Object):void
		{
		}*/
		
		
		public function cleanUp():void {
			_CM = null;
			_GM = null;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}