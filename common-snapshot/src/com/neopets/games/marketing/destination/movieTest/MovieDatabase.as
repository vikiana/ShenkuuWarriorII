/**
 *	Main Database tracker for collection quest
 *	It keeps track of:
 *	1 games played (X 2)
 *	2 video trailer watched
 *	3 park info clicked
 *	4 main fixflag page click
 *	5 feedapet
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.sixFlags
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractDatabase;
	import com.neopets.util.events.CustomEvent;
	
	public class SixFlagsDatabase extends AbstractDatabase
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
			
		public const FLAG_FOUND:String = "a_flag_or_all_flags_found";
		
		//Collection quest qualifications/requirements
		private var mReqGame1Play:int = 2;
		private var mReqVideoWatch:int = 2;
		private var mReqInfoClickLinks:int = 3;
		private var mReqGateClick:int = 2;
		private var mReqGame2Play:int = 2;
		private var mReqFeedAPet:int = 3;
		private var mReqTotalFlags:int = 6;
		
		
		//Collection quest user status
		private var mGame1Played:int;
		private var mVideoWatched:int;
		private var mClickLinks:int;
		private var mGateClicked:int;
		private var mGame2Played:int;
		private var mFeedAPet:int;
		
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SixFlagsDatabase(pUserName:String = "GUEST_USER_ACCOUNT", pProjectID:String = "TYPE14ITEM0000"):void
		{
			super(pUserName, pProjectID)
			addEventListener(ACTION_CONFIRMED, setupObjData)
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function get game1():int { return mGame1Played;}
		public function get game2():int { return mGame2Played;}
		public function get trailer():int { return mVideoWatched;}
		public function get clickLink():int { return mClickLinks;}
		public function get gate():int { return mGateClicked;}
		public function get feedAPet():int { return mFeedAPet;}
		
		public function set game1(pInt:int):void 
		{ 
			mGame1Played = pInt;
			checkUnlockedFlag("mGame1Played")
			updateDatabase();
		}
		public function set game2(pInt:int):void 
		{ 
			mGame2Played = pInt;
			checkUnlockedFlag("mGame2Played")
			updateDatabase();
		}
		public function set trailer(pInt:int):void 
		{ 
			mVideoWatched = pInt;
			checkUnlockedFlag("mVideoWatched")
			updateDatabase();
		}
		public function set clickLink(pInt:int):void 
		{ 
			mClickLinks = pInt;
			checkUnlockedFlag("mClickLinks")
			updateDatabase();
		}
		public function set gate(pInt:int):void 
		{ 
			mGateClicked = pInt;
			checkUnlockedFlag("mGateClicked")
			updateDatabase();
		}
		public function set feedAPet(pInt:int):void 
		{ 
			mFeedAPet = pInt;
			checkUnlockedFlag("mFeedAPet")
			updateDatabase();
		}
				
		
		
		
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//return status of flags:  true = fount, false = not found
		public function showFlags():Array
		{
			var flag1:Boolean = false;
			var flag2:Boolean = false;
			var flag3:Boolean = false;			
			var flag4:Boolean = false;
			var flag5:Boolean = false;
			var flag6:Boolean = false;
			if (mUserName != GUEST_USER)
			{
				trace ("isn't it?", mClickLinks >= mReqInfoClickLinks)
				flag1 = mGame1Played >= mReqGame1Play? true: false;
				flag2 = mVideoWatched >= mReqVideoWatch? true:false;
				flag3 = mClickLinks >= mReqInfoClickLinks? true:false;
				flag4 = mGateClicked >= mReqGateClick? true:false;
				flag5 = mGame2Played >= mReqGame2Play? true:false;
				flag6 = mFeedAPet >= mReqFeedAPet? true:false;
			}
			return [flag1, flag2, flag3, flag4, flag5, flag6];
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	Every time when user status is changed, check if any given flag has met the requirements
		 *	If flag is found, dispatch an event with approriate click ID and if all flags are found
		 *	@PARAM		pFlagToCheck		user data (variables) that should be should be check
		 **/
		private function checkUnlockedFlag(pFlagToCheck:String):void
		{
			trace ("check for flag unlock", pFlagToCheck)
			var flagFound:Boolean = false
			var clickID:int
			if (mUserName != GUEST_USER)
			{
				switch(pFlagToCheck)
				{
					
					case "mGame1Played":
						if (mGame1Played >= mReqGame1Play && objData.game1FlagFound == "false")
						{
							objData.game1FlagFound = true
							flagFound = true
							clickID = 14428;
							objData.FlagsFound++
						}
						break;
					
					case "mGame2Played":
						if (mGame2Played >= mReqGame2Play && objData.game2FlagFound == "false")
						{
							objData.game2FlagFound = true
							flagFound = true
							clickID = 14427;
							objData.FlagsFound++
						}
						break;
					
					case "mVideoWatched":
						if (mVideoWatched >= mReqVideoWatch && objData.videoFlagFound == "false")
						{
							objData.videoFlagFound = true
							flagFound = true
							clickID = 14429;
							objData.FlagsFound++
						}
						break;
					
					case "mClickLinks":
						trace (mClickLinks >= mReqInfoClickLinks && !objData.linksFlagFound)
						trace (mClickLinks, mReqInfoClickLinks, objData.linksFlagFound)
						if (mClickLinks >= mReqInfoClickLinks && objData.linksFlagFound == "false")
						{
							objData.linksFlagFound = true
							flagFound = true
							clickID = 14430;
							objData.FlagsFound++
						}
						break;
					
					case "mGateClicked":
						if (mGateClicked >= mReqGateClick && objData.gateFlagFound == "false")
						{
							objData.gateFlagFound = true
							flagFound = true
							clickID = 14431;
							objData.FlagsFound++
						}
						break;
					
					case"mFeedAPet":
						if (mFeedAPet >= mReqFeedAPet && objData.feedAPetFlagFound == "false")
						{
							objData.feedAPetFlagFound = true
							flagFound = true
							clickID = 14432;
							objData.FlagsFound++
						}
						break ;
				}
			}
			if (flagFound)
			{
				var allFlagsFound:Boolean = objData.FlagsFound >= mReqTotalFlags? true: false;
				var prizeClickID:int = 14433;
				dispatchEvent(new CustomEvent ({ALLFOUND:allFlagsFound, PRIZEID:prizeClickID, CLICKID:clickID}, FLAG_FOUND));
				
			}
		}
		
		//when user status is changed, updtate the database as well
		private function updateDatabase():void
		{
			if (mUserName != GUEST_USER) 
			{
				objData.game1 = mGame1Played;
				objData.game2 = mGame2Played;
				objData.video = mVideoWatched;
				objData.links = mClickLinks;
				objData.gate = mGateClicked;
				objData.feedAPet = mFeedAPet;
				setVars();
			}
			else 
			{
				trace ("USER NOT LOGGEDIN: databse update avoided")
			}
		}
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		//	For initial set up, if the objData is empty, 
		// 	it creates the appropriate properties and corresponding values
		private function setupObjData(evt:Event):void
		{
			removeEventListener(ACTION_CONFIRMED, setupObjData)
			objData.game1 == undefined? mGame1Played = objData.game1 = 0: mGame1Played = objData.game1;
			objData.game2 == undefined? mGame2Played = objData.game2=  0: mGame2Played = objData.game2;
			objData.video == undefined? mVideoWatched = objData.video = 0: mVideoWatched = objData.video;
			objData.links == undefined? mClickLinks = objData.links =  0: mClickLinks= objData.links;
			objData.gate == undefined? mGateClicked = objData.gate =  0: mGateClicked = objData.gate;
			objData.feedAPet == undefined? mFeedAPet =objData.feedAPet =  0: mFeedAPet =objData.feedAPet;
			//
			if (objData.game1FlagFound == undefined) objData.game1FlagFound = false;
			if (objData.game2FlagFound == undefined) objData.game2FlagFound = false;
			if (objData.videoFlagFound == undefined) objData.videoFlagFound = false;
			if (objData.linksFlagFound == undefined) objData.linksFlagFound = false;
			if (objData.gateFlagFound == undefined) objData.gateFlagFound = false;
			if (objData.feedAPetFlagFound == undefined)objData.feedAPetFlagFound = false;
			if (objData.FlagsFound == undefined) objData.FlagsFound = 0;
			//
			setVars();
		}
	}
}