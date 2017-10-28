/* Bubblemaster version - 3/2010
 property names have been added to access stage MCs
 

*/

package com.neopets.games.inhouse.AttackOfTheRevengeAS3
{
	
	//IMPORTS
	
	import flash.display.MovieClip;
	import flash.net.*
	import flash.media.*;
	import flash.events.*
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	
	//
	import com.neopets.util.sound.SoundManager;
	//import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID; // new sound files for BubbleMaster
	
	
	/**
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive
	 *	@since  2009 
	 */
	
	

	//CLASS DECLARATION
	public class Attack_OpeningScreen extends OpeningScreen
	{	
	 
		
	    //--------------------------------------------------------------------------
	    //  Properties
	    //--------------------------------------------------------------------------	
	    // public var instructionsButton:NeopetsButton; // declared in superclass
		public var mSoundManager:SoundManager;
		 
		
	  
	    //--------------------------------------------------------------------------
	    //  Constructor
	    //--------------------------------------------------------------------------


		public function Attack_OpeningScreen ()
		{
			mSoundManager = SoundManager.instance;
			
			init();
		}	
		
		// -------------------------------------------------------------------------
		// EVENTS
		// -------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//METHODS
		//--------------------------------------------------------------------------
		
		private function init()
		{
			instructionsButton.addEventListener(MouseEvent.ROLL_OVER, btnRO );
			startGameButton.addEventListener(MouseEvent.ROLL_OVER, btnRO );
			
		}
		
		private function btnRO(e:MouseEvent):void
		{
			
			mSoundManager.soundPlay(Attack_SoundID.CREAK, false);	
			
		}
		
		
		 
		
	}
}