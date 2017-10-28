/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieTest.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPageWithBtnState;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class PageGames extends AbstractPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageGames(pName:String = null):void
		{
			super(pName);
			setupPage ()
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addTextImage("GenericBackground", "background", "Arcade Page");
			addTextButton("GenericButton", "game1", "game 1", 170, 150);
			addTextButton("GenericButton", "game2", "game 2", 320, 150);
			addTextButton("GenericButton", "game3", "game 3", 470, 150);
			
			addTextButton("GenericButton", "backToLanding", "Back", 320, 300);
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}