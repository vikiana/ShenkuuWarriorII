/**
 *	Synopsis extends AbsIcon class.  the only additional info it carries is synopsis content text
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
		
	public class SynopsisIcon extends AbsIcon
	
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mSynopsis:String;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function SynopsisIcon (pName:String = null,pImageName:String = null, pImageClass:String = null,pTextName:String = null, pSynop:String = null, pTrackLinks:Array = null):void
		{
			super (pName, pImageName,pImageClass,pTextName, pTrackLinks)
			mSynopsis = pSynop
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get content():String
		{
			return mSynopsis;
		}
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public override function cleanup():void
		{
			removeChild (mImage)
			mImage = null;
			mSynopsis = null;
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