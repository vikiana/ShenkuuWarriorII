/**
 *	Base of all icons in the theater
 *	Not all icon's functionality has been set.
 *	So far there are only very few variations of icons:
 *	one that opens up a link or antoher one that shows a popup with text in it
 *	In case icon should be more flexible, I separated each and every icons for the future usage
 *
 *	Each icon holds only necessary information needed (they are more like simple movie clip w/data storage) 
 *	From movie theater class, it'll be determined how/what should happen with each icon
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
	import flash.utils.getDefinitionByName;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	public class AbsIcon extends MovieClip
	
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mImage:MovieClip;	//	Image of the icon
		protected var mNameText:String;	//	Title or the name of the icon different from this.name 
		protected var mTrackingArray:Array;	//	contains url(s) that needs to be tracked.
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	Contructor of the clas
		 *	@PARAM		pName			String		name of this instace (will be this.name property)
		 *	@PARAM		pImageCalss		String		name of the icon class (It has to be in the library)
		 *	@PARAM		pNameText		String		name of the icon that'll be displayed on the stage
		 *	@PARAM		pTrackingURLs	Array		array of urls to be tracked when this icon is clicked
		 **/
		public function AbsIcon (pName:String = null,pImageName:String = null, pImageClass:String = null, pNameText:String = null, pTrackingURLs:Array = null):void
		{
			name = pName
			var imageClass:Class = getDefinitionByName (pImageClass) as Class;
			mImage = new imageClass ()
			mImage.gotoAndStop(0)
			mImage.buttonMode = true
			mImage.name = pImageName
			mNameText = pNameText;
			mTrackingArray = pTrackingURLs
			addChild (mImage)
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get iconImage():MovieClip
		{
			return mImage
		}
		
		public function get tracking():Array
		{
			return mTrackingArray;
		}
		
		public function get iconText():String
		{
			return mNameText;
		}
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	clean up the variables and the image
		 **/
		public function cleanup():void
		{
			removeChild (mImage)
			mImage = null;
			mTrackingArray = null
			mNameText = null
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