
/* AS3
	Copyright 2008
*/
package com.neopets.examples.soundExample
{
	
	import com.neopets.neopetsGameShell.events.SharedListener;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.sound.SoundObj;
	import com.neopets.util.support.BaseObject;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 *	This is a Example of the Use of the Sound Manager and SoundObject Classes
	 *	For More Advance Sound Uses, See Neopets_SoundExample2
	 * 
	 *  ############ NOTES #################
	 *  We use a mcInterface MovieClip to Hold all the displayObjects that will be on stage. This is
	 *  to simplify things so we do not have to public declare all the Buttons, TextFields, and so on.
	 *  If also allows for easying the use of files between FLA's as you can just copy the mcInterface from the Library.
	 * 
	 *  The Basic of Sound is the SOUNDOBJECT. It Extends the sound Class and allows for more advance control of sound.
	 *  SoundObjects are storage in a SOUNDMANAGER. The SoundManager controls the interaction between soundObjects and the Flash enviroment.
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
	 
	public class Neopets_SoundExample extends BaseObject
	{
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mSoundManager:SoundManager;
		private var mSharedListener:SharedListener;
		
		//--------------------------------------
		//  PUBLIC VARIABLES 
		//--------------------------------------
		
		/* (Stated as they are on the Stage of the FLA) */
		public var mcInterface:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function Neopets_SoundExample():void{
			super();
			setupVars();
			setupFLA();
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: A Common place to Have all Button Commands
		 */
		 
		private function buttonAction(evt:Event):void
		{
			switch (evt.target.name)
			{
				case "btn1":
					mSharedListener.dispatchEvent(new CustomEvent({},mSharedListener.REQUEST_SND_PLAY));
					mSoundManager.soundPlay("Sound1");
					displayMessage("Sound1 is Playing");
				break;
				case "btn2":
					mSoundManager.soundPlay("Sound2");
					displayMessage("Sound2 is Playing");
				break;
				case "btn3":
					mSoundManager.soundPlay("Sound3");
					displayMessage("Sound3 is Playing");
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
						var tURL:String = (mFlexComplie) ? "include/include/ChaserThemeMusic.mp3":"include/ChaserThemeMusic.mp3";
						mSoundManager.loadSound("Sound4",SoundObj.TYPE_EXTERNAL,0,tURL);
						mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_ALLLOADED, externalSoundLoaded, false,0,true);
						mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_FILELOADED, externalSoundLoaded, false,0,true);
					}
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
			mSharedListener = new SharedListener();
			mSoundManager = new SoundManagerOld(mSoundManager,"SM_SoundExample1");	
			
		}
		
		/**
		 * 	@Note: This is the basic Setup of the FLA
		 */
		 
		private function setupFLA():void
		{
			//Setup Sound Files
			mSoundManager.loadSound("Sound1",SoundObj.TYPE_INTERNAL);
			mSoundManager.loadSound("Sound2",SoundObj.TYPE_INTERNAL);
			mSoundManager.loadSound("Sound3",SoundObj.TYPE_INTERNAL);
			
			
			//Add Event Listeners to the Buttons
			mcInterface.btn1.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
			mcInterface.btn2.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
			mcInterface.btn3.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
			mcInterface.btn4.addEventListener(MouseEvent.MOUSE_DOWN,buttonAction,false,0,true);
		}
		
		/**
		 * 	@Note: Puts a Message into the Dynamic TextField
		 */
		 
		private function displayMessage(pString:String):void
		{
			mcInterface.txtFld.appendText("\n" + pString);
		}
	}
	
}
