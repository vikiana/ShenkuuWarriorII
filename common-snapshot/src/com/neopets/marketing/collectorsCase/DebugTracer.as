/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	
	/**
	 *	This class let's you mimic the trace statement in a browser by providing global
	 *  access to a set of textfields.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  12.08.2009
	 */
	public class DebugTracer 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected static var _textfields:Array;
		protected static var _log:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function DebugTracer():void{
			if(_textfields == null) _textfields = new Array();
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Adds a textfield to our global output list.
		 * @param		tf		TextField 		TextField to be added.
		 */
		 
		public static function addTextfield(tf:TextField):void {
			if(_textfields == null) _textfields = new Array();
			if(tf != null && _textfields.indexOf(tf) < 0) {
				if(_log != null) tf.text = _log;
				else tf.text = "null";
				tf.mouseEnabled = false;
				tf.filters = [new GlowFilter(0xFFFFFF)];
				_textfields.push(tf);
			}
		}
		
		/**
		 * @Adds a new output textfield to the target container.
		 * @param		cont		DisplayObjectContainer 		Target container
		 * @param		tf_width	Number				 		New textfield's width
		 * @param		tf_height	Number				 		New textfield's height
		 */
		 
		public static function addTextfieldTo(cont:DisplayObjectContainer,tf_width:Number=0,tf_height:Number=0):TextField {
			if(cont == null) return null;
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.mouseEnabled = false;
			if(tf_width > 0) tf.width = tf_width;
			if(tf_height > 0) tf.height = tf_height;
			cont.addChild(tf);
			addTextfield(tf);
			return tf;
		}
		
		/**
		 * @This function converts an incoming message to a string and sends that 
		 * @string to all our associated textfields.
		 * @param		msg		Object 		Message to be displayed
		 */
		 
		public static function showMessage(msg:Object):void {
			var str:String = String(msg);
			// update log
			if(_log == null || _log.length < 1) _log = str;
			else _log += "\n" + str;
			// push message to our textfields
			if(_textfields != null) {
				var tf:TextField;
				for(var i:int = 0; i < _textfields.length; i++) {
					tf = _textfields[i];
					if(_log != null) tf.text = _log;
					else tf.text = "null";
				}
			} else  _textfields = new Array();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}