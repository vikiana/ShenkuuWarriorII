// ---------------------------------------------------------------------------------------
// Game Data object
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	/**
	 * <p>Contains all default variables used by the gaming system and preloader.</p>
	 * <p>This object is instantiated at NP9_Loader_Control constructor.</p>
	 * @see com.neopets.projects.np9.system.NP9_Loader_Control#NP9_Loader_Control()
	 */
	public class NP9_Game_Data {
		
		/**
		 * The URL to access all swfs. eg: http://images.neopets.com, http://images50.neopets.com
		 */
		public var FG_GAME_BASE:String;
		/**
		 * The URL to access scripts. eg: http://www.neopets.com, http://dev.neopets.com, http://webdev.neopets.com
		 */
		public var FG_SCRIPT_BASE:String;
		
		public var bDebug:Boolean;
		public var bTransDebug:Boolean;
		public var bOffline:Boolean;
		public var bDictionary:Boolean;
		public var bMeterVisible:Boolean;
		public var objTransLevel:Object;
		
		public var sFilename:String;
		public var sPreloader:String;
		public var sQuality:String;
		public var iFramerate:Number;
		public var iVersion:Number;
		public var iGameID:Number;
		public var iNPRatio:Number;
		public var iNPCap:Number;
		public var sUsername:String;
		public var sName:String;
		public var iAge13:Number;
		public var iNsm:Number;
		public var iNsid:Number;
		public var sNcReferer:String;
		public var sLang:String;
		public var sHash:String;
		public var sSK:String;
		public var iCalibration:Number;
		public var sBaseURL:String;
		public var iTypeID:Number;
		public var iItemID:Number;
		public var iScorePosts:Number;
		public var iVerifiedAct:Number;
		public var iHiscore:Number;
		public var sDestination:String;
		public var iChallenge:Number;
		public var sPSurl:String;
		public var iTracking:Number;
		public var iMultiple:Number;
		public var iIsMember:Number;
		public var iIsAdmin:Number;
		public var iIsSponsor:Number;
		public var iPlaysAllowed:Number;
		public var iDailyChallenge:Number;
		public var iDictVersion:Number;
		public var sImageHost:String;
		public var sIncludeMovie:String;
		public var iIE:Number;
		public var iChallengeCard:Number;
		public var iDdNcChallenge:Number;
		public var iUseCustomMsg:Number;
		public var iForceScore:Number;
		
		public var iBIOSWidth:Number;
		public var iBIOSHeight:Number;
		public var iGameWidth:Number;
		public var iGameHeight:Number;
		public var iGameMaxW:Number;
		public var iGameMaxH:Number;
		
		// dynamic sponsored preloader data
		public var sSpLogoURL:String;
		public var iSpTrackID:Number;
		public var sSpAdURL:String;
		public var sSpClickUrl:String;
		public var iSpLogoTrackID:Number;
		
		public var iMeterX:Number;
		public var iMeterY:Number;
		
		public var tLoaded:Number;
		public var bEmbedFonts:Boolean;
		public var iAvgFramerate:Number;
		
		public var objAddVars:Object;

		/**
		 * @Constructor
		 */
		public function NP9_Game_Data()
		{
			// will be set by loader
			FG_GAME_BASE    = "";
			FG_SCRIPT_BASE  = "";
			
			// set default values
			bDebug          = false;
			bTransDebug     = false;
			bOffline        = false;
			bDictionary     = false;
			bMeterVisible   = true;
			objTransLevel   = undefined;
			
			sFilename       = "g915_v1_77768";
			sPreloader      = "np9_preloader_hauntedwoods_v1";
			sQuality        = "high";
			iFramerate      = 24;
			iVersion        = 15;
			iGameID         = 915;
			iNPRatio        = 0;
			iNPCap          = 1000;
			sUsername       = "guest_user_account";
			sName           = "";
			iAge13          = 1;
			iNsm            = 0;
			iNsid           = 0;
			sNcReferer      = "";
			sLang           = "en";
			sHash           = "35ba379a5d920acb6f18";
			sSK             = "35ba379a5d920acb6f18";
			iCalibration    = 256;
			sBaseURL        = "www.neopets.com";
			iTypeID         = 4;
			iItemID         = 46;
			iScorePosts     = 0;
			iVerifiedAct    = 1;
			iHiscore        = 0;
			sDestination    = "games/";
			iChallenge      = 0;
			sPSurl          = "";
			iTracking       = 0;
			iMultiple       = 0;
			iIsMember       = 0;
			iIsAdmin        = 0;
			iIsSponsor      = 0;
			iPlaysAllowed   = 3;
			iDailyChallenge = 0;
			iDictVersion    = 19;
			sImageHost      = "http://images50.neopets.com";
			sIncludeMovie   = "games/gaming_system/np9_gaming_system_v15.swf";
			iIE             = 0;
			iChallengeCard  = 1;
			iUseCustomMsg	= 0;
			iForceScore		= -1;
			
			iBIOSWidth      = 640;
			iBIOSHeight     = 480;
			iGameWidth      = 640;
			iGameHeight     = 480;
			iGameMaxW       = 640;
			iGameMaxH       = 480;
			
			sSpLogoURL      = "";
			iSpTrackID      = -1;
			sSpAdURL        = "";
			sSpClickUrl		= "";
			iSpLogoTrackID	= -1;
		
			iMeterX         = 0;
			iMeterY         = 0;
			
			tLoaded         = 0;
			bEmbedFonts     = true;
			iAvgFramerate   = 24;
			
			objAddVars = {};
		}
		

		/**
		 * Sets a variable value
		 * @param	cVar		Name of the variable
		 * @param	val		Value of the variable
		 */
		public function setVar( cVar:String, val:* ):void
		{
			// property exists
			if ( this[cVar] != undefined ) {
				// passed value is valid
				if ( val != undefined ) {
					this[cVar] = val;
					//race(cVar+" set to "+val);
				}
			}
		}
		
		/**
		 * Adds a new variable to the class
		 * 
		 * @param	cVar		Name of new non existing variable to store
		 * @param	val		Value of the variable
		 */
		public function setAddVar( cVar:String, val:* ):void
		{
			// passed value is valid
			if ( val != undefined ) {
				objAddVars[cVar] = val;
				//race(cVar+" does not exist! Added to additional params object: "+objAddVars[cVar]);
			}
		}
	}
}
