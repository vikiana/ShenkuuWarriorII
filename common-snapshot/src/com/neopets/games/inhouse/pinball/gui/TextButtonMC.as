// This lets you couple dynamic text with button behaviours.
// Author: David Cary
// Last Updated: June 2008

package com.neopets.games.inhouse.pinball.gui{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TextButtonMC extends MovieClip {
		protected var _button:Sprite;
		protected var _textfield:TextField;
		protected var _text:String;
		protected var _translator:Object;
		
		// Accessor Functions
		
		public function get button():Sprite { return _button; }
		
		public function set button(spr:Sprite) {
			var clip:MovieClip
			// clear the previous button
			if(_button != null) {
				if(_button is MovieClip) {
					_button.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					_button.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					_button.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownEvent);
					_button.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpEvent);
				}
				_button.removeEventListener(MouseEvent.CLICK,onMouseClick);
			}
			// set the new button
			_button = spr;
			if(_button != null) {
				// if our "button" is actually a movieclip, set up listeners
				// to emulate button functionality.
				if(_button is MovieClip) {
					_button.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					_button.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					_button.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownEvent);
					_button.addEventListener(MouseEvent.MOUSE_UP,onMouseUpEvent);
					(_button as MovieClip).gotoAndStop("up");
				}
				_button.addEventListener(MouseEvent.CLICK,onMouseClick);
			}
		}
		
		public function get textfield():TextField { return _textfield; }
		
		public function set textfield(tf:TextField) {
			_textfield = tf;
			refreshText();
		}
		
		public function get text():String { return _text; }
		
		// Use this function to set the button text without using the translation system.
		// If the button is to be translated, use setText instead.
		public function set text(str:String) {
			_text = str;
			refreshText();
		}
		
		// Text Handling functions
		
		// This function just makes sure the textfield's text stays in synch with our text property.
		public function refreshText():void {
			if(_textfield != null) {
				if(_text != null) _textfield.htmlText = _text;
				else _textfield.htmlText = "";
			}
		}
		
		// This function will try to set the text using the translation system.  If no 
		// translation is found, the text in the second parameter can be used instead.
		public function setText(ref:String,default_text:String=null) {
			_text = translate(ref);
			if(text == null) {
				if(default_text != null) _text = default_text;
				else _text = ref;
			}
			refreshText();
		}
		
		// This function will try to use the button's translator on the target text if it has one.
		// The code below is a placeholder until this class is worked into the NP translation system.
		public function translate(ref:String):String {
			if(_translator != null) return _translator.translate(ref);
			else return null;
		}
		
		// Mouse Event Functions
		
		protected function onMouseOver(ev:MouseEvent) {
			gotoButtonFrame("over");
			refreshText();
		}
		
		protected function onMouseOut(ev:MouseEvent) {
			gotoButtonFrame("up");
			refreshText();
		}
		
		protected function onMouseDownEvent (ev:MouseEvent) {
			gotoButtonFrame("down");
			refreshText();
		}
		
		protected function onMouseUpEvent (ev:MouseEvent) {
			gotoButtonFrame("over");
			refreshText();
		}
		
		public function gotoButtonFrame(ref:String) {
			if(_button != null) {
				if(_button is MovieClip) {
					var clip:MovieClip = _button as MovieClip;
					clip.gotoAndStop(ref);
				}
			}
		}
		
		// This function is usually overriden by sub-classes.
		protected function onMouseClick(ev:MouseEvent) {
		}
		
	}
	
}