/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.pinball.objects.button
{
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.translation.TranslationObject;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	
	/**
	 *	This is for Simple Control of a Button  with a Text Field that Has different Effects on the Text Field
	 *  Since you have many Text Fields inorder for this to Work you have to have code to handle the updates to all the Fields.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Clive Henrick
	 *	@since  6.30.2009
	 */
	 
	public class TextEfxButton extends NeopetsButton
	{

		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		
		public var label_txt_On:TextField;
		public var label_txt_Down:TextField;
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TextEfxButton()
		{
			super();
			
			if (label_txt_On != null)
			{
				//label_txt_On.htmlText = "";
			}
			
			if (label_txt_Down != null)
			{
				//label_txt_Down.htmlText = "";
			}
			
			label_txt.visible = true;
			label_txt_On.visible = false;
			label_txt_Down.visible = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public override  function setText(pString:String):void
		{
			if (label_txt != null)
			{
				label_txt.htmlText = pString;
				label_txt.setTextFormat(mDefaultFormat);
				
				label_txt_On.htmlText = pString;
				label_txt_On.setTextFormat(mDefaultFormat);
				
				label_txt_Down.htmlText = pString;
				label_txt_Down.setTextFormat(mDefaultFormat);
			}
			
		}
		
		/** 
		 * @Note: This is the Init
		 * @param		pID 							String				The Name of the Button
		 * @param		pConstructionData				XML or Object		The Data used for the Button Creation
		 * @param		pSoundManager					SoundManager		The Sound Manager of the parent
		 */
		 
		public override function init( pConstructionData:Object, pID:String = "button", pSoundManager:SoundManager = null):void	
		{
			mID = pID;
			mSoundManager = pSoundManager;
			mDataObject = pConstructionData;
			
			if (mDataObject.hasOwnProperty("visible"))
			{
				displayFlag = GeneralFunctions.convertBoolean(mDataObject.visible.toString());
			}
			else
			{
				displayFlag = true;
			}
			
		
			
				
			if (mDataObject.hasOwnProperty("text"))
			{
				label_txt.htmlText = mDataObject.text;
				label_txt_On.htmlText = mDataObject.text;
				label_txt_Down.htmlText = mDataObject.text;
				
				if (mDataObject.hasOwnProperty("FORMAT"))
				{
					GeneralFunctions.setParamatersList(mDefaultFormat,mDataObject.FORMAT);	
					
					if (mDataObject.FORMAT.hasOwnProperty("font")) 
					{
						if (checkFont(mDataObject.FORMAT.font))
						{
							mDefaultFormat.font = mDataObject.FORMAT.font;
							label_txt.embedFonts = true;
							label_txt_On.embedFonts = true;	
							label_txt_Down.embedFonts = true;			
						}
						else
						{
							label_txt.embedFonts = false;	
							label_txt_On.embedFonts = false;	
							label_txt_Down.embedFonts = false;
						}
					}
				}
				
				if (mDataObject.hasOwnProperty("translationId"))
				{
					mTranslationObject = new TranslationObject(mDataObject.translationId,mDataObject.FORMAT.font,label_txt);	
				}	
				
				label_txt.setTextFormat(mDefaultFormat);
				label_txt_On.setTextFormat(mDefaultFormat);
				label_txt_Down.setTextFormat(mDefaultFormat);
			}

			if (mDataObject.hasOwnProperty("scaleX"))
			{
				scaleX = mDataObject.scaleX.toString();	
			}
			
			if (mDataObject.hasOwnProperty("scaleY"))
			{
				scaleY = mDataObject.scaleY.toString();		
			}
			
					
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		protected override function onRollOver(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				checkSoundPlayBack(evt);
				
				gotoAndStop("on");	
				label_txt_On.visible = true;
				label_txt.visible = false;	
				label_txt_Down.visible = false;	

				
			}
		}
		
		
		
		protected override function onRollOut(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
			
				gotoAndStop("off");		
				label_txt_On.visible = false
				label_txt.visible = true;	
				label_txt_Down.visible = false;	
				
				checkSoundPlayBack(evt);
			}
			
		}
		
		protected override function onDown(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				gotoAndStop("down");
				label_txt_On.visible = false
				label_txt.visible = false;	
				label_txt_Down.visible = true;	
			
				checkSoundPlayBack(evt);
				
			}
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
	}
	
}
