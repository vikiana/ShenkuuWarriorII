/**
 *	Abstract icon for simply having a link that it needs to call
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
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class AbsLinkIcon extends AbsIcon
	
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mLinkURL:String;	// a link to call or laod
		protected var mTarget:String;	// webpage target
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	Contructor of the clas
		 *	@PARAM		pName			String		name of this instace (will be this.name property)
		 *	@PARAM		pImageCalss		String		name of the icon class (It has to be in the library)
		 *	@PARAM		pNameText		String		name of the icon that'll be displayed on the stage
		 *	@PARAM		pURL			String		URL it needs to call
		 *	@PARAM		pTargert		String		html target base: self, blank, etc.
		 *	@PARAM		pTrackingURLs	Array		array of urls to be tracked when this icon is clicked
		 **/
		public function AbsLinkIcon (pName:String = null, pImageName:String = null, pImageClass:String = null,pTextName:String = null, pURL:String = null, pTarget:String = "_blank",  pTrackArray:Array = null):void
		{
			super (pName,pImageName, pImageClass,pTextName, pTrackArray)
			mLinkURL = pURL;
			mTarget = pTarget;
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		/**
		 *	clean up fucntion
		 **/
		public override function cleanup():void
		{
			removeChild (mImage)
			mImage = null;
			mTrackingArray = null;
			mNameText = null
			mLinkURL = null;
			mTarget = null;
		}
		
		
		/**
		 *	open up a html page according target designation
		 **/
		public function doYourThing():void
		{
			navigateToURL(new URLRequest (mLinkURL),mTarget );
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