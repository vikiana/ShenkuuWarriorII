//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10
{
	import com.neopets.projects.np10.NP10_Document;
	import com.neopets.projects.np10.data.vo.GameStatesVO;
	import com.neopets.projects.np10.managers.NP10_GameManager;
	import com.neopets.projects.np10.statemachine.interfaces.INeopetsGame;
	import com.neopets.projects.np10.util.Logging.NeopetsLogger;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.osmf.logging.Logger;

	/**
	 * This is the class that needs to be extended by the custom game document class.
	 * DEV NOTE: It employs a Decorator pattern to allows for different types of integration of existing games. 
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NP10_Document extends MovieClip implements INeopetsGame
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * Initial settings defaults. These are obtained from the Flashvars when online.
		 * DEV NOTE: you can override these in your document class with the specific game values you need to test.
		 */
		public var USERNAME:String = "guest_user_account";
		public var LANGUAGE:String = "EN";
		public var COUNTRY:String = "USA";
		public var GAMEID:int = 3000;
		public var LOGLEVEL:String = NeopetsLogger.DEBUG;
		
		
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		protected var _GM:NP10_GameManager;
		
		/**
		 * _game gets created/assigned in the custom game document class.
		 * 
		 */
		protected var _game:INeopetsGame;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Gets a reference to the Game Manager and initialize it.
		 * By now, _game has to be created/assigned.
		 *
		 */
		public function NP10_Document()
		{
			super();
			if (_game){
				_GM = NP10_GameManager.instance;
				_GM.init(this);
			} else {
				throw new Error ("Please instantiate or assign _game before calling the superclass constructor");
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * This is the class to override in your game document class. 
		 * It gets called by the Game Manager when the gaming system is done setting up.
		 * 
		 */
		public function initGame ():void {
			_GM.logger.info("Please override initGame in your document class", [this]);
		}
		
		
		/**
		 * This is the class to override in your game document class. 
		 * It gets called by the Game Manager when the 'restart game' button is pressed from the score resul diplay screen.
		 * 
		 */
		public function restartGame():void {
			_GM.logger.info("Please override restartGame in your document class", [this]);
		}
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
		public function get game ():INeopetsGame {
			return _game;
		}
	}
}