package com.neopets.games.inhouse.shootergame.gameshell
{
	import com.neopets.games.inhouse.shootergame.Main;
	
	import flash.display.MovieClip;


	/**
	 *	Scoring Page. 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Viviana Baldarelli
	 *	@since  6.11.2009
	 */
	public class ScoringPage extends MovieClip
	{
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _MAIN:Main;
		private var titleLogo:GameLogo;
		
		
		/**
		 *	@Constructor
		 * 
		 * @param   main   Game Engine class.
		 * 
		 */
		public function ScoringPage(main:Main)
		{
			super();
			_MAIN = main;
			titleLogo = new GameLogo ();
			titleLogo.x = 169;
			titleLogo.y = 95;
			addChild (titleLogo);
			titleLogo.gotoAndStop(_MAIN.gamingSystem.getFlashParam("sLang").toUpperCase());
		}
		
	}
}