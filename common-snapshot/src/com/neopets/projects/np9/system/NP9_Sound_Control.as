package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Sound_Object;
	
	
	/**
	 * A sound controlling class for NP Games
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Sound_Control {

		private var _objTracer:NP9_Tracer;
		
		// Constants
		private static var _C_FX:int    = 0;
		private static var _C_MUSIC:int = 1;
		
		// Sound & Music Flags
		private var _bFX:Boolean;
		private var _bMusic:Boolean;
		
		// Sound & Music Arrays
		private var _aFX:Array;
		private var _aMusic:Array;

		// SoundChannel Array
		private var _aChannels:Array;
		
		/**
		 * @Constructor
		 * @param	p_bTrace	True if debug output is needed
		 */
		public function NP9_Sound_Control( p_bTrace:Boolean=false ) {
			
			// tracer object
			_objTracer = new NP9_Tracer( this, p_bTrace );
			_objTracer.out( "Instance created!", true );
			
			_bFX    = true;
			_bMusic = true;
			
			_aFX    = new Array();
			_aMusic = new Array();
			
			_aChannels = new Array();
		}
		
		/**
		 * Turns on/off sound effects
		 * @param	p_bMode	True to turn on
		 */
		public function setFX( p_bMode:Boolean ):void { _bFX = p_bMode; }
		/**
		 * Gets sound effects state
		 * @return	True if sound effects are on
		 */
		public function getFX():Boolean { return (_bFX); }
		
		/**
		 * Turns on/off music effects
		 * @param	p_bMode	True to turn on
		 */
		public function setMusic( p_bMode:Boolean ):void { _bMusic = p_bMode; }
		/**
		 * Gets music effects state
		 * @return	True if music effects are on
		 */
		public function getMusic():Boolean { return (_bMusic); }
		
		/**
		 * Adds a sound effect
		 * @param	p_FX					Sound object
		 * @param	p_sID				Unique ID for the sound
		 * @param	p_bMultiple		Set true to allow multiple instances of the sound to be played
		 */
		public function addFX( p_FX:Sound, p_sID:String="", p_bMultiple:Boolean=true ):void {
			
			if ( p_sID == "" ) return;
			
			if ( _aFX[ p_sID ] == undefined ) {
				
				var objSound:Object = createSoundAsset( _C_FX, p_FX, p_sID, p_bMultiple );
				
				_aFX[ p_sID ] = objSound;
			}
		}
		
		/**
		 * Adds a music object
		 * @param	p_Music			The sound object to be added
		 * @param	p_sID			Unqiue ID for the music
		 * @param	p_bMultiple	Set true to allow multiple instances of the music to be played	
		 */
		public function addMusic( p_Music:Sound, p_sID:String="", p_bMultiple:Boolean=false ):void {
			
			if ( p_sID == "" ) return;
			
			if ( _aMusic[ p_sID ] == undefined ) {
				
				var objMusic:Object = createSoundAsset( _C_MUSIC, p_Music, p_sID, p_bMultiple );
				
				_aMusic[ p_sID ] = objMusic;
			}
		}
		
		/**
		 * Creates an internal sound object
		 * @param	p_iType			Sound type id
		 * @param	p_Sound		Sound object
		 * @param	p_sID			Unique sound id
		 * @param	p_bMultiple	Allow multiple instance
		 * @return						The created internal sound object
		 */
		private function createSoundAsset( p_iType:int, p_Sound:Sound, p_sID:String, p_bMultiple:Boolean):Object {
			
			var objNewSound:Object = new Object();

			objNewSound.iType	  = p_iType;
			objNewSound.sound     = p_Sound;
			objNewSound.soundID   = p_sID;
			objNewSound.bMultiple = p_bMultiple;
			objNewSound.iPlaying  = 0;
			
			return ( objNewSound );
		}
		
		/**
		 * Plays a sound object
		 * @param	p_sID			The unique sound ID
		 * @param	p_iOffset		Time offset to start the sound playback
		 * @param	p_iLoop			Number of loops to play this sound
		 * @param	p_nVol			Starting volume of the sound (range: 0..1)
		 * @param	p_nPan			Left and right pan of the sound (range -1..0..1)
		 */
		public function playFX( p_sID:String="", p_iOffset:int=0, p_iLoop:int=1, p_nVol:Number=1.0, p_nPan:Number=0 ):void {
			
			if ( !_bFX ) return;
			
			if ( _aFX[ p_sID ] != undefined ) {
				
				var objSound:Object = _aFX[ p_sID ];
			
				if ( (objSound.iPlaying==0) || objSound.bMultiple ) {
					
					playIt( objSound, p_iOffset, p_iLoop, p_nVol, p_nPan )
				}
			}
		}
		
		/**
		 * Plays a music object
		 * @param	p_sID			The unique sound ID
		 * @param	p_iOffset		Time offset to start the sound playback
		 * @param	p_iLoop			Number of loops to play this sound
		 * @param	p_nVol			Starting volume of the sound (range: 0..1)
		 * @param	p_nPan			Left and right pan of the sound (range -1..0..1)
		 */
		public function playMusic( p_sID:String="", p_iOffset:int=0, p_iLoop:int=1, p_nVol:Number=1.0, p_nPan:Number=0 ):void {
			
			if ( !_bMusic ) return;
			
			if ( _aMusic[ p_sID ] != undefined ) {

				var objAsset:Object = _aMusic[ p_sID ];
			
				if ( (objAsset.iPlaying==0) || objAsset.bMultiple ) {
					
					playIt( objAsset, p_iOffset, p_iLoop, p_nVol, p_nPan )
				}
			}
		}
		
		/**
		 * Plays a sound using the created internal sound object
		 * @param	p_objAsset
		 * @param	p_iOffset
		 * @param	p_iLoop
		 * @param	p_nVol
		 * @param	p_nPan
		 */
		public function playIt( p_objAsset:Object, p_iOffset:int=0, p_iLoop:int=1, p_nVol:Number=1.0, p_nPan:Number=0 ):void {
			
			// create new object
			var objPlaySound:NP9_Sound_Object = new NP9_Sound_Object( this );
			
			// create new soundChannel
			objPlaySound._soundChannel = p_objAsset.sound.play( p_iOffset, p_iLoop );
			
			// increase play counter
			p_objAsset.iPlaying++;
			
			// set volume and pan
			objPlaySound._soundTransform.volume = p_nVol;
			objPlaySound._soundTransform.pan = p_nPan;
			objPlaySound._soundChannel.soundTransform = objPlaySound._soundTransform;

			// give object id
			var sCustomID:String = getTimer() + p_objAsset.soundID;
			objPlaySound.setID( p_objAsset.iType, p_objAsset.soundID, sCustomID );
			
			// add sound complete event listener			
			objPlaySound._soundChannel.addEventListener( Event.SOUND_COMPLETE, objPlaySound.onSoundComplete, false, 0, true );
			
			// add new object to list
			_aChannels[ sCustomID ] = objPlaySound;
			
			//race("started sound "+sCustomID);
		}
		
		/**
		 * Handler for sound playback completion
		 * @param	p_iType				The type ID of the sound
		 * @param	p_soundID			Unique sound ID
		 * @param	p_sCustomID		New ID for use in the sound array
		 */
		public function soundComplete( p_iType:int, p_soundID:String, p_sCustomID:String ):void {
			
			if ( _aChannels[ p_sCustomID ] != null ) {

				var objPlaySound:NP9_Sound_Object = _aChannels[ p_sCustomID ];
				objPlaySound._soundChannel.removeEventListener( Event.SOUND_COMPLETE, objPlaySound.onSoundComplete );
				
				// decrease plays counter
				if ( p_iType == _C_FX ) {
					if ( _aFX[ p_soundID ] != null ) {
						_aFX[ p_soundID ].iPlaying--;
					}
				}
				else if ( p_iType == _C_MUSIC ) {
					if ( _aMusic[ p_soundID ] != null ) {
						_aMusic[ p_soundID ].iPlaying--;
					}
				}
				
				_aChannels[ p_sCustomID ] = null;
				delete( _aChannels[ p_sCustomID ] );
				
				//ECHO ANY DEBUGGING INFO NEEDED("completed sound "+p_sCustomID);
			}
		}

		/**
		 * Stops all sound playback
		 * @param	p_sID		If specified, this sound will not be turned off
		 */
		public function stopFX( p_sID:String = "" ):void {
			
			var objSound:NP9_Sound_Object;
			var objAsset:Object;
			
			for ( var x:String in _aChannels ) {
				
				objSound = _aChannels[x];
				
				// just in case
				if ( objSound == null ) continue;
				
				if ( objSound.getType() == _C_FX ) {
				
					var bStop:Boolean = true;
					if ( (p_sID != "") && (objSound.getID() != p_sID) ) {
						bStop = false;
					}
					
					if ( bStop ) {
						//objSound.stop();
						objSound._soundChannel.stop();
						objAsset = _aFX[ objSound.getID() ];
						objAsset.iPlaying--;
					}
				}
			}
		}
		
		/**
		 * Stops all music playback
		 * @param	p_sID		If specified, this music will not be turned off
		 */
		public function stopMusic( p_sID:String = "" ):void {
			
			var objSound:NP9_Sound_Object;
			var objAsset:Object;
			
			for ( var x:String in _aChannels ) {
				
				objSound = _aChannels[x];
				
				// just in case
				if ( objSound == null ) continue;
				
				if ( objSound.getType() == _C_MUSIC ) {
				
					var bStop:Boolean = true;
					if ( (p_sID != "") && (objSound.getID() != p_sID) ) {
						bStop = false;
					}
					
					if ( bStop ) {
						//objSound.stop();
						objSound._soundChannel.stop();
						objAsset = _aMusic[ objSound.getID() ];
						objAsset.iPlaying--;
					}
				}
			}
		}
		
		/**
		 * Stops ALL sound and music playback
		 */
		public function stopAll():void {
			
			stopFX();
			stopMusic();
			
			_aChannels = new Array();
		}
		
		/**
		 * Fades a particular sound effect.
		 * @param	p_sID				Unique ID of the sound effect
		 * @param	p_iVolTarget		Final volume of the sound
		 * @param	p_iPanTarget		Pan value of the sound
		 * @param	p_iMSecs			Number of miliseconds for the sound to fade from current volume to p_iVolTarget
		 */
		public function fadeFX( p_sID:String = "", p_iVolTarget:Number = 0.0, p_iPanTarget:Number = 1.0, p_iMSecs:int = 1000 ):void {
			fade( _C_FX, p_sID, p_iVolTarget, p_iPanTarget, p_iMSecs );
		}
		
		/**
		 * Fades a particular music
		 * @param	p_sID				Unique ID of the music effect
		 * @param	p_iVolTarget		Final volume of the music
		 * @param	p_iPanTarget		Pan value of the music
		 * @param	p_iMSecs			Number of miliseconds for the music to fade from current volume to p_iVolTarget
		 */
		public function fadeMusic( p_sID:String = "", p_iVolTarget:Number = 0.0, p_iPanTarget:Number = 1.0, p_iMSecs:int = 1000 ):void {
			fade( _C_MUSIC, p_sID, p_iVolTarget, p_iPanTarget, p_iMSecs );
		}
		
		/**
		 * Fades a sound object
		 * @param	p_iType				Type of the sound
		 * @param	p_sID				Unique ID of the sound
		 * @param	p_iVolTarget		Final volume of the sound
		 * @param	p_iPanTarget		Pan value of the sound
		 * @param	p_iMSecs			Number of miliseconds for the sound to fade from current volume to p_iVolTarget
		 */
		private function fade( p_iType:int, p_sID:String, p_iVolTarget:Number, p_iPanTarget:Number, p_iMSecs:int ):void {
			
			var objSound:NP9_Sound_Object;
			var objAsset:Object;
			
			for ( var x:String in _aChannels ) {
				
				objSound = _aChannels[x];
				
				if ( objSound == null ) continue;
				
				if ( objSound.getType() == p_iType ) {
				
					var bFade:Boolean = true;
					if ( (p_sID != "") && (objSound.getID() != p_sID) ) {
						bFade = false;
					}
					
					if ( bFade ) {
						objSound.fade( p_iVolTarget, p_iPanTarget, p_iMSecs );
					}
				}
			}
		}
	}
}
