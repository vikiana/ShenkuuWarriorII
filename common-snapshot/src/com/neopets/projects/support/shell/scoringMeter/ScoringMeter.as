package com.neopets.projects.support.shell.scoringMeter
{
	public class ScoringMeter
	{
		public function ScoringMeter()
		{
		}
		// -------------------------------------------------------------------------------
		// display send score result in scoring meter
		// -------------------------------------------------------------------------------
		public function scoreResult():void {
			
			var returnID:Number = 0;
			var sNewNP:String   = "";
			
			// Data okay?
			if ( aScoreMeterVars["eof"] == undefined ) {
				returnID = 5;
			}
			else {
				// save the new number of plays
				objGameData.iScorePosts = Number( aScoreMeterVars["plays"] );
				
				sNewNP = String( aScoreMeterVars["np"] );
				
				// error?
				var nErrCode:Number = Number( aScoreMeterVars["errcode"] );
				var nSuccess:Number = Number( aScoreMeterVars["success"] );
				
				if ( nErrCode == 20 ) returnID = 20; 		// Daily Dare IDS_SM_DD_NOSUCCESS
				else if ( nErrCode == 19 ) returnID = 19; 	// Daily Dare IDS_SM_DD_SUCCESS
				else if ( nErrCode == 18 ) returnID = 18; 	// World Challenge Low Score
				else if ( nErrCode == 17 ) returnID = 17; 	// missing hash
				else if ( nErrCode == 16 ) returnID = 16; 	// quick session
				else if ( nErrCode == 15 ) returnID = 15; 	// score is being reviewed
				else if ( nErrCode == 14 ) returnID = 14; 	// challenge not in time
				else if ( nErrCode == 13 ) returnID = 13; 	// challenge stuff
				else if ( nErrCode == 12 ) returnID = 12; 	// FR too slow for challenge
				else if ( nErrCode == 11 ) returnID = 11; 	// no challenge max posts
				else if ( nErrCode == 10 ) returnID = 10; 	// cookie error
				else if ( nErrCode == 9 ) returnID = 9; 	// daily challenge max posts
				else if ( nErrCode == 8 ) returnID = 8;		// not logged in msg
				else if ( nErrCode > 0 ) returnID = 5; 		// unknown error
				else if ( nSuccess == 2 ) returnID = 2; 	// x2 bonus
				else returnID = 1;
				
				if ( aScoreMeterVars["sh"] != undefined ) objGameData.sHash = aScoreMeterVars["sh"];
				if ( aScoreMeterVars["sk"] != undefined ) objGameData.sSK   = aScoreMeterVars["sk"];
			
				/*if ( (objScoreMeterVars.call_url != "") && (objScoreMeterVars.call_url != undefined) ) {
					var new_call_url = unescape( objScoreMeterVars.call_url );
					getURL(new_call_url,"_blank");
				}*/
			}
		
			// restart game if the scoring meter is invisible
			if ( !objGameData.bMeterVisible ) {
				restartGame();
			} else {
				objScoringMeter.showMsg( returnID, nShowScore, nShowNP, sNewNP, aScoreMeterVars );
			}
		}
		
		// -------------------------------------------------------------------------------
		// HTML Links in the scoring meter
		// -------------------------------------------------------------------------------
		public function TextLinkHandler( e:TextEvent ):void {
		
			var t_sEvent:String = e.text.toUpperCase();
			
			switch ( t_sEvent ) {
				case "RESTARTGAME":
					objScoringMeter.removeListeners();
					removeEventListener(TextEvent.LINK, TextLinkHandler);
					restartGame();
					break;
				case "SHOWCARD":
					objScoringMeter.removeListeners();
					objScoringMeter.showCCard();
					break;
				case "SUBMITCARD":
					objScoringMeter.removeListeners();
					objScoringMeter.submitCCard();
					break;
				case "CANCELCARD":
					objScoringMeter.removeListeners();
					objScoringMeter.cancelCCard();
					break;
				case "BACKTOCARD":
					objScoringMeter.removeListeners();
					objScoringMeter.gotoCCard();
					break;
				case "SHOWLOGIN":
					showLogin();
					break;
				case "SHOWSIGNUP":
					showSignup();
					break;
				case "VALIDATEEMAIL":
					validateEmail();
					break;
				case "SHOWCHALLENGE":
					showChallenge();
					break;
			}
		}

	}
}