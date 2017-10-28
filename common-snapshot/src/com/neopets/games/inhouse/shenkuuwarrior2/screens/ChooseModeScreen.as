//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	
	/**
	 * public class ChooseModeScreen extends AbsMenu
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ChooseModeScreen extends AbsMenu
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
		public var trainingModeBtn:NeopetsButton;
		public var zenModeBtn:NeopetsButton;
		public var trainingModeTextField:TextField;
		public var zenModeTextField:TextField;
		public var title_txt:TextField;
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		protected var _tManager:TranslationManager;
		protected var _tData:SW2_TranslationData;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ChooseModeScreen extends AbsMenu instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ChooseModeScreen()
		{
			super();
			_tManager = TranslationManager.instance;
			_tData = SW2_TranslationData(_tManager.translationData);
			mID = "ChooseModeScene";
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
		protected function setupVars():void {
			//TRANSLATIONS
			_tManager.setTextField(title_txt, _tData.IDS_CHOOSEMODE_TITLE);
			//PAGES
			_tManager.setTextField(trainingModeTextField, _tData.IDS_TMODE_COPY);
			_tManager.setTextField(zenModeTextField, _tData.IDS_ZENMODE_COPY);
		
			//btns
			_tManager.setTextField(trainingModeBtn.label_txt, _tData.IDS_BTN_MODE1);
			_tManager.setTextField(zenModeBtn.label_txt, _tData.IDS_BTN_MODE2);
			
			trainingModeBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			zenModeBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
		}
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