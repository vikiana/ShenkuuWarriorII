
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.gui
{
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.events.SingletonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This will Translate the TextField for a User for the StoryEngine and allow for URL Events to be dispatched.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  8.25.2009
	 */
	 
	public class StoryBookLinkPanel extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const SEND_URL_MESSAGE:String = "SendingURLRequest";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		protected var mTranslationManager:TranslationManager;
		protected var mSingletonED:MultitonEventDispatcher;
		protected var mKey:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookLinkPanel():void
		{
			this.root.addEventListener(StoryBookPage.SENDKEY_EVENT, setupEventDispatcher, false, 0, true);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverEvent ,false ,0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOutEvent ,false ,0, true);
			addEventListener(MouseEvent.MOUSE_UP, sendURLMessage, false, 0, true);
		}

		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onMouseOverEvent(evt:MouseEvent):void
		{
			this.gotoAndStop(2);
		}
		
		protected function onMouseOutEvent(evt:MouseEvent):void
		{
			this.gotoAndStop(1);
		}
		
		/**
		 * 	@Param		evt.oData.key					 	String					The Key for the Shared Listener	
		 * */
		 
		 protected function setupEventDispatcher (evt:CustomEvent):void
		 {
		 	mKey = evt.oData.key;	
		 	mSingletonED = MultitonEventDispatcher.getInstance(mKey);
			mSingletonED.addEventListener(StoryBookPage.TOGGLE_POPUP_VISIBILITY_EVENT, toggleVisibility, false,0, true);
		}
		 
		/**
		 * 	@Note: Send a Message to go to a URL Link
		 */
		 
		 protected function sendURLMessage(evt:MouseEvent):void
		 {
		 		mSingletonED.dispatchEvent(new CustomEvent({objectName:this.name}, 	StoryBookLinkPanel.SEND_URL_MESSAGE));
		 }
		 
		 
		/**
		 * @Note: This listens for a translation Request
		 *  @Param		evt.oData.id					String					The Language ID for TranslationManager
		**/
		
		protected function toggleVisibility(evt:CustomEvent):void
		{
			var tEndID:String;
			
			if (this.name.charAt(this.name.length-2) == "_")
			{
				tEndID = this.name.charAt(this.name.length-1)
			}
			else
			{
				tEndID = this.name.charAt(this.name.length-2) + this.name.charAt(this.name.length-1);
			}
			
			if (evt.oData.id != tEndID)
			{
				this.gotoAndStop(1);
			}
		
		}
				
	
	}
	
}
