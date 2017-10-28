/**
 *	This class handles basic pop up behaviour.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  06.22.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	
	dynamic public class TeamScoreMeter extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _percentScore:Number;
		// components
		protected var _scoreField:TextField;
		protected var _meterMask:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TeamScoreMeter():void {
			super();
			// check for components
			_scoreField = getChildByName("score_txt") as TextField;
			_meterMask = getChildByName("mask_mc") as MovieClip;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get percentScore():Number { return _percentScore; }
		
		public function set percentScore(val:Number) {
			if(isNaN(val)) _percentScore = 0;
			else _percentScore = val;
			// set score text
			if(_scoreField) _scoreField.htmlText = _percentScore + "%";
			// go to target meter frame
			if(_meterMask != null) {
				var deci:Number = Math.min(Math.max(0,_percentScore / 100),1);
				var index:int = int(Math.ceil(deci * _meterMask.totalFrames));
				_meterMask.gotoAndStop(index);
			}
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