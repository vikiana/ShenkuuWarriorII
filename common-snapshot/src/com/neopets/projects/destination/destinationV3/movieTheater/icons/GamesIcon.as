/**
 *	Just need call a link when clicked (games html page)
 *	This does not refer to a arcade scene/page in main movie central destination(lobby)
 *	The link should lead directly to a game's landing page (When internal) or go third party/client's page
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
		
	public class GamesIcon extends AbsLinkIcon
	
	{
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function GamesIcon (pName:String = null, pImageName:String = null,pImageClass:String = null,pTextName:String = null, pURL:String = null, pTarget:String = "_blank", pTrackArray:Array = null):void
		{
			super (pName,pImageName,pImageClass,pTextName, pURL, pTarget, pTrackArray)
		}
		
	}
}