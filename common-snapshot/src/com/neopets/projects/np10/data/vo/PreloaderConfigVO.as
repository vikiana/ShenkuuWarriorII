//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.data.vo
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.registerClassAlias;

	/**
	 * public class PreloaderConfigVO
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class PreloaderConfigVO
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
		public var bkgURL:String = "games/preloaders/neopets/default_bkg.swf";
		public var logoURL:String = "games/preloaders/neopets/neopets_logo.png";
		public var logoOffset:Array = new Array (200, 200);
		public var logoClickURL:String = "";
		public var legalCopy:String = "<p align='center'><font size='10'  color='#008000'>this is the legal copy</font></p>";
		
		//promotional event:
		//none
		//New Game Challenge
		//Game Master Challenge
		//Daily Dare Challenge
		//Featured Game
		//Addicting Game
		//Daily Dare
		//Altador Cup
		public var promotion:String = "none";
		
		
		
		//sponsored
		public var logoClickTrackID:int = 0;
		public var preloaderTrackID:int = 0;
		public var displayTrackID:int = 0;
		public var addtlTrackingURLS:Array = [];
		public var delay:int = 3;
		
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
		 * Creates a new public class PreloaderConfigVO instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function PreloaderConfigVO()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public static function register(remoteClass:String):void
		{	
			registerClassAlias(remoteClass, com.neopets.projects.np10.data.vo.PreloaderConfigVO);		
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