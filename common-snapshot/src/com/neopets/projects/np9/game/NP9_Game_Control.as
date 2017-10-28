// ---------------------------------------------------------------------------------------
// GAME DOCUMENT CLASS
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.game
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	
	import flash.text.TextField;
	
	import flash.events.Event;
	
	// ONLY USED IN OFFLINE MODE
	import com.neopets.projects.np9.system.NP9_Loader_Control;
	
	import flash.display.SimpleButton;
	
	// -----------------------------------------------------------------------------------
	public class NP9_Game_Control extends MovieClip {

		protected var _GS:MovieClip;
		
		public var bOffline:Boolean;
		
		// ONLY USED IN OFFLINE MODE
		private var objBIOS:MovieClip;
		private var objLoaderControl:NP9_Loader_Control;
		
		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_Game_Control() {
			
			trace("\n**"+this+": "+"Instance created!");
			
			bOffline = false;
		}
		
		// -------------------------------------------------------------------
		// CALLED ON FIRST FRAME OF GENERIC GAME
		// -------------------------------------------------------------------
		public function init( p_mcBIOS:MovieClip ):Boolean {

			objBIOS = p_mcBIOS;

			// are we offline?
			if ( this.parent.toString().toUpperCase().indexOf("STAGE",0) >= 0 ) {
				bOffline = true;
				offlineMode();
			}
				
			// get bios props
			objBIOS.visible = bOffline;
			
			return ( true );
		}
		
		// -------------------------------------------------------------------
		// TRIGGER OFFLINE MODE
		// -------------------------------------------------------------------
		public function getBIOS():MovieClip {
			
			return ( objBIOS );
		}
		
		// -------------------------------------------------------------------
		// TRIGGER OFFLINE MODE
		// -------------------------------------------------------------------
		public function offlineMode():void {
			trace("--------------------");
			trace("offlineMode()");
			trace("--------------------");
			objLoaderControl =  new NP9_Loader_Control( this );
			trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			// if the game is launched offline, we need to 
			// pass the BIOS settings to the loader class
			objLoaderControl.setEnvironment("offline");
			objLoaderControl.setOfflineBiosParams( objBIOS );
			
			this.addEventListener( Event.ENTER_FRAME, main, false, 0, true );
		}
		private function main( e:Event ):void
		{
			if ( !objLoaderControl.main() ) {
				this.removeEventListener( Event.ENTER_FRAME, main );
			}
		}

		// -------------------------------------------------------------------------------
		// CALLED FROM NP9_LOADER
		// -------------------------------------------------------------------------------
		public function setGamingSystem( p_mcGS:MovieClip ) {
			
			_GS = p_mcGS;
		}
		
		// -------------------------------------------------------------------------------
		// CALLED FROM GAME
		// -------------------------------------------------------------------------------
		public function getGamingSystem():MovieClip {
			
			return( _GS );
		}
	}
}


