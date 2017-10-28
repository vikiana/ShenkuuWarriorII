//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import virtualworlds.lang.TranslationManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
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
	public class ChooseLevelScreen extends AbsMenu
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
		public var forestLevelBtn:MovieClip;
		public var mountainLevelBtn:MovieClip;
		public var icedMountainLevelBtn:MovieClip;
		public var skyLevelBtn:MovieClip;
		
		public var chooseLevelTextField:TextField;
		
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
		 * Creates a new public class ChooseModeScreen extends AbsMenu instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ChooseLevelScreen()
		{
			super();
			forestLevelBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mountainLevelBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			icedMountainLevelBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			skyLevelBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "ChooseLevelScene";

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