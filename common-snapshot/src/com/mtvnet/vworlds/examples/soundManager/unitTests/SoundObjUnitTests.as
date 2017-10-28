/* AS3
	Copyright 2009
*/

package com.mtvnet.vworlds.examples.soundManager.unitTests
{
	import com.mtvnet.vworlds.util.sound.ISoundObject;
	import com.mtvnet.vworlds.util.sound.SoundManager;
	import com.mtvnet.vworlds.util.sound.SoundObj;
	import com.mtvnet.vworlds.util.sound.SoundObjEvents;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import flexunit.framework.TestCase;
	
	/**
	 *	This is for Testing the Sound Object
	 * 
	 *  assertEquals: Compare with ==
	 *  assertTrue: Check condition is true
	 *  assertNull: Check if null
	 *  assertStrictlyEquals: Compare with ===
	 *  FlexUnit also provides various convenience assertions which test for the opposite condition such as assertFalse and assertNotNull. 
 	 *  See the Assert API documentation included with FlexUnit for a complete list of assertions.
 	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern FlexUnit
	 * 
	 *	@author Clive Henrick
	 *	@since  12.01.2009
	 */
	 
	public class SoundObjUnitTests extends TestCase
	{
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SoundObjUnitTests(methodName:String=null)
		{
			super(methodName);
			
			
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		
		/**
		 * @Note: Tests to see if an file in memory (From a Embeded SWC or loaded SWF) can be created
		 */
		 
		public function testSoundObjLocal():void
		{
			var tSoundObj:SoundObj = new SoundObj("MusicLoop","SoundFileisinLibrary",0,null,null,1,null);
			assertTrue("Create a SoundObj, then tested to see if the file is there", tSoundObj is SoundObj);
			tSoundObj.clearLoadedItem();	
			
		}
		
		/**
		 * @Note: Tests to see if an external Sound File can be loaded
		 */
		 
		public function testLoadExternalSound():void
		{
			var tExternalFileURL:String = "Explo_EnergyFireball01.wav";
		 	var tSoundObj:SoundObj = new SoundObj("Explo_EnergyFireball01",SoundObj.TYPE_EXTERNAL,0,tExternalFileURL,null,1,null);
			tSoundObj.addEventListener(SoundObjEvents.EVENT_SOUND_LOADED, addAsync(verifyLoadedSoundExternal,3000));
			tSoundObj.loadExternalSound();
		}
		
		/**
		 * @Note Will test a few Functions about playing a sound file (Play and Stop)
		 */
		 
		public function testPlayStopSound():void
		{
			var tSoundObj:ISoundObject= setupTestSndObj(new PowerUp1(),"PowerUp1",1);
			tSoundObj.playSound();
			assertTrue("Using playSound a soundObj named PowerUp1 is loaded, and is playing", tSoundObj.isPlaying);	
			tSoundObj.stopSound();
			assertFalse("Using playSound a soundObj named PowerUp1 is loaded, and has Stop playing", tSoundObj.isPlaying);	
			tSoundObj.clearLoadedItem();
		}
		
		/**
		 * @Note: Will test toggling a Sound File on and off
		 */
		 
		public function testTogglePlayback():void
		{
			var tSoundObj:ISoundObject= setupTestSndObj(new PowerUp1(),"PowerUp1",1);
			tSoundObj.togglePlayback();
			assertTrue("Using testTogglePlayback a soundObj named PowerUp1 is loaded, and is playing", tSoundObj.isPlaying);	
			tSoundObj.togglePlayback();
			assertFalse("Using testTogglePlayback a soundObj named PowerUp1 is loaded, and has Stop playing", tSoundObj.isPlaying);
			tSoundObj.togglePlayback();
			assertTrue("Using testTogglePlayback a soundObj named PowerUp1 is loaded, and is playing", tSoundObj.isPlaying);
			tSoundObj.clearLoadedItem();		
		}
		
		/**
		 * This Turns off or On the Volume
		*/
		
		public function testToggleMute():void
		{
			var tSoundObj:ISoundObject= setupTestSndObj(new PowerUp1(),"PowerUp1",1);
			tSoundObj.playSound();
			assertEquals("Using testToggleMute a soundObj named PowerUp1 is loaded, and is volume = 1", 1, tSoundObj.volume);	
			tSoundObj.toggleMute();
			assertEquals("Using testToggleMute a soundObj named PowerUp1 is loaded, and is volume = 0", 0, tSoundObj.volume);
			tSoundObj.toggleMute();	
			assertEquals("Using testToggleMute a soundObj named PowerUp1 is loaded, and is volume = 1", 1, tSoundObj.volume);	
			tSoundObj.clearLoadedItem();
		}
		
		/**
		 * This Will Fade the Sound File
		*/
		
		public function testFadeDown():void
		{
			var tSoundObj:ISoundObject= setupTestSndObj(new PowerUp1(),"PowerUp1",1);
			tSoundObj.addEventListener(SoundObjEvents.EVENT_SOUND_FADEDOWN_COMPLETE, addAsync(verifyFadeoutSoundTimer,1250), false, 0, true);
			tSoundObj.playSound();
			tSoundObj.fadeDown();		
		}
		
		/**
		 * This Will Fade the Sound File to a set volume
		*/
		
		public function fadeIn():void
		{
			var tSoundObj:ISoundObject= setupTestSndObj(new PowerUp1(),"PowerUp1",1);
			tSoundObj.addEventListener(SoundObjEvents.EVENT_SOUND_FADEDOWN_COMPLETE, addAsync(verifyFadeInSoundTimer,1250), false, 0, true);
			tSoundObj.volume = 0;
			tSoundObj.playSound();
			assertEquals("Using fadeIn a soundObj named PowerUp1 is loaded, and is volume = 0", 0, tSoundObj.volume);
			tSoundObj.fadeIn();		
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
	
		/**
		 * @Note: Checks to see that an external file has been loaded correctly
		 */
		 
		protected function verifyLoadedSoundExternal (evt:Event):void
		{
			assertTrue("Using verifyLoadedSoundExternal, Explo_EnergyFireball01 sound should be in the library",evt.currentTarget is SoundObj);			
			SoundObj(evt.currentTarget).clearLoadedItem();
		}
		
		/**
		 * @Note: After the Sound File has faded, test to see if sound Stopped
		 */
		 
		protected function verifyFadeoutSoundTimer(evt:Event):void
		{
			
			var tSndObj:ISoundObject = SoundObj(evt.currentTarget);
			
			assertEquals("Using verifyFadeoutSoundTimer, It is one second after the sound faded, sound volume should be 0",0,tSndObj.volume);
			tSndObj.clearLoadedItem();	
			
		}
		
		/**
		 * @Note: After the Sound File has faded in, test to see if sound volume = 1
		 */
		 
		protected function verifyFadeInSoundTimer(evt:Event):void
		{
			
			var tSndObj:ISoundObject = SoundObj(evt.currentTarget);
			
			assertEquals("Using verifyFadeInSoundTimer, It is one second after the sound faded, sound volume should be 1",1,tSndObj.volume);
			tSndObj.clearLoadedItem();	
			
		}
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Allows a User to Add a SoundObject that is from a SWC File.
		 * @Param		pSoundObj			SoundObj		 	The SoundObject to be Added
		 * @Param		pSoundName			String		 		The Name used to Reference the soundObj
		 * @Param		pVolume				Number			 	The Starting Volume of the SoundObj
		**/
		
		protected function setupTestSndObj(pSoundObj:ISoundObject, pSoundName:String, pVolume:Number = 1):ISoundObject
		{
		
			pSoundObj.name = pSoundName;
			pSoundObj.type = SoundManager.TYPE_SND_SWC;
			pSoundObj.soundApplicationDomain = ApplicationDomain.currentDomain;
			pSoundObj.volume = pVolume;
			
			var tArray:Array = [pSoundName,SoundManager.TYPE_SND_SWC,0,null,null,pVolume];
			pSoundObj.constructionInfo = tArray;
			
			return pSoundObj;
			
		}
	}
	
}
