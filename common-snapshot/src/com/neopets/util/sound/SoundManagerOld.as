/* AS3
	Copyright 2008
*/

package com.neopets.util.sound
 {

	import com.neopets.projects.mvc.model.SharedListener;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.*;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	
	/**
	 *	This is a Sound Storage Device used to keep track of SoundFiles
	 * 	This SoundManager can be communicated with anywere in the project by using the SharedListener
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author Clive Henrick
	 *	@since  12.30.2008
	 */
	 
	public class SoundManagerOld extends EventDispatcher 
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		public const SOUNDMANAGER_FILELOADED:String = "SoundFileIsLoaded";
		public const SOUNDMANAGER_ALLLOADED:String = "SoundManagerAllLoaded";
		public const TYPE_SND_EXTERNAL:String = "SoundFileisExternal";
		public const TYPE_SND_INTERNAL:String = "SoundFileisinLibrary";
		public const SOUNDMANAGER_ALLCLEANED:String = "AllMemoryShouldBeFreeforSoundManager";
		
		//--------------------------------------
		//  PRIVATE VARS
		//--------------------------------------
		
		private var mListCurrentSounds:Array;
		private var mIsLoaded:Boolean;
		private var mLocalListener:SharedListener;
		private var mID:String;
		private var mMasterVolume:Number;	
		private var mSoundtobeLoadedCount:uint;
		private var mSoundsLoadedCount:uint;
		private var mGlobalSoundLevel:uint;
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * CREATES a SoundManger
		 * @Param		pMasterListener		SharedListener	The Common Communications
		 * @Param		pID					String			The Name of the Sound Manager
		 **/
		 
		public function SoundManagerOld(pMasterListener:SharedListener = null, pID:String = "SM_Default"):void {
			setupVars();
			
			if (pMasterListener != null) {
				mLocalListener = pMasterListener;
			}
		
			mID = pID;
			
			mLocalListener.addEventListener(mLocalListener.REQUEST_SND_PLAY, onSoundRequest,false,0,true);
			mLocalListener.addEventListener(mLocalListener.REQUEST_SND_STOP, onSoundRequest,false,0,true);
			mLocalListener.addEventListener(mLocalListener.REQUEST_SND_STOPALL, onSoundRequest,false,0,true);
			mLocalListener.addEventListener(mLocalListener.REQUEST_SND_FADE, onSoundRequest,false,0,true);
			mLocalListener.addEventListener(mLocalListener.SOUND_VOLUME_CHANGE, onSoundRequest,false,0,true);
			
			mLocalListener.addEventListener(mLocalListener.PROJECT_STOPSOUNDS, stopAllCurrentSounds,false,0,true);
			mLocalListener.addEventListener(mLocalListener.PROJECT_QUIT_APPLICATION, stopAllCurrentSounds,false,0,true);
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
		
		public function set sharedListener(pSharedListener:SharedListener):void
		{
			mLocalListener = pSharedListener;	
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
		
		public function fadeoutAllSounds(pFadeTime:uint = 1000):void 
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
		
		public function fadeOutSound(pSoundName:String,pFadeTime:uint = 1):void 
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
		 * Returns a True (If file is playing or False if not playing)
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
		 * @Param		pType				String			TYPE_EXTERNAL for files that need to be loaded / TYPE_INTERNAL for files in Library
		 * @Param		pAmountToBuffer		Number			The Amount of the File that needs to be buffered before playback (seconds)
		 * @Param		pLocation			String			The URL location of the File
		 * @Param		pPool				String			
		 * @Param		pClass				Class			The Linked File Name from the Library
		 * * **/
		
		public function loadSound(pSoundName:String,pType:String = TYPE_SND_EXTERNAL,pAmountToBuffer:Number = 0,pLocation:String = null,pPool:String = null, pVolume:Number = 1, pID:String = null):void
		{
			try {
				mSoundtobeLoadedCount++;
				mIsLoaded = false;
				var sndObj:SoundObj;
				
				if (pType == TYPE_SND_EXTERNAL)
				{
					sndObj = new SoundObj(pSoundName,pType,pAmountToBuffer,pLocation, null, pVolume);
					sndObj.addEventListener(sndObj.SOUND_LOADED,onLoaded,false,0,true);	
				}
				else
				{
					var LoadedClass:Class = ApplicationDomain.currentDomain.getDefinition(pSoundName) as Class;
					sndObj = new LoadedClass();
					sndObj.name = pID != null? pID:pSoundName;
					mListCurrentSounds.push(sndObj);
					mSoundsLoadedCount++;
					
					if (mSoundsLoadedCount == mSoundtobeLoadedCount) {
						mIsLoaded = true;
						dispatchEvent(new Event(SOUNDMANAGER_ALLLOADED));
					}
				}
				
				sndObj.volume = pVolume;
				//[pSoundName,pType,pAmountToBuffer,pLocation,pPool, mVolume];
				var tArray:Array = sndObj.constructionInfo;
				tArray[5] = pVolume;
				sndObj.constructionInfo = tArray;
										
										
				
			} catch (e:ArgumentError) {
   					 trace("Sound Load Error " + e);
					 return;
			}
		}
		
		/**
		 * Allows a User to Add a Sound to the List without having to Load the Sound
		 * @Param		pSoundObj			SoundObj		 	The SoundObject to be Added
		**/
		
		public function addSound(pSoundObj:SoundObj):void{
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
				
				var sndObj:SoundObj = getSoundObj(pSoundName);
				
				//ERROR CHECKING
				if (sndObj == null)
				{
					trace ("Sound File Missing > " + sndObj.name);
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
		 	
		 	mListCurrentSounds = null;
		 	
		 	if (mLocalListener != null) {
				mLocalListener = null;
			}
		 	
		 	dispatchEvent(new Event(SOUNDMANAGER_ALLCLEANED));
				
		 }
		 
		//--------------------------------------
		//  PRIVATE HANDLERS
		//--------------------------------------
	
		private function setupVars():void
		{
			mLocalListener = new SharedListener();
			mGlobalSoundLevel = 1;
			mSoundtobeLoadedCount = 0;
			mListCurrentSounds = [];
			mIsLoaded = false;
		}
		
		/**
		 * changeVoume This is used Change the Volume of all sounds or the Current Sound Playing
		 * @Param		pSoundName					String								The Name of the SoundFile		
		 * @Param		pVolume						uint								The Volume you want the sound to play at
		**/
		
		private function changeVoume(pSoundName:String,pVolume:uint = 1):void 
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
		 
		private function duplicateSoundObject(pSndObj:SoundObj):SoundObj
		{
			if (pSndObj.isPlaying)
			{
				var tCloneSoundObj:SoundObj;
				var tConArray:Array = pSndObj.constructionInfo;
				
				if (tConArray[1] == TYPE_SND_EXTERNAL)
				{
					tCloneSoundObj = new SoundObj(tConArray[0],tConArray[1],tConArray[2],tConArray[3],tConArray[4], tConArray[5]);
				}
				else
				{
					var LoadedClass:Class = ApplicationDomain.currentDomain.getDefinition(pSndObj.name) as Class;
					tCloneSoundObj = new LoadedClass();
				}
				
				mListCurrentSounds.push(tCloneSoundObj);
				tCloneSoundObj.name = pSndObj.name + "_" + Math.round(Math.random() * 1000);
				tCloneSoundObj.addEventListener(tCloneSoundObj.SOUND_FINISHED, deleteCopySoundObj, false,0,true);
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
		 
		private function onLoaded(evt:CustomEvent):void {
			try {
				var sndObj:SoundObj = evt.target as SoundObj;
				
				mListCurrentSounds.push(sndObj);
				
				mSoundsLoadedCount++;
				
				if (mSoundsLoadedCount == mSoundtobeLoadedCount) {
					mIsLoaded = true;
					dispatchEvent(new Event(SOUNDMANAGER_ALLLOADED));
				}
				else
				{
					this.dispatchEvent(new CustomEvent({ID:sndObj.name},SOUNDMANAGER_FILELOADED));	
				}
				
			} catch (e:ArgumentError) {
   					 trace("SoundManager Load Error: ");
			}
		}
		
		/**
		 * onSoundRequest is called then you want to Send a CMD to the Sound Manager from the mainListener
		 * @param		evt	
		 * @Param		evt.oData.SMID				String				REQUIRED				The Name of the SoundManager or "All"	
		 * @Param		evt.oData.SOUNDNAME			String				REQUIRED/OPTIONAL		The mID of the Sound to Play. Not Needed for StopAll
		 * @Param		evt.oData.DATA				Object				OPTIONAL				And Object with Sound Playback Info in it.
		 * @Param		evt.oData.DATA.INFLOOP		Boolean				OPTIONAL				True for Infinite Loop
		 * @Param		evt.oData.DATA.LOOPS		uint				OPTIONAL				Number of Loops
		 * @Param		evt.oData.DATA.START		uint				OPTIONAL				Start of the Sound File
		 * @Param		evt.oData.DATA.SNDTRAN		SoundTransform		OPTIONAL				SoundTransform for a Sound File
		 * @Param		evt.oData.DATA.TIME			uint				REQUIRED/OPTIONAL		Time to Fade Out/In a Sound File
		 * @Param		evt.oData.DATA.RANDOMPOOL	String				OPTIONAL				The Name of the Random Pool for Sound PlayBack
		 * **/
		 
		private function onSoundRequest(evt:CustomEvent):void {
			
			if (evt.oData.SMID == mID || evt.oData.SMID == "All") {
				switch (evt.type) {
					case mLocalListener.REQUEST_SND_PLAY:
					
						if (evt.oData.hasOwnProperty("DATA")) {
							var tInfLoops:Boolean = false;
							var tLoops:uint = 0;
							var tStart:uint = 0;

							if (evt.oData.DATA.hasOwnProperty("INFLOOP")) {
								tInfLoops = evt.oData.DATA.INFLOOP;	
							}
							
							if (evt.oData.DATA.hasOwnProperty("LOOPS")) {
								tLoops = evt.oData.DATA.LOOPS;	
							}
							
							if (evt.oData.DATA.hasOwnProperty("START")) {
								tStart = evt.oData.DATA.START;	
							}
							
							if (evt.oData.DATA.hasOwnProperty("SNDTRAN")) {
								soundPlay(evt.oData.SOUNDNAME,tInfLoops,tStart,tLoops,evt.oData.DATA.SNDTRAN);
								return;
							}
							else
							{
								soundPlay(evt.oData.SOUNDNAME,tInfLoops,tStart,tLoops);
							}
						} else {
							soundPlay(evt.oData.SOUNDNAME);	
						}
						
					break;
					case mLocalListener.SOUND_VOLUME_CHANGE:
						changeVoume(evt.oData.SOUNDNAME, evt.oData.DATA.VOLUME);
					break;
					case mLocalListener.PROJECT_SOUND_VOLUME_CHANGE:
						mGlobalSoundLevel = evt.oData.DATA.VOLUME;
						changeVoume("ALL");
					break;
					case mLocalListener.REQUEST_SND_STOP:
						stopSound(evt.oData.SOUNDNAME);
					break;
					case mLocalListener.REQUEST_SND_STOPALL:
						stopAllCurrentSounds();
					break;
					case mLocalListener.REQUEST_SND_FADE:
						fadeOutSound(evt.oData.SOUNDNAME,evt.oData.DATA.TIME);
					break;
				}
			}
		}
		
		/**
		 * Deletes the tempory SoundFile
		 * @Param		pSoundname			String			Name of the SoundFile
		*/
		
		private function deleteCopySoundObj(evt:Event):void
		{
			removeSound(evt.target.name);		
		}
		
		
		
		
	}
}