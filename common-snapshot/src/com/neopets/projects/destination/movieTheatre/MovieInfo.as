/**
 *	MOVIE INFO
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.projects.destination.movieTheatre
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	
	public class MovieInfo extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mVideoSourceURL:String;
		private var mClickLinkID:Number;
		private var mHint:String;
		private var mImage:MovieClip;
		private var mDescription:String;
		
		private var mBtnImageURL:String;	//for future usage
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MovieInfo (pImage:MovieClip, pVideoSource:String, pClickLinkID:String = null,  pHint:String = null, pDescription = null):void
		{			
			mVideoSourceURL = pVideoSource;
			mClickLinkID = Number(pClickLinkID);
			mHint = pHint;
			mImage = pImage
			mDescription = pDescription
			addChild(mImage)
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get videoSourceURL():String { return mVideoSourceURL};
		public function get clickLinkID():Number { return mClickLinkID};
		public function get clue():String { return mHint };
		public function get image():MovieClip { return mImage };
		public function get description():String {return mDescription};
		
		

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