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
	
	
	public class PageMainLanding extends AbstractPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageMainLanding(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
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
			addTextImage("GenericBackground", "background", "Main Landing Page");
			addTextButton("GenericButton", "feedapet", "Feed A Pet", 150, 100);
			addTextButton("GenericButton", "arcade", "Arcade", 500, 100);
			addTextButton("GenericButton", "marquee1", "Marquee 1", 170, 300);
			addTextButton("GenericButton", "marquee2", "Marquee 2", 320, 300);
			addTextButton("GenericButton", "marquee3", "Marquee 3", 470, 300);
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}