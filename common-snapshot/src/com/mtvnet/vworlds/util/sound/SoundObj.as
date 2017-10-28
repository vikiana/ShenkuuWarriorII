package com.mtvnet.vworlds.util.sound
{
	import caurina.transitions.*;
	
	import com.mtvnet.vworlds.util.events.CustomEvent;
	
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	
	/**
	 *	This is the Basic Sound Object
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author Clive Henrick
	 *	@since  12.30.2008
	 */
	 
	public class SoundObj extends Sound implements ISoundObject
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		public static const TYPE_EXTERNAL:String = "SoundFileisExternal";
		public static const TYPE_INTERNAL:String = "SoundFileisinLibrary";
		
		//--------------------------------------
		// PRIVATE
		//--------------------------------------
		
		private var mName:String;
		private var mType:String;
		private var mPool:String;
		private var mVolume:Number;
		private var mOldVolume:Number;
		private var mAmountToBuffer:Number;
		private var mCurrentSoundChannel:SoundChannel;
		private var mIsPlaying:Boolean;
		private var mPausePosition:int;
		private var mTimer:Timer;
		private var mDisplayTimer:Timer;
		private var mCurrentSoundTrans:SoundTransform;
		private var mExternalURL:String;
		
		private var mSoundApplicationDomain:ApplicationDomain;
		private var mPlayInfo:Array;
		private var mInfiniteLoop:Boolean;
		private var mConstructionInfo:Array;
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * CREATES a SoundObj
		 * @Param		pSoundName			String		 	The ID of the Sound File
		 * @Param		pType				String			TYPE_EXTERNAL for files that need to be loaded / TYPE_INTERNAL for files in Library
		 * @Param		pAmountToBuffer		Number			The Amount of the File that needs to be buffered before playback (seconds)
		 * @Param		pLocation			String			The URL location of the File
		 * @Param		pPool				String			
		 * * **/
		
		 public function SoundObj(pSoundName:String = "",pType:String = "SoundFileisinLibrary",pAmountToBuffer:Number = 0,pLocation:String = null,pPool:String = null, pVolume:Number = 1,pApplicationDomain:ApplicationDomain = null):void
		 {
		
				setupVars();
				mName = pSoundName;
				mType = pType;
				mVolume = pVolume;
				mOldVolume = mVolume;
				mIsPlaying = false;
				mPool = pPool;
				mAmountToBuffer = pAmountToBuffer;
				mExternalURL = pLocation;
				
				if (pApplicationDomain != null)
				{
					mSoundApplicationDomain = pApplicationDomain;
				}
				else
				{
					mSoundApplicationDomain = ApplicationDomain.currentDomain;	
				}
				
				mConstructionInfo = [pSoundName,pType,pAmountToBuffer,pLocation,pPool, mVolume];
				
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set currentSoundChannel(pSNDC:SoundChannel):void
		{
			mCurrentSoundChannel = pSNDC;
		}
		
		public function get currentSoundChannel():SoundChannel
		{
			return mCurrentSoundChannel;
		}
		
		public function get name():String
		{
			return mName;
		}
		
		public function set name(pName:String):void
		{
			mName = pName;
		}
		
		public function get type():String 
		{
			return mType;
		}
		
		public function set type(pType:String):void
		{
			mType = pType;
		}
		
		public function set volume(pVolume:Number):void
		{
			
			mOldVolume = mVolume;
			
			mVolume = pVolume;
			
			if (mIsPlaying)
			{
				var transform:SoundTransform = new SoundTransform(mVolume,0);
		        mCurrentSoundChannel.soundTransform = transform; 
	  		}
		}
		
		public function get volume():Number
		{
			return mVolume;
		}
		
		public function set isPlaying(pIsPlaying:Boolean):void
		{
			if (!pIsPlaying)
			{
				mTimer.stop();
			}
			
			togglePlayback();
		}
		
		public function get isPlaying():Boolean
		{
			return mIsPlaying;
		}
		public function get randomPool():String
		{
			return mPool;
		}
		
		public function set randomPool(pPool:String):void
		{
			mPool = pPool;
		}
		
		public function get playInfo():Array
		{
			return mPlayInfo;
		}
		
		public function set playInfo(pArray:Array):void
		{
			mPlayInfo = pArray;
		}
		
		public function get infiniteLoop():Boolean
		{
			return mInfiniteLoop;
		}
		
		public function get constructionInfo():Array
		{
			return mConstructionInfo;	
		}
		
		public function set constructionInfo(pArray:Array):void
		{
			mConstructionInfo = pArray;
		}
		
		public function get soundApplicationDomain():ApplicationDomain
		{
			return mSoundApplicationDomain;
		}
		
		public function set soundApplicationDomain(pApplicationDomain:ApplicationDomain):void
		{
			mSoundApplicationDomain =pApplicationDomain ;
		}
		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		/**
		 * Add a SoundFile from an External Location
		 * 
		 */
		 
		 public function loadExternalSound ():void
		 {
			var request:URLRequest = new URLRequest(mExternalURL);
			addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
			addEventListener(Event.COMPLETE,onComplete,false,0,true);
			
			if (mAmountToBuffer != 0)
			{
				var buffer:SoundLoaderContext = new SoundLoaderContext(mAmountToBuffer);
				this.load(request,buffer);
				addEventListener(ProgressEvent.PROGRESS,onProgressCheck);
			} 
			else
			{
				load(request);
			}	
				
		 }
		
		/**
		 * This is the Basic PlayBack of a Sound File
		 * @param	startTime		Number				The StartTime in a SoundFile
		 * @param	loops			int					Tells the Sound to Loop
		 * @param	sndTransform	SoundTransform		For Special Effects
		 * */
			
		public function playSound(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null,pInfiniteLoop:Boolean = false):void
		{
			var tsndTranform:SoundTransform = new SoundTransform ()
			
			if (sndTransform == null) {
				tsndTranform = new SoundTransform (mVolume);
			} 
			else
			{
				tsndTranform = sndTransform;
			}
			mCurrentSoundChannel =  play(startTime, loops, tsndTranform);
			mIsPlaying = true;
			if (mCurrentSoundChannel != null) {
				mCurrentSoundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundFinished);
				mInfiniteLoop = pInfiniteLoop;
				mDisplayTimer.start();
			}
			
		}
		
		/**
		 * This turns on or off a sound file
		*/
		
		public function togglePlayback():void
		{
			if (mCurrentSoundChannel != null)
			{
				if (mIsPlaying)
				{
					mPausePosition = mCurrentSoundChannel.position;
					mCurrentSoundChannel.stop();
					mIsPlaying = false;
					mDisplayTimer.stop();
					mInfiniteLoop = false;
				}
				else
				{
					playSound(mPausePosition);
					mDisplayTimer.start();
			
				}
			}
			else
			{
				if (!mIsPlaying)
				{
					playSound(mPausePosition);
					mDisplayTimer.reset();
					mDisplayTimer.start();
				}
			}
		}
		
		/**
		 * This is a Fake Fast Foward (There is no fast foward of Audio in Flash). It Skips every few seconds
		*/
		
		public function fastFwd():void
		{
			if (mIsPlaying)
			{
				mTimer.start();	
			}
			else if (mTimer.running)
			{
				mTimer.stop();		
			}
			
		}
		
		/**
		 * This Turns off or On the Volume
		*/
		
		public function toggleMute():void
		{
			if (volume == 0)
			{
				mVolume = mOldVolume;
				volume = mVolume;
			}
			else
			{
				//mOldVolume = mVolume;
				volume = 0;	
			}
			
		}
		
		/**
		 * This Stops Playback
		*/
		
		public function stopSound():void
		{
			if (mCurrentSoundChannel != null)
			{
				mInfiniteLoop = false;
				mCurrentSoundChannel.stop();
				mDisplayTimer.stop();
				mDisplayTimer.reset();
				mIsPlaying = false;	
			}
		}
		
		/**
		 * This Starts PlayBack at a lcoation for Playback
		 * @param		pLocation		Number				The StartTime in a SoundFile 
		*/
		
		public function seek(pLocation:Number):void
		{
			if (mCurrentSoundChannel != null)
			{
				mCurrentSoundChannel.stop();	
			}
			
			playSound(pLocation);	
		}
		
		/**
		 * This Will Fade the Sound File
		 * @param		pDuration		Number		The Amount of time to Fade the SoundFile
		*/
		
		public function fadeDown(pDuration:Number=1):void
		{
			if (mCurrentSoundChannel != null)
			{
				mCurrentSoundTrans = new SoundTransform();
				
				mCurrentSoundTrans.volume = mCurrentSoundChannel.soundTransform.volume;  
            
	            Tweener.addTween(
	           		mCurrentSoundTrans, 
	           		{
	           			volume:0, 
	           			time:pDuration, 
	           			transition:"easeInOutQuad",
	           			onUpdate:fadeSound,
	           			onComplete:fadeComplete
	           		}
	           	);  		
			}
			
		}
		
		/**
		 * This Will Fade the Sound File to a set volume
		 * @param		pDuration		Number		The Amount of time to Fade the SoundFile
		*/
		
		public function fadeIn(pVolume:Number = 1, pDuration:Number=1):void
		{
			if (mCurrentSoundChannel != null)
			{
				mCurrentSoundTrans = new SoundTransform();
				
				mCurrentSoundTrans.volume = mCurrentSoundChannel.soundTransform.volume;  
            
	            Tweener.addTween(
	           		mCurrentSoundTrans, 
	           		{
	           			volume:pVolume, 
	           			time:pDuration, 
	           			transition:"easeInOutQuad",
	           			onUpdate:fadeSound,
	           			onComplete:fadeInComplete
					}
	           	);  		
			}
			
		}
		
		/**
		 * @Note This is to Clear Memory for the Loaded Item
		 */
		
		public function clearLoadedItem():void
		{
			if (mCurrentSoundChannel != null)
			{
				mCurrentSoundChannel.stop();
				mIsPlaying = false;	
				mTimer.stop();
				mTimer = null;
				mDisplayTimer.stop();
				mDisplayTimer = null;
				mCurrentSoundChannel = null;
			}
			
				
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function fadeInComplete():void
		{
			volume = mCurrentSoundChannel.soundTransform.volume;
			dispatchEvent(new Event(SoundObjEvents.EVENT_SOUND_FADEUP_COMPLETE));
		}
		
		private function fadeSound():void
		{
			mCurrentSoundChannel.soundTransform = mCurrentSoundTrans;	
			volume = mCurrentSoundChannel.soundTransform.volume;
		}
		
		private function fadeComplete():void
		{
			mInfiniteLoop = false;
			stopSound();
			dispatchEvent(new Event(SoundObjEvents.EVENT_SOUND_FADEDOWN_COMPLETE));	
		}
		
		/**
		 * Fires and Event when the Sound is Finished
		 */
		
		private function onSoundFinished(evt:Event):void
		{
			if (!mInfiniteLoop)
			{
				dispatchEvent(new Event(SoundObjEvents.EVENT_SOUND_FINISHED));
				mDisplayTimer.stop();
				mDisplayTimer.reset();
				mIsPlaying = false;
			} 
			else
			{
				playSound(0,0,null,true);	
			}
		}
		
		/**
		 * Fires and Event a sound File is Buffered
		 */
		 
		private function onProgressCheck(evt:ProgressEvent):void
		{
			if (this.isBuffering == false)
			{
				this.removeEventListener(ProgressEvent.PROGRESS,onProgressCheck);
				dispatchEvent(new Event(SoundObjEvents.EVENT_SOUND_BUFFERED));
			}	
		}
		
		/** 
       	 * @NOTE: 	This is for the Fast Foward Functionality
       	 */
       	 
       	private function onTimerUpdate(evt:Event):void
       	{
       		var tTC:Number = mCurrentSoundChannel.position;;
       		var tNewTC:Number = tTC + 10000;
       		
       		if (this.length < tNewTC)
       		{
       			mTimer.stop();
       		}
       		else
       		{
       			mCurrentSoundChannel.stop();
       			this.playSound(tNewTC);
       		}
       		
       	}
       	
       	private function onError(evt:IOErrorEvent):void
       	{
       		trace("Error loading on SoundFile: " + name);
       	}
       	
       	private function onComplete(evt:Event):void
       	{
       		dispatchEvent(new CustomEvent({ID:name},SoundObjEvents.EVENT_SOUND_LOADED));
       	}
       	
		//--------------------------------------
		//  PRIVATE Functions
		//--------------------------------------
		
		private function setupVars():void
		{
			mPausePosition = 0;
			mTimer = new Timer(2000);
			mTimer.addEventListener(TimerEvent.TIMER,onTimerUpdate,false,0,true);
			mDisplayTimer = new Timer(1000);
			mDisplayTimer.addEventListener(TimerEvent.TIMER,onDisplayUpdate,false,0,true);
			mInfiniteLoop = false;
			mConstructionInfo = [];
		}
		
		/**
		 * This is for a Display of the Current Position of a sound File
		 * @param	TIME		uint		The Current Time of the Sound Timer
		 */
		 
		private function onDisplayUpdate(evt:TimerEvent):void
		{
			this.dispatchEvent(new CustomEvent({TIME:mCurrentSoundChannel.position},SoundObjEvents.EVENT_SOUND_TIMEDISPLAY));		
			
		}
		
		
	} //End Class
} // End Package