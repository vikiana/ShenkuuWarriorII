package virtualworlds.helper.SoundHelperClasses
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import virtualworlds.helper.Fu.BaseClasses.UpdateableClass;
	import virtualworlds.helper.SoundHelper;
	
	public class SoundEmitter extends UpdateableClass
	{
		private var _soundLink:Sound
		
		public var radius:Number
		public var lastSoundChannel:SoundChannel
		public var soundLength:uint
		
		private var soundTimer:Timer
		private var soundSet:Boolean
		
		public var position:Point = new Point(0,0)
		public var soundHelper:SoundHelper
		
		public function SoundEmitter()
		{
			radius = 300
			soundSet = false
		}
		
		/**
		 * returns the sound of the soundLink pointer 
		 * @return 
		 * 
		 */		
		public function get soundLink():Sound{
			return _soundLink
		}
		
		/**
		 * sets the sound link object 
		 * @param aSound a sound you want this emitter to loop
		 * 
		 */		
		public function set soundLink(aSound:Sound):void
		{
			soundTimer.removeEventListener(TimerEvent.TIMER,replayEmitterSound)
			soundSet = true
			soundTimer = new Timer(aSound.length,0)
			soundTimer.addEventListener(TimerEvent.TIMER,replayEmitterSound,false,0,true)
			_soundLink = aSound	
		}
		
		/**
		 * sets the soundHelper this emitter should use for transformations 
		 * @param aSoundHelper
		 * 
		 */		
		public function setSoundHelper(aSoundHelper:SoundHelper):void{
			soundHelper = aSoundHelper
		}
		
		/**
		 * executes the emitters steps, basically it sees if its in range and if so plays and times, then adjusts the sound transform on update 
		 * @param aStep
		 * 
		 */		
		public override function execute(aStep:uint=0):void{
			if(soundSet && soundHelper){
				var d:Number = Point.distance(soundHelper.currentMic.position, position)
				if(d < soundHelper.currentMic.sensitivity + radius){
					if(soundTimer.running == false){
						lastSoundChannel = soundHelper.playEmitterSound(this, d)
						if(lastSoundChannel){
							soundTimer.reset();
							soundTimer.start();
						}
					}			
				}else{
					if(soundTimer.running == true){
						soundTimer.stop()
					}
				}
			}
			
			if(lastSoundChannel){
				var sc:SoundTransform = soundHelper.updateSoundChannel(this)
				if(sc){
					lastSoundChannel.soundTransform = soundHelper.updateSoundChannel(this)
				}else{
					soundTimer.stop()
				}
			}
		}
	
			
		public override function exit():void{
			soundTimer.stop()
			if(lastSoundChannel){
				lastSoundChannel.stop()
			}
		}
		
		/**
		 * cleans and destroys the sound emitter 
		 * 
		 */	
		 
		public function destroy():void{
			soundTimer.stop()
			soundTimer = null
			soundHelper = null
			position = null
			if(lastSoundChannel){
				lastSoundChannel.stop()
			}
		}
		
		private function replayEmitterSound(e:TimerEvent):void{
			var d:Number = Point.distance(soundHelper.currentMic.position, position)
			lastSoundChannel = soundHelper.playEmitterSound(this, d)
		}
	}
}