/**
 *	TrailBitmap is used to make a trail after particle affects.
 *	It has decay_rate to determine how long the trail should last.
 *
 *	@NOTE:	mDecayRate is bit misleading.  The correct understanding is "maintain rate"
 *			Meaning, mDecayRate = .9 means for every frame, it maintains 90% of previous screen
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.projects.effects.particle
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class TrailBitmap extends Bitmap
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mDecayRate:Number	// 0.9 will last longer than 0.1
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	main constructor
		 *	@PRAM		pBitmapData		BitmapData		a copy of bitmpaData where all teh particles ar shown
		 *	@PRAM		pDecayRate		Number			The rate that trail shoudl last (read @NOTE at top)
		 **/
		public function TrailBitmap(pBitmapData:BitmapData, pDecayRate:Number = .9):void
		{
			this.bitmapData = pBitmapData
			mDecayRate = pDecayRate
			if (mDecayRate >= 1) mDecayRate = 1;	// set max
			if (mDecayRate <= 0) mDecayRate = 0;	// set min
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get decay():Number
		{
			return mDecayRate;
		}
		
		
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