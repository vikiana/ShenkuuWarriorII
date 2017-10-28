//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.guardians.widgets
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 * public class ReleaseDate extends MovieClip
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ReleaseDate extends MovieClip
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
		
		public var title_txt:TextField;
		
		
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		private var _curDate:Date;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ReleaseDate extends MovieClip instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ReleaseDate()
		{
			super();
			_curDate = new Date ();
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
		public function init(date1:String, date2:String, date3:String):void {
			title_txt.text = "SEPTEMBER 24";
			processDate (date1, "IN THEATERS FRIDAY");
			processDate (date2, "IN THEATERS TOMORROW");
			processDate (date3, "NOW PLAYING");
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function processDate (d:String, newTitle:String):void {
			trace ("processing dates");
			if (_curDate.getFullYear() >= Number (d.slice (7, 11)) && _curDate.getMonth() >= Number (d.slice (0, 2))-1 && _curDate.getDate() > Number (d.slice(3,5))-1){
				title_txt.text = newTitle;
				trace ("passed");
				//date is passed
			} 
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