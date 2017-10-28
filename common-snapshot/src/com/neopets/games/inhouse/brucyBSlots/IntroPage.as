/**
 *	creates Introduction page
 *	Idea is that when button(s) on this page is (are) clicked, it'll carry out actions
 *	if the actiosn is pertained within instructions page.  Otherwise, it'll dispatch an event and mMainGame
 *	will listen for it.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.inhouse.brucyBSlots
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.users.abelee.resource.easyCall.QuickFunctions;
	//import com.neopets.mvc.model.SharedListener;
	//import com.neopets.util.events.CustomEvent;	
	
	import flash.text.TextField;
	
	public class IntroPage extends MovieClip {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public static const PLAY_GAME:String = "play_game";
		public static const VIEW_INSTRUCTIONS:String = "view_instructions";
		public static const MUSIC_ON:String = "music_on";
		public static const MUSIC_OFF:String = "music_off";
		public static const SOUND_ON:String = "sound_on";
		public static const SOUND_OFF:String = "sound_off";
		
		private var mMainGame:Object;
		private var mClickedButton:String;		//keeps track of latest button that's clicked
		private var mSoundOn:Boolean;		//if sound is on or off
		private var mMusicOn:Boolean;		//if music is on of off
		private var bg:MovieClip;					// bg is the movieclip of the entire intro screen
		private var buttonArray:Array;
		
		//private var testText:TextField;
		//private var mListener:SharedListener;
		
		
		//----------------------------------------
		//constructor
		//----------------------------------------
		public function IntroPage(pMainGame:Object) {
			mMainGame = pMainGame;
			mSoundOn = true
			mMusicOn = true
		}		
		
		//----------------------------------------
		//Getters and setters
		//----------------------------------------
		public function get soundOn():Boolean
		{
			return mSoundOn;
		}
		public function set soundOn(b:Boolean):void
		{
			mSoundOn = b
		}
		public function get musicOn():Boolean
		{
			return mMusicOn;
		}
		public function set musicOn(b:Boolean):void
		{
			mMusicOn = b
		}
		public function get clickedButton():String
		{
			return mClickedButton;
		}
		
		
		
		//----------------------------------------
		//public fucntions
		//----------------------------------------
		
		public function init():void
		{
			var playGame:String = mMainGame.system.getTranslation ("IDS_MAIN_MENU_BUTTON_PLAY");
			var viewIst:String = mMainGame.system.getTranslation ("IDS_MAIN_MENU_BUTTON_INSTRUCTIONS");
			//addEventListener(MouseEvent.MOUSE_DOWN, carryOutFunction)
			createBackground()
			//placeButton ("GenericButton", PLAY_GAME, playGame, 140, 380);
			//placeButton ("GenericButtonB", VIEW_INSTRUCTIONS,viewIst, 140, 450);
			//placeToggleButton ("SoundToggleButton", SOUND_ON, "Sound On", 180, 525, mMainGame.soundOn);
			//placeToggleButton ("MusicToggleButton", MUSIC_ON, "Music On", 80, 525, mMainGame.musicOn);		
		}
		
		
		////
		// 	Most Generic function to place a button
		//	
		//	@PARAM		pBtnClass		Export class name from the asset library
		//	@PARAM		pName			Name of the button
		//	@PARAM		pText			Text that'll be shown on the button
		//	@PARAM		px				x position
		//	@PARAM		py				y position
		////
		public function placeButton (buttonClass:String, pName:String, pText:String, px:Number, py:Number):void
		{
			var btnClass:Class = mMainGame.assetInfo.getDefinition(buttonClass)
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.name = pName;
			btn.buttonMode = true;
			mMainGame.setText("headerFont", btn.btnText, pText)
			btn.btnText.mouseEnabled = false
			btn.button.mouseEnabled = false
			btn.button.gotoAndStop("out")
			if (btn.button.button != null)
			{
				btn.button.button.mouseEnabled = false
			}
			addChild(btn);
		}
		
		
		////
		//	Deals with "on" or "off" display setting of the button (music, sound etc.)
		//	The actual control of the sound and music happens at the main game level "mMainGame.musicOn"
		//	
		//	@PARAM		pBtnClass		Export class name from the asset library
		//	@PARAM		pName			Name of the button
		//	@PARAM		px				x position
		//	@PARAM		py				y position
		//	@PARAM		pb				is "on" or "off"
		////
		public function placeToggleButton (buttonClass:String, pName:String, pText:String, px:Number, py:Number, pb:Boolean = true):void
		{
			var btnClass:Class = mMainGame.assetInfo.getDefinition(buttonClass)
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.name = pName;
			btn.buttonMode = true;
			pb? btn.gotoAndStop("on"): btn.gotoAndStop("off")
			addChild(btn);
		}
		
		
		////
		// 	clean up introduction page
		////
		public function cleanup():void 
		{  
			removeEventListener(MouseEvent.MOUSE_DOWN, carryOutFunction)
			var func:QuickFunctions = new QuickFunctions ()
			func.removeChildren(this)
		}	
		
		
		
		//----------------------------------------
		//Private functions
		//----------------------------------------
		
		////
		// 	create background (for now the name is hard coded) it's not pulled out in config xml
		//	*notice the main title(logo) is embeded on the background and the language is set at this point
		////
		private function createBackground():void
		{
			var xml:XMLList = mMainGame.configXML.GAME
			if (xml.hasOwnProperty("introBackground"))
			{
				var bgClass:Class = mMainGame.assetInfo.getDefinition(xml.introBackground.@className);
				bg = new bgClass();
				bg.x = Number(xml.introBackground.@x);
				bg.y = Number(xml.introBackground.@y);
				bg.titleLogo.gotoAndStop(mMainGame.system.getFlashParam("sLang").toUpperCase());
				
				buttonArray = new Array(bg.start_game_btn,bg.instructions_btn,bg.sounds_btn,bg.music_btn);
				
				for each ( var movieClip in buttonArray)
				{
					movieClip.stop();
					movieClip.addEventListener(MouseEvent.CLICK,onAnyButtonClicked);
				}
				
				var startButtonText:String = mMainGame.system.getTranslation("IDS_MAIN_MENU_BUTTON_PLAY");
				var instructionButtonText:String = mMainGame.system.getTranslation("IDS_MAIN_MENU_BUTTON_INSTRUCTIONS");
				
				trace ("\n//////////",startButtonText, instructionButtonText)
				
				mMainGame.setText("messageFont", bg.start_game_btn.btnTextField , startButtonText);
				mMainGame.setText("messageFont", bg.instructions_btn.btnTextField , instructionButtonText);

				bg.start_game_btn.addEventListener(MouseEvent.CLICK,onPlayGameClicked);
				bg.instructions_btn.addEventListener(MouseEvent.CLICK,onViewInstructionsClicked);
				bg.sounds_btn.addEventListener(MouseEvent.CLICK,onSoundToggleClicked);
				
				if ( mMainGame.soundOn)
				{
					bg.sounds_btn.gotoAndStop("on")
				}
				else
				{
					bg.sounds_btn.gotoAndStop("off")
				}
				
				if ( mMainGame.musicOn)
				{
					bg.music_btn.gotoAndStop("on")
				}
				else
				{
					bg.music_btn.gotoAndStop("off")
				}
				
				bg.music_btn.addEventListener(MouseEvent.CLICK,onMusicToggleClicked);
				bg.addEventListener(Event.ENTER_FRAME,onButtonEnterFrame);
				addChild(bg)
			}
			else 
			{
				trace ("MISSING: intro page background")
			}
		}

			
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		/**
		 * Stops the animation of a button when it has reach a certain frame.
		 * Will probably replace this code with addFrameScript. 
		 * @param event enter frame event
		 * 
		 */		
		private function onButtonEnterFrame(event:Event):void
		{
			for each( var movieClip:MovieClip in buttonArray)
			{
				if(movieClip.currentLabel == "buttonUpToDown_end" || movieClip.currentLabel == "buttonDownToUp_end")
				{
					movieClip.stop();
				}
			} 
		}

		/**
		 * This handler plays a button sound when any button is clicked 
		 * @param event mouse event
		 * 
		 */
		private function onAnyButtonClicked(event:MouseEvent):void
		{
			mMainGame.playThisSound(mMainGame.soundBank.button, mMainGame.soundOn);
		}
		
		/**
		 * Handler for when the play game button is clicked
		 * @param event mouse event
		 * 
		 */		
		private function onPlayGameClicked(event:MouseEvent):void
		{
			mClickedButton = PLAY_GAME;
					dispatchEvent(new Event ("updateIntroStatus"))
		}
		
		/**
		 * Handler for when view instructions button is clicked
		 * @param event mouse event
		 * 
		 */		
		private function onViewInstructionsClicked(event:MouseEvent):void
		{
			mClickedButton = VIEW_INSTRUCTIONS;
					dispatchEvent(new Event ("updateIntroStatus"))
		}
		
		/**
		 * button handler for toggling the sound on and off 
		 * @param event mouse event
		 * 
		 */		
		private function onSoundToggleClicked(event:MouseEvent):void
		{
			if (mSoundOn)
			{
				mSoundOn = false;
				event.target.gotoAndStop("off")
				mClickedButton = SOUND_OFF;
			}
			else 
			{
				mSoundOn = true;
				event.target.gotoAndStop("on")
				mClickedButton = SOUND_ON
			}
			dispatchEvent(new Event ("updateIntroStatus"))
		}
		
		/**
		 * button handler for toggling music on and off 
		 * @param event mouse event
		 * 
		 */		
		private function onMusicToggleClicked(event:MouseEvent):void
		{
			if (mMusicOn)
			{
				mMusicOn = false;
				event.target.gotoAndStop("off")
				mClickedButton = MUSIC_OFF;
			}
			else 
			{
				mMusicOn = true;
				event.target.gotoAndStop("on")
				mClickedButton = MUSIC_ON
			}
			dispatchEvent(new Event ("updateIntroStatus"))
		}
		

		
		/**
		 * Plays button over animation when goes over button
		 * @param evt mouse event
		 * 
		 */
		private function btnOverState(evt:MouseEvent):void
		{
			evt.currentTarget.gotoAndPlay("buttonDownToUp");
		}
		
		/**
		 * Plays button out animation when mouse goes out of button 
		 * @param evt mouse event
		 * 
		 */
		private function btnOutState(evt:MouseEvent):void
		{
			
			evt.currentTarget.gotoAndPlay("buttonUpToDown");
		}
		
	
		
		////
		// 	carries out set of actions based on buttons that's clicked on this page
		////
		private function carryOutFunction (evt:MouseEvent):void
		{
			
			var button:MovieClip = evt.target as MovieClip
			var buttonName:String = evt.target.name;
			switch (buttonName)
			{
				case PLAY_GAME:
					mMainGame.playThisSound(mMainGame.soundBank.button, mMainGame.soundOn);
					mClickedButton = PLAY_GAME;
					dispatchEvent(new Event ("updateIntroStatus"))
					break;
				
				case VIEW_INSTRUCTIONS:
					mMainGame.playThisSound(mMainGame.soundBank.button, mMainGame.soundOn);
					mClickedButton = VIEW_INSTRUCTIONS;
					dispatchEvent(new Event ("updateIntroStatus"))
					break;
				
				case SOUND_ON:
					mMainGame.playThisSound(mMainGame.soundBank.button, mMainGame.soundOn);
					if (mSoundOn)
					{
						mSoundOn = false;
						button.gotoAndStop("off")
						mClickedButton = SOUND_OFF;
					}
					else 
					{
						mSoundOn = true;
						button.gotoAndStop("on")
						mClickedButton = SOUND_ON
					}
					dispatchEvent(new Event ("updateIntroStatus"))
					break;
				
				case MUSIC_ON:
					mMainGame.playThisSound(mMainGame.soundBank.button, mMainGame.soundOn);
					if (mMusicOn)
					{
						mMusicOn = false;
						button.gotoAndStop("off")
						mClickedButton = MUSIC_OFF;
					}
					else 
					{
						mMusicOn = true;
						button.gotoAndStop("on")
						mClickedButton = MUSIC_ON
					}
					dispatchEvent(new Event ("updateIntroStatus"))
					break;
			}
			
		}
		
		
	}
}
		