package com.neopets.games.inhouse.wheels {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;

	
	
	public class WheelClipClass extends MovieClip {
		
		private var _endSlot: int;
		private var _initSpinSpeed: Number = 25;
		private var _spinSpeed: Number = 25;
		private var _spinSpeed2: Number = 0;
		private var _destAngle: Number;
		private var _spinCounter: Number = 0;
		private var _numSlots: Number;
		private var _trigger: Boolean = false;
		private var _lastCount: Number = 0;
		private var _mcFlap: MovieClip;
		private var _clickSound: Sound = new ClickSound();
		private var _lastSlot: Number;
		public var WHEEL_STOP: String = "wheel has stopped";
		private var _soundOn: Boolean = true;
		
		public function WheelClipClass() 
		{
		}
		
		public function init(p_numSlots: Number) {
			_numSlots = p_numSlots;			
		}
		
		public function setWheelSpeed(p_speed: Number) {
			_spinSpeed = p_speed;
			_initSpinSpeed = p_speed;
		}
		
		public function startSpin(): void
		{			
			_spinSpeed = _initSpinSpeed;
			_lastSlot = calcCurrentSlot();
			_spinCounter = 0;
			_spinSpeed2 = 0;
			_trigger = false;
			_lastCount = 0;
			this.addEventListener( Event.ENTER_FRAME, rotateWheel );
			trace("CACHE AS BITMAP? " + this.cacheAsBitmap);
		}
		
		public function setSpin(p_slot: int): void
		{
			trace("SLOT SET:" + p_slot);
			_endSlot = p_slot;
			//_endSlot = 7;
			_destAngle = (-360/_numSlots) * _endSlot + 0.7 * ((Math.random() - 0.5) * 360/(_numSlots));
			//_destAngle = -147.2;
			if (_destAngle < -180) {
				_destAngle+=360;
			}
			trace("DESTANGLE = " + _destAngle);
		}
		
		public function setFlapper(p_flap: MovieClip): void {
			trace("SETTING FLAPPER");
			_mcFlap = p_flap;
		}
		
		public function setSound(p_sound: Boolean): void {
			_soundOn = p_sound;
		}
		
		private function calcCurrentSlot(): Number {
			var cs = Math.round(rotation/(360/_numSlots));
			if (cs < 0) {cs+= _numSlots};
			return(_numSlots - cs);
		}
		
		
		private function rotateWheel( event:Event ):void 
		{
			this.rotation += _spinSpeed;
			if (_lastSlot != calcCurrentSlot() ) {
				_mcFlap.gotoAndStop(2);				
				if (_soundOn) {
					_clickSound.play();
				}
				_lastSlot = calcCurrentSlot();
				//trace("CALC CURR SLOT:" + calcCurrentSlot());
			} else {
				_mcFlap.gotoAndStop(1);
			}
			//trace(this.rotation);
			var closeness = Math.abs(this.rotation - _destAngle);
			//trace("Closeness: " + closeness + "   spinspeed = " + _spinSpeed);
			if (_spinCounter > 2) {
				if (_spinSpeed2 == 0) {
					_spinSpeed2 = _spinSpeed * _spinSpeed/722;
				}
				//trace("OVER 7::: speed = " + _spinSpeed);
				_spinSpeed -= _spinSpeed2;				
				_lastCount++;
				if (Math.abs(this.rotation - _destAngle) <= _spinSpeed && _lastCount > 2) {
					stopWheel();
				} else if( _spinSpeed < 0) {
					stopWheel();
				}
			} else if (Math.abs(this.rotation - _destAngle) <= _spinSpeed/2 && !_trigger) {
				_spinCounter++;
				_spinSpeed*=0.75;
				//trace("SPINCOUNTER:" + _spinCounter);
				_trigger = true;
			} else {
				_trigger = false;
			}
		}
		
		private function stopWheel() {
			//var evt:Event = new Event(WHEEL_STOP);
			dispatchEvent(new Event(WHEEL_STOP));
			removeEventListener( Event.ENTER_FRAME, rotateWheel );
			this.rotation = _destAngle;
			_mcFlap.gotoAndStop(1);
			trace("STOP WHEEL");
		}
		
		
		
		
		
		
	}
	
	
	
}