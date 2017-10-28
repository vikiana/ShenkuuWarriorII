//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.data.vo
{
	import com.neopets.games.marketing.destination.altadorbooths.common.Preloader;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;

	/**
	 * public class GameShellConfigVO
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class GameShellConfigVO 
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
		public var userName:String = "guest_user_account";
		public var lang = "EN";
		public var gameID:int = 0;
		public var country:String = "USA";
		
		public var gameURL:String;
	
		public var sHash:int = 0;
		
		//preloader configuration
		public var preloaderConfig:PreloaderConfigVO;
		
		//PROPOSED NEW VARS
		public var logLevel:String = "";
		public var extraStates:Vector.<StateVO>;

		
		//EVENT
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
		
		public var prizeInfo:PrizeVO;
		

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
		 * Creates a new public class GameShellConfigVO instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function GameShellConfigVO()
		{
			
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init():void{
			preloaderConfig = new PreloaderConfigVO ();
			if (promotion != "none"){
				prizeInfo = new PrizeVO ();
			}
		}
		
		
		public static function register(remoteClass:String):void
		{	
			registerClassAlias (remoteClass, com.neopets.projects.np10.data.vo.GameShellConfigVO);		
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