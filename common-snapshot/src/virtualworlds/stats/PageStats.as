package virtualworlds.stats
{
	
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	import flash.errors.*;
	import flash.external.*;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger; 

	/**
	 * Wraps all the tracking functionality for PageStats.
	 * 
	 * @author Dan Johnston
	 */
	public class PageStats 
	{		
		public static var ACTIVE:Boolean = false;
		public static var DEBUG:Boolean = false;
		protected static var log:Logger = LogContext.getLogger(PageStats);
		
		// Seperate tracker for google-only events
		public static var googleTracker:AnalyticsTracker;
				
		// Consts for which service tracking should go to
		public static const SV_GOOG:String = "google";
		public static const SV_OMN:String = "omniture";
		public static const SV_BOTH:String = "both";
		
		public static var demoInfo:Object;	// demographic info to be sent with all events

		// EVENTS --------------------------------------------------------------------------------
		// Add in-game event tracking here.   This is for google only.  These should not be pageviews.  
		public static const G_CAT_GUI:String = "GUI";
		public static const G_CAT_ADOPTION:String = "ADOPTION";
		public static const G_CAT_TRICKS:String = "TRICKS";
		public static const G_CAT_QUESTS:String = "QUESTS";
		public static const G_CAT_MAP:String = "MAP";
		public static const G_CAT_GAME:String = "GAME";


		// PAGE VIEWS --------------------------------------------------------------------------------
		// Add page tracking events here with a description of where they are called
		
		// LOGIN
		public static const TITLE_01:String = "ApplicationStart_01";	// Title State
		public static const LOGIN_01:String = "Login_01";				// Enter username/password
		public static const CHOOSESERVER_01:String = "ChooseServer_01";	// Choose Server Screen
		public static const CHOOSEPETPET_01:String = "ChoosePetPet_01";	// ChoosePetPet Screen
		public static const FORGOTUSER_01:String = "ForgotUser_01";		// Forgot username step 1
		public static const FORGOTUSER_02:String = "ForgotUser_02";		// Forgot username step 2
		public static const FORGOTPASS_01:String = "ForgotPass_01";		// Forgot password step 1
		public static const FORGOTPASS_02:String = "ForgotPass_02";		// Forgot password step 2
		public static const PRIVACYPOLICY_01:String = "PrivacyPolicy_01"; // Privacy policy page
		
		// REGISTRATION
		public static const REG_01:String = "Reg_01";						// Registration step 1 - Enter username, password, age
		public static const REG_02_u13:String = "Reg_02_u13";				// Registration step 2, under 13
		public static const REG_02_o13:String = "Reg_02_o13";				// Registration step 2, over 13
		public static const REG_03:String = "Reg_03";						// Registration step 3 - printable acct info
		
		// ADOPTION
		public static const ADOPT_INTRO:String = "Adopt_01_Intro";			// Intro screen
		public static const ADOPT_SELECT:String = "Adopt_02_PetSelect";		// Petpet selection
		public static const ADOPT_STATS:String = "Adopt_03_PetStats";		// Petpet stats screen
		public static const ADOPT_CUSTOMIZE:String = "Adopt_04_Customize";	// Customize gender, name
		public static const ADOPT_STARTERPACK:String = "Adopt_05_StarterPack";// Choose starter pack
		public static const ADOPT_EXIT:String = "Adopt_06_Exit";			// Exit state, see adoption papers
		
		// TUTORIAL
		public static const TUT_WELCOME:String = "Tutorial_01_Welcome";	// Welcome
		public static const TUT_CONTROLS_1:String = "Tutorial_02_Controls"; // Controls 1
		public static const TUT_MAP:String = "Tutorial_03_Map"; 			// Getting around/Map
		public static const TUT_MOVE:String = "Tutorial_04_Move";			// Moving/Walking
		public static const TUT_PLAY:String = "Tutorial_05_Play";			// Playing games
		public static const TUT_SHOP:String = "Tutorial_06_Shop"; 		// Shopping
		public static const TUT_JOBS:String = "Tutorial_07_Jobs";			// Jobs
		public static const TUT_EXPLORE:String = "Tutorial_08_Explore";	// Explore

		// TUTORIAL INGAME
		public static const TUT_INGAME_1_WELCOME:String = "TutorialInGame_01_Welcome";	// Welcome
		public static const TUT_INGAME_2_CONTROLS_1:String = "TutorialInGame_02_Controls"; // Controls 1
		public static const TUT_INGAME_3_MAP:String = "TutorialInGame_03_Map"; 			// Getting around/Map
		public static const TUT_INGAME_4_MOVE:String = "TutorialInGame_04_Move";			// Moving/Walking
		public static const TUT_INGAME_5_PLAY:String = "TutorialInGame_05_Play";			// Playing games
		public static const TUT_INGAME_6_SHOP:String = "TutorialInGame_06_Shop"; 		// Shopping
		public static const TUT_INGAME_7_JOBS:String = "TutorialInGame_07_Jobs";			// Jobs
		public static const TUT_INGAME_8_EXPLORE:String = "TutorialInGame_08_Explore";	// Explore
		
		// IN GAME
		public static const ENTER_WORLD:String = "EnterWorld"; 			// Upon initial entry to game
		public static const ENTER_REGION:String = "EnterRegion";		// Enter a region
		public static const EXIT_REGION:String = "ExitRegion";			// Exit a region
		public static const LOST_CONNECTION:String = "LostConnectionToServer";  // Lost connection to smartfox server
		
		// QUESTS
		public static const QUEST_STARTED:String = "QuestStarted";
		public static const QUEST_COMPLETED:String = "QuestCompleted";
		
		// GAMES
		public static const GAME_STARTED:String = "GameStart";			// Starting a game (game name appended)
		public static const GAME_COMPLETE:String = "GameComplete";		// Finishing a game
		public static const GAME_EXITED:String = "GameEarlyExit";		// Quitting a game in the middle
		
		// MISC
		public static const PET_TYPE:String = "PetpetType";				// For number of adoptions by species and color
		
		// SHOPS
		public static const ENTER_SHOP:String = "EnterStore";			// Entering shop, shop name appended
		public static const DRESSING_ROOM:String = "EnterDressingRoom"; // Enter dressing room
		public static const ENTER_SPA:String = "EnterSpa";				// Enter spa
		
		public static const HUD_MAP:String = "HudMap";
		
		public static const EAT_FOOD : String = "EatFood";
		
		
		/**
		 * Wraps the PageStats.GamePlay javascript call.
		 * @param gameID the identifier of the game.  IE "blocktacular"
		 * @param mode "multiplayer" or "singleplayer"
		 * @param params Actionscript Object.  IE.. {user: {age: "9", gender: "female"}}
		 */
		public static function trackingGameplay(gameID:String, mode:String, params:Object, type:String = SV_BOTH):void
		{
			if (!ACTIVE) return;
			
			
			var javaObj:Object = new Object();
			
			javaObj.gameID = gameID;
			javaObj.mode = mode;
			
			//javaObj.params = constructJavascriptObject(params);
			javaObj.params = demoInfo;
			
			try
			{
				switch (type) {
					case SV_BOTH:
					case SV_OMN:
						ExternalInterface.call("PageStats.GamePlay", javaObj.gameID, javaObj.mode, javaObj.params);
						break;
					case SV_GOOG:
						break;
				}
					
			}
			catch (e:Error)
			{
				log.error("trackingGameplay error", e);
			}
			
			
			
			
		}//end gameplay()
		
		
		public static function setGoogleTracker(displayObject:DisplayObject):void
		{
			googleTracker = new GATracker(displayObject, "UA-1152868-2", "AS3", false);
		}
		
		/**
		 * 
		 * Wraps the PageStats.Event javascript call.
		 * @param eventName the name of the event. IE.. "Login"
		 * @param params ActionscriptObject.  IE..{user: {age: "9", gender: "female"}}
		 * 
		 */
		public static function trackingEvent(event:String, params:Object = null):void
		{
			if (!ACTIVE) return;

			var javaObj:Object = new Object();
			
			javaObj.event = event;
			javaObj.params = demoInfo;
			//javaObj.params = constructJavascriptObject(params);
			;
			
			var isAvailable:Boolean = ExternalInterface.available;
			if (!isAvailable)
				;
			try
			{
				ExternalInterface.call("PageStats.Event", javaObj.event, javaObj.params);
			}
			catch (e:Error)
			{
				log.error("trackingEvent error", e);
			}
		}//end event()

		public static function googleEvent(category:String, action:String, label:String = null, value:Number = -1):void
		{
			if (!ACTIVE) return;

			if(!googleTracker) 
			{
				throw new Error("Google tracker doesn't have a displayObject. googleTracker is null")
			}
			if (label) {
				if (value>-1) 
					googleTracker.trackEvent(category, action, label, value);
				else
					googleTracker.trackEvent(category, action, label);
			}
			else
				googleTracker.trackEvent(category, action);
		}
		
		/**
		 * 
		 * Converts the Actionscript Object to a Javascript Object syntax friendly for PageStats.
		 * 
		 * @private
		 * @param	obj the object to translate to a String.
		 * @return the translated javascript object notation.
		 */
		private static function constructJavascriptObject(obj:Object):String
		{
			var output:String = "{";
			
			if (obj)
				output = addToJavascriptObject(obj, output);
			if (demoInfo)
				if (obj)
					output += ",";
				output = addToJavascriptObject(demoInfo, output);

			output += "}";
	
			return output;
			
		}	
		
		private static function addToJavascriptObject(obj:Object, output:String):String
		{
			var incr:int = 0;
			for ( var prop:* in obj)
			{
				if(incr > 0) output += ",";
				
				output += prop+":";
				
				if( typeof obj[prop] == "Object")
				{
					output += addToJavascriptObject(obj[prop], output);
					
				}
				else
				{
					output +="\""+obj[prop]+"\"";
					
				}
			
				incr ++;
				
			}//end for
			return output;
			
		}	
	}
	
}