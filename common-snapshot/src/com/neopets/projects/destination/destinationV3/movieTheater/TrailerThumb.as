/**
 *	abs icon
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 
 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------

 
package com.neopets.projects.destination.destinationV3.movieTheater
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class TrailerThumb extends MovieClip
	
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mImage:Bitmap;
		protected var mVideoLink:String;
		protected var mTrackingLinks:Array;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function TrailerThumb (pName:String = null, pImage:Bitmap = null, pVideoURL:String =  null, pTrackingLinks:Array = null):void
		{
			trace ("my Name is", pName)
			name = pName
			buttonMode = true
			mImage = pImage
			mVideoLink = pVideoURL
			mTrackingLinks = pTrackingLinks
			addChild (mImage)
			addChild (returnButtonArea())
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get iconImage():Bitmap
		{
			return mImage
		}
		
		public function get videoLink():String
		{
			return mVideoLink
		}
		
		public function get tracking():Array
		{
			return mTrackingLinks;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function cleanup():void
		{
			removeChild (mImage)
			mImage = null;
			
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected function returnButtonArea():MovieClip
		{
			var btnAreaClass:Class = getDefinitionByName("BtnArea") as Class;
			var btnArea:MovieClip = new btnAreaClass ()
			btnArea.name = "btnArea"
			btnArea.width = mImage.width;
			btnArea.height = mImage.height;
			return (btnArea)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
}