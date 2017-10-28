//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	
	/**
	 * public class EndLevelPopup extends AbsMenu
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ScorePopup extends Popup
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
		public var retryBtn:NeopetsButton;
		public var reportScoreBtn:NeopetsButton;
		
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
		private var _type:String="fail";
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class EndLevelPopup extends AbsMenu instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ScorePopup()
		{
			super();
			y = - height;
			x = 30;
			mID = "ScorePopupScreen";
			setupVars();
			
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		override public function init (data:Object=null):void {
			results.altitude.htmlText = data.altitude;
			results.time.htmlText = data.time;
			results.points.htmlText = data.points;
			results.ltotal.htmlText = data.ltotal;
			results.total.htmlText = data.total;
			results.accuracy.htmlText = data.accuracy;
			//
			_type = data.type;
			switch (_type){
				/*case GameInfo.POPUP_QUIT:
					_tManager.setTextField(copy_txt, _tData.IDS_POPUP_QUIT_COPY);
					
					break;*/
				case GameInfo.POPUP_FAIL:
					if (data.levelNo >= 3){
						var str:String =  _tManager.getTranslationOf(_tData.IDS_POPUP_FAIL_SKY_COPY);
						str = str.split("$altitude").join(String(data.altitude)+" "+_tManager.getTranslationOf(_tData.IDS_UNIT));
						_tManager.setTextField(copy_txt, str);
					} else {
						_tManager.setTextField(copy_txt, _tData.IDS_POPUP_FAIL_COPY);
					}
					break;
			}
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		override protected function MouseClicked(evt:Event):void
		{
			
			super.MouseClicked(evt);
			exit();
		}
		
		protected function setupVars():void {
			//TRANSLATIONS
			_tManager.setTextField(title_txt, _tData.IDS_SCORE_TITLE);
			//RESULTS
			_tManager.setTextField(results.altitude_txt, _tData.IDS_SCORE_ALTITUDE);
			_tManager.setTextField(results.time_txt, _tData.IDS_SCORE_TIME);
			_tManager.setTextField(results.points_txt, _tData.IDS_SCORE_POINTS);
			_tManager.setTextField(results.score_txt, _tData.IDS_SCORE_LSCORE);
			_tManager.setTextField(results.tscore_txt, _tData.IDS_SCORE_SCORE);
			_tManager.setTextField(results.accuracy_txt, _tData.IDS_SCORE_ACCURACY);
			
			//btns
			_tManager.setTextField(retryBtn.label_txt, _tData.IDS_BTN_TRYAGAIN );
			retryBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			_tManager.setTextField( reportScoreBtn.label_txt, _tData.IDS_BTN_SENDSCORE );
			reportScoreBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			
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