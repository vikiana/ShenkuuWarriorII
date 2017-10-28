
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.pinball
{
	
	
	/**
	 *	This is just a List of All the SoundFile Names
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern PinBall
	 * 
	 *	@author Clive Henrick
	 *	@since  6.19.2009
	 */
	public class SoundIDs
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//Beeps
		public static const BEEP_SHORT1:String = "Beep04";
		public static const BEEP_SHORT2:String = "Beep24";
		
		//Bumpers
		public static const BUMPER_SND1:String = "Pinball_Bumper07";
		public static const BUMPER_SND2:String = "Mustang_DoorClose1";
		public static const BUMPER_SCIFI:String = "Scifi_ShieldHit_Deflect";
		
		//Misc Objects
		public static const FLIPPER_RELEASE:String = "Pinball_FlipperRelease";
		
		//Balls
		public static const LOSE_BALL:String = "Pinball_Drain_LoseBall";
		
		//Bit Hits
		public static const TARGET_HIT:String = "TargetHit"; 
		public static const TARGET_HIT2:String = "TargetHit2"; 
		public static const SF_TARGET_HIT:String = "SFHIT"; 
		public static const TARGET_BIG_WHOOSH:String = "BigWoosh"; 
		public static const ZAP_UP:String = "ZapUp1"; 
		public static const BIG_DOOR_CLOSE:String = "SynthDoor";
		
		//Misc Sounds
		public static const KICKOUT_BALL:String = "Pinball_KickoutBall2";
		public static const BUMPER_ERROR:String = "Beep_Error";
		public static const BALL_ROLL:String = "Pinball_BallRoll2";
		public static const POWER_UP:String = "Scifi_ShieldForm_Powerup";
		public static const WIN_BOSS:String = "Scifi_ShieldForm_Powerup" //###### WILL NEED TO SWAP SOUND FILE
		public static const MOVEUP_LEVEL:String = "MoveUpBoardLevel"; 
		
		public static const MUSIC_LOOP:String = "MainMusicLoop";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function SoundIDs():void{
			super();
		}
		
		
	}
	
}
