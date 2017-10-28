// ---------------------------------------------------------------------------------------
// THE GENERIC GAME SUPERCLASS
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.game
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Sound_Control;
		
	// -----------------------------------------------------------------------------------
	public class NP9_Generic_Game extends MovieClip{

		// GENERIC GAME VARS
		public var _ROOT:Object;
		public var _GAMINGSYSTEM:MovieClip;
		public var _SOUND:Object;

		private var __GS_INDEX:Number;

		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_Generic_Game( objDocumentClass:Object ) {
			
			_ROOT = objDocumentClass;
			
			_GAMINGSYSTEM = _ROOT.getGamingSystem();
			
			_SOUND = _GAMINGSYSTEM._SOUND;
			
			// keep track of scoring meter index
			__GS_INDEX = 0;
		}
		
		// -------------------------------------------------------------------------------
		// OFFLINE ONLY FUNCTIONS
		// -------------------------------------------------------------------------------
		public function sendScoringMeterToFront():void {

			if ( _ROOT.bOffline ) {
				
				var nNumLastChild:Number = (_ROOT.numChildren-1);
				
				// make sure scoring meter is always top DisplayObject
				if ( __GS_INDEX != nNumLastChild ) {
					_ROOT.setChildIndex( _ROOT.getChildAt(__GS_INDEX), nNumLastChild );
					__GS_INDEX = nNumLastChild;
				}
			}
		}
		
		// -------------------------------------------------------------------------------
		// OFFLINE ONLY FUNCTIONS
		// -------------------------------------------------------------------------------
		public function sendScoringMeterToBack():void {
			
			if ( _ROOT.bOffline ) {
				if ( __GS_INDEX != 0 ) {
					_ROOT.setChildIndex( _ROOT.getChildAt(__GS_INDEX), 0 );
					__GS_INDEX = 0;
				}
			}
		}
		
		// -------------------------------------------------------------------------------
		// OFFLINE ONLY FUNCTIONS
		// -------------------------------------------------------------------------------
		public function _GETHELPTEXT():String {
			
			var sDesc:String   = "<font color='#CCCCCC'>";
			var sResult:String = "<font color='#FF0000'>";
			var sSample:String = "<font color='#00FFFF'>";
			var sMethod:String = "<font color='#FFFF00'>";
			
			var sHelp:String = "<p align='left'><font size='13'>";
			
			sHelp += "<font color='#FFFFFF'>// --------------------------------------------------------------------\n";
			sHelp += "// _GAMINGSYSTEM Functions\n";
			sHelp += "// --------------------------------------------------------------------</font>\n\n";
			
			sHelp += "_GAMINGSYSTEM.getScriptServer():String\n";
			sHelp += sDesc + " Description: " + "Returns the current script server domain.</font>\n";
			sHelp += sResult + "      Result: " + _GAMINGSYSTEM.getScriptServer() + "</font>\n\n";
			
			sHelp += "_GAMINGSYSTEM.getImageServer():String\n";
			sHelp += sDesc + " Description: " + "Returns the current script server domain.</font>\n";
			sHelp += sResult + "      Result: " + _GAMINGSYSTEM.getImageServer() + "</font>\n\n";

			sHelp += "_GAMINGSYSTEM.getFlashParam( sID:String ):String\n";
			sHelp += sDesc + " Description: " + "Returns value of a swf parameter.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.getFlashParam('sUsername')</font>\n";
			sHelp += sResult + "      Result: " + _GAMINGSYSTEM.getFlashParam("sUsername") + "</font>\n\n";
			
			sHelp += "_GAMINGSYSTEM.getTranslation( identifier:String ):String\n";
			sHelp += sDesc + " Description: " + "Returns the translated text variable.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.getTranslation('FGS_MAIN_MENU_START_GAME')</font>\n\n";

			sHelp += "_GAMINGSYSTEM.addFont( font:Font, identifier:String ):void\n";
			sHelp += sDesc + " Description: " + "Adds a font to the games font list.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.addFont( new myFont1(), 'myFont1' )</font>\n\n";
			
			sHelp += "_GAMINGSYSTEM.setFont( sID:String ):void\n";
			sHelp += sDesc + " Description: " + "Selects a font from the games font list.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.setFont( 'myFont1' )</font>\n\n";

			sHelp += "_GAMINGSYSTEM.setTextField( tfInstance:TextField, sHTML:String ):void\n";
			sHelp += sDesc + " Description: " + "Formats textfield and sets its HTML text property.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.setTextField( myTextField, myHTMLString )</font>\n\n";

			sHelp += "_GAMINGSYSTEM.sendTag( tag:String ):void\n";
			sHelp += sDesc + " Description: " + "NeoContent & Flash tracking.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.sendTag('Game Started')</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.sendTag('Game Finished')</font>\n\n";

			sHelp += "_GAMINGSYSTEM.createEvar( xVar:* ):Object\n";
			sHelp += sDesc + " Description: " + "Creates an encrypted variable.</font>\n";
			sHelp += sSample + "     Example: " + "var objEvar:Object = _GAMINGSYSTEM.createEvar(0)</font>\n";
			sHelp += sMethod + "     Methods: " + "objEvar.show()\n";
			sHelp += "              " + "objEvar.changeBy( myValue )\n";
			sHelp += "              " + "objEvar.changeTo( myValue )</font>\n\n";

			sHelp += "_GAMINGSYSTEM.sendScore( nVal:Number ):void\n";
			sHelp += sDesc + " Description: " + "Sends the score to the server.</font>\n";
			sHelp += sSample + "     Example: " + "_GAMINGSYSTEM.sendScore( myEvar.show() )</font>\n\n\n";
			
			
			sHelp += "<font color='#FFFFFF'>// --------------------------------------------------------------------\n";
			sHelp += "// _SOUND Functions\n";
			sHelp += "// --------------------------------------------------------------------</font>\n\n";
			
			sHelp += "_SOUND.setFX( active:Boolean ):void\n";
			sHelp += sDesc + " Description: " + "Sets sound effects flag.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.setFX( myFXSetting )</font>\n\n";
			
			sHelp += "_SOUND.getFX():Boolean\n";
			sHelp += sDesc + " Description: " + "Returns the setting for sound effects.</font>\n";
			sHelp += sResult + "      Result: " + _SOUND.getFX() + "</font>\n\n";
			
			sHelp += "_SOUND.setMusic( active:Boolean ):void\n";
			sHelp += sDesc + " Description: " + "Sets music loops flag.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.setMusic( myMusicSetting )</font>\n\n";
			
			sHelp += "_SOUND.getMusic():Boolean\n";
			sHelp += sDesc + " Description: " + "Returns the setting for music loops..</font>\n";
			sHelp += sResult + "      Result: " + _SOUND.getMusic() + "</font>\n\n";
			
			sHelp += "_SOUND.addFX( FX:Sound, identifier:String, multiple:Boolean ):void\n";
			sHelp += sDesc + " Description: " + "Adds a sound effect to the games sound effects list.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.addFX( new FXClick(), 'myClick', true )</font>\n\n";
			
			sHelp += "_SOUND.addMusic( music:Sound, identifier:String, multiple:Boolean ):void\n";
			sHelp += sDesc + " Description: " + "Adds a music loop to the games music loops list.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.addMusic( new musicLoop(), 'myMusic', false )</font>\n\n";
			
			sHelp += "_SOUND.playFX( identifier:String,\n";
			sHelp += "               [ offset:int, loops:int, volume:Number, pan:Number ] ):void\n";
			sHelp += sDesc + " Description: " + "Plays a sound effect.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.playFX( 'myClick' )</font>\n\n";
			
			sHelp += "_SOUND.playMusic( identifier:String,\n";
			sHelp += "               [ offset:int, loops:int, volume:Number, pan:Number ] ):void\n";
			sHelp += sDesc + " Description: " + "Plays a music loop.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.playMusic( 'myMusic', 0, 9999, 1, 0 )</font>\n\n";
			
			sHelp += "_SOUND.fadeFX( identifier:String,\n";
			sHelp += "               [ volume:int, pan:Number, millisecs:int ] ):void\n";
			sHelp += sDesc + " Description: " + "Fades a sound effect.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.fadeFX( 'myClick', 0, 0, 1000 )</font>\n\n";
			
			sHelp += "_SOUND.fadeMusic( identifier:String,\n";
			sHelp += "               [ volume:int, pan:Number, millisecs:int ] ):void\n";
			sHelp += sDesc + " Description: " + "Fades a music loop.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.fadeMusic( 'myMusic', 1, 0, 2000 )</font>\n\n";
			
			sHelp += "_SOUND.stopFX( [ identifier:String ] ):void\n";
			sHelp += sDesc + " Description: " + "Stops all sound effects or single sound effect if\n identifier is set.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.stopFX( 'myClick' )</font>\n\n";
			
			sHelp += "_SOUND.stopMusic( [ identifier:String ] ):void\n";
			sHelp += sDesc + " Description: " + "Stops all music loops or single music loop if\n identifier is set.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.stopMusic( 'myMusic' )</font>\n\n";
			
			sHelp += "_SOUND.stopAll():void\n";
			sHelp += sDesc + " Description: " + "Stops all sound effects and music loops.</font>\n";
			sHelp += sSample + "     Example: " + "_SOUND.stopAll()</font>\n\n";
			
			/*
		    */
		                        
			sHelp += "</font><p>";

			return( sHelp );
		}
		
		// -------------------------------------------------------------------------------
		// 
		// -------------------------------------------------------------------------------
	}
}


