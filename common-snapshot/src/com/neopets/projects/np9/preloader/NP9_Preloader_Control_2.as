// ---------------------------------------------------------------------------------------
// Control of the Game PreLoader
// This version has a 5 second delay before the game starts
//
// Author: Ollie B.
// Last Update: 04/07/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.preloader
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.events.Event;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_TTextfields;
	
	// -----------------------------------------------------------------------------------
	public class NP9_Preloader_Control_2 extends MovieClip {

		private var mcMain:mcPreloader;
		
		private var objTTextfields:NP9_TTextfields;
		private var bTextInit:Boolean;
		
		private var bLoggedIn:Boolean;
		private var bPlayGame:Boolean;
		
		private var iDelayGamestart:int;

		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_Preloader_Control_2() {
			
			trace("\n**"+this+": "+"Instance created");
			
			mcMain = new mcPreloader();
			mcMain.x = 0;
			mcMain.y = 0;
			addChild( mcMain );
			
			mcMain.addEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
			
			if ( mcMain.mcLayer != null ) {
				mcMain.mcLayer.alpha = 0; 
			}
			
			objTTextfields = new NP9_TTextfields( true );
			bTextInit = false;
			
			bLoggedIn   = true;
			bPlayGame   = false; // true
			
			iDelayGamestart = getTimer() + 4000;
		}
		
		// ---------------------------------------------------------------
		public function setData( p_bIsLoggedIn:Boolean,
		                         p_bStartGame:Boolean ):void {
		                         	
			bLoggedIn = p_bIsLoggedIn;
			bPlayGame = p_bStartGame;
			
			// just in case
			if ( bPlayGame ) {
				if ( mcMain.hasEventListener( Event.ENTER_FRAME ) ) {
					mcMain.removeEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
				}
			}
		}
		
		// ---------------------------------------------------------------
		public function isLoggedIn():Boolean {
			return ( bLoggedIn );
		}
		
		// ---------------------------------------------------------------
		public function startGame():Boolean {
			// just in case
			if ( bPlayGame ) {
				if ( mcMain.hasEventListener( Event.ENTER_FRAME ) ) {
					mcMain.removeEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
				}
			}
			return ( bPlayGame );
		}
		
		// ---------------------------------------------------------------
		public function setStart( p_b:Boolean ):Boolean {
			if ( p_b ) {
				if ( mcMain.hasEventListener( Event.ENTER_FRAME ) ) {
					mcMain.removeEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
				}
			}
			bPlayGame = p_b;
		}
		
		// ---------------------------------------------------------------
		public function initTextFields( p_bIsWesternLang:Boolean ):void {
			
			// initialize ttextfield object
			objTTextfields.init( p_bIsWesternLang );
			
			objTTextfields.addFont( new _internalVerdana(), "myVerdana" );
			objTTextfields.addFont( new _internalJokerman(), "myJoker" );
			
			trace("\n**"+this+": "+"initTextFields: "+p_bIsWesternLang);
		}
		
		// ---------------------------------------------------------------
		public function setLegalText( sText:String ):void {
			
			if ( mcMain.mcFields.txtLegal != null ) {
				mcMain.mcFields.txtLegal.embedFonts = true;
				mcMain.mcFields.txtLegal.htmlText = sText;
			}
		}
		
		// ---------------------------------------------------------------
		public function setHeaderText( sText:String ):void {
			
			if ( mcMain.mcFields.txtHeader != null ) {
				objTTextfields.setFont( "myJoker" );
				objTTextfields.setTextField( mcMain.mcFields.txtHeader, sText );
			}
		}
		
		// ---------------------------------------------------------------
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
		
		// ---------------------------------------------------------------
		private function onPreloaderEnterFrame( e:Event ):void {
			
			if ( getTimer() >= iDelayGamestart ) {
				
				mcMain.removeEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
				bPlayGame = true;
			}
		}
	}
}


