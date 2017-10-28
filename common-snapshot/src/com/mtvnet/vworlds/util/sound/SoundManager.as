/* AS3
	Copyright 2009
*/

package com.mtvnet.vworlds.util.sound
 {

	import com.mtvnet.vworlds.util.data.EmbedObjectData;
	import com.mtvnet.vworlds.util.events.CustomEvent;
	
	import flash.events.*;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	/**
	 *	This is a Sound Storage Device used to keep track of SoundFiles
	 *  This Sound Manager is the Gateway to access SoundFiles. IT uses the Singleton Design Pattern
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author Clive Henrick
	 *	@since  12.30.2008 (re worked 8/12/09)
	 */
	 
	public class SoundManager extends EventDispatcher implements ISoundManager
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		public static const TYPE_SND_EXTERNAL:String = "SoundFileisExternal";
		public static const TYPE_SND_INTERNAL:String = "SoundFileisinLibrary";
		public static const TYPE_SND_SWC:String = "SoundFileStoredinSWC";
		public static const TYPE_EMBEDED:String = "SoundFilesEmbeded";

		//--------------------------------------
		//  PRIVATE VARS
		//--------------------------------------
		
		protected var mListCurrentSounds:Array;
		protected var mIsLoaded:Boolean;
		protected var mMasterVolume:Number;	
		protected var mSoundtobeLoadedCount:uint;
		protected var mSoundsLoadedCount:uint;
		protected var mGlobalSoundLevel:uint;
		
		private static const mInstance:ISoundManager = new SoundManager( SingletonEnforcer);
		
		private var mSoundOverRide:Boolean;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * CREATES a SoundManger
		 **/
		 
		 		
		 public function SoundManager(singletonEnforcer : Class = null):void
		 {
		 		if(singletonEnforcer != SingletonEnforcer)
		 		{
					throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
				}

				setupVars();	
		}
	
		//--------------------------------------
		//  GETTERS and SETTERS
		//--------------------------------------
		
		public function set soundtobeLoadedCount(pNumber:uint):void
		{
			mSoundtobeLoadedCount = pNumber;
		}
		
		public function get globalSoundLevel():uint
		{
			return mGlobalSoundLevel;
		}
		
		public function set globalSoundLevel(pLevel:uint):void
		{
			mGlobalSoundLevel = pLevel;
		}
		
		public static function get instance():ISoundManager
		{ 
			return mInstance;	
		} 
		
		public function get soundOverRide():Boolean
		{
			return mSoundOverRide;
		}
		
		public function set soundOverRide(pFlag:Boolean):void
		{
			mSoundOverRide = pFlag;
		
			if (mSoundOverRide)
			{
				SoundMixer.soundTransform = new SoundTransform(0);
			}
			else
			{
				SoundMixer.soundTransform= new SoundTransform(mGlobalSoundLevel);
			}
			
		}
		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		/**
		 * Checks to See if there is an instance of the SoundFile
		 * @Param		pSoundname			String			Name of the SoundFile
		**/
		 
		public function checkSoundObj(pSoundname:String):Boolean
		{
			var tFlag:Boolean = false;
			var tCount:uint = mListCurrentSounds.length;
			
			for (var i:uint = 0; i < tCount; i++) {
				if ( mListCurrentSounds[i].name == pSoundname) {
					var sndObj:SoundObj =mListCurrentSounds[i];
					tFlag = true;
					break;
				}
			}
			
			return tFlag;
			
		}
		
		
		/**
		 * Clear one Sound for SoundArray
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
	
		public function removeSound(pSoundname:String):void {
			try {
				var tCount:uint = mListCurrentSounds.length;
				
				for (var i:uint = 0; i < tCount; i++) {
					if ( mListCurrentSounds[i].name == pSoundname) {
						var tSndObj:SoundObj = mListCurrentSounds[i];
						if (tSndObj.isPlaying)
						{
							tSndObj.stopSound();
						}
						mListCurrentSounds.splice(i,1);
						tSndObj = null;
						return;
					}
				}
				throw new Error("Sound File Not Found");
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
		/**
		 * Fades out all current Sounds
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public function fadeoutAllSounds(pFadeTime:int = 1):void 
		{
			try {
				var tCount:uint = mListCurrentSounds.length;
				
				for (var i:uint = 0; i < tCount; i++) 
				{
					if (mListCurrentSounds[i].isPlaying)
					{
						mListCurrentSounds[i].fadeDown(pFadeTime);	
					}
	
				}
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
		/**
		 * Fades out a Sounds
		 * @Param		pSoundname			String			Name of the SoundFile
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public function fadeOutSound(pSoundName:String,pFadeTime:int = 1):void 
		{
			try 
			{
				var sndObj:SoundObj = getSoundObj(pSoundName);
				sndObj.fadeDown(pFadeTime);
			} catch (e:ArgumentError) 
			{
   				trace(e);
			}
		}
		
		/**
		 * Fades in a Sounds
		 * @Param		pSoundname			String			Name of the SoundFile
		 * @Param		pVolume				Number			The fimal Volume
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public function fadeInSound(pSoundName:String,pVolume:Number = 1, pFadeTime:int = 1):void 
		{
			try 
			{
				var sndObj:SoundObj = getSoundObj(pSoundName);
				sndObj.fadeIn(pVolume, pFadeTime);
			} catch (e:ArgumentError) 
			{
   				trace(e);
			}
		}
	
	
		
		/**
		 * Stops All Sounds in the SManager from Playing, Clears the Sound Channel Array
		 * @Param		pFadeTime			uint			The Amount of time to fade the sound Files
		*/
		
		public function stopAllCurrentSounds(evt:Event = null):void {
			try {
				var tCount:uint = mListCurrentSounds.length;
				
				for (var i:uint = 0; i < tCount; i++) 
				{
					if (mListCurrentSounds[i].isPlaying)
					{
						mListCurrentSounds[i].stopSound();	
					}
	
				}
			} catch (e:ArgumentError) {
   					 trace(e);
			}
		}
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		public function checkSoundState(pNameSound:String):Boolean {
			var sndObj:SoundObj = getSoundObj(pNameSound);
				
			return sndObj.isPlaying;
		}
		
		/**
		 * Stops a Sound File From Playing
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		public function stopSound(pNameSound:String):void
		{
			try {
				var sndObj:SoundObj = getSoundObj(pNameSound);
					
				return sndObj.stopSound();
			
			} catch (e:ArgumentError) {
   				trace(e);
			}
		}
		
		/**
		 * Loads a Sound into the SoundManager
		 * @Param		pSoundName			String		 	The ID of the Sound File
		 * @Param		pType						String			TYPE_EXTERNAL for files that need to be loaded / TYPE_INTERNAL for files in Library
		 * @Param		pAmountToBuffer		Number			The Amount of the File that needs to be buffered before playback (seconds)
		 * @Param		pLocation					String			The URL location of the File
		 * @Param		pPool						String			
		 * @Param		pClass						Class			The Linked File Name from the Library
		 * * **/
		
		public function loadSound(pSoundName:String,pType:String = "SoundFileIsLoaded",pAmountToBuffer:Number = 0,pLocation:String = null,pPool:String = null, pVolume:Number = 1, pID:String = null, pEmbedObjData:EmbedObjectData = null):void
		{
			try {
				mSoundtobeLoadedCount++;
				mIsLoaded = false;
				
				var sndObj:SoundObj;
				var tLoadedClass:Class;
				var tName:String = pID != null? pID:pSoundName;
				

				switch (pType)
				{
					case SoundManager.TYPE_SND_EXTERNAL:
						sndObj = new SoundObj(pSoundName,pType,pAmountToBuffer,pLocation, null, pVolume);
						sndObj.addEventListener(SoundObjEvents.EVENT_SOUND_LOADED,onLoaded,false,0,true);
						sndObj.loadExternalSound();	
					break;
					case SoundManager.TYPE_EMBEDED: // This is used for a EMBEDED SWF FILE NOT A SWC

						var tEmbedObjData:EmbedObjectData = pEmbedObjData;
						
						tLoadedClass = tEmbedObjData.mApplicationDomain.getDefinition(pSoundName) as Class;	
						
						sndObj = new tLoadedClass();
						sndObj.name = tName;
						sndObj.type = pType;
						sndObj.soundApplicationDomain = tEmbedObjData.mApplicationDomain;
						mListCurrentSounds.push(sndObj);
						mSoundsLoadedCount++;
						
						if (mSoundsLoadedCount == mSoundtobeLoadedCount) {
							mIsLoaded = true;
							dispatchEvent(new Event(SoundManagerEvents.EVENT_SOUNDMANAGER_ALLLOADED));
						}


					
					break;
					default:
						
						tLoadedClass = ApplicationDomain.currentDomain.getDefinition(pSoundName) as Class;
						sndObj = new tLoadedClass();

						sndObj.name = tName;
						sndObj.type = pType;
						sndObj.soundApplicationDomain = ApplicationDomain.currentDomain;
						
						mListCurrentSounds.push(sndObj);
						mSoundsLoadedCount++;
						
						if (mSoundsLoadedCount == mSoundtobeLoadedCount) {
							mIsLoaded = true;
							dispatchEvent(new Event(SoundManagerEvents.EVENT_SOUNDMANAGER_ALLLOADED));
						}
					break;
					
				}

				sndObj.volume = pVolume;
				var tArray:Array = sndObj.constructionInfo;
				tArray[5] = pVolume;
				sndObj.constructionInfo = tArray;
										
										
				
			} catch (e:ArgumentError) {
   					 trace("Sound Load Error " + e);
					 return;
			}
		}
		
		/**
		 * Allows a User to Add a SoundObject that is from a SWC File.
		 * @Param		pSoundObj			SoundObj		 	The SoundObject to be Added
		 * @Param		pSoundName			String		 		The Name used to Reference the soundObj
		 * @Param		pVolume				Number			 	The Starting Volume of the SoundObj
		**/
		
		public function registerSWCSoundObj(pSoundObj:ISoundObject, pSoundName:String, pVolume:Number = 1):void
		{
		
			pSoundObj.name = pSoundName;
			pSoundObj.type = SoundManager.TYPE_SND_SWC;
			pSoundObj.soundApplicationDomain = ApplicationDomain.currentDomain;
			pSoundObj.volume = pVolume;
			
			var tArray:Array = [pSoundName,SoundManager.TYPE_SND_SWC,0,null,null,pVolume];
			pSoundObj.constructionInfo = tArray;
			
			mListCurrentSounds.push(pSoundObj);
			
		}
		
		
		/**
		 * Allows a User to Add a Sound to the List without having to Load the Sound (again)
		 * @Param		pSoundObj			SoundObj		 	The SoundObject to be Added
		**/
		
		public function addSound(pSoundObj:ISoundObject):void{
			if (!checkSoundObj(pSoundObj.name))
			{
				mListCurrentSounds.push(pSoundObj);	
			}
		}
		
		/**
		 * This function playbacks the appropriate sound
		 * @Param		pSoundName			String		 	The ID of the Sound File
		 * @Param		pInfLoop			Boolean			
		 * @Param		pStart				uint			
		 * @Param		pLoops				int			
		 * @Param		pStartVolume		uint			
		 */
		
		public  function soundPlay(pSoundName:String,pInfLoop:Boolean = false,pStart:uint = 0,pLoops:int = 0, pStartVolume:Number = -1):void {
			try {
				
			
				if (!mSoundOverRide)
				{
						var sndObj:SoundObj = getSoundObj(pSoundName);
					
					//ERROR CHECKING
					if (sndObj == null)
					{
						trace ("Sound File Missing > ");
						return;
					}
					
					sndObj = duplicateSoundObject(sndObj);
					
				
					
					if (pStartVolume != -1)
					{
						var tSoundTrans:SoundTransform = new SoundTransform(pStartVolume);
						
						sndObj.playSound(pStart,pLoops,tSoundTrans,pInfLoop);
						sndObj.playInfo = [pStart,pLoops,tSoundTrans,pInfLoop];
					}
					else
					{
						sndObj.playSound(pStart,pLoops,null,pInfLoop);	
						sndObj.playInfo = [pStart,pLoops,null,pInfLoop];
					}	
					
					sndObj.addEventListener(SoundObjEvents.EVENT_SOUND_FINISHED, onSoundObjFinishedPlaying, false, 0 , true);
				}
				
					

			} catch (e:ArgumentError) {
   					 trace("SoundPlay Error" + e);
					 return;
			}	
		}
		
		
		/**
		 * Returns a True (If file is playing or False if not playing)
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		public function changeSoundVolume(pNameSound:String,pVolume:Number):void
		{
			try {
				var sndObj:SoundObj = getSoundObj(pNameSound);
				
				sndObj.volume = pVolume;
			
			} catch (e:ArgumentError) {
   				trace(e);
			}
		}
		
		/**
		 * Returns the SoundObj from the Array
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
	
		public function getSoundObj(pSoundname:String):*
		{
			try
			{
				var tCount:uint = mListCurrentSounds.length;
				
				for (var i:uint = 0; i < tCount; i++) {
					if ( mListCurrentSounds[i].name == pSoundname) {
						var sndObj:SoundObj = mListCurrentSounds[i];
						return sndObj;
					}
				}
			
				throw new Error("Sound File Not Found > " + pSoundname);
			} catch (e:ArgumentError) {
   					 trace("Can Not Find SoundFile: > " + pSoundname);
   					 return null;
			}
		}
		
		/**
		 * @Note: This removes all sounds from the SoundList
		 */
		 
		public function removeAllSounds():void
		{
			var tCount:int = mListCurrentSounds.length;
		 	
		 	for (var t:int = 0; t < tCount; t++)
		 	{
		 		var tLoadedItem:SoundObj = mListCurrentSounds[t];
		 		tLoadedItem.clearLoadedItem();
		 		tLoadedItem = null;
		 	}
		 	
		 	mListCurrentSounds = [];	
		}
		
		
		
		/**
		 * @Note: Unloads all the Objects for Memory CleanUp.
		 */
		 
		 public function cleanUpAllMemory():void
		 {
		 	var tCount:int = mListCurrentSounds.length;
		 	
		 	for (var t:int = 0; t < tCount; t++)
		 	{
		 		var tLoadedItem:SoundObj = mListCurrentSounds[t];
		 		tLoadedItem.clearLoadedItem();
		 		tLoadedItem = null;
		 	}
		 	
		 	mListCurrentSounds = [];
		 	
		 	dispatchEvent(new Event(SoundManagerEvents.EVENT_SOUNDMANAGER_ALLCLEANED));
				
		 }
		 
		//--------------------------------------
		//  PROTECTED HANDLERS
		//--------------------------------------
	
		protected function setupVars():void
		{
			mGlobalSoundLevel = 1;
			mSoundtobeLoadedCount = 0;
			mListCurrentSounds = [];
			mIsLoaded = false;
			mSoundOverRide = false;
		}
		
		/**
		 * changeVoume This is used Change the Volume of all sounds or the Current Sound Playing
		 * @Param		pSoundName					String								The Name of the SoundFile		
		 * @Param		pVolume						uint								The Volume you want the sound to play at
		**/
		
		protected function changeVoume(pSoundName:String,pVolume:uint = 1):void 
		{
			pVolume = 1 ? mGlobalSoundLevel:pVolume;
			
			if (pSoundName == "ALL")
			{
				var tCount:uint = mListCurrentSounds.length;
				
				for (var i:uint = 0; i < tCount; i++) 
				{
					if ( mListCurrentSounds[i].isPlaying) {
						mListCurrentSounds[i].volume = pVolume;	
					}
				}	
			}
			else
			{
				var sndObj:SoundObj = getSoundObj(pSoundName);
				sndObj.volume = pVolume;	
			}
		}
		
		/** 
		 * Checks to see if the SoundFile is Playing, and If it is creates another Tempory Copy of it
		 * @param		pSndObj		SoundObj		The File to be copied
		 */
		 
		protected function duplicateSoundObject(pSndObj:SoundObj):SoundObj
		{
			if (pSndObj.isPlaying)
			{
				var tCloneSoundObj:SoundObj;
				var tConArray:Array = pSndObj.constructionInfo;
				
				if (tConArray[1] == SoundManager.TYPE_SND_EXTERNAL)
				{
					tCloneSoundObj = new SoundObj(tConArray[0],tConArray[1],tConArray[2],tConArray[3],tConArray[4], tConArray[5]);
				}
				else
				{
					var LoadedClass:Class = pSndObj.soundApplicationDomain.getDefinition(pSndObj.name) as Class;
					tCloneSoundObj = new LoadedClass();
				}
				
				mListCurrentSounds.push(tCloneSoundObj);
				tCloneSoundObj.name = pSndObj.name + "_" + Math.round(Math.random() * 1000);
				tCloneSoundObj.addEventListener(SoundObjEvents.EVENT_SOUND_FINISHED, deleteCopySoundObj, false,0,true);
				tCloneSoundObj.volume = tConArray[5];
				
				return tCloneSoundObj;	
			}
			else
			{
				return pSndObj;	
			}
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * When each SoundObject is Loaded
		 * @param	evt.oData.ID		String		The Name of the SoundObject
		 */
		 
		protected function onLoaded(evt:CustomEvent):void {
			try {
				var sndObj:SoundObj = evt.target as SoundObj;
				sndObj.name = evt.oData.ID;
				sndObj.type = TYPE_SND_EXTERNAL;
				
				mListCurrentSounds.push(sndObj);
				
				mSoundsLoadedCount++;
				
				if (mSoundsLoadedCount == mSoundtobeLoadedCount) {
					mIsLoaded = true;
					dispatchEvent(new Event(SoundManagerEvents.EVENT_SOUNDMANAGER_ALLLOADED));
				}
				else
				{
					this.dispatchEvent(new CustomEvent({ID:sndObj.name},SoundManagerEvents.EVENT_SOUNDMANAGER_FILELOADED));	
				}
				
			} catch (e:ArgumentError) {
   					 trace("SoundManager Load Error: ");
			}
		}
		
		/**
		 * Deletes the tempory SoundFile
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		protected function deleteCopySoundObj(evt:Event):void
		{
			removeSound(evt.target.name);		
		}
		
		/**
		 * Sound File has finished playing , Just passing the event up the chain
		 */
		 
		 protected function onSoundObjFinishedPlaying(evt:Event):void
		 {
		 	dispatchEvent(new CustomEvent({soundName:evt.currentTarget.name},SoundManagerEvents.EVENT_SOUND_FINISHED));	
		 }
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}