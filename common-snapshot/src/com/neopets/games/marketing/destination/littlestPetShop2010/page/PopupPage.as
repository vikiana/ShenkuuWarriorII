/**
 *	SIMPLE POPUP
 *	For this project this popup conains most of the user feedback
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.littlestPetShop2010.page
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	import com.neopets.util.events.CustomEvent;
	
	
	public class PopupPage extends PageDesitnationBase2
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupPage():void
		{
			setupPage ()
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get messages():MovieClip
		{
			var temp:MovieClip =  MovieClip(getChildByName("popupBg"))
			return temp.messages
		}
		
		public function get urlButton():MovieClip
		{
			return MovieClip(getChildByName("urlButton"))
		}
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------

		

				
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("MC_popup", "popupBg", 0, 0);
			addImage("URLButton", "urlButton", 280, 362);
			getChildByName("urlButton").visible = false;
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
	}
	
}