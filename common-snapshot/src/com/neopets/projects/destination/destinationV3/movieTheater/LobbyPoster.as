/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

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
	
	
	public class LobbyPoster extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private var mImage:DisplayObject
		private var mLinkURL:String
		private var mTarget:String
		private var mTrackerArray:Array;
		private var mActive:Boolean;
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LobbyPoster (pName:String, pImage:DisplayObject = null, pURL:String = null, pTarget:String = null, pArray:Array= null, pActive:Boolean = false):void
		{
			name = pName;
			if (pImage != null)
			{
				mImage = pImage;
				addChild(mImage);
			}
			mLinkURL = pURL;
			mTarget = pTarget;
			mTrackerArray = pArray;
			mActive = pActive
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
		
		public function get active(): Boolean
		{
			return mActive;
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