package com.mtvnet.vworlds.util.sound
{
	/**
	 *	This is just a List of Events for the SoundManager
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern SoundManager
	 * 
	 *	@author Clive Henrick
	 *	@since  12.10.2009
	 */
	 
	public class SoundManagerEvents
	{
		
		public static const EVENT_SOUNDMANAGER_FILELOADED:String = "SoundFileIsLoaded";
		public static const EVENT_SOUNDMANAGER_ALLLOADED:String = "SoundManagerAllLoaded";
		public static const EVENT_SOUNDMANAGER_ALLCLEANED:String = "AllMemoryShouldBeFreeforSoundManager";
		public static const EVENT_SOUND_FINISHED:String = "A soundObj is Finished";
		
		public function SoundManagerEvents()
		{
		}

	}
}