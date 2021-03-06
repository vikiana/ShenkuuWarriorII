﻿

package com.neopets.games.inhouse.AttackOfTheRevengeAS3 
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
	import com.neopets.games.inhouse.AttackOfTheRevengeAS3.Attack_SoundID;
	
	
	
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
	public class Attack_GameScreen extends GameScreen
	{	
	 
		
	    //--------------------------------------------------------------------------
	    //  Properties
	    //--------------------------------------------------------------------------	
		 public var mSoundManager:SoundManager;
	   
	    //--------------------------------------------------------------------------
	    //  Constructor
	    //--------------------------------------------------------------------------


		public function Attack_GameScreen ()
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
			quitGameButton.addEventListener(MouseEvent.ROLL_OVER, btnRO );
			
			
		}
		
		private function btnRO(e:MouseEvent):void
		{
			
			mSoundManager.soundPlay(Attack_SoundID.CREAK, false);	
			
		}
		
		
		
		
		
	}
}