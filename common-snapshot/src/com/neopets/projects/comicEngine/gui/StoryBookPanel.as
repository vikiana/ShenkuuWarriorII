
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
	 *	This is used to Handle Each Panel as an interactive Object
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  8.25.2009
	 */
	 
	public class StoryBookPanel extends MovieClip 
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
		public function StoryBookPanel():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown ,false ,0, true);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver ,false ,0, true);
			
			this.root.addEventListener(StoryBookPage.SENDKEY_EVENT, setupEventDispatcher, false, 0, true);
			stop();
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
			mSingletonED.addEventListener(HandleArtworkTranslation.TRANSLATE_ARTWORK, changeArtworkEvent);
			mSingletonED.addEventListener(StoryBookPanel.CHANGE_VISIBILITY_EVENT, changeVisibility, false,0, true);
		 }
		 
		/**
		 * @Note: When the Panel Is Clicked
		 */
		 
		protected function onMouseDown(evt:MouseEvent):void
		{

			var tColorTransform:ColorTransform = new ColorTransform();
			tColorTransform.blueMultiplier = HL_BRIGHTNESS;
			tColorTransform.redMultiplier = HL_BRIGHTNESS;
			tColorTransform.greenMultiplier = HL_BRIGHTNESS;
			
			 this.transform.colorTransform = tColorTransform;
		}
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			
			var tID:String;
			
			if (this.name.charAt(this.name.length-2) == "_")
			{
				tID = this.name.charAt(this.name.length-1)
			}
			else
			{
				tID = this.name.charAt(this.name.length-2) + this.name.charAt(this.name.length-1);
			}
			
			trace ('panelID:' +tID);
			
			mSingletonED.dispatchEvent(new CustomEvent({id:tID},StoryBookPage.TOGGLE_POPUP_VISIBILITY_EVENT));	
			mSingletonED.dispatchEvent(new CustomEvent({id:"ALL",amount:StoryBookPanel.DEFAULT_BRIGHTNESS},StoryBookPanel.CHANGE_VISIBILITY_EVENT));
			
			var tColorTransform:ColorTransform = new ColorTransform();
			tColorTransform.blueMultiplier = HL_BRIGHTNESS;
			tColorTransform.redMultiplier = HL_BRIGHTNESS;
			tColorTransform.greenMultiplier = HL_BRIGHTNESS;
			
			 this.transform.colorTransform = tColorTransform;

			this.gotoAndPlay(2);
		}
		
		
		/**
		 * @Note: This listens for a translation Request
		 *	@Param		evt.oData.amount			Number				The Amount to Show
		 *  @Param		evt.oData.id					String					The Language ID for TranslationManager
		**/
		
		protected function changeVisibility(evt:CustomEvent):void
		{
			if (this.name != String(evt.oData.id) || String(evt.oData.id) == "ALL")
			{
				this.gotoAndStop(1);
	
				var tColorTransform:ColorTransform = new ColorTransform();
				tColorTransform.blueMultiplier =Number(evt.oData.amount);
				tColorTransform.redMultiplier = Number(evt.oData.amount);
				tColorTransform.greenMultiplier = Number(evt.oData.amount);
			
				 this.transform.colorTransform = tColorTransform;

			}
		}
				
		/**
		 * @Note: This listens for a translation Request
		 *	@Param		evt.oData.lang				String					The Language to be Translated to
		 *  @Param		evt.oData.id					String					The Language ID for TranslationManager
		 * 	@Param		evt.oData.TransData		TranslationData		Translation Data for the Pannel
		 * 	@Param		evt.oData.transFrontID	String					The Front End of the String for Translation	
		 */
		
		protected function changeArtworkEvent(evt:CustomEvent):void
		{
				//this.alpha =StoryBookPanel.DEFAULT_ALPHA;
				mSingletonED.removeEventListener(HandleArtworkTranslation.TRANSLATE_ARTWORK, changeArtworkEvent);
				stop();
		}
			
	
	}
	
}
