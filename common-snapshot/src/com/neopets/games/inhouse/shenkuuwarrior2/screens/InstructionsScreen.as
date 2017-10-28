//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import com.mtvnet.vworlds.util.sound.SoundManager;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 * public class InstructionsScreen extends InstructionScreen
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class InstructionsScreen extends InstructionScreen
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
		public var title_txt:TextField;
		public var copy_txt:TextField;
		public var copy_pu_txt:TextField;
		public var copy_po_txt:TextField;
		public var copy_intro_txt:TextField;
		public var nextBtn:NeopetsButton;
		public var prevBtn:NeopetsButton;
		public var icons:MovieClip;
		public var icons2:MovieClip;
		
		
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
		 * Creates a new public class InstructionsScreen extends InstructionScreen instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function InstructionsScreen()
		{
			super();
			_tManager = TranslationManager.instance;
			_tData = SW2_TranslationData(_tManager.translationData);
			setupVars();
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
		//------------------------------------
		//--------------------------------------
		protected function setupVars():void {
			//TRANSLATIONS
			_tManager.setTextField(title_txt, _tData.IDS_INSTRUCTIONS_TITLE);
			//PAGES
			_tManager.setTextField(copy_txt, _tData.IDS_INSTRUCTIONS_COPY);
			_tManager.setTextField(copy_po_txt,_tData.IDS_INSTRUCTIONS_COPY2);
			_tManager.setTextField(copy_pu_txt, _tData.IDS_INSTRUCTIONS_COPY1);
			_tManager.setTextField(copy_intro_txt, _tData.IDS_INSTRUCTIONS_COPY3);
			//
			copy_intro_txt.visible = false;
			copy_po_txt.visible = false;
			copy_pu_txt.visible = false;
			prevBtn.visible = false;
			icons.visible = false;
			icons2.visible = false;
		
			
			//btns
			_tManager.setTextField(returnBtn.label_txt, _tData.IDS_BTN_BACK);
			nextBtn.addEventListener(MouseEvent.CLICK, getpage2);
			prevBtn.addEventListener(MouseEvent.CLICK, getpage1);
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
		private function getpage2 (evt:MouseEvent):void {
			if (!mButtonLock)
			{
				this.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_PRESSED));	
			}
			else
			{
				trace ("ButtonLock is Active for Menu: " + mID);
			}
			copy_txt.visible = false;
			copy_po_txt.visible = true;
			copy_pu_txt.visible = true;
			copy_intro_txt.visible = true;
			prevBtn.visible = true;
			nextBtn.visible = false;
			icons.visible = true;
			icons2.visible = true;
			title_txt.visible = false;
		}
		
		private function getpage1 (evt:MouseEvent):void {
			if (!mButtonLock)
			{
				this.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_PRESSED));	
			}
			else
			{
				trace ("ButtonLock is Active for Menu: " + mID);
			}
			copy_txt.visible = true;
			copy_po_txt.visible = false;
			copy_pu_txt.visible = false;
			copy_intro_txt.visible = false;
			prevBtn.visible = false;
			nextBtn.visible = true;
			icons.visible = false;
			icons2.visible = false;
			title_txt.visible = true;
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}