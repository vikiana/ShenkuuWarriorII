
/* AS3
	Copyright 2008
*/
package  com.neopets.games.inhouse.suteksTomb.game.extendedMenus
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.sound.GameSoundManager;
	import com.neopets.games.inhouse.suteksTomb.game.Sounds;
	
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *	This is a Simple Menu for the Opening Screen
	 *	The Button Click Commands are not handled at this level but at the Insatiation of this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	public class ExtInstructionScreen extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var returnBtn:NeopetsButton; 		//On Stage
		

		//public var introText_txt:TextField; //On Stage
		public var longText_txt:TextField; //On Stage
		public var longText2_txt:TextField; //On Stage
		public var longText3_txt:TextField; //On Stage
		public var longText4_txt:TextField; //On Stage
		public var longText5_txt:TextField; //On Stage
		
		public var hourglass:MovieClip;
		
		public var toggleButton:MovieClip;
		
		public var soundToggleBtn:SelectedButton; 			//On Stage
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ExtInstructionScreen():void
		{
			super();
			setupVars();

		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	The toggle button's display will be set based on GameSoundManager's music and sound setting (on or off)
		 *	This public function should be called whenever memuManager is showing the instructions page in SuteksTombEngine class
		 **/
		public function matchSoundSetting ():void
		{
			if (GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				toggleButton.gotoAndStop("on")
			}
			else if (!GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				toggleButton.gotoAndStop("sound")
			}
			else if (!GameSoundManager.musicOn && !GameSoundManager.soundOn)
			{
				toggleButton.gotoAndStop("off")
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Setups Variables
		 */
		 
		 private function setupVars():void
		 {
		 	returnBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			//soundToggleBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			toggleButton.addEventListener(MouseEvent.MOUSE_DOWN, toggleButtonClicked, false, 0, true);
		
			mID = "GameScene";
			hourglass.gotoAndStop(1)
			//toggleButton.gotoAndStop("on")
		 }
		 
		private function toggleButtonClicked (evt:MouseEvent):void
		{
			trace ("clicked")
			if (GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				GameSoundManager.musicOn = false
				GameSoundManager.stopSound(Sounds.SND_LOOP);
				toggleButton.gotoAndStop("sound")
			}
			else if (!GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				GameSoundManager.soundOn = false
				toggleButton.gotoAndStop("off")
			}
			else if (!GameSoundManager.musicOn && !GameSoundManager.soundOn)
			{
				GameSoundManager.soundOn = true
				GameSoundManager.musicOn = true
				GameSoundManager.soundPlay(GameSoundManager.musicOn, Sounds.SND_LOOP, true);
				toggleButton.gotoAndStop("on")
			}
		}
		 
		 
	}
	
}
