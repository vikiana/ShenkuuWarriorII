
/* AS3
	Copyright 2008
*/
package com.neopets.examples.neobuttons
{
	
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.sound.SoundObj;
	import com.neopets.util.support.BaseObject;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 *	This is a Example of the Use of the neoButtons and the Sound Manager and SoundObject Classes
	 *	
	 * 
	 *  ############ NOTES #################
	 *  We use a mcInterface MovieClip to Hold all the displayObjects that will be on stage. This is
	 *  to simplify things so we do not have to public declare all the Buttons, TextFields, and so on.
	 *  If also allows for easying the use of files between FLA's as you can just copy the mcInterface from the Library.
	 * 
	 *  The NeopetsButton extends the MovieClip Class and adds some simple functionality to a Button.
	 *  You need to have buttons in the FLA (Library) extend the NeopetsButton Class
	 * 
	 *  In This Example, The Buttons are already on the Stage. 
	 * 
	 *  ####################################
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.16.2009
	 */
	 
	public class Neopets_NeoButtonsExample extends BaseObject
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const BTN_OVERSND_A:String = "Btn_Over_A";
		public const BTN_OVERSND_B:String = "Btn_Over_B"
		public const BTN_OUTSND:String = "Btn_Out";
		public const BTN_CLICKSND:String = "Btn_Click";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mSoundManager:SoundManager;
		
		//--------------------------------------
		//  PUBLIC VARIABLES 
		//--------------------------------------
		
		/* (Stated as they are on the Stage of the FLA) */
		public var mcInterface:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function Neopets_NeoButtonsExample():void{
			super();
			setupVars();
			setupFLA();
		}
		
		//--------------------------------------
		//  GETTERS / SETTERS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: A Common place to Have all Button Commands
		 */
		 
		private function buttonAction(evt:Event):void
		{
			switch (evt.currentTarget.name)
			{
				case "btn1":
					displayMessage("Sound1 is Playing");
					mSoundManager.soundPlay(BTN_OVERSND_A);	
				break;
				case "btn2":
					displayMessage("Sound2 is Playing");
					mSoundManager.soundPlay(BTN_OVERSND_A);	
				break;
				case "btn3":
					displayMessage("Sound3 is Playing");
					mSoundManager.soundPlay(BTN_OVERSND_B);	
				break;
				case "btn4":
					if (mSoundManager.checkSoundObj("Sound4"))
					{
						displayMessage("Sound4 is Playing");
						mSoundManager.soundPlay("Sound4");	
					} 
					else
					{
						displayMessage("Loading Sound File 4");
						var tURL:String = "games/g13000/ChaserThemeMusic.mp3";
						mSoundManager.loadSound("Sound4",SoundObj.TYPE_EXTERNAL,0,tURL);
						mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_ALLLOADED, externalSoundLoaded, false,0,true);
						mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_FILELOADED, externalSoundLoaded, false,0,true);
					}
				break;
			}	
		}
		
		/**
		 * @Note: A Common place to Have all Button Rollover Actions
		 */
		 
		private function buttonRolloverAction(evt:Event):void
		{
			switch (evt.currentTarget.name)
			{
				case "btn1":
					mSoundManager.soundPlay(BTN_OUTSND);	
				break;
				case "btn2":
					mSoundManager.soundPlay(BTN_OUTSND);	
				break;
			}	
		}
		
		/**
		 * @NOTE: When the External Sound File is Loaded
		 */
		 
		 private function externalSoundLoaded(evt:Event):void
		 {
		 	displayMessage("External Sound File is Loaded");
		 	mSoundManager.soundPlay("Sound4");	
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * 	@Note: Sets the Vars
		 */
		 
		private function setupVars():void
		{
			mFlexComplie = false;
			mSoundManager = SoundManager.instance;
		}
		
		/**
		 * 	@Note: This is the basic Setup of the FLA
		 */
		 
		private function setupFLA():void
		{
			//Setup Sound Files
			mSoundManager.loadSound(BTN_OVERSND_A,SoundObj.TYPE_INTERNAL);
			mSoundManager.loadSound(BTN_OVERSND_B,SoundObj.TYPE_INTERNAL);
			mSoundManager.loadSound(BTN_OUTSND,SoundObj.TYPE_INTERNAL);
			mSoundManager.loadSound(BTN_CLICKSND,SoundObj.TYPE_INTERNAL);
			
			setupButtons();
		}
		
		/**
		 * 	@Note: Puts a Message into the Dynamic TextField
		 */
		 
		private function displayMessage(pString:String):void
		{
			mcInterface.txtFld.appendText("\n" + pString);
		}
		
		/**
		 * @Note: Setup for the NeoButtons
		 * @Note: Buttons have a few qualities to them such as:
		 * @param		Data							XML or Object		The Data used for the Button Creation
		 * 				Data.visible					Boolean				Starting Visibilty of the Button
		 * 				Data.text						String				The Text in the TextField (Null if there in not one)	
		 * 
		 * @param		pID 							String				The Name of the Button
		*/
		
		private function setupButtons():void
		{
			mcInterface.btn1.init({visible:1,text:"OVER SND"},"Button_One");
			mcInterface.btn2.init({visible:1,text:"ALL SNDS"},"Button_Two");
			mcInterface.btn3.init({visible:1},"Button_Three");
			mcInterface.btn4.init({visible:1,text:"LOAD SND"},"Button_Four");
			
			//Example of Setting up a Button Manuelly
			mcInterface.btn3.setText ("FUN BUTTON");
			
			//Events
			mcInterface.btn1.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
			mcInterface.btn2.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
			mcInterface.btn3.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
			mcInterface.btn4.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);	
			
			mcInterface.btn1.addEventListener(MouseEvent.MOUSE_OVER,buttonRolloverAction,false,0,true);
			mcInterface.btn2.addEventListener(MouseEvent.MOUSE_OVER,buttonRolloverAction,false,0,true);
			
		}
	}
	
}
