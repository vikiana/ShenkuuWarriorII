//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
	import virtualworlds.lang.TranslationManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	
	/**
	 * public class SW2_GameOverScreen extends GameOverScreen
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class SW2_GameOverScreen extends GameOverScreen
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
		
		public var results:MovieClip;
		
		public var altitude_txt:TextField;
		public var time_txt:TextField;
		public var points_txt:TextField;
		public var score_txt:TextField;
		public var accuracy_txt:TextField;
		public var tscore_txt:TextField;
		
		public var altitude:TextField;
		public var time:TextField;
		public var points:TextField;
		public var accuracy:TextField;
		public var total:TextField;
		public var ltotal:TextField;
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
		 * Creates a new public class SW2_GameOverScreen extends GameOverScreen instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function SW2_GameOverScreen()
		{
			super()
			_tManager = TranslationManager.instance;
			_tData = SW2_TranslationData(_tManager.translationData);;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init (data:Object=null):void {
			results.visible = true;
			copy_txt.visible = true;
			results.altitude.htmlText = data.altitude;
			results.time.htmlText = data.time;
			results.points.htmlText = data.points;
			results.ltotal.htmlText = data.ltotal;
			results.total.htmlText = data.total;
			results.accuracy.htmlText = data.accuracy;

			_tManager.setTextField(copy_txt, _tData.IDS_POPUP_QUIT_COPY);
			_tManager.setTextField(title_txt, _tData.IDS_SCORE_TITLE);
		}
		
		override public function toggleInterfaceButtons(pFlag:Boolean):void
		{
			super.toggleInterfaceButtons(pFlag);
			results.visible = false;
			copy_txt.visible = false;
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
	}
}