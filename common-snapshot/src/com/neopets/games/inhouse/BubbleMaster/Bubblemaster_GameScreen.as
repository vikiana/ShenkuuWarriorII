// Bubblemaster version - 3/2010

// This is an empty class that can be used later in case more items are added to the game screen

package com.neopets.games.inhouse.BubbleMaster
{
	
	//IMPORTS
	
	import flash.display.MovieClip;
	import flash.net.*
	import flash.media.*;
	import flash.events.*
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	
	import com.neopets.util.sound.SoundManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.games.inhouse.BubbleMaster.BubbleMaster_SoundID;
	
	
	
	/**
	 *	This integrates the main game scene with the NP Game Engine
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive
	 *	@since  02.23.2009 
	 */
	
	

	//CLASS DECLARATION
	public class Bubblemaster_GameScreen extends GameScreen
	{	
	 
		
	    //--------------------------------------------------------------------------
	    //  Properties
	    //--------------------------------------------------------------------------	
		 // quitGame btn already declared in super class
	   
	    //--------------------------------------------------------------------------
	    //  Constructor
	    //--------------------------------------------------------------------------


		public function Bubblemaster_GameScreen ()
		{
			//init();
			
			// the main game scene is added dynamically using the viewportEngine class
			
			
			//trace("what is: "+quitGameButton) // in superclass 
			
		}	
		
		// -------------------------------------------------------------------------
		// EVENTS
		// -------------------------------------------------------------------------
		
	
		//--------------------------------------------------------------------------
		//METHODS
		//--------------------------------------------------------------------------
		
		private function init()
		{
			
		  
		}
		
		
		
		
		
	}
}