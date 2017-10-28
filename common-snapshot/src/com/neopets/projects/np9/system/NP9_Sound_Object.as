package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import flash.utils.Timer;

	// CUSTOM IMPORTS
	
	
	/**
	 * The sound object base class
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Sound_Object {

		private var _objParent:Object;
		private var _iType:int;
		private var _sSoundID:String;
		private var _sCustomID:String;
		
		private var _tFade:Timer;
		
		private var _nFadeVol:Number;
		private var _nFadePan:Number;
		
		private var _iFadeVolTarget:Number;
		private var _iFadePanTarget:Number;
		
		public var _soundChannel:SoundChannel;
		public var _soundTransform:SoundTransform;
		
	
		/**
		 * @Constructor
		 * @param	p_objParent		Parent object of this sound (Is this still needed?)
		 */
		public function NP9_Sound_Object( p_objParent:Object ) {
			
			_objParent = p_objParent;
			_iType     = 0;
			_sSoundID  = "";
			_sCustomID = "";
			
			_tFade = new Timer(0,0);
			
			_nFadeVol = 0;
			_nFadePan = 0;
			
			_iFadeVolTarget = 0;
			_iFadePanTarget = 0;
			
			_soundChannel = new SoundChannel();
			_soundTransform = new SoundTransform();
		}
		
		/**
		 * Sets IDs for this sound object
		 * @param	p_iType
		 * @param	p_soundID
		 * @param	p_sCustomID
		 */
		public function setID( p_iType:int, p_soundID:String, p_sCustomID:String ):void {
			
			_iType     = p_iType;
			_sSoundID  = p_soundID;
			_sCustomID = p_sCustomID;
		}
		
		/**
		 * Obtains the type ID 
		 * @return	type ID
		 */
		public function getType():int { return ( _iType ); }
		/**
		 * Obtains sound ID
		 * @return	sound ID
		 */
		public function getID():String { return ( _sSoundID ); }
		
		/**
		 * Stops playback and all other processes
		 */
		public function stop():void {
			
			_soundChannel.stop();
			if ( _tFade.running ) _tFade.stop();
			_objParent.soundComplete( _iType, _sSoundID, _sCustomID );
		}
		/**
		 * Sound complete handler
		 * @param	e
		 */
		public function onSoundComplete( e:Event ):void {
			
			_objParent.soundComplete( _iType, _sSoundID, _sCustomID );
		}
		
		/**
		 * Fades the sound
		 * @param	p_iVolTarget		Final volume value
		 * @param	p_iPanTarget		Pan value (constant)
		 * @param	p_iMSecs			Number of miliseconds to change from current volume to p_iVolTarget
		 */
		public function fade( p_iVolTarget:Number, p_iPanTarget:Number, p_iMSecs:int ):void {

			// fade & pan invalid?
			if ( p_iVolTarget == _soundTransform.volume ) {
				if ( p_iPanTarget == _soundTransform.pan ) {
					return;
				}
			}
			
			// stop timer if running
			if ( _tFade.running ) _tFade.stop();
			
			// set target vars
			_iFadeVolTarget = p_iVolTarget;
			_iFadePanTarget = p_iPanTarget;
			
			// call fader every 100 ms
			var nVolDelay:Number = 100;
			
			// volume change total
			var iVolChange:Number = Math.abs( _soundTransform.volume - _iFadeVolTarget );
			var iPanChange:Number = Math.abs( _soundTransform.pan - _iFadePanTarget );
			
			// timer count total
			var iTimerCount:int = int( p_iMSecs / nVolDelay );
			
			// fade amount for each trigger
			_nFadeVol = Number( iVolChange / iTimerCount );
			_nFadePan = Number( iPanChange / iTimerCount );
			
			// fade out?
			if ( _iFadeVolTarget < _soundTransform.volume ) _nFadeVol *= -1;
			// pan out?
			if ( _iFadePanTarget < _soundTransform.pan ) _nFadePan *= -1;
			
			// let's fade
			startFadeTimer( nVolDelay, iTimerCount );
		}
		
		/**
		 * Starts the fading timer
		 * @param	p_nVolDelay			Time delay between each interval
		 * @param	p_iTimerCount		Number of intervals to call
		 */
		private function startFadeTimer( p_nVolDelay:Number, p_iTimerCount:int ):void {
			
			_tFade = new Timer( p_nVolDelay, p_iTimerCount );
			
			_tFade.addEventListener( TimerEvent.TIMER, onTimerFade, false, 0, true );
			_tFade.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerCompleteFade, false, 0, true );
			
			_tFade.start();
		}
		
		/**
		 * Fading timer call
		 * @param	event
		 */
		private function onTimerFade( event:TimerEvent ):void {
			
			_soundTransform.volume += _nFadeVol;
			_soundTransform.pan += _nFadePan;
			_soundChannel.soundTransform = _soundTransform;
			//race(_sCustomID+" fade - vol: "+_soundTransform.volume);
		}
		
		/**
		 * Fading timer complete event
		 * @param	event
		 */
		private function onTimerCompleteFade( event:TimerEvent ):void {
			
			_soundTransform.volume = _iFadeVolTarget;
			_soundTransform.pan = _iFadePanTarget;
			_soundChannel.soundTransform = _soundTransform;
			//race(_sCustomID+" fade complete - vol: "+_soundTransform.volume);
			
			if ( _soundTransform.volume <= 0 ) {
				
				_soundChannel.stop();
				_objParent.soundComplete( _iType, _sSoundID, _sCustomID );
			}
		}
	}
}
