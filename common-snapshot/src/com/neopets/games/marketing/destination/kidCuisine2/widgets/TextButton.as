/**
 *	This class attaches a text field to a ButtonClip.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.14.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TextButton extends ButtonClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _text:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TextButton():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get text():String { return _text; }
		
		public function set text(str:String) {
			_text = str;
			updateText();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	This functions makes sure the textfield is kept up to date.
		 **/
		
		public function updateText() {
			var txt:TextField = getChildByName("main_txt") as TextField;
			if(txt != null) {
				if(_text != null) txt.text = _text;
				else txt.text = "";
				removeEventListener(Event.ENTER_FRAME,onWaitForText);
			} else addEventListener(Event.ENTER_FRAME,onWaitForText);
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
		
		/**	
		 *	This functions triggers the mouse-out animation.
		 **/
		
		override protected function onMouseOut(ev:Event) {
			gotoAndPlay(OFF_FRAME);
			updateText();
		}
		
		/**	
		 *	This functions triggers the mouse-over animation.
		 **/
		
		override protected function onMouseOver(ev:Event) {
			gotoAndPlay(OVER_FRAME);
			updateText();
		}
		
		/**	
		 *	This functions continues every frame until text is found.
		 **/
		
		protected function onWaitForText(ev:Event) {
			updateText();
		}
		
	}
	
}