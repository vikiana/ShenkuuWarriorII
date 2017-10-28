/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets.countdown
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	
	/**
	 *	This class handle the teaser swf.  It mostly just sets up flash var defaults.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	public class CountDownText extends CountDownDisplay 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _textField:TextField;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CountDownText():void{
			super();
			// search for textfield
			var child:DisplayObject;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is TextField) {
					textField = child as TextField;
					break;
				}
			}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get textField():TextField { return _textField; }
		
		public function set textField(txt:TextField) {
			if(txt != _textField) {
				_textField = txt;
				timeLeft = Number(FlashVarManager.getVar(DAYS_LEFT));
			}
		}
		
		override public function set timeLeft(val:Number) {
			if(isNaN(val)) return;
			if(_textField != null) _textField.htmlText = String(val);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
