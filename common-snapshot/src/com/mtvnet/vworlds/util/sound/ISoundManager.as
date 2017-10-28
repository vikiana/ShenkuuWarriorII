package com.mtvnet.vworlds.util.sound
{
	import com.mtvnet.vworlds.util.data.EmbedObjectData;
	
	import flash.events.*;	
	/**
	 *	This is the Basic Interface for the Sound Manager
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	@Pattern Interface
	 * 
	 *	@author Clive Henrick
	 *	@since  12.08.2009
	 */
	 
	public interface ISoundManager extends IEventDispatcher 
	{
		
		function set soundtobeLoadedCount(pNumber:uint):void;
		function get globalSoundLevel():uint;
		function set globalSoundLevel(pLevel:uint):void;
		function get soundOverRide():Boolean;
		function set soundOverRide(pFlag:Boolean):void;
		
		/**
		 * Checks to See if there is an instance of the SoundFile
		 * @Param		pSoundname			String			Name of the SoundFile
		**/
		
		function checkSoundObj(pSoundname:String):Boolean;
		
		/**
		 * Clear one Sound for SoundArray
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		function removeSound(pSoundname:String):void;
		
		/**
		 * Fades out all current Sounds
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		function fadeoutAllSounds(pFadeTime:int = 1):void;
		
		/**
		 * Fades out a Sounds
		 * @Param		pSoundname			String			Name of the SoundFile
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		function fadeOutSound(pSoundName:String,pFadeTime:int = 1):void;
		
		/**
		 * Fades in a Sounds
		 * @Param		pSoundname			String			Name of the SoundFile
		 * @Param		pVolume				Number			The fimal Volume
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		function fadeInSound(pSoundName:String,pVolume:Number = 1, pFadeTime:int = 1):void;
		
		/**
		 * Stops All Sounds in the SManager from Playing, Clears the Sound Channel Array
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		function stopAllCurrentSounds(evt:Event = null):void;
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		function checkSoundState(pNameSound:String):Boolean;
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		function stopSound(pNameSound:String):void;
		
		/**
		 * Loads a Sound into the SoundManager
		 * @Param		pSoundName			String		 	The ID of the Sound File
		 * @Param		pType						String			TYPE_EXTERNAL for files that need to be loaded / TYPE_INTERNAL for files in Library
		 * @Param		pAmountToBuffer		Number			The Amount of the File that needs to be buffered before playback (seconds)
		 * @Param		pLocation					String			The URL location of the File
		 * @Param		pPool						String			
		 * @Param		pClass						Class			The Linked File Name from the Library
		 * * **/
		 
		function loadSound(pSoundName:String,pType:String = "SoundFileIsLoaded",pAmountToBuffer:Number = 0,pLocation:String = null,pPool:String = null, pVolume:Number = 1, pID:String = null, pEmbedObjData:EmbedObjectData = null):void
		
		/**
		 * Allows a User to Add a Sound to the List without having to Load the Sound (again)
		 * @Param		pSoundObj			SoundObj		 	The SoundObject to be Added
		**/
		
		function addSound(pSoundObj:ISoundObject):void;
		
		/**
		 * Allows a User to Add a SoundObject that is from a SWC File.
		 * @Param		pSoundObj			SoundObj		 	The SoundObject to be Added
		 * @Param		pSoundName			String		 		The Name used to Reference the soundObj
		 * @Param		pVolume				Number			 	The Starting Volume of the SoundObj
		**/
		
		function registerSWCSoundObj(pSoundObj:ISoundObject, pSoundName:String, pVolume:Number = 1):void
		
		/**
		 * This function playbacks the appropriate sound
		 * @Param		pSoundName			String		 	The ID of the Sound File
		 * @Param		pInfLoop			Boolean			
		 * @Param		pStart				uint			
		 * @Param		pLoops				int			
		 * @Param		pStartVolume		uint			
		 */
		 
		function soundPlay(pSoundName:String,pInfLoop:Boolean = false,pStart:uint = 0,pLoops:int = 0, pStartVolume:Number = -1):void;
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		function changeSoundVolume(pNameSound:String,pVolume:Number):void;
		
		/**
		 * Returns the SoundObj from the Array
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		function getSoundObj(pSoundname:String):*;
		
		/**
		 * @Note: Unloads all the Objects for Memory CleanUp.
		 */
		 
		function cleanUpAllMemory():void;
		
		/**
		 * @Note: This removes all sounds from the SoundList
		 */
		 
		function removeAllSounds():void;
	}
}