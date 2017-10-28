/**
 *	meant to be used in conjunction with the soundManager class
 *	This only enhances in that it'll check the music and sound toggle state and play the sound accordingly.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */
package com.neopets.util.sound
 {
	 
	public class GameSoundManager 
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE VARS
		//--------------------------------------
		private var mSoundOn:Boolean = true;
		private var mMusicOn:Boolean = true;
		private static var mInstance:GameSoundManager = new GameSoundManager (SingletonEnforcer)

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * CREATES a SoundManger
		 **/
		 
		 		
		 public function GameSoundManager(singletonEnforcer : Class = null):void
		 {
		 		if(singletonEnforcer != SingletonEnforcer)
		 		{
					throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
				}
		}
	
		//--------------------------------------
		//  GETTERS and SETTERS
		//--------------------------------------
		
		public static function get instance():GameSoundManager
		{ 
			return mInstance;	
		}
		
		public static function get soundOn():Boolean
		{ 
			return GameSoundManager.instance.mSoundOn;	
		}
		
		public static function get musicOn():Boolean
		{ 
			return GameSoundManager.instance.mMusicOn;	
		}
		
		public static function set soundOn(pb:Boolean):void
		{ 
			GameSoundManager.instance.mSoundOn = pb;	
		}
		
		public static function set musicOn(pb:Boolean):void 
		{ 
			GameSoundManager.instance.mMusicOn = pb;	
		}
		

		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		
		
		
		/**
		 * Fades out all current Sounds
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public static function fadeoutAllSounds(pFadeTime:uint = 1000):void 
		{
			SoundManager.instance.fadeoutAllSounds(pFadeTime)
		}
		
		/**
		 * Fades out a Sounds
		 * @Param		pSoundname			String			Name of the SoundFile
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public static function fadeOutSound(pSoundName:String,pFadeTime:uint = 1):void 
		{
			SoundManager.instance.fadeOutSound(pSoundName,pFadeTime)
		}
		
		/**
		 * Fades in a Sounds
		 * @Param		pCond				Boolean			Condition of the either music/sound on status
		 * @Param		pSoundname			String			Name of the SoundFile
		 * @Param		pVolume				Number			The fimal Volume
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public static function fadeInSound(pCond:Boolean, pSoundName:String,pVolume:Number = 1, pFadeTime:uint = 1):void 
		{
			if (pCond)
			{
				SoundManager.instance.fadeInSound(pSoundName,pVolume, pFadeTime)
			}
		}
	
	
		
		/**
		 * Stops All Sounds in the SManager from Playing, Clears the Sound Channel Array
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		public static function stopAllCurrentSounds():void 
		{
			SoundManager.instance.stopAllCurrentSounds()
		}
		
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		public static function checkSoundState(pNameSound:String):Boolean 
		{
			return SoundManager.instance.checkSoundState(pNameSound)
		}
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		public static function stopSound(pNameSound:String):void
		{
			SoundManager.instance.stopSound(pNameSound)
		}
		
		/**
		 * This function playbacks the appropriate sound
		 * @Param		pCond				Boolean			Condition of the either music/sound on status
		 * @Param		pSoundName			String		 	The ID of the Sound File
		 * @Param		pInfLoop			Boolean			
		 * @Param		pStart				uint			
		 * @Param		pLoops				int			
		 * @Param		pStartVolume		uint			
		 */
		
		public static  function soundPlay(pCond:Boolean, pSoundName:String,pInfLoop:Boolean = false,pStart:uint = 0,pLoops:int = 0, pStartVolume:Number = -1):void 
		{
			if (pCond)
			{
				SoundManager.instance.soundPlay(pSoundName,pInfLoop,pStart,pLoops, pStartVolume)
			}
		}
		
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		public static function changeSoundVolume(pNameSound:String,pVolume:Number):void
		{
			SoundManager.instance.changeSoundVolume(pNameSound,pVolume)
		}
				 
		//--------------------------------------
		//  PROTECTED HANDLERS
		//--------------------------------------
	
		
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}