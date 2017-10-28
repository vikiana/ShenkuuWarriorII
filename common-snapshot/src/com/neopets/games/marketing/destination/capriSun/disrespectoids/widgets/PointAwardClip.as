/**
 *	This class acts as an interface for javascript and neocontent tracking calls.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.23.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.IParticle;
	
	public class PointAwardClip extends MovieClip implements IParticle
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _pointValue:Number;
		protected var _pointField:TextField;
		public var _textTemplate:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PointAwardClip():void {
			_textTemplate = "%1 XP"
			_pointField = DisplayUtils.getDescendantInstance(this,TextField) as TextField;
			pointValue = -1;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get active():Boolean {
			return currentFrame < totalFrames;
		}
		
		public function set active(bool:Boolean) {
			if(bool) gotoAndPlay(1);
			else gotoAndStop(totalFrames);
		}
		
		public function get pointField():TextField { return _pointField; }
		
		public function set pointField(txt:TextField) {
			if(_pointField != txt) {
				_pointField = txt;
				updateText();
			}
		}
		
		public function get pointValue():Number { return _pointValue; }
		
		public function set pointValue(val:Number) {
			if(_pointValue != val) {
				_pointValue = val;
				updateText();
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function updateText():void {
			if(_pointField != null) _pointField.htmlText = _textTemplate.replace("%1",_pointValue);
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