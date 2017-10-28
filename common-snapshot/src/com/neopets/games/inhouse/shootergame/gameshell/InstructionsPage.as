package com.neopets.games.inhouse.shootergame.gameshell
{
	import com.neopets.games.inhouse.shootergame.Main;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;



	/**
	 *	Instructions Page.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Viviana Baldarelli
	 *	@since  6.11.2009
	 */
	public class InstructionsPage extends MovieClip
	{
		
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var backBtn:GenericButton;
		public var message_txt:TextField;
		
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
		public function InstructionsPage(main:Main, sl:SharedListener)
		{
			super();
			_MAIN = main;
			_sl = sl;
			backBtn = new GenericButton ();
			backBtn.x = 510;
			backBtn.y = 363;
			addChild (backBtn);
			init();
		}
		
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		private function init ():void {
			setupButtons();
			setUpText();
		}
		
		private function setupButtons():void
		{
			backBtn.init (_MAIN);
			backBtn.addEventListener(MouseEvent.CLICK, buttonBehavior,false,0,true);
			_MAIN.setTransText("BodyFont", backBtn.label_txt, "FGS_OTHER_MENU_GO_BACK");
		}
		
		
		private function setUpText ():void{
			_MAIN.setTransText ("BodyFont", message_txt, "IDS_INSTRUCTIONS_BODY");
		
		}
		
		private function buttonBehavior (e:Event):void{
			_sl.sendCustomEvent(SharedListener.BACK_TO_INTRO, null, false, true);
		}
	}
}