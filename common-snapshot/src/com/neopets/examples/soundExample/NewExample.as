package com.neopets.examples.soundExample
{
	import com.neopets.util.sound.SoundManagerOld;
	import com.neopets.util.sound.SoundObj;
	import com.neopets.util.support.BaseObject;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NewExample extends BaseObject
	{
		private var mSoundManager:SoundManager;
		public var myButton:MovieClip;
		
		public function NewExample()
		{
			super();
			setup();
		}
		
		private function setup():void
		{
			mSoundManager = new SoundManager(null,"SM_Game");
			mSoundManager.loadSound("MySound",SoundObj.TYPE_INTERNAL);
			mSoundManager.soundPlay("MySound");	
			myButton.addEventListener(MouseEvent.MOUSE_DOWN, stopSounds,false,0,true);
			var tSound:SoundObj = mSoundManager.getSoundObj("MySound");
			var tSound2:SoundObj = new SoundObj("MySound",SoundObj.TYPE_INTERNAL);
			mSoundManager.addSound(tSound2);
		}
		
		private function stopSounds(evt:Event):void
		{
			mSoundManager.stopSound("MySound");	
		}
		
	}
}