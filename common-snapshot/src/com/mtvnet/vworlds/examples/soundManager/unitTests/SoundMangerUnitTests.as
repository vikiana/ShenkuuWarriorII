/* AS3
	Copyright 2009
*/

package com.mtvnet.vworlds.examples.soundManager.unitTests
{
	import com.mtvnet.vworlds.util.sound.ISoundManager;
	import com.mtvnet.vworlds.util.sound.ISoundObject;
	import com.mtvnet.vworlds.util.sound.SoundManager;
	import com.mtvnet.vworlds.util.sound.SoundManagerEvents;
	import com.mtvnet.vworlds.util.sound.SoundObj;
	import com.mtvnet.vworlds.util.sound.SoundObjEvents;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import flexunit.framework.TestCase;
	
	/**
	 *	This is for Testing the BankAccount Class
	 * 
	 * assertEquals: Compare with ==
	 *  assertTrue: Check condition is true
	 * assertNull: Check if null
	 * assertStrictlyEquals: Compare with ===
	 * FlexUnit also provides various convenience assertions which test for the opposite condition such as assertFalse and assertNotNull. 
 	 *  See the Assert API documentation included with FlexUnit for a complete list of assertions.
 	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern FlexUnit
	 * 
	 *	@author Clive Henrick
	 *	@since  12.01.2009
	 */
	 
	public class SoundMangerUnitTests extends TestCase
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function SoundMangerUnitTests(methodName:String=null)
		{
			super(methodName);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function testCheckSoundObj():void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			
			tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			
			assertTrue("Registered a SWC Sound MusicLoop, then tested using CheckSoundObj to see if the file is there", tSoundManager.checkSoundObj("MusicLoop"));	
			tSoundManager.removeSound("MusicLoop");
		}
		
		 
		public function testRegisterSWCSoundObj():void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			
			tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			
			assertTrue("Using RegisterSWCSoundObj a soundObj named MusicLoop is loaded, then tested to see if the file is there", tSoundManager.checkSoundObj("MusicLoop"));	
			tSoundManager.removeSound("MusicLoop");
		}

		public function testRemoveSound():void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			
			tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			
			tSoundManager.removeSound("MusicLoop");
			assertFalse("Using RemoveSound a soundObj named MusicLoop is loaded, then tested to see if the file is there", tSoundManager.checkSoundObj("MusicLoop"));	
		}
		
		/**
		 * @Note: Timer is destroyed when complete
		 * 
		 */
		 
		public function testFadeoutAllSounds():void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			var tSndObj:SoundObj = tSoundManager.getSoundObj("MusicLoop");
			tSndObj.addEventListener(SoundObjEvents.EVENT_SOUND_FADEDOWN_COMPLETE, addAsync(verifyFadeoutAllSounds,1250), false, 0, true);
			tSoundManager.soundPlay("MusicLoop");
			tSoundManager.fadeoutAllSounds();
		}
		
		/**
		 * @Note: Timer is destroyed when complete
		 * 
		 */
		 
		public function testFadeOutSound():void
		{
			
			var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			var tSndObj:SoundObj = tSoundManager.getSoundObj("MusicLoop");
			tSndObj.addEventListener(SoundObjEvents.EVENT_SOUND_FADEDOWN_COMPLETE, addAsync(verifyFadeoutSoundTimer,1250), false, 0, true);
			tSoundManager.soundPlay("MusicLoop");
			tSoundManager.fadeOutSound("MusicLoop");

		
		}
		
		public function testFadeInSound():void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			var tSndObj:SoundObj = tSoundManager.getSoundObj("MusicLoop");
			tSndObj.addEventListener(SoundObjEvents.EVENT_SOUND_FADEUP_COMPLETE, addAsync(verifyFadeInSoundTimer,1250), false, 0, true);
			tSoundManager.soundPlay("MusicLoop");
			tSndObj.volume = 0;
			tSoundManager.fadeInSound("MusicLoop");
			
		}
		
		/**
		 * @Note: This will test for stopping all the sound currently playing
		 */
		 
		public function testStopAllCurrentSounds():void 
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new PowerUp1(),"PowerUp1");
			tSoundManager.registerSWCSoundObj(new PowerUp2(),"PowerUp2");
			tSoundManager.registerSWCSoundObj(new PowerUp3(),"PowerUp3");
			
			tSoundManager.soundPlay("PowerUp1");
			tSoundManager.soundPlay("PowerUp2");
			tSoundManager.soundPlay("PowerUp3");
			
			tSoundManager.stopAllCurrentSounds();
			
			assertFalse("Using stopAllCurrentSounds, PowerUp1 sound should be stopped",tSoundManager.checkSoundState("PowerUp1"));	
			assertFalse("Using stopAllCurrentSounds, PowerUp2 sound should be stopped",tSoundManager.checkSoundState("PowerUp2"));
			assertFalse("Using stopAllCurrentSounds, PowerUp3 sound should be stopped",tSoundManager.checkSoundState("PowerUp3"));	
		
			tSoundManager.removeAllSounds();
		}
		
		/**
		 * @Note: This will check the sound state of a sound Object
		 */
		 
		 public function testCheckSoundState():void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new PowerUp1(),"PowerUp1");
			tSoundManager.soundPlay("PowerUp1");
			
			assertTrue("Using checkSoundState, PowerUp1 sound should be playing",tSoundManager.checkSoundState("PowerUp1"));
			tSoundManager.stopSound("PowerUp1");	
			assertFalse("Using checkSoundState, PowerUp1 sound should not be playing",tSoundManager.checkSoundState("PowerUp1"));
		 	tSoundManager.removeSound("PowerUp1");
		 }
		 
		 /**
		 * @Note: This will check the sound state of a sound Object
		 */
		 
		 public function testStopSound():void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new PowerUp1(),"PowerUp1");
			
			tSoundManager.soundPlay("PowerUp1");
			
			tSoundManager.stopSound("PowerUp1");
			
			assertFalse("Using stopSound, PowerUp1 sound should be stopped",tSoundManager.checkSoundState("PowerUp1"));	
			tSoundManager.removeSound("PowerUp1");	
		 }
		 
		 /**
		 * @Note this check for the loading of the sound Files (loadSound function)
		 */
		 
		 public function testLoadSoundExternal():void
		 {
		 	var tExternalFileURL:String = "Explo_EnergyFireball01.wav";
		 	
		 	var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.addEventListener(SoundManagerEvents.EVENT_SOUNDMANAGER_ALLLOADED, addAsync(verifyLoadedSoundExternal,3000));
			tSoundManager.loadSound("Explo_EnergyFireball01",SoundManager.TYPE_SND_EXTERNAL,0,tExternalFileURL);
		 }
		 
		  /**
		 * @Note this check for the loading of the sound Files (loadSound function)
		 */
		 
		 public function testLoadSoundExternalSWF():void
		 {
		 	var tExternalFileURL:String = "sourceSoundsExternal.swf";
		 	var tLoader:Loader = new Loader();
		 	var tURLREQ:URLRequest = new URLRequest(tExternalFileURL);
		 	tLoader.addEventListener(Event.COMPLETE, onExternalSWFLoaded, false, 0, true);
		 	tLoader.load(tURLREQ);
		 }
		 
		 /**
		 * @Note: This tests to add a Sound File that you loaded through another means
		 */
		 
		 public function testAddSound():void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
		 	assertFalse("Using addSound, MusicLoop sound should be not be loaded yet",tSoundManager.checkSoundObj("MusicLoop"));	
		 	
		 	tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			var tSndObj:ISoundObject = tSoundManager.getSoundObj("MusicLoop");
			tSoundManager.addSound(tSndObj);
			assertTrue("Using addSound, MusicLoop sound should be loaded",tSoundManager.checkSoundObj("MusicLoop"));	
			tSoundManager.removeSound("MusicLoop");
		 }
		 
		 /**
		 * @Note: Tests to see if a sound file has changed its volume
		 */
		 
		 public function testChangeSoundVolume():void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
		 	tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");
			tSoundManager.soundPlay("MusicLoop");
			tSoundManager.changeSoundVolume("MusicLoop",.5);
			assertEquals("Using ChangeSoundVolume, MusicLoop sound volume should be .5",.5,SoundObj(tSoundManager.getSoundObj("MusicLoop")).volume); 
			tSoundManager.removeSound("MusicLoop");		
		 }
		 
		 /**
		 * @Note: Makes sure that you get a given Sound Object
		 */
		 
		 public function testGetSoundObj():void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
		 	assertFalse("Using getSoundObj, MusicLoop sound should be not be loaded yet",tSoundManager.checkSoundObj("MusicLoop"));	
		 	tSoundManager.registerSWCSoundObj(new MusicLoop(),"MusicLoop");	
		 	assertTrue("Using GetSoundObj, A sound Object should be returned",(tSoundManager.getSoundObj("MusicLoop") is ISoundObject));
		 	tSoundManager.removeSound("MusicLoop");		 
		 } 
		 
		 /**
		 * @Note: Unloads all the Objects for Memory CleanUp. Use Only when you want to stop using the SoundManger (such as quiting a game)
		 */
		 
		 public function testCleanUpAllMemory():void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.registerSWCSoundObj(new PowerUp1(),"PowerUp1");
			tSoundManager.registerSWCSoundObj(new PowerUp2(),"PowerUp2");
			tSoundManager.registerSWCSoundObj(new PowerUp3(),"PowerUp3");
			
			tSoundManager.soundPlay("PowerUp1");
			tSoundManager.soundPlay("PowerUp2");
			tSoundManager.soundPlay("PowerUp3");
			
			tSoundManager.cleanUpAllMemory();
			
			assertFalse("Using testCleanUpAllMemory, PowerUp1 sound should be cleared",tSoundManager.checkSoundObj("PowerUp1"));	
			assertFalse("Using testCleanUpAllMemory, PowerUp2 sound should be cleared",tSoundManager.checkSoundObj("PowerUp2"));
			assertFalse("Using testCleanUpAllMemory, PowerUp3 sound should be cleared",tSoundManager.checkSoundObj("PowerUp3"));	
		 	
		 }
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: After the Sound File has faded, test to see if sound Stopped
		 */
		 
		protected function verifyFadeoutAllSounds(evt:Event):void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			var tSndObj:ISoundObject = tSoundManager.getSoundObj("MusicLoop");
			assertFalse("Using verifyFadeoutAllSounds, It is one second after the sound faded, sound should be stopped",tSndObj.isPlaying);	
			tSoundManager.removeSound("MusicLoop");
		}
		
		/**
		 * @Note: After the Sound File has faded, test to see if sound Stopped
		 */
		 
		protected function verifyFadeoutSoundTimer(evt:Event):void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			var tSndObj:ISoundObject = tSoundManager.getSoundObj("MusicLoop");
			assertFalse("Using verifyFadeoutSoundTimer, It is one second after the sound faded, sound should be stopped",tSndObj.isPlaying);	
			tSoundManager.removeSound("MusicLoop");
		}
		
		/**
		 * @Note: After the Sound File has faded, test to see if sound Stopped
		 */
		 
		protected function verifyFadeInSoundTimer(evt:Event):void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			var tSndObj:ISoundObject = tSoundManager.getSoundObj("MusicLoop");
			assertTrue("Using fadeInSoundTimer, It is one second after the sound faded Up, sound volume should be 1",tSndObj.volume == 1);	
			tSoundManager.removeSound("MusicLoop");
			
		}
		
		/**
		 * @Note: Checks to see that an external file has been loaded correctly
		 */
		 
		protected function verifyLoadedSoundExternal (evt:Event):void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			assertTrue("Using verifyLoadedSoundExternal, Explo_EnergyFireball01 sound should be in the library",tSoundManager.checkSoundObj("Explo_EnergyFireball01"));	
			tSoundManager.removeSound("Explo_EnergyFireball01");		
		}
		
		/**
		 * @Note: Checks to see that an external SWF file that has the SoundFile in the Library has been loaded correctly
		 */
		 
		protected function verifyLoadedSoundExternalSWF (evt:Event):void
		{
			var tSoundManager:ISoundManager = SoundManager.instance;
			assertTrue("Using verifyLoadedSound, PowerUpExternal sound should be in the library",tSoundManager.checkSoundObj("PowerUpExternal"));	
			tSoundManager.removeSound("PowerUpExternal");		
		}
		
		/**
		 * @Note: Checks when the External SWF File is Loaded
		 */
		 
		 protected function onExternalSWFLoaded (evt:Event):void
		 {
		 	var tSoundManager:ISoundManager = SoundManager.instance;
			tSoundManager.addEventListener(SoundManagerEvents.EVENT_SOUNDMANAGER_ALLLOADED, addAsync(verifyLoadedSoundExternalSWF,3000));
			tSoundManager.loadSound("PowerUpExternal",SoundManager.TYPE_SND_INTERNAL);
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
