/**
 *	Data object.  indicates various "states" of the game.  
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  Nov.2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class GameStates
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var index = 0;
		
		public static var ST_SHOWPLAYFIELD   = index++; //0
		public static var ST_NEXTLEVEL       = index++; //1
		public static var ST_CREATELEVEL     = index++; //2
		public static var ST_CREATEBUBBLES   = index++; //3
		public static var ST_CREATEBALL      = index++; //4
		public static var ST_AIMBALL	     = index++; //5
		public static var ST_BALLROLLS       = index++; //6
		public static var ST_BALLSTOPPED     = index++; //7 
		public static var ST_CHECKCOMBOS     = index++; //8
		public static var ST_CANNONBUBBLE    = index++; //9
		public static var ST_CANNONBUBBLE2   = index++; //10
		public static var ST_DESTROY         = index++; //11
		public static var ST_DROPBUBBLES     = index++; //12
		public static var ST_SEARCHFREE      = index++; //13
		public static var ST_CHECKEMPTYLEVEL = index++; //14
		public static var ST_SETFIRE         = index++; //15
		public static var ST_FIRECOMBO       = index++; //16
		public static var ST_SETWATER        = index++; //17
		public static var ST_WATERCOMBO      = index++; //18
		public static var ST_SETLIGHT        = index++; //19
		public static var ST_LIGHTCOMBO      = index++; //20
		public static var ST_SETEARTH        = index++; //21
		public static var ST_EARTHCOMBO      = index++; //22
		public static var ST_SETAIR          = index++; //23
		public static var ST_AIRCOMBO        = index++; //24
		public static var ST_SETDARK         = index++; //25
		public static var ST_DARKCOMBO       = index++; //26
		
		public static var ST_COURSE_1        = index++; //27 // instruction course popup
		public static var ST_COURSE_2        = index++; //28 // instruction activity
			
		public static var ST_GAMEPAUSED      = index++; //29
		public static var ST_LEVELSCREEN     = index++; //30
		public static var ST_LEVELSCREEN2    = index++; //31
		public static var ST_GAMEOVERSCREEN  = index++; //32
		public static var ST_GAMEFINISHED    = index++; //33
		public static var ST_GAMEOVERDROP    = index++; //34
		public static var ST_CLEANUP         = index++; //35
		public static var ST_RESTART         = index++; //36
		public static var ST_SENDSCORE       = index++; //37
		public static var ST_HIDEPLAYFIELD   = index++; //38
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GameStates():void
		{
			

		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}