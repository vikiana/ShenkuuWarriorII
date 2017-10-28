
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.gui
{
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.ColorTransform;
	
	
	/**
	 *	This is used to Handle The reseting of the Brightness when a mouse goes off stage.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  8.25.2009
	 */
	 
	public class StoryBookBackground extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const DEFAULT_BRIGHTNESS:Number = .65;
		public static const HL_BRIGHTNESS:Number = 1;
		
		public static const  CHANGE_VISIBILITY_EVENT:String = "ChangetheBrightness";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mKey:String;
		protected var mSingletonED:MultitonEventDispatcher;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function StoryBookBackground():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver ,false ,0, true);
			
			this.root.addEventListener(StoryBookPage.SENDKEY_EVENT, setupEventDispatcher, false, 0, true);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * 	@Param		evt.oData.key					 	String					The Key for the Shared Listener	
		 * */
		 
		 protected function setupEventDispatcher (evt:CustomEvent):void
		 {
		 	mKey = evt.oData.key;	
		 	mSingletonED = MultitonEventDispatcher.getInstance(mKey);
		 }
		 
		/**
		 * @Note: When the Panel Is Clicked
		 */
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			
			var tID:String = this.name.charAt(this.name.length-1);
			
			mSingletonED.dispatchEvent(new CustomEvent({id:tID},StoryBookPage.TOGGLE_POPUP_VISIBILITY_EVENT));	
			mSingletonED.dispatchEvent(new CustomEvent({id:"ALL",amount:StoryBookPanel.HL_BRIGHTNESS},StoryBookPanel.CHANGE_VISIBILITY_EVENT));

		}
	
	}
	
}
