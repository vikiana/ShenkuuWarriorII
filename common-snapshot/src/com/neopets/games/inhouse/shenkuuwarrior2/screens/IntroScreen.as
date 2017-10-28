//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{

	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	
	/**
	 * public class IntroScreen extends AbsMenu
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class IntroScreen extends OpeningScreen
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
		public var chooseModeButton:NeopetsButton; 		//On Stage

		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var _tManager:TranslationManager;
		private var _tData:SW2_TranslationData;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class IntroScreen extends AbsMenu instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function IntroScreen()
		{
			super();
			setupVars()
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
		/**
		 * @Note: Setups Variables
		 */
		
		private function setupVars():void
		{
			_tManager = TranslationManager.instance;
			_tData = SW2_TranslationData(_tManager.translationData);
			//TRANSLATIONS
			_tManager.setTextField(startGameButton.label_txt, _tData.IDS_BTN_START);
			_tManager.setTextField(instructionsButton.label_txt, _tData.IDS_BTN_INSTRUCTION);
			
			//for testing
			_tManager.setTextField(chooseModeButton.label_txt, _tData.IDS_BTN_CHOOSEMODE);
			chooseModeButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);

			//mButtonArray = new Vector.<NeopetsButton>(); // Vector not supported by Flash Player 9
			mButtonArray.push (chooseModeButton);
			
			mcTransLogo.gotoAndStop(_tManager.languageCode);
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
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}