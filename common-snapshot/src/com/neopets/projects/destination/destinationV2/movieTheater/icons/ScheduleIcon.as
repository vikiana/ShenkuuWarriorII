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

 
package com.neopets.projects.destination.destinationV2.movieTheater.icons
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class ScheduleIcon extends AbsIcon
	
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
		
		public function ScheduleIcon (pName:String = null, pImageName:String = null,pImageClass:String = null,pTextName:String = null, pTrackArray:Array = null):void
		{
			super (pName, pImageName,pImageClass,pTextName, pTrackArray)
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public override function cleanup():void
		{
			removeChild (mImage)
			mImage = null;
		}
		
		
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