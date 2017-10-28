package com.neopets.games.inhouse.G1156.events
{
	public class GameEvents 
	{
		public static const SEND_ACTIVATE_EVENT:String = "ActivateTheObject";
		public static const SEND_DEACTIVATE_EVENT:String = "DeActivateTheObject";
		public static const GAME_TIMER_EVENT:String = "GameTimerHasFiredEvent";
		public static const GAME_QUICK_TIMER_EVENT:String = "QuickGameTimerHasFiredEvent";
		public static const GAME_SLOW_TIMER_EVENT:String = "SlowGameTimerHasFiredEvent";
		public static const GAME_TIMEOUT_EVENT:String = "TheGameHasRunOutofTime";
		public static const REMOVE_DISPLAYOBJECT:String = "RemoveThisDsiplayObject";
		
		public static const ACTIVATE_POPUP_MENU:String = "LaunchPopupMenu";
		public static const SECTION_COMPLETE:String = "aGameSectionIsComplete";
		public static const LEVEL_RESET:String = "ALevelNeedsToBeReset";
		public static const HEALTH_CHANGE:String = "HealthHasChanged";
		public static const TIME_CHANGE:String = "HealthHasChangedf";
		public static const SCORE_CHANGE:String = "ScoreHasChanged";
		public static const PLAYER_DIED:String = "PlayersHealth0"
		
		public static const TIMER_STOP_ALL:String = "StopAndResetAllGlobalTimers";
		public static const TIMER_START_ALL:String = "StartAllGlobalTimers";
		public static const QUIT_GAME:String = "UserHasQuitTheGame";
		public static const GAME_OVER:String = "TheGameHasFinished";
		public static const GAME_CLEANUP_MEMORY:String = "TheGameNeedsToBeResetCleanMemory";
		public static const GAMECOREDISPLAY_STARTNEXTLEVEL:String = "GCD_StartNewLevel";
		
		public function GameEvents (){}

	}
}