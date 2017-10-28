/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.gui
{
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	
	/**
	 *	This is the
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.09.2009
	 */
	public class StoryBookNavigation extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAVIGATION_EVENT_BTN:String = "NavigationBarEventBtn";
		public static const NAVIGATION_EVENT_UPDATE:String = "NavigationBarEventUpdate";
		public static const NAV_SEND_KEY:String = "NavigationSendTheKey";
	
		public static const UPDATE_TEXT:String = "updateTextFields";
		public static const BUTTON_DISPLAY_EVENT:String = "ChangeTheButtonsVisibility";
		
		public static const PREVIOUS_BTN:String = "previous";
		public static const NEXT_BTN:String = "next";
		
		public static const KEY:String  = "NavBarKey";
		
		//--------------------------------------
		// Public Vars (On Stage in the FLA)
		//--------------------------------------
		
		protected var mSingletonED:MultitonEventDispatcher;
		public var previous_mc:MovieClip;
		public var next_mc:MovieClip;
		public var logoButton_mc:MovieClip;
		public var message_txt:TextField;
		
		protected var mRightBtnLock:Boolean;
		protected var mLeftBtnLock:Boolean;
		protected var mLanguage:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function StoryBookNavigation():void{
			super();
			mSingletonED = MultitonEventDispatcher.getInstance(StoryBookNavigation.KEY);
			addEventListener(StoryBookNavigation.NAVIGATION_EVENT_UPDATE, updateNavigation, false, 0, true);
			setupButtons();
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note this is for the StoryEngine to Update the TextFields and such
		 * @param			evt.oData.cmd				String			The Name of the Command
		 * @param			evt.oData.leftTxt				String			The Left Text Field
		 * @param			evt.oData.rightTxt			String 			The Right Text Field
		 * @param			evt.oData.messageTxt		String 			The Middle Text Field
		 * @param			evt.oData.lang				String			The Language Code for this NavBar
		 * @param			evt.oData.button			String			The Button to Hide
		 * */
		 
		public function updateNavigation (evt:CustomEvent):void
		{
			var tLang:String = "en";
			
			trace("UpdateNavigation cmd: ",evt.oData.cmd, " button: ", evt.oData.button);
			
			switch (evt.oData.cmd)
			{
				case StoryBookNavigation.UPDATE_TEXT:
				
					trace("UPDATE_TEXT cmd: ",evt.oData.cmd, " left: ", evt.oData.leftTxt, " right:",evt.oData.rightTxt);
							
					
					
					if (evt.oData.hasOwnProperty("messageTxt"))
					{
						message_txt.htmlText = evt.oData.messageTxt;	
					}
					
					if (evt.oData.hasOwnProperty("lang"))
					{
						tLang = String(evt.oData.lang).toUpperCase();
						mLanguage = tLang;
					}
					else
					{
						tLang = tLang.toUpperCase();	
						mLanguage = tLang;
					}
					
					if (mLanguage == "ZH" || mLanguage == "CH")
					{
						previous_mc.arrowLeft.visible = false;	
						next_mc.arrowRight.visible = true;
						previous_mc.previousPage_txt.htmlText = "";
						next_mc.nextPage_txt.htmlText = "";
					}
					else
					{
						previous_mc.arrowLeft.visible = false;	
						next_mc.arrowRight.visible = false;
						previous_mc.previousPage_txt.htmlText = evt.oData.leftTxt;
						next_mc.nextPage_txt.htmlText = evt.oData.rightTxt;	
					}
					
					mSingletonED.dispatchEvent(new CustomEvent({lang:tLang}, StoryBookNavigationArtwork.TRANSLATE_ARTWORK));
					
				break;
				case StoryBookNavigation.BUTTON_DISPLAY_EVENT:
					switch (evt.oData.button)
					{
						case "left":
							mLeftBtnLock = true;
							mRightBtnLock = false;
							previous_mc.previousPage_txt.visible = false;
							next_mc.nextPage_txt.visible = true;
							
							if (mLanguage == "ZH" || mLanguage == "CH")
							{
								previous_mc.arrowLeft.visible = false;	
								next_mc.arrowRight.visible = true;
							}
						break;
						case "right":
							mLeftBtnLock = false;
							mRightBtnLock = true;
							next_mc.nextPage_txt.visible = false;
							previous_mc.previousPage_txt.visible = true;
							
							if (mLanguage == "ZH" || mLanguage == "CH")
							{
								previous_mc.arrowLeft.visible = true;	
								next_mc.arrowRight.visible = false;
							}
							
						break;
						default:
							mLeftBtnLock = false;
							mRightBtnLock = false;
							next_mc.nextPage_txt.visible = true;
							previous_mc.previousPage_txt.visible = true;
							
							if (mLanguage == "ZH" || mLanguage == "CH")
							{
								previous_mc.arrowLeft.visible = true;	
								next_mc.arrowRight.visible = true;
							}
							
						break;
					}
				
				
				break;
			}
		}
		
		/**
		 * @Note: The Mouse UP EVENT
		 */
		 
		protected function onMouseEventUp(evt:MouseEvent):void
		{
			
			var tDirection:String;
			
			switch (evt.currentTarget.name)
			{
				case "previous_mc":
					if (!mLeftBtnLock)
					{
						tDirection = StoryBookNavigation.PREVIOUS_BTN;	
						dispatchEvent(new CustomEvent({direction:tDirection}, NAVIGATION_EVENT_BTN));
					}
					
				break;
				case "next_mc":
				if (!mRightBtnLock)
					{
						tDirection = StoryBookNavigation.NEXT_BTN;
						dispatchEvent(new CustomEvent({direction:tDirection}, NAVIGATION_EVENT_BTN));
					}
				
				break;
			}
			
			
		}
		
		/**
		 * @Note: The Mouse Rollover Event (Text Fields)
		 */
		 
		 protected function onMouseEventOver (evt:MouseEvent):void
		 {
			
			
		 	var tGlowFilter:GlowFilter = new GlowFilter();
		 	tGlowFilter.color = 0xf2dc45;		//Yellow
		 	tGlowFilter.blurX = 2;
		 	tGlowFilter.blurY = 2;
		 	tGlowFilter.strength = 1.5;
		 	
		 	switch (evt.currentTarget.name)
			{
				case "previous_mc":
					
					if (mLanguage == "ZH" || mLanguage == "CH")
					{
						previous_mc.arrowLeft.gotoAndStop(2);
					}
					else
					{
						previous_mc.previousPage_txt.filters = [tGlowFilter];	
					}
				break;
				case "next_mc":
					if (mLanguage == "ZH" || mLanguage == "CH")
					{
						next_mc.arrowRight.gotoAndStop(2);
					}
					else
					{
						next_mc.nextPage_txt.filters = [tGlowFilter];
					}
					
				break;	
			}	
		 }
		 
		 /**
		 * @Note: The Mouse RollOut Event (TextFields)
		 */
		 
		 protected function onMouseEventOut (evt:MouseEvent):void
		 {
		 	switch (evt.currentTarget.name)
			{
				case "previous_mc":
					if (mLanguage == "ZH" || mLanguage == "CH")
					{
						previous_mc.arrowLeft.gotoAndStop(1);
					}
					else
					{
						previous_mc.previousPage_txt.filters = [];
					}
					
				break;
				case "next_mc":
					if (mLanguage == "ZH" || mLanguage == "CH")
					{
							next_mc.arrowRight.gotoAndStop(2);
					}
					else
					{
						next_mc.nextPage_txt.filters = [];
					}
					
					
				break;	
			}		
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupButtons():void
		{
			previous_mc.addEventListener(MouseEvent.MOUSE_UP, onMouseEventUp, false,0,true);
			next_mc.addEventListener(MouseEvent.MOUSE_UP, onMouseEventUp, false,0,true);
			
			previous_mc.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventOver, false,0,true);
			next_mc.addEventListener(MouseEvent.MOUSE_OVER, onMouseEventOver, false,0,true);
			
			previous_mc.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventOut, false,0,true);
			next_mc.addEventListener(MouseEvent.MOUSE_OUT, onMouseEventOut, false,0,true);
		
			previous_mc.buttonMode = true;
			next_mc.buttonMode = true;
			previous_mc.previousPage_txt.mouseEnabled = false;
			next_mc.nextPage_txt.mouseEnabled = false;
			mRightBtnLock = false;
			mLeftBtnLock = true;
			
		}
	}
	
}
