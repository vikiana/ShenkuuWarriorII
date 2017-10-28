//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * public class EndLevelPopup extends ScorePopup
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class EndLevelPopup extends Popup
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public var nextLevelBtn:NeopetsButton;
		public var reportScoreBtn:NeopetsButton;

		public var title_txt:TextField;
		public var copy_txt:TextField;
		
		public var results:MovieClip;
		
		public var map:MovieClip;
		
		public var altitude_txt:TextField;
		public var time_txt:TextField;
		public var points_txt:TextField;
		public var score_txt:TextField;
		public var tscore_txt:TextField;
		public var accuracy_txt:TextField;
		
		public var altitude:TextField;
		public var time:TextField;
		public var points:TextField;
		public var accuracy:TextField;
		public var total:TextField;
		public var ltotal:TextField;
		
		
		
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
		 * var description
		 */
		private var _type:String ="forest";
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class EndLevelPopup extends ScorePopup instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function EndLevelPopup()
		{
			super();
			map.gotoAndStop(1);
			y = - height;
			x = 30;
			mID = "EndLevelPopupScreen";
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
			
			//MAP
			map.gotoAndStop(_type);
			//MESSAGE
			switch (_type){
				case GameInfo.POPUP_LEVEL+"1":
					_tManager.setTextField(copy_txt, _tData.IDS_ENDLEVEL_COPY1);
					break;
				case GameInfo.POPUP_LEVEL+"2":
					_tManager.setTextField(copy_txt, _tData.IDS_ENDLEVEL_COPY2);
					break;
				case GameInfo.POPUP_LEVEL+"3":
					_tManager.setTextField(copy_txt, _tData.IDS_ENDLEVEL_COPY3);
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
		
		protected function setupVars ():void {
			//title
			_tManager.setTextField(title_txt, _tData.IDS_SCORE_TITLE);
			//RESULTS
			_tManager.setTextField(results.altitude_txt, _tData.IDS_SCORE_ALTITUDE);
			_tManager.setTextField(results.time_txt, _tData.IDS_SCORE_TIME);
			_tManager.setTextField(results.points_txt, _tData.IDS_SCORE_POINTS);
			_tManager.setTextField(results.score_txt, _tData.IDS_SCORE_LSCORE);
			_tManager.setTextField(results.tscore_txt, _tData.IDS_SCORE_SCORE);
			_tManager.setTextField(results.accuracy_txt, _tData.IDS_SCORE_ACCURACY);
			
			
			_tManager.setTextField( nextLevelBtn.label_txt, _tData.IDS_BTN_NEXTLEVEL );
			_tManager.setTextField( reportScoreBtn.label_txt, _tData.IDS_BTN_SENDSCORE );
			nextLevelBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			reportScoreBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
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