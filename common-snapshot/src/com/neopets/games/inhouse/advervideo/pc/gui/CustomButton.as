/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	/**
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 09 Sept 2009
	*/	
	
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		
	 
	 public class CustomButton extends NeopetsButton {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _mytext:String;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CustomButton():void {
			super();
			label_mouseEnabled = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public override function setText(pString:String):void {
			_mytext = pString;
			var str:String = NPTextData.replaceToken(_mytext, "%color", NPTextData.getTranslationOf("IDS_MENU_NORMAL_COLOR"));
			NPTextData.pushCustomText(this, "label_txt", str);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		protected override function rollOverHandler():void {
			gotoAndStop("on");
			var str:String = NPTextData.replaceToken(_mytext, "%color", NPTextData.getTranslationOf("IDS_MENU_HIGHLIGHT_COLOR"));
			NPTextData.pushCustomText(this, "label_txt", str);
		}
		
		protected override function rollOutHandler():void {
			gotoAndStop("off");	
			var str:String = NPTextData.replaceToken(_mytext, "%color", NPTextData.getTranslationOf("IDS_MENU_NORMAL_COLOR"));
			NPTextData.pushCustomText(this, "label_txt", str);
		}
		
		protected override function mouseDownHandler():void {
			gotoAndStop("down");
			var str:String = NPTextData.replaceToken(_mytext, "%color", NPTextData.getTranslationOf("IDS_MENU_HIGHLIGHT_COLOR"));
			NPTextData.pushCustomText(this, "label_txt", str);
		}
		
		protected override function mouseUpHandler():void {
			var str:String = NPTextData.replaceToken(_mytext, "%color", NPTextData.getTranslationOf("IDS_MENU_NORMAL_COLOR"));
			NPTextData.pushCustomText(this, "label_txt", str);
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}