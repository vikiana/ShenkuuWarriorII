
/* AS3
	Copyright 2008 NeoPets
*/
package com.neopets.projects.mvc.model
{
	import com.neopets.projects.mvc.model.BaseSharedListener;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.model.Listener;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.*;
	
	
	/**
	 *	This is a Class for Sending Events to Various Objects within the Scope of the Project
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.04.2008
	 */
	 
	public class SharedListener extends Listener
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		/* PROXY REQUEST */
		public const PROXY_SENDOBJ:String = "ContainerSendObject";				//Send an Loaded Object to Another Class
		public const PROXY_GETOBJ:String = "ContainerGetObject";				//Get an Loaded Object from another Class
		public const PROXY_LOADERROR:String = "ErrorLoadingXML";				//PROXY Could not get the Asked for Item
		
		/* SHELL COMMUNICATIONS */
		public const CONTROLLER_SENDOBJ:String = "ControllerReturnObject";		//A LoadedObject is being Returned to the Class
		public const PROJECT_CHANGE_FOCUS:String = "ChangeDisplayFocus";		//Changes the Focus of the Main Site for the Other Elemenets
		
		/* SOUND CONTROL */
		public const REQUEST_SND_PLAY:String = "RequestSNDPlayBack";			//Request a Snd File to Play from the SoundMangaer
		public const REQUEST_SND_STOP:String = "RequestSNDstop";				//Stop a Sound File from Playing
		public const REQUEST_SND_STOPALL:String = "RequestSNDStopAll";				//Stop all Sound Files From Playing
		public const REQUEST_SND_FADE:String = "RequestSNDFade";
		public const SOUND_VOLUME_CHANGE:String = "onSoundVolumeChange";
		public const PROJECT_SOUNDSLOADED:String = "gameSoundsLoaded";
		public const PROJECT_STOPSOUNDS:String = "gameStopSounds";			//Stops All Sounds
		public const PROJECT_SOUND_VOLUME_CHANGE:String = "ChangeAnyCurrentSoundstoThisLevel";
		
		/* APPLICATION RESOURCES */
		public const PROJECT_QUIT_APPLICATION:String = "onQuitApplication"; 	/* The Application shell is quitting*/
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SharedListener():void 
		{
			super();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		//--------------------------------------
		
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
