package com.mtvnet.vworlds.util.sound
{
	/**
	 *	This is just a List of Events for the SoundObject
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern SoundManager
	 * 
	 *	@author Clive Henrick
	 *	@since  12.10.2009
	 */
	 
	public class SoundObjEvents
	{
		public static const EVENT_SOUND_BUFFERED:String = "SoundisBuffered";
		public static const EVENT_SOUND_FINISHED:String = "SoundisFinished";
		public static const EVENT_SOUND_TIMEDISPLAY:String = "SoundTCUpdate";
		public static const EVENT_SOUND_LOADED:String = "SoundisLoaded";
		public static const EVENT_SOUND_FADEDOWN_COMPLETE:String = "SoundFileFadedDown";
		public static const EVENT_SOUND_FADEUP_COMPLETE:String = "SoundFileFadedUp";
		
		public function SoundObjEvents()
		{
		}

	}
}