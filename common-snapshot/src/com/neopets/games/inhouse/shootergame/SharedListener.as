package com.neopets.games.inhouse.shootergame
{

	import com.neopets.util.events.CustomEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This a Class to Send and Listen to Events across the whole application.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 * 
	 *	@author Clive Henrick/ Viviana Baldarelli
	 *	@since  03.19.2009
	 */
	 
	public class SharedListener extends EventDispatcher 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		/* SOUND CONTROL */
		public const REQUEST_SND_PLAY:String = "RequestSNDPlayBack";//Request a Snd File to Play from the SoundMangaer
		public const REQUEST_SND_STOP:String = "RequestSNDStop";//Stop a Sound File from Playing
		public const REQUEST_SND_STOPALL:String = "RequestSNDStopAll";//Stop all Sound Files From Playing
		public const REQUEST_SND_FADE:String = "RequestSNDFade";
		public const SOUND_VOLUME_CHANGE:String = "onSoundVolumeChange";
		public const PROJECT_SOUNDSLOADED:String = "gameSoundsLoaded";
		public const PROJECT_STOPSOUNDS:String = "gameStopSounds";//Stops All Sounds
		public const PROJECT_SOUND_VOLUME_CHANGE:String = "ChangeAnyCurrentSoundstoThisLevel";
		
		public static const PLAY_SOUND:String = "play_sound";
		public static const STOP_SOUND:String = "stop_sound";
		public static const CHANGE_MUSIC:String = "change_music";
		public static const CHANGE_SOUNDS:String = "change_sounds";
		
		
		/* IN-GAME EVENTS */
		public static const SHOOT:String = "shoot";
		public static const COLLIDE_BOSS:String = "collide_boss";
		public static const BOSS_DEAD:String = "boss_dead";
		public static const REMOVE_TARGET:String = "remove_string";
		public static const COLLIDE1:String = "collide1";
		public static const COLLIDE2:String = "collide2";
		
		/*GAME STATES*/
		public static const GAME_STARTED:String = "game_started";
		public static const GAME_END:String = "game_end";
		public static const CLEAN_UP:String = "clean_up";
		public static const GAME_CLEAN_UP:String = "game_clean_up";
		
		/*LEVEL EVENTS*/
		public static const LEVEL_START:String = "level_start";
		public static const LEVEL_END:String = "level_end";
		public static const NEW_LEVEL:String = "new_level";
		public static const LOAD_STAGE:String = "load_stage";
		public static const STOP_LAYER:String ="stop_layer";
		public static const START_LAYER:String ="start_layer";
		public static const INIT_STAGE_END:String = "init_stage_end";
		public static const STAGE_END:String = "stage_end";
		public static const STAGE_START:String = "stage_start";
		public static const WARN_BOSS:String = "warn_boss";
		public static const SEND_BOSS:String = "send_boss";
		
		/*MISC*/
		public static const STOP_TIMERS:String ="stop_timers";
		public static const DONTSHOOT:String ="dont_shoot";
		
		/*UI EVENTS*/
		public static const START_GEARS:String = "start_gears";
		public static const STOP_GEARS:String = "stop_gears";
		
		/*TARGET EVENTS*/
		public static const ADD_SCORE:String = "add_score";
		public static const LOOSE_LIFE:String = "loose_life";
		public static const DESTROY_TARGET:String = "destroy_target";
		public static const DRAW_CROSSHAIR:String = "draw_crosshair";
		
		/*GAMESHELL EVENTS*/
		public static const BACK_TO_INTRO:String = "back_to_intro";
		public static const GOTO_GAME:String = "goto_game";
		public static const GOTO_INSTRUCTIONS:String = "goto_instructions";
		public static const SEND_SCORE:String = "send_score";
		public static const END_GAME:String = "end_game";
		public static const ADD_SENDSCORE_PAGE:String = "add_sendscore_page";
		public static const GAME_RESTART:String = "game_restart";
		public static const SEND_TO_SCORING:String = "ShowtheNP9ScoreMeter";
		
		/**
		 * 
		 * Constructor
		 * 
		 *
		 */
		public function SharedListener(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is for sending an Object (Data) with an Event
		 * @param		pEvent			String
		 * @param		pObject			Object
		 * @param		pBubbles		Boolean
		 * @param		pCancelable		Boolean
		 */
		public function sendCustomEvent(pEvent:String,pObject:Object, pBubbles:Boolean=false, pCancelable:Boolean=false):void {
			if (pEvent != DRAW_CROSSHAIR){
				trace ("E: "+pEvent);
			}
			this.dispatchEvent(new CustomEvent(pObject,pEvent,pBubbles,pCancelable));
		}
	}
}
