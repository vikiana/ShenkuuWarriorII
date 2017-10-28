/**
 *
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *
 **/

package com.neopets.projects.destination.destinationV3.movieTheater
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.navigateToURL
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	import com.neopets.util.events.CustomEvent;
	
	
	public class GameObject extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private var mImage:DisplayObject
		private var mLinkURL:String
		private var mTarget:String
		private var mTrackerArray:Array;
		private var mTitle:String;
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GameObject (pName:String, pTitle:String = null, pImage:DisplayObject = null, pURL:String = null, pTarget:String = null, pArray:Array= null):void
		{
			//trace ("lobby poster created", pName, pImage, pURL, pTarget, pArray, pActive)
			name = pName;
			if (pImage != null)
			{
				mImage = pImage;
				addChild(mImage);
			}
			mLinkURL = pURL;
			mTarget = pTarget;
			mTrackerArray = pArray;
			mTitle = pTitle;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get linkURL():String
		{
			return mLinkURL;
		}
		
		public function get target():String
		{
			return mTarget;
		}
		
		public function get tracking():Array
		{
			return mTrackerArray;
		}
		
		
		public function get title(): String
		{
			return mTitle;
		}

		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function addImage(pImage:DisplayObject)
		{
			if (pImage != null && mImage == null)
			{
				mImage = pImage;
				addChild(mImage);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
	}
	
}