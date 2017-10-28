
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.ExtremePotatoCounterAS3.util
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This class uses a movie clip shell and bitmap manipulation to get around a bug where dynamic
	 *  text fields become hidden when rotated.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  1.05.2010
	 */
	 
	public class BitmapText extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// protected variables
		protected var _textField:TextField;
		protected var _translationID:String;
		protected var _translatedText:String;
		protected var _bitmap:Bitmap;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function BitmapText():void {
			// create bitmap element
			_bitmap = new Bitmap();
			_bitmap.smoothing = true;
			addChild(_bitmap);
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
		
		public function get bitmap():Bitmap { return _bitmap; }
		
		public function get textField():TextField { return _textField; }
		
		public function set textField(txt:TextField) {
			if(txt != _textField) {
				_textField = txt;
				updateText();
			}
		}
		
		public function get translationID():String { return _translationID; }
		
		public function set translationID(id:String) {
			if(_translationID != id) {
				_translationID = id;
				// get translation
				var translator:TranslationManager = TranslationManager.instance;
				_translatedText = translator.getTranslationOf(_translationID);
				updateText();
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	This function makes sure our displayed bitmap matches our text.
		 */
		
		public function updateText():void {
			// update text
			if(_textField != null && _translatedText != null) {
				_textField.htmlText = _translatedText;
			}
			// copy textfield to bitmap
			if(_bitmap != null) {
				if(_textField != null) {
					// draw textfield to bitmap data
					var bmd:BitmapData = new BitmapData(_textField.width,_textField.height,true,0x00FFFFFF);
					bmd.draw(_textField);
					// assign map data to display object
					_bitmap.bitmapData = bmd;
					// position display object over text
					_bitmap.x = _textField.x;
					_bitmap.y = _textField.y;
					_bitmap.rotation = _textField.rotation;
					// hide text
					_textField.visible = false;
				} else {
					// clear bitmap
					_bitmap.bitmapData = null;
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
