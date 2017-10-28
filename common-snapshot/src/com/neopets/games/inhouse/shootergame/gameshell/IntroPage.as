package com.neopets.games.inhouse.shootergame.gameshell
{
	import com.neopets.games.inhouse.shootergame.Main;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.Main;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 *	Intro Page.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Viviana Baldarelli
	 *	@since  6.11.2009
	 */
	public class IntroPage extends MovieClip
	{
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var startgameBtn:IntroButton;
		public var instructionsBtn:IntroButton;
		public var musicBtn:MusicButton;
		public var soundsBtn:SoundsButton;
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _MAIN:Main;
		private var _sl:SharedListener;
		private var titleLogo:GameLogo;

		/**
		*	@Constructor
		* 
		* @param   main   Game Engine class.
		* @param   sl     Shared Listener.
		*/
		public function IntroPage(main:Main, sl:SharedListener)
		{
			super();
			_MAIN = main;
			_sl = sl;
			instructionsBtn = new IntroButton ();
			instructionsBtn.x = 217;
			instructionsBtn.y = 308;
			addChild (instructionsBtn);
			startgameBtn = new IntroButton ();
			startgameBtn.x = 85;
			startgameBtn.y = 308;
			addChild (startgameBtn);
			musicBtn = new MusicButton();
			soundsBtn = new SoundsButton ();
			musicBtn.x = 124;
			musicBtn.y = 452;
			soundsBtn.x = 230;
			soundsBtn.y = 452;
			addChild (musicBtn);
			addChild (soundsBtn);
			titleLogo = new GameLogo ();
			titleLogo.x = 169;
			titleLogo.y = 95;
			addChild (titleLogo);
			titleLogo.gotoAndStop(_MAIN.gamingSystem.getFlashParam("sLang").toUpperCase());
			init();
		}
		
			
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		private function init ():void{
			//musicBtn.visible = false;
			//soundsBtn.visible = false;
			setupButtons();
		}
				
				
		private function setupButtons():void
		{
			startgameBtn.init (_MAIN, "FGS_MAIN_MENU_START_GAME");
			startgameBtn.addEventListener(MouseEvent.CLICK, sgBtnBehavior,false,0,true);
			
			instructionsBtn.init (_MAIN, "FGS_MAIN_MENU_VIEW_INSTRUCTIONS");
			instructionsBtn.addEventListener(MouseEvent.CLICK, iBtnBehavior,false,0,true);
			
			musicBtn.init (_MAIN);
			musicBtn.addEventListener(MouseEvent.CLICK, muBtnBehavior,false,0,true);
			
			soundsBtn.init (_MAIN);
			soundsBtn.addEventListener(MouseEvent.CLICK, soBtnBehavior,false,0,true);
		}
		
		
		private function sgBtnBehavior (e:Event):void{;
			_sl.sendCustomEvent(SharedListener.GOTO_GAME, null, false, true);
		}
		
		
		
		
		
		private function iBtnBehavior (e:Event):void{
			_sl.sendCustomEvent(SharedListener.GOTO_INSTRUCTIONS, null, false, true);
		}
		
		
		private function soBtnBehavior (e:Event):void{
			_sl.sendCustomEvent(SharedListener.CHANGE_SOUNDS, null);
		}
		
		
		private function muBtnBehavior (e:Event):void{
			_sl.sendCustomEvent(SharedListener.CHANGE_MUSIC, null);
		}

		
	}
}