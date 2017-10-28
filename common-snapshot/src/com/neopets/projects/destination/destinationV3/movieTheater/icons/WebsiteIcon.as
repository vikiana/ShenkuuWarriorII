/**
 *	Just need call a link when clicked (client's web page)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 
 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------

 
package com.neopets.projects.destination.destinationV3.movieTheater.icons
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class WebsiteIcon extends AbsLinkIcon
	
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function WebsiteIcon (pName:String = null, pImageName:String = null,pImageClass:String = null,pTextName:String = null, pURL:String = null, pTarget:String = "_blank", pTrackArray:Array = null):void
		{
			trace ("whatps my url:", pURL)
			super (pName, pImageName,pImageClass,pTextName, pURL, pTarget, pTrackArray)
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
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
}