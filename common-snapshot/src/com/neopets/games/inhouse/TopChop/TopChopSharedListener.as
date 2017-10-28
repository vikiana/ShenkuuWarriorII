package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import com.neopets.projects.mvc.model.SharedListener;
	import com.neopets.projects.mvc.model.BaseSharedListener;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.model.Listener;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.*;
	 
	public class TopChopSharedListener extends SharedListener
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		public const GAME_OVER_SCREEN : String = "goToGameOverScreen";
		
		//===============================================================================
		// CONSTRUCTOR TopChopSharedListener
		//===============================================================================
		public function TopChopSharedListener():void 
		{
			super( );
			
		}
		
	} // end class
	
} // end package