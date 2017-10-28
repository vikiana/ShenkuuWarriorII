// ---------------------------------------------------------------------------------------
// Control of the Game PreLoader
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
	 * This is the first object that get loaded when a Neopets game is called.
	 */
	public class NP9_Preloader_Control extends MovieClip {

		private var mcMain:MovieClip;
		
		private var objTTextfields:NP9_TTextfields;
		private var bTextInit:Boolean;
		
		private var bLoggedIn:Boolean;
		private var bPlayGame:Boolean;

		/**
		 * @Constructor
		 */
		public function NP9_Preloader_Control() {
			
			trace("\n**"+this+": "+"Instance created");
			
			objTTextfields = new NP9_TTextfields( true );
			bTextInit = false;
			
			bLoggedIn   = true;
			bPlayGame   = true;
		}
		
		public function addAnimation():void {
			// mcMain = new mcPreloader(); // -- comment for ASDocs
			var PreloaderClass:Class = ApplicationDomain.currentDomain.getDefinition("mcPreloader") as Class;
			mcMain = new PreloaderClass();
			
			mcMain.x = 0;
			mcMain.y = 0;
			addChild( mcMain );
			
			if ( mcMain.mcLayer != null ) {
				mcMain.mcLayer.alpha = 0; 
			}
		}

		/**
		 * Flag the logged in and start game flags
		 * @param	p_bIsLoggedIn	True if logged in
		 * @param	p_bStartGame	True if game is started
		 */
		public function setData( p_bIsLoggedIn:Boolean, p_bStartGame:Boolean ):void {
			bLoggedIn = p_bIsLoggedIn;
			bPlayGame = p_bStartGame;
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
		 * Sets the western language flag for translation engine
		 * @param	p_bIsWesternLang		True if the language is western
		 */
		public function initTextFields( p_bIsWesternLang:Boolean ):void {
			
			// initialize ttextfield object
			objTTextfields.init( p_bIsWesternLang );
			
			// added for ASDocs
			var VerdanaClass:Class = ApplicationDomain.currentDomain.getDefinition("_internalVerdana") as Class;
			var JokermanClass:Class = ApplicationDomain.currentDomain.getDefinition("_internalJokerman") as Class;
			
			objTTextfields.addFont( new VerdanaClass(), "myVerdana" );
			objTTextfields.addFont( new JokermanClass(), "myJoker" );
			
			trace("\n**"+this+": "+"initTextFields: "+p_bIsWesternLang);
		}
		
		/**
		 * Sets the legal text string
		 * @param	sText	The text string to display
		 */
		public function setLegalText( sText:String ):void {
			
			if ( mcMain.mcFields.txtLegal != null ) {
				mcMain.mcFields.txtLegal.embedFonts = true;
				mcMain.mcFields.txtLegal.htmlText = sText;
			}
		}
		
		/**
		 * Sets the preloader header text string
		 * @param	sText	The text string to display
		 */
		public function setHeaderText( sText:String ):void {
			
			if ( mcMain.mcFields.txtHeader != null ) {
				objTTextfields.setFont( "myJoker" );
				objTTextfields.setTextField( mcMain.mcFields.txtHeader, sText );
			}
		}
		
		/**
		 * Displays the loading progress text
		 * @param	sText		Text to display
		 * @param	iPercent	Percentage of loading
		 */
		public function showLoadingProcess( sText:String, iPercent:int=0 ):void {
			
			if ( mcMain.mcFields.txtProgress == null ) return;
			
			if ( !bTextInit ) {
			
				bTextInit = true;	
				objTTextfields.setFont( "myVerdana" );
				objTTextfields.setTextField( mcMain.mcFields.txtProgress, "" );
			}
			
			mcMain.mcFields.txtProgress.htmlText = sText;
			
			if ( mcMain.mcLayer != null ) {
				if ( mcMain.mcLayer.alpha != 0.5 ) { 
					mcMain.mcLayer.alpha = 0.5;
				}
			}
		}
	}
}


