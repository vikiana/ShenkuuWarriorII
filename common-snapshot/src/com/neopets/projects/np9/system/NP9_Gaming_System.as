// ---------------------------------------------------------------------------------------
// Gaming System Class
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.Font;

	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	
	import flash.system.ApplicationDomain;
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Tracer;
	//import com.neopets.projects.np9.system.NP9_Game_Data;
	import com.neopets.projects.np9.system.NP9_Translator;
	import com.neopets.projects.np9.system.NP9_Score_Encryption;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.projects.np9.system.NP9_Neostatus;
	import com.neopets.projects.np9.system.NP9_Scoring_Meter;
	import com.neopets.projects.np9.system.NP9_Sound_Control;
	
	// -----------------------------------------------------------------------------------
	public class NP9_Gaming_System extends MovieClip {

		private var objTracer:NP9_Tracer;
		
		private var objGameData:Object;
		
		private var objTranslator:NP9_Translator;
		private var objEncryption:NP9_Score_Encryption;
		private var objNeoStatus:NP9_Neostatus;
		private var objScoringMeter:NP9_Scoring_Meter;
		
		public var _SOUND:NP9_Sound_Control;
		
		private var sScoreURL:String;
		private var scoreLoader:URLLoader;
		private var aScoreMeterVars:Object;
		private var bScoringMeterClick:Boolean;
		
		private var bTRACE:Boolean;
		
		private var mcMeter:MovieClip;
		
		private var nShowScore:Number;
		private var nShowNP:Number;

		private var extraSendScoreVars : Array;
		private var mGSVersion:String = "v19";
		
		public const RESTART_CLICKED:String = "TheRestartBtnClicked";
		

		/**
		 * @Constructor
		 * <p>This GamingSystem object is loaded as an external swf file from the NP9_Loader_Control object.</p>
		 * @see NP9_Loader_Control#loadGamingSystem()
		 */
		public function NP9_Gaming_System() {
			
			// tracer object
			objTracer = new NP9_Tracer( this, false );
			objTracer.out( "Instance created of GamingSystem!" + mGSVersion, true);
			
			extraSendScoreVars = new Array( );
			trace("extraSendScoreVars: "+  extraSendScoreVars );
			bTRACE = false;
			
			scoreLoader = new URLLoader();
			
			// display only
			nShowScore = 0;
			nShowNP    = 0;
		}
		
		/**
		 * <p>Initializer</p>
		 * 
		 * @param	p_GameData The NP9_Game_data object
		 * @param	p_bTrace		
		 * 
		 * @see NP9_Loader_Control#setGamingSystem()
		 * 
		 */
		public function init( p_GameData:Object, p_bTrace:Boolean ):void {
			
			objTracer.setDebug( p_bTrace );
			
			objGameData = p_GameData;
			bTRACE = p_bTrace;
			
			objTracer.out( "Game Data initialized - Game ID: "+objGameData.iGameID+"game width"+objGameData.iGameWidth, false );
			
			// the actual scoring meter movieclip
			//mcMeter = new mcMeter(); //FLASH BASED
			var ScoreMeterClass:Class= ApplicationDomain.currentDomain.getDefinition("mcInclude") as Class
			mcMeter = new ScoreMeterClass();
			addChild( mcMeter );
			
			bScoringMeterClick = false;
			
			// sendScore URL
			var sSlash:String = String.fromCharCode(47);
			sScoreURL = "high_scores" + sSlash + "process_flash_score.phtml";
			
			// OTHER GS CLASSES
			objTranslator = new NP9_Translator( bTRACE );
			objTranslator.init( objGameData.FG_SCRIPT_BASE,
								objGameData.iGameID,
								objGameData.sLang );
			
			objEncryption = new NP9_Score_Encryption();
			
			objNeoStatus  = new NP9_Neostatus( bTRACE );
			objNeoStatus.init( objGameData );
			
			objScoringMeter = new NP9_Scoring_Meter( bTRACE );
			objScoringMeter.init( mcMeter, objGameData, objTranslator );
			
			showScoringMeter( false );
			
			_SOUND = new NP9_Sound_Control( bTRACE );
		}
		
		/**
		 * Passes extra variables to the send score script
		 * @param	aVarName		Name of the variable
		 * @param	aValue			Value of the variable
		 */
		public function addSendScoreVar( aVarName : String, aValue : * ) : void
		{
			// TODO: see if the aVarName exists, if so overwrite the value (aValue)
			var a : Array = new Array( aVarName, aValue );
			extraSendScoreVars.push( a );
		}
		
		/**
		 * Obtains extra variables returned by the send score script
		 * @param	aVarName		Name of the expected variable
		 * @return						Value of the variable
		 */
		public function getSendScoreVar( aVarName : String ) : Object
		{
			return aScoreMeterVars[ aVarName ];
		}

		/**
		 * Sets a variable sent from the send score script
		 * @param	aVarName		Name of the variable to modify
		 * @param	aValue			Value of the variable
		 */
		public function setSendScoreVar( aVarName : String, aValue : * ) : void
		{
			aScoreMeterVars[ aVarName ] = aValue;
		}

		/**
		 * Checks if current language is a western language
		 * @return		True if it's a western language
		 */
		public function isWesternLang():Boolean {
			return ( objTranslator.isWesternLang() );
		}
		
		/**
		 * Returns the current script server
		 * @return	URL String
		 */
		public function getScriptServer():String { return ( objGameData.FG_SCRIPT_BASE ); }

		/**
		 * Returns the current image server
		 * @return	URL String
		 */
		public function getImageServer():String { return ( objGameData.FG_GAME_BASE ); }
		
		/**
		 * Obtains a flashvar value
		 * @param	p_sID	String name of the flashvar variable
		 * @return				Value of the flashvar variable
		 */
		public function getFlashParam( p_sID:String ):String {
			
			if( objGameData[ p_sID ] == null ){
				return ( String( objGameData.objAddVars[ p_sID ] ) );
			}else{
				return ( String( objGameData[ p_sID ] ) );
			}

		}

		/**
		 * Returns the string value of a translation text loaded by the Translator
		 * @param	p_sID		String name of text
		 * @return					Contents of the text string
		 */
		public function getTranslation( p_sID:String ):String {
			return ( objTranslator.getTranslation( p_sID ) );
		}
		
		/**
		 * Adds a font to the translation engine - Not in use anymore
		 * @param	p_Font		The font object
		 * @param	p_sID		A string identifier 
		 */
		public function addFont( p_Font:Font, p_sID:String ):void {
			objTranslator.addFont( p_Font, p_sID );
		}

		/**
		 * Sets the default font to use by the translation engine - Not in use anymore
		 * @param	p_sID		The string identifier of the font
		 */
		public function setFont( p_sID:String ):void {
			objTranslator.setFont( p_sID );
		}

		/**
		 * Sets the contents of a TextField object with a html text
		 * @param	p_tfInstance	The TextField instance
		 * @param	p_sHTML		The string to enter into the TextField
		 */
		public function setTextField( p_tfInstance:TextField, p_sHTML:String ):void {
			objTranslator.setTextField( p_tfInstance, p_sHTML );
		}
		
		/**
		 * Creates a new encrypted value using NP9_Evar class
		 * @param	xVar		Value to be encrypted
		 * @return				The created NP9_Evar object
		 * 
		 * @see NP9_Evar
		 */
		public function createEvar( xVar:* ):Object {
			
			var objEvar:NP9_Evar = new NP9_Evar( xVar );
			
			return ( objEvar );
		}
		
		/**
		 * Sends a Neopets tracking tag to NeoStatus object
		 * @param	p_sTag		The tag to send
		 * 
		 * @see NP9_NeoStatus
		 */
		public function sendTag( p_sTag:String ):void {		
			objNeoStatus.sendTag( p_sTag );
		}
		
		/**
		 * Submits the game score
		 * @param	p_nVal			Score to be sent
		 * @param	p_nPrize		Prize ID obtained (usable?)
		 */
		public function sendScore( p_nVal:Number, p_nPrize:Number = 0 ):void {
			trace ("SENDING SCORE");
			nShowScore = p_nVal;
			nShowNP    = int(nShowScore * objGameData.iNPRatio);
			
			// check np cap
			if ( nShowNP > objGameData.iNPCap ) {
				nShowNP = objGameData.iNPCap;
			}
			
			bScoringMeterClick = false;
			
			var sendID:Number = 0;
			
			if ( objGameData.bOffline ) sendID = 5;
			//var check added by Viviana: it was giving me an error on dev
			if (objGameData.iUseCustomMsg && objGameData.iUseCustomMsg == 1) sendID = 0;
			else if ( p_nVal <= 0 ) sendID = 4;
			else if ( objGameData.sUsername.toUpperCase() == "GUEST_USER_ACCOUNT" ) {
				// not logged in		
				sendID = 8;
				// Daily dare change
				//
				//if ( _level0.dd_game != undefined ) {
				//	if ( Number(_level0.dd_game) == 1 ) {
				//		sendID = 0;
				//	}
				//}
			}
			else if ( (objGameData.iScorePosts >= objGameData.iPlaysAllowed) ) {
				// max posts reached and no challenges going on
				if ( (objGameData.iChallenge != 1) && (objGameData.iDailyChallenge != 1) ) {
					sendID = 3; // max reached
				}
			}
		
			// !!DEBUG!!
			// sendID = 0;
			
			// everything's cool
			trace ("sendID is", sendID, !objGameData.bMeterVisible)
			if ( sendID == 0) {
				callScoreScript( p_nVal, p_nPrize );
			} else {
				// no score was sent and the meter is visible
				if ( !objGameData.bMeterVisible ) {
					restartGame();
				} else {
					trace ("SHOWING SCORING METER");
					showScoringMeter( true );
					objScoringMeter.showMsg( sendID, nShowScore, nShowNP, "0", new Array() );
					addEventListener(TextEvent.LINK, TextLinkHandler, false, 0, true);
				}
			}
		}
		
		/**
		 * Poll this function to check if the user clicked on the restart game link on the black scoring meter
		 * @return True if player clicked on restart
		 */
		public function userClickedRestart():Boolean {			
			return ( bScoringMeterClick );
		}

		/**
		 * @private
		 * Hides the scoring meter when player clicks on restart
		 */
		private function restartGame():void {
			
			objTracer.out( "Restart Game was called!", false );
			this.dispatchEvent(new Event(RESTART_CLICKED));
			bScoringMeterClick = true;
			showScoringMeter( false );
		}

		/**
		 * @private
		 * Sends the score and display the scoring meter
		 * @param	p_nVal		Score to send
		 * @param	p_nPrize	Prize ID obtained (usable?)
		 */
		private function callScoreScript( p_nVal:Number, p_nPrize:Number = 0 ):void {
			
			objEncryption.init( objGameData.sHash, objGameData.sSK );
			
			// created to be encrypted string
			var sString:String = "";
			sString += "s="+String(p_nVal);
			
			// checknum - probably not needed anymore!
			var cn:String = String(300*objGameData.iGameID);

			// create url plus checknum & time played
			var sURL:String = "?cn="+cn+"&gd="+String(getTimer()-objGameData.tLoaded);
			
			// prevent caching
			sURL += "&r="+String( (Math.random()*1000000) );

			// encrypt data
			var sRaw:String = "ssnhsh="+objGameData.sHash+"&ssnky="+objGameData.sSK+"&gmd="+objGameData.iGameID+"&scr="+String(p_nVal)+"&przlvl="+p_nPrize+"&frmrt="+objGameData.iAvgFramerate+"&chllng="+objGameData.iChallenge+"&gmdrtn="+String(getTimer()-objGameData.tLoaded);
			
			// added 7/14/08 -- moved the extra vars over to encryption
			for( var i : uint = 0; i < extraSendScoreVars.length; i ++ ){
				var a : Array = extraSendScoreVars[ i ];
				sRaw += "&" + String( a[0] ) + "=" + String( a[1] );
			}
			
			var sEncryptedData:String = objEncryption.encrypt( sRaw );
			var sessionID:String = String(objGameData.sHash)+String(objGameData.sSK);
			sURL += "&gmd_g="+objGameData.iGameID+"&mltpl_g="+objGameData.iMultiple+"&gmdt_g="+sEncryptedData+"&sh_g="+objGameData.sHash+"&sk_g="+objGameData.sSK+"&usrnm_g="+objGameData.sUsername+"&dc_g="+objGameData.iDailyChallenge+"&cmgd_g="+objEncryption.iVID+"&ddNcChallenge="+objGameData.iDdNcChallenge+"&fs_g="+objGameData.iForceScore;
			
			
			// call scoring script
			var request:URLRequest = new URLRequest();
			request.url = objGameData.FG_SCRIPT_BASE + sScoreURL + sURL;
			request.method = URLRequestMethod.POST;
			scoreLoader.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			scoreLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			scoreLoader.load( request );
			
			objTracer.out( "Calling Scoring Script...", false );
			objTracer.out( "...URL: "+objGameData.FG_SCRIPT_BASE + sScoreURL, false );
			objTracer.out( "...Parameters: "+sURL, false );
			
			trace("parameters: " + sURL);
			
			// update user's highscore
			if ( p_nVal > objGameData.iHiscore ) objGameData.iHiscore = p_nVal;
			
			var cStr:String = "";
			// show scoring meter?
			if ( objGameData.bMeterVisible ) {
				showScoringMeter( true );
				objScoringMeter.scoreSent( nShowScore, nShowNP );
				addEventListener(TextEvent.LINK, TextLinkHandler, false, 0, true);
			}
		}

		/**
		 * @private
		 * @param	event
		 */
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			removeLoaderListeners();
			objTracer.out( "securityErrorHandler: "+event.text, true );
        }
		
		/**
		 * @private
		 * Send score completed
		 * @param	event
		 */
		private function completeHandler(event:Event):void {
			
			removeLoaderListeners();
			
			var sResult:String = String(event.target.data);
			
			// !!DEBUG!!
			// sResult = "eof=0&message=Congratulations+You+scored+500+and+won+2+prizes&gp_img_1=http%3A%2F%2Fimages50.neopets.com%2Fitems%2Ftoy_fireracer.gif&gp_img_2=http%3A%2F%2Fimages50.neopets.com%2Fitems%2Fcan_negghunt_lollipop.gif&gp_bg_img=http%3A%2F%2Fimages50.neopets.com%2Fgames%2Fgaming_system%2Fbackgrounds%2Fbg_1095.gif&np=10,764&success=1&errcode=31&avatar=&plays=3&eof=1&call_url=&sk=c26039b130344241f5fa&sh=10fab9bcb3189b922a5c";
			
			var aResult:Array = sResult.split("&");
			aScoreMeterVars = new Array();
			
			for ( var i:Number=0; i<aResult.length; i++ ) {
				var aPair:Array = aResult[i].split("=");
				aScoreMeterVars[aPair[0]] = aPair[1];
				objTracer.out( "aScoreMeterVars['"+aPair[0]+"'] = "+aPair[1], false );
			}
			
			scoreResult();
			
			// SUCCESS:
			// eof=0&np=1,479,743&success=1&errcode=0&avatar=&plays=1&eof=1&call_url=&sk=0e34701c3a4df4e74c52&sh=f963c971ef9f4f82e5bd
			// ERROR:
			// eof=0&success=0&errcode=17&eof=1
		}
		
		/**
		 * @private
		 * Removes all listeners
		 */
		private function removeLoaderListeners():void {
			
			scoreLoader.removeEventListener(Event.COMPLETE, completeHandler);
			scoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}


		/**
		 * @private
		 * Displays the score result on the black scoring meter
		 */
		private function scoreResult():void {
			
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
				
				if ( nErrCode == 32 ) returnID = 32; 		// one prize awarded
				else if ( nErrCode == 31 ) returnID = 31; 	// two prizes awarded
				else if ( nErrCode == 28 ) returnID = 28; 	// Daily Dare IDS_SM_DD_NC_LOST_LULU
				else if ( nErrCode == 27 ) returnID = 27; 	// Daily Dare IDS_SM_DD_NC_BEAT_LULU
				else if ( nErrCode == 26 ) returnID = 26; 	// Altador IDS_SM_AC_MAX_SCORE
				else if ( nErrCode == 25 ) returnID = 25; 	// Daily Dare IDS_SM_DD_BEAT_DOUBLE
				else if ( nErrCode == 24 ) returnID = 24; 	// Daily Dare IDS_SM_DD_BEAT_DOUBLE
				else if ( nErrCode == 23 ) returnID = 23; 	// Daily Dare IDS_SM_DD_BEAT_ABIGAIL
				else if ( nErrCode == 22 ) returnID = 22; 	// Daily Dare IDS_SM_DD_BEAT_AAA
				else if ( nErrCode == 21 ) returnID = 21; 	// Daily Dare IDS_SM_DD_MAX
				else if ( nErrCode == 20 ) returnID = 20; 	// Daily Dare IDS_SM_DD_NOSUCCESS
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
				
				// handle external function call request
				if((aScoreMeterVars["call_external_function"] != null) && (aScoreMeterVars["call_external_function"] != "")) {
					if((aScoreMeterVars["call_external_params"] != null) && (aScoreMeterVars["call_external_params"] != "")) {
						// new code added 2/22/2010 for converting parameter strings to data objects
						var unescaped_params:String = unescape(aScoreMeterVars["call_external_params"]);
						var param_list:Array = unescaped_params.split("&");
						var param_obj:Object = new Object();
						var unnamed_id:Number = 0;
						var param_entry:Array;
						// cycle through all paramter entries
						for(var i:int = 0; i < param_list.length; i++) {
							// break entries into name-value pairs
							param_entry = param_list[i].split("=");
							// store paremeter values to an object property
							if(param_entry.length > 1) {
								param_obj[param_entry[0]] = param_entry[1];
							} else {
								if(param_entry.length > 0) {
									param_obj[unnamed_id] = param_entry[0];
									unnamed_id++;
								}
							}
						} // end of conversion from string to object
						ExternalInterface.call(aScoreMeterVars["call_external_function"],param_obj);
					} else ExternalInterface.call(aScoreMeterVars["call_external_function"]);
				}
				
				if ( (aScoreMeterVars["call_url"] != "") && (aScoreMeterVars["call_url"] != undefined) ) {
					var new_call_url:String = unescape(aScoreMeterVars["call_url"]);
					navigateToURL(new URLRequest(new_call_url),"_blank");
				}
			}
		
			// restart game if the scoring meter is invisible
			if ( !objGameData.bMeterVisible ) {
				restartGame();
			} else {
				objScoringMeter.showMsg( returnID, nShowScore, nShowNP, sNewNP, aScoreMeterVars as Array );
			}
		}
		
		/**
		 * Displays html links on the scoring meter based on the event
		 * @param	e	The text event
		 */
		private function TextLinkHandler( e:TextEvent ):void {
		
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
		
		/**
		 * Displays the Neopets login page
		 */
		public function showLogin():void {

			var t_sParam:String = "?destination="+objGameData.sDestination;
			var t_sURL:String   = objGameData.FG_SCRIPT_BASE + "loginpage.phtml" + t_sParam;
			
			var request:URLRequest = new URLRequest(t_sURL);
			navigateToURL( request, "NEOPETS LOGIN" );
		}

		/**
		 * Displays the Neopets signup page
		 */
		public function showSignup():void {
			
			var t_sURL:String = objGameData.FG_SCRIPT_BASE + "reg";
			
			var request:URLRequest = new URLRequest(t_sURL);
			navigateToURL( request, "NEOPETS SIGNUP" );
		}
		

		/**
		 * @private
		 * Email validator
		 */
		private function validateEmail():void {
			
			var t_sParam:String = "?destination="+objGameData.sDestination;
			var t_sURL:String   = objGameData.FG_SCRIPT_BASE + "activate.phtml" + t_sParam;
			
			var request:URLRequest = new URLRequest(t_sURL);
			navigateToURL( request, "NEOPETS SIGNUP" );
		}
		
		/**
		 * @private
		 */
		private function showChallenge():void {
			
			var t_sParam:String = "?destination="+objGameData.sDestination;
			var t_sURL:String   = objGameData.FG_SCRIPT_BASE + "challenges/challenge_list.phtml" + t_sParam;
			
			var request:URLRequest = new URLRequest(t_sURL);
			navigateToURL( request, "NEOPETS SIGNUP" );
		}
		
		/**
		 * Executes the translation script
		 */		
		public function callTranslation():void {
			objTranslator.callTranslation();
		}
		
		/**
		 * Poll this method to check if the translation process is complete
		 * @return True if completed
		 */
		public function translationComplete():Boolean {
			
			return ( objTranslator.translationComplete() );
		}
		
		
		/**
		 * Shows or hides the black scoring meter
		 * @param	bShow	True to display or false to hide
		 */
		private function showScoringMeter( bShow:Boolean ):void {
			
			if ( bShow ) {
				
				trace("meter dimensions before: "+mcMeter.width+", "+mcMeter.height);
				
				var t_nRatioX:Number = objGameData.iGameWidth / objGameData.iBIOSWidth;
				var t_nRatioY:Number = objGameData.iGameHeight / objGameData.iBIOSHeight;
				
				trace("BIOS dimensions: "+objGameData.iBIOSWidth+", "+objGameData.iBIOSHeight);
				trace("ratios: "+t_nRatioX+", "+t_nRatioY);
				
				mcMeter.scaleX  = t_nRatioX;
				mcMeter.scaleY = t_nRatioY;
				
				trace("meter dimensions: "+mcMeter.width+", "+mcMeter.height);
				
				mcMeter.x = int(objGameData.iMeterX * t_nRatioX);
				mcMeter.y = int(objGameData.iMeterY * t_nRatioY);
				
				trace("meter position: "+mcMeter.x+", "+mcMeter.y);
				
			} else {
				objScoringMeter.goTo("empty");
			}
			
			this.visible = bShow;
		}
	}
}


