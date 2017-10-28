/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	
	import flash.utils.ByteArray;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;

	public class soundEngine extends Sprite {
		private var doc:Object;
		
		private var mute:Boolean = false;
		
		private var loop = new DobrChutnn_liteMP3();
		private var loopChannel:SoundChannel = new SoundChannel();
		private var loopVolume:Number = 0.5;
		
		private var levelroll = new Tymp_rollCrash();
		private var levelrollChannel:SoundChannel = new SoundChannel();
		
		private var thwang = new Thwang_short();
		private var thwangChannel:SoundChannel = new SoundChannel();
		
		private var boing = new Boing_fast();
		private var boingChannel:SoundChannel = new SoundChannel();
		
		private var blip = new Blip();
		private var blipChannel:SoundChannel = new SoundChannel();
		
		private var pop = new Pop();
		private var popChannel:SoundChannel = new SoundChannel();
		
		private var bell = new GLASSBELL();
		private var bellChannel:SoundChannel = new SoundChannel();
		
		private var crash = new Tymp_rollCrash();
		private var crashChannel:SoundChannel = new SoundChannel();
		
		private var buzzer = new BUZZER2();
		private var buzzerChannel:SoundChannel = new SoundChannel();
		
		private var slidewhistle = new Slidewhistle();
		private var slidewhistleChannel:SoundChannel = new SoundChannel();
		
		public function soundEngine(scope) {
			doc = scope;
		}
		
		public function playSound(sound, vol) {
			if(mute) { vol = 0; }
			this[sound+'Channel'] = this[sound].play(0, 0, new SoundTransform(vol, 0));
		}
		
		public function stopTwisty():void {
			slidewhistleChannel.stop();
		}
		
		public function stopSound():void { stopLoop(); SoundMixer.stopAll(); }
		
		public function playLoop():void {
			loopChannel = loop.play(0, 0, new SoundTransform(loopVolume, 0));
			loopChannel.addEventListener(Event.SOUND_COMPLETE, replayLoop, false, 0, true);
		}
		
		private function replayLoop(e:Event):void {
			loopChannel.removeEventListener(Event.SOUND_COMPLETE, replayLoop);
			playLoop();
		}
		
		public function stopLoop():void { 
			loopChannel.removeEventListener(Event.SOUND_COMPLETE, replayLoop);
		}
		
		public function muteHandler(e:MouseEvent):void {
			(mute) ? playLoop() : stopSound();
			doc.viewport.muteBtn.chrome.gotoAndStop( (doc.viewport.muteBtn.chrome.currentLabel == 'on') ? 'off' : 'on' );
			mute = !mute;
		}
		
	}
	
}