package com.neopets.games.inhouse.shootergame.gameshell
{
	import com.neopets.games.inhouse.shootergame.Main;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	
	/**
	 *	Menu page button.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Viviana Baldarelli
	 *	@since  6.11.2009
	 */
	public class IntroButton extends CustomButton
	{
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		public var label_txt:TextField;

		private var _MAIN:Main;
	
	
		/**
		 *	@Constructor
		 */
		public function IntroButton()
		{
			super();
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		override public function init(main:Main, textVar:String="none", pID:String = "button"):void	
		{
			mID = pID;
			_MAIN = main;	
			mSoundManager = _MAIN.soundManager;
			//setup text
			if (textVar!="none"){
				var textVar: String = _MAIN.gamingSystem.getTranslation("IDS_BUTTON_HTML_OPEN") + 
									 _MAIN.gamingSystem.getTranslation(textVar) + 
									 _MAIN.gamingSystem.getTranslation("IDS_BUTTON_HTML_CLOSE");
				_MAIN.setFormattedText("bodyFont", label_txt, textVar);
			}
		}
		
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		override protected function onDown(evt:MouseEvent):void 
		{
			gotoAndStop("down");
			playButtonSnd();
		}
		
		
		override protected function playButtonSnd():void
		{
			if (_MAIN){
				if (_MAIN.soundOn){
					mSoundManager.soundPlay("mouse_over");
				}
			}
		}
		
	}
}