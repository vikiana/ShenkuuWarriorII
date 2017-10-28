package virtualworlds.helper.SoundHelperClasses
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;

	public class RandomSoundEmitter
	{
		protected static const log:Logger = LogContext.getLogger(RandomSoundEmitter);
		private var _soundNames:Array = new Array();
		private var _timer:Timer = new Timer(1000, 0);
		private var _minTimeMs:Number;
		private var _maxTimeMs:Number;
		private var _soundChannel:SoundChannel;
		private var _playing:Boolean = false;
		private var _volume:Number = 1.0;
		private var _initialDelay:Number = 0;
		private var _position:Point;
		private var _radius:Number;
		
		public function get soundChannel():SoundChannel { return _soundChannel; }
		
		public function RandomSoundEmitter(minDelayTimeMs:Number, maxDelayTimeMs:Number, initialDelay:Number, volumeScalar:Number) 
		{
			_minTimeMs = minDelayTimeMs;
			if (_minTimeMs < 10)
			{
				_minTimeMs = 10;
			}
			_maxTimeMs = maxDelayTimeMs;
			_volume = volumeScalar;
			_initialDelay = initialDelay;
		}
		
		public function addSound(name:String):void
		{
			_soundNames.push(name);
		}
		
		/**
		 * Clear the list of random sounds
		 */
		public function clearSounds():void
		{
			while(_soundNames.length != 0)
			{
				_soundNames.pop();
			}	
		}
		
		
		/**
		 * Play a single random sound
		 */
		public function playSound(position:Point = null, radius:Number = 0):void
		{
			_position = position;
			_radius = radius;
			play();
		}
		
		/**
		 * Start the random sound emmiter
		 * @param	position
		 * @param	radius
		 */
		public function start(position:Point = null, radius:Number = 0):void
		{
			if(_soundNames.length > 0)
			{
				_playing = true;
				_position = position;
				_radius = radius;
				if (_initialDelay)
				{
					_timer.stop();
					_timer.reset();
					_timer.delay = _initialDelay;
				
					_timer.addEventListener(TimerEvent.TIMER, onTimerComplete, false, 0, true);
					_timer.start();
				}
				else
				{
					playNext();
				}
			}
		}
		
		
		public function stop(immediate:Boolean):void
		{
			_playing = false
			if (immediate)
			{
				if (_soundChannel)
				{
					_soundChannel.stop();
				}
			}
		}
		
		public function updatePosition(position:Point):void
		{
			_position = position;
		}
		
		/**
		 * Play a single sound
		 */
		private function play():void
		{
			//var resourceManagerMediator:ResourceManagerMediator = PPPFacade.getInstance().retrieveMediator(ResourceManagerMediator.NAME) as ResourceManagerMediator;
			
			
			var index:int  = Math.random() * _soundNames.length;
			var name:String = _soundNames[index];
			// About to trash _soundChannel, remove any listener first			
			if(_soundChannel && _soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			
			if (_position)
			{
				// Play 3D sound
				//_soundChannel = resourceManagerMediator.soundHelper.playSoundFromMic(name, _position, _radius, _volume);
			}
			else
			{
				// play 2D sound
				//_soundChannel = resourceManagerMediator.soundHelper.playSound(name, _volume);
			}
			
		}
		
		/**
		 * Play the next random sound
		 */
		private function playNext():void
		{
			if (!_playing)
				return;
			
			play();
			
			if(_soundChannel)
			{
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}	
		}
		
		private function onSoundComplete(e:Event):void
		{
			if(_soundChannel)
			{
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			else
			{
				log.warn("onSoundComplete: null object _soundChannel, listener cannot be removed")
			}
		
			_timer.stop();
			_timer.reset();
			var delay:int = _minTimeMs + Math.random() * (_maxTimeMs - _minTimeMs);
			_timer.delay = delay;
			
			_timer.addEventListener(TimerEvent.TIMER, onTimerComplete);
			_timer.start();
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimerComplete);
			playNext();
		}
	}
}