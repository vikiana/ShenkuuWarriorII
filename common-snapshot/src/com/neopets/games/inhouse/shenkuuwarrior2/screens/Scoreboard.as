//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.screens
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	
	/**
	 * public class Scoreboard extends MovieClip
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Scoreboard extends MovieClip
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
		public var altitude:TextField;
		public var altitude_text:TextField;
		public var time:TextField;
		public var time_text:TextField;
		public var points:TextField;
		public var points_text:TextField;
		public var ledges_icon:MovieClip;
		public var ledges:TextField;
		
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var mTranslationManager:TranslationManager;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Scoreboard extends MovieClip instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function Scoreboard()
		{
			super();
			mTranslationManager = TranslationManager.instance;
			ledges_icon.gotoAndStop(1);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init ():void {
			mTranslationManager.setTextField(altitude_text, mTranslationManager.translationData.ALTITUDE_TITLE);
			mTranslationManager.setTextField(time_text, mTranslationManager.translationData.TIME_TITLE);
			mTranslationManager.setTextField(points_text, mTranslationManager.translationData.POINTS_TITLE);
			altitude.text = "0";
			time.text = "00:00";
			points.text = "0";
		}
		
		public function update(p:Number, a:Number, t:Number):void {
			points.text = String (p);
			altitude.text = String(a);
			time.text = formatTime (t);
		}
		
		public function updateLedges(n):Number {
			var l:Number = Number (ledges.text);
			ledges.text = String (l+n);
			return l+n;
		}
		
		
		public function reset():void {
			trace ("reset scoreboard");
			altitude.text = "0";
			time.text = "00:00";
			points.text = "0";
			ledges.text = "0";
			ledges_icon.gotoAndStop(1);
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function formatTime (t:Number):String {
			var min:String;
			var secs:String;
			if (Math.floor (t/60) < 1 ){
				min = "00"
			} else {
				if (Math.floor (t/60) >= 10){
					min = String (Math.floor (t/60));
				} else {
					min = "0"+Math.floor (t/60)
				}
			}
			var seconds:Number  = t - (Math.floor (t/60)*60);
			if (seconds<10){
				secs = "0"+String (seconds);
			} else {
				secs = String (seconds);
			}
			return min+":"+secs;
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