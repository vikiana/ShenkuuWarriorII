/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	import com.neopets.util.display.ListPane;
	
	/**
	 *	This class provides a block of pop up text with an added title bar.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  3.22.2009
	 */
	public class TitledPopUp extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var locked:Boolean;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _titleField:TextField;
		protected var _closeButton:InteractiveObject;
		protected var _contentPane:ListPane;
		protected var _txtFormat:TextFormat;
		protected var _txtWidth:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TitledPopUp():void{
			super();
			visible = false; // hide by default
			locked = false;
			// create content area
			_contentPane = new ListPane();
			_contentPane.alignment = ListPane.CENTER_ALIGN;
			addChild(_contentPane);
			// set up default component linkages
			titleField = getChildByName("title_txt") as TextField;
			closeButton = getChildByName("close_btn") as InteractiveObject;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get closeButton():InteractiveObject { return _closeButton; }
		
		public function set closeButton(btn:InteractiveObject) {
			// clear previous listeners
			if(_closeButton != null) {
				_closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			}
			// set up new button
			_closeButton = btn;
			if(_closeButton != null) {
				_closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
				if(_closeButton is Sprite) {
					Sprite(_closeButton).buttonMode = true;
				}
			}
		}
		
		public function get contentPane():ListPane { return _contentPane; }
		
		public function get titleField():TextField { return _titleField; }
		
		public function set titleField(txt:TextField) {
			_titleField = txt;
			if(_titleField != null) {
				// reuse title formatting for body text
				_txtFormat = _titleField.getTextFormat();
				_txtFormat.size = Number(_txtFormat.size) * 0.8;
				// position contents under title
				_contentPane.x = _titleField.x + (_titleField.width / 2);
				_contentPane.y = _titleField.y + _titleField.height;
				_txtWidth = _titleField.width;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// This function appends a section of text to the end of our content.
		
		public function addImage(url:String,index:int=-1):Loader {
			if(url == null || url.length <= 0) return null;
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(url);
			loader.load(req);
			_contentPane.addItemAt(loader,index);
			return loader;
		}
		
		// This function appends a section of text to the end of our content.
		
		public function addText(txt_str:String,index:int=-1):TextField {
			var txt:TextField = new TextField();
			// check formatting options
			var openner:String;
			var closer:String = "</font>";
			if(_txtFormat != null) {
				openner = "<p align='" + _txtFormat.align + "'><font";
				openner += " color='#" + _txtFormat.color.toString(16) + "'";
				openner += " face='" + _txtFormat.font + "'";
				openner += " size='" + _txtFormat.size + "'";
				openner += ">";
				// check for bolding
				if(_txtFormat.bold) {
					openner += "<b>";
					closer = "</b>" + closer;
				}
				closer += "</p>";
			} else openner = "<font>";
			// set text
			txt.htmlText = openner + txt_str + closer;
			// set special properties
			txt.embedFonts = true;
			txt.selectable = false;
			txt.multiline = true;
			txt.wordWrap = true;
			// resize bounds
			txt.width = _txtWidth;
			txt.height = txt.textHeight + 4; // add extra padding to make sure text shows
			// add text to content pane
			_contentPane.addItemAt(txt,index);
			return txt;
		}
		
		// Use this function to push text into the pop up.
		
		public function setText(header:String,body:String) {
			if(locked) return; // don't change text if locked
			if(_titleField != null) {
				if(header != null) _titleField.htmlText = header;
				else _titleField.htmlText = "";
			}
			// fill content pane
			_contentPane.clearItems();
			addText(body);
			// show pop up
			visible = true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public function onCloseRequest(ev:Event) {
			if(!locked) visible = false;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
