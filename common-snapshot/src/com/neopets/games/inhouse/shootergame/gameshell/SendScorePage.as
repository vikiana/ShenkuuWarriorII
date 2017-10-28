package com.neopets.games.inhouse.shootergame.gameshell
{
	import com.neopets.games.inhouse.shootergame.Main;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 *	Send Score Page.  
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Viviana Baldarelli
	 *	@since  6.11.2009
	 */
	public class SendScorePage extends MovieClip
	{
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var sendscoreBtn:GenericButton;
		public var restartBtn:GenericButton;
		public var score:Number = 0;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _MAIN:Main;
		private var _sl:SharedListener;

		
		/**
		 *	@Constructor
		 * 
		 * @param   main   Game Engine class.
		 * @param   sl     Shared Listener.
		 */
		public function SendScorePage(main:Main, sl:SharedListener)
		{
			super();
			_MAIN = main;
			_sl = sl;
			sendscoreBtn = new GenericButton ();
			sendscoreBtn.x = 315;
			sendscoreBtn.y = 270;
			addChild (sendscoreBtn);
			restartBtn = new GenericButton ();
			restartBtn.x = 315;
			restartBtn.y = 339;
			addChild (restartBtn);
			//
			_MAIN.gamingSystem.sendTag ("Game Finished");
			init();
		}
		
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		private function init():void{
			setupButtons();
		}
		
		private function setupButtons():void
		{
			sendscoreBtn.init (_MAIN);
			sendscoreBtn.addEventListener(MouseEvent.CLICK, onSendScore,false,0,true);
			_MAIN.setTransText("BodyFont", sendscoreBtn.label_txt, "FGS_GAME_OVER_MENU_SEND_SCORE");
			
			restartBtn.init (_MAIN);
			restartBtn.addEventListener(MouseEvent.CLICK,onRestartGame ,false,0,true);
			_MAIN.setTransText("BodyFont", restartBtn.label_txt, "FGS_GAME_OVER_MENU_RESTART_GAME");
		}
		

		private function onSendScore(e:Event):void {
			_sl.sendCustomEvent(SharedListener.SEND_SCORE, null, false, true);
			trace ("SCORE SENT:", score);
			_sl.dispatchEvent(new CustomEvent ({finalscore:score},"ShowtheNP9ScoreMeter"));
		 }
		 
		
		private function onRestartGame(e:Event):void {
		 	_sl.sendCustomEvent (SharedListener.GAME_CLEAN_UP, null, false, true);
		 } 	

		
	}	
}
