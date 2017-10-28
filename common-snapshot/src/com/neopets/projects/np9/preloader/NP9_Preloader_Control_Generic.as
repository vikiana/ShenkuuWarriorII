// ---------------------------------------------------------------------------------------
// Control of the Generic Game PreLoader
//
// Author: Ollie B.
// Last Update: 04/10/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.preloader
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.system.ApplicationDomain;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_TTextfields;
	
	/**
	 * A generic version of the Preloader Control.
	 * @see NP9_Preloader_Control
	 */
	public class NP9_Preloader_Control_Generic extends MovieClip {
		
		private const mcPreloader:Class = MovieClip;

		private var mcMain:MovieClip;
		
		private var objTTextfields:NP9_TTextfields;
		private var bTextInit:Boolean;
		
		private var bLoggedIn:Boolean;
		private var bPlayGame:Boolean;
		
		private var iProgressbarW:int;

		/**
		 * @Constructor
		 */
		public function NP9_Preloader_Control_Generic() {
			
			trace("\n**"+this+": "+"Instance created");
			
			objTTextfields = new NP9_TTextfields( true );
			bTextInit = false;
			
			bLoggedIn   = true;
			bPlayGame   = true;
		}
		
		/**
		 * Creates the preloader animation
		 */
		public function addAnimation():void {
		
			mcMain = new mcPreloader();
			mcMain.x = 0;
			mcMain.y = 0;
			addChild( mcMain );
			
			if ( mcMain.mcLayer != null ) {
				mcMain.mcLayer.alpha = 0; 
			}
			
			if ( mcMain.mcBar != null ) {
				iProgressbarW = mcMain.mcBar.width;
				mcMain.mcBar.width = 0;
			}
		}
		
		/**
		 * Flag the logged in and start game flags
		 * @param	p_bIsLoggedIn	True if logged in
		 * @param	p_bStartGame	True if game is started
		 */
		public function setData( p_bIsLoggedIn:Boolean, p_bStartGame:Boolean ):void {
		}
		
		/**
		 * Checks the logged in status of the player
		 * @return True if player is logged in
		 */
		public function isLoggedIn():Boolean {
			return ( bLoggedIn );
		}
		
		/**
		 * Checks if the game has started
		 * @return	True if game has started
		 */
		public function startGame():Boolean {
			return ( bPlayGame );
		}
		
		/**
		 * Sets the game start status
		 * @param	p_b
		 */
		public function setStart( p_b:Boolean ):void {
			bPlayGame = p_b;
		}
		
		/**
		 * Sets the game start status
		 * @param	p_b
		 */
		public function initTextFields( p_bIsWesternLang:Boolean ):void {			
		}
		
		/**
		 * Sets the legal text string
		 * @param	sText	The text string to display
		 */
		public function setLegalText( sText:String ):void {
		}
		
		/**
		 * Sets the preloader header text string
		 * @param	sText	The text string to display
		 */
		public function setHeaderText( sText:String ):void {
		}
		
		/**
		 * Displays the loading progress text
		 * @param	sText		Text to display
		 * @param	iPercent	Percentage of loading
		 */
		public function showLoadingProcess( sText:String, iPercent:int=0 ):void {			
			mcMain.mcBar.width = int( (iProgressbarW/100) * iPercent );
		}
	}
}


