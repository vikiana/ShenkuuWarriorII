/**
 *	Just need call a link when clicked (banner quest html page)
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
	

	public class BannerQuestIcon extends AbsLinkIcon
	{

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function BannerQuestIcon (pName:String = null,pImageName:String = null, pImageClass:String = null,pTextName:String = null, pURL:String = null, pTarget:String = "_blank", pTrackArray:Array = null):void
		{
			super (pName, pImageName,pImageClass,pTextName, pURL, pTarget, pTrackArray)
		}
		
	
	}
}