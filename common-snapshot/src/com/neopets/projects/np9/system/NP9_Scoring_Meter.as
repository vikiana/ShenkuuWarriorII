package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.utils.unescapeMultiByte;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Tracer;
	import com.neopets.projects.np9.system.NP9_CCard;
	//import com.neopets.util.display.IconLoader;
	
	/**
	 * Scoring Meter base class
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Scoring_Meter extends MovieClip {
		
		//public const mcPrizePopUp:Class = MovieClip;
		
		private var objTracer:NP9_Tracer;
		
		private var mcMeter:MovieClip;
		
		private var objGameData:Object;
		private var objTranslator:Object;
		
		private var sMeterState:String;
		private var aMeterText:Array;

		private var sLastMarker:String;
		
		private var objCCard:NP9_CCard;
		private var aSaveTextVars:Array;
		private var aSaveInputVars:Array;
		
		//private var aPrizes:Array;
		//private var sBGURL:String;
		//private var ldrBGLoader:Loader;
		
		public var mcPrizes:MovieClip;
		
		private var bSlider:Boolean;
		private var bSliderActive:Boolean;

		private var nShowScore:Number;
		private var nShowNP:Number;
		
		//FLEX NEEDS THE FILES DECLARED IF ON THE STAGE (FLASH DOES NOT)
		public var t_sStr:String;
		
		/**
		 * @Constructor
		 * @param	p_bTrace	True if debug tracing is needed
		 */
		public function NP9_Scoring_Meter( p_bTrace:Boolean ) {
			
			sMeterState = "";
			aMeterText = new Array("","","","");
			
			sLastMarker = "";
			
			// tracer object
			objTracer = new NP9_Tracer( this, p_bTrace );
			objTracer.out( "Instance created!", true );
			
			// challenge card
			objCCard = new NP9_CCard( p_bTrace );
			aSaveTextVars  = new Array();
			aSaveInputVars = new Array();
			
			//aPrizes = new Array();
			
			bSlider = false;
			bSliderActive = false;
			
			// dispaly only
			nShowScore = 0;
			nShowNP    = 0;
		}
		
		/**
		 * Initialization
		 * @param	p_objMC			The meter movieclip instance
		 * @param	p_GameData		The NP9_Game_Data object instance
		 * @param	p_Translator		The translator instance
		 * 
		 * @see NP9_Game_Data
		 * @see NP9_Translator
		 */
		public function init( p_objMC:MovieClip, p_GameData:Object, p_Translator:Object ):void {			
			mcMeter = p_objMC;
	
			objGameData   = p_GameData;
			objTranslator = p_Translator;
			
			objCCard.init( objGameData.FG_SCRIPT_BASE, objGameData.iGameID );
			
			goTo("empty");
		}

		/**
		 * Switch to a frame in the scoring meter movieclip
		 * @param	p_sGoTo	Frame name
		 */
		public function goTo( p_sGoTo:String ):void {

			sMeterState = p_sGoTo.toUpperCase();
			//race("sMeterState: "+sMeterState);
			
			switch ( sMeterState ) {
				
				case "EMPTY":
					mcMeter.gotoAndStop("start");
					mcMeter.box.gotoAndStop("empty");
					showPopUp(false);
					break;
				case "PENDING":
					mcMeter.gotoAndStop("pending");
					mcMeter.box.gotoAndStop("idle");
					showPopUp(false);
					break;
				case "SUCCESS":
					mcMeter.gotoAndStop("success");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(true);
					break;
				case "ERROR":
					mcMeter.gotoAndStop("error");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(false);
					break;
				case "CARDWAIT":
					mcMeter.gotoAndStop("cardwait");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(false);
					break;
				case "CARDWAIT2":
					mcMeter.gotoAndStop("cardwait");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(false);
					break;
				case "CARDSUCCESS":
					mcMeter.gotoAndStop("cardsuccess");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(false);
					break;
				case "CARDERROR":
					mcMeter.gotoAndStop("carderror");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(false);
					break;
				case "CHALLENGE":
					mcMeter.gotoAndStop("challenge");
					mcMeter.box.gotoAndStop("stop");
					showPopUp(false);
					break;
				/*case "PRIZE":
					mcMeter.gotoAndStop("prize");
					mcMeter.box.gotoAndStop("extended");
					showPopUp(false);
					break;*/
			}
		}
		
		/**
		 * Meter update
		 * @param	e
		 */
		private function stateChanged( e:Event ):void {
			
			var bDone:Boolean = true;
			
			//setBG(); // make sure background is reset
			
			switch ( sMeterState ) {
				
				case "PENDING":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						mcMeter.slider.visible = false;
					} else {
						bDone = false;
					}
					break;
					
				case "SUCCESS":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2,3,4) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						setText2( aMeterText[2] );
						initScrollbar( true );
						// challenge card textfield
						if ( aMeterText[3] != "" ) {
							setText3( aMeterText[3] );
						} else {
							// center restart game text if challenge card is deactivated
							mcMeter.textbox3.x = 87;
						}
					} else {
						bDone = false;
					}
					break;
					
				case "ERROR":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2,3,4) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						setText2( aMeterText[2] );
						mcMeter.textbox3.x = 87;
						initScrollbar( true );
					} else {
						bDone = false;
					}
					break;
					
				case "CARDWAIT":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						addEventListener( "enterFrame", challengeCardReady, false, 0, true );
						
					} else {
						bDone = false;
					}
					break;
					
				case "CARDWAIT2":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						addEventListener( "enterFrame", challengeCardSent, false, 0, true );
						
					} else {
						bDone = false;
					}
					break;
					
				case "CHALLENGE":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,3,4) ) ) {
						setText0( aMeterText[0] );
						setText2( aMeterText[2] );
						setText3( aMeterText[3] );
						setCCardTextFields();
					} else {
						bDone = false;
					}
					break;
					
				case "CARDERROR":
				case "CARDSUCCESS":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2,3,4) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						setText2( aMeterText[2] );
						setText3( aMeterText[3] );
						initScrollbar( false );
					} else {
						bDone = false;
					}
					break;
					
				/*case "PRIZE":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2,3,4) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						setText2( aMeterText[2] );
						initScrollbar( true );
						showPrizes( aPrizes );
						setBG( sBGURL );
						// challenge card textfield
						if ( aMeterText[3] != "" ) {
							setText3( aMeterText[3] );
						} else {
							// center restart game text if challenge card is deactivated
							mcMeter.textbox3.x = 87;
						}
					} else {
						bDone = false;
					}
					break;*/
					
				case "RESETFIELDS":
					// make sure all objects on frame are initialized by Flash
					if ( !allObjectsInitialized( mcMeter ) ) {
						bDone = false;
					}
					else if ( setTextFields( new Array(1,2,3,4) ) ) {
						setText0( aMeterText[0] );
						setText1( aMeterText[1] );
						setText2( aMeterText[2] );
						setText3( aMeterText[3] );
						showScrollbar( bSlider );
					} else {
						bDone = false;
					}
					break;
			}
			
			if ( bDone ) {
				removeEventListener( "enterFrame", stateChanged );
			}
		}
		
		/**
		 * Challenge card info loaded
		 * @param	e
		 */
		private function challengeCardReady( e:Event ):void {
			
			if ( objCCard.profileLoaded() ) {
				
				removeEventListener( "enterFrame", challengeCardReady );
				
				gotoCCard();
			}
		}
		
		/**
		 * Challenge card info sent
		 * @param	e
		 */
		private function challengeCardSent( e:Event ):void {
			
			if ( objCCard.cardSent() ) {
				
				removeEventListener( "enterFrame", challengeCardSent );
				
				gotoCCardResult();
			}
		}
		
		/**
		 * Score has been sent, display next frame
		 * @param	p_nScore	Score to display
		 * @param	p_nNP		NP awarded
		 */
		public function scoreSent( p_nScore:Number, p_nNP:Number ):void {
			
			// just for display
			nShowScore = p_nScore;
			nShowNP    = p_nNP;
			
			goTo("pending");
			addEventListener( "enterFrame", stateChanged, false, 0, true );
			
			// score display
			showPointsText( p_nScore, p_nNP );
			
			// pending display
			t_sStr = "";
			t_sStr += objTranslator.getTranslation("IDS_SM_TAG2_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_pending");
			t_sStr += objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[1] = t_sStr;
		}
		
		/**
		 * Display the points text on the score meter
		 * @param	p_nScore		Score obtained
		 * @param	p_nNP			NP awarded
		 */
		private function showPointsText( p_nScore:Number, p_nNP:Number ):void {
			
			// score display
			var t_sStr:String = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_score") + " " + String( p_nScore );
			t_sStr += "   " + objTranslator.getTranslation("IDS_SM_npscore") + " " + String( p_nNP );
			t_sStr += objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[0] = t_sStr;
		}
		
		/**
		 * Display score script results
		 * @param	msgID					Message ID to determine if there is an error
		 * @param	p_nScore				Score obtained
		 * @param	p_nNP					NP awarded
		 * @param	sNewNP					
		 * @param	aScoreMeterVars
		 */
		public function showMsg( msgID:Number, p_nScore:Number, p_nNP:Number, sNewNP:String, aScoreMeterVars:Array ):void {
			
			// just for display
			nShowScore = p_nScore;
			nShowNP    = p_nNP;
			
			// score display
			showPointsText( p_nScore, p_nNP );
			
			var t_sCloseTag:String = "</font>";
			var t_sStr:String = "";
			
			// get the main message
			var sResult:String = getMsgResult( msgID, sNewNP );
			sResult += t_sCloseTag;
			
			var t_sRepl:String = replaceSubString( sResult, "_parent._parent.", "" );
			aMeterText[1] = replaceSubString( t_sRepl, "asfunction", "event" );
			
			// overwrite message if it was passed back
			if ( aScoreMeterVars["message"] != undefined ) {
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG2_OPEN");
				t_sStr += "<font size='14' color='#ff0000'>";
				t_sStr += unescape( aScoreMeterVars["message"] ) + t_sCloseTag;
				//
				aMeterText[1] = t_sStr;
			}
			
			// add hiscore and plays if no error occurred
			if ( msgID < 3 ) {
				// update internal game duration var
				objGameData.tLoaded = getTimer();
				t_sStr = "<br>" + objTranslator.getTranslation("IDS_SM_hiscore") + " " + String( objGameData.iHiscore );
				t_sStr += t_sCloseTag;
				t_sStr += "<br>" + objTranslator.getTranslation("IDS_SM_plays") + " " + String( objGameData.iScorePosts );
				t_sStr += t_sCloseTag;
				//
				aMeterText[1] += t_sStr;
			}
			
			aMeterText[1] += objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			
			/*// addintional message?
			var addmsg = objScoreMeterVars.IDS_MSG;
			if ( addmsg != undefined ) {
				if ( int(addmsg) == 1 ) {
					var oldCStr = cStr;
					cStr = _transLevel.IDS_SM_TAG2_OPEN + _transLevel.IDS_MESSAGE_1 + _transLevel.IDS_SM_TAG_CLOSE;
					cStr += "<br>" + oldCStr;
				}
			}*/
			
			// restart button
			t_sStr = objTranslator.getTranslation("IDS_SM_TAG3_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_restart_new");
			t_sStr += objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			t_sRepl = replaceSubString( t_sStr, "_parent._parent.", "" );
			aMeterText[2] = replaceSubString( t_sRepl, "asfunction", "event" );
			
			
			// ------------------------------------------------------------------------------------------------------
			// Challenge Card Code
			aMeterText[3] = "";
			if ( objGameData.iChallengeCard == 1 ) {
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG3_OPEN");
				t_sStr += objTranslator.getTranslation("IDS_SM_challengecard");
				t_sStr += objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				var t_sRepl2:String = replaceSubString( t_sStr, "_parent._parent.", "" );
				aMeterText[3] = replaceSubString( t_sRepl2, "asfunction", "event" );
			}
			// ------------------------------------------------------------------------------------------------------
			
			//if(aScoreMeterVars["gp_bg_img"] != undefined) sBGURL = aScoreMeterVars["gp_bg_img"];
			//else sBGURL = null;
			
			//while(aPrizes.length > 0) aPrizes.pop(); // clear previous prizes

			if ( msgID > 2 ) {
				/*switch(msgID) {
					case 32: // one prize awarded
						sLastMarker = "prize";
						if(aScoreMeterVars["gp_img_1"] != undefined) aPrizes.push(aScoreMeterVars["gp_img_1"]);
						break;
					case 31: // two prizes awarded
						sLastMarker = "prize";
						if(aScoreMeterVars["gp_img_1"] != undefined) aPrizes.push(aScoreMeterVars["gp_img_1"]);
						if(aScoreMeterVars["gp_img_2"] != undefined) aPrizes.push(aScoreMeterVars["gp_img_2"]);
						break;
					default: sLastMarker = "error";
				}*/
				sLastMarker = "error";
			} else sLastMarker = "success";
			
			// Check for a prize popup message
			if(aScoreMeterVars["messageCode"] != null) loadMessage(aScoreMeterVars["messageCode"]);
			else loadMessage(null);
			
			goTo( sLastMarker );
			addEventListener( "enterFrame", stateChanged, false, 0, true );
		}
		
		/**
		 * Display a result message for the black box
		 * @param	msgID		ID of the message to be displayed
		 * @param	sNewNP		NP obtained
		 * @return					The new resulting/combined string
		 */
		public function getMsgResult( msgID:Number, sNewNP:String ):String {

			var t_sResult:String = objTranslator.getTranslation("IDS_SM_TAG2_OPEN");
			
			switch ( msgID )
			{
				case 1:
					t_sResult += objTranslator.getTranslation("IDS_SM_success") + " " + sNewNP;
					break;
					
				case 2:
					t_sResult += objTranslator.getTranslation("IDS_SM_bonus") + " " + sNewNP;
					break;
					
				case 3:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_MAXPLAYS");
					break;
					
				case 4:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_ZEROSCORE");
					break;
					
				case 5:
					t_sResult += "<font size='14' color='#ff0000'>D'oh...<br>Can't send score in<br>Offline Mode!</font>";
					//objTranslator.getTranslation("IDS_SM_ERR_UNKNOWN");
					break;
					
				case 6:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_INVALID");
					break;
					
				case 7:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_TIMEOUT");
					break;
					
				case 8:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_NOLOGIN");
					break;
					
				case 9:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_CHALLENGE");
					break;
					
				case 10:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_COOKIE");
					break;
					
				case 11:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_NOCHALL");
					break;
					
				case 12:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_CHALLSLOW");
					break;
					
				case 13:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_DC_COMP");
					break;
					
				case 14:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_DC_TIME");
					break;
					
				case 15:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_REVIEW");
					break;
					
				case 16:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_QUICK_SESSION");
					break;
					
				case 17:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_MISSING_HASH");
					break;
					
				case 18:
					t_sResult += objTranslator.getTranslation("IDS_SM_ERR_WC_TOO_LOW");
					break;
					
				case 19:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_SUCCESS");
					break;
					
				case 20:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_NOSUCCESS");
					break;
					
				case 21:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_MAX");
					break;
					
				case 22:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_BEAT_AAA");
					break;
					
				case 23:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_BEAT_ABIGAIL");
					break;
					
				case 24:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_BEAT_DOUBLE");
					break;
					
				case 25:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_BEAT_LULU");
					break;
					
				case 26:
					t_sResult += objTranslator.getTranslation("IDS_SM_AC_MAX_SCORE");
					break;
					
				case 27:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_NC_BEAT_LULU");
					break;
					
				case 28:
					t_sResult += objTranslator.getTranslation("IDS_SM_DD_NC_LOST_LULU");
					break;
			}
			
			return ( t_sResult );
		}
			
		/**
		 * Assigning text to all listed textfields
		 * @param	p_aFields	Array of textfields to populate
		 * @return					True if the process is completed successfully
		 */
		public function setTextFields( p_aFields:Array ):Boolean {
			
			var bOK:Boolean = true;
			
			for ( var i:Number=0; i<p_aFields.length; i++ ) {
				
				if ( mcMeter["textbox"+String(p_aFields[i])] != undefined ) {
					
					if ( mcMeter["textbox"+String(p_aFields[i])] != null ) {
						objTranslator.setTextField( mcMeter["textbox"+String(p_aFields[i])].text1, "" );
					} else {
						bOK = false;
					}
					
				} else {
					bOK = false;
				}
			}
			
			return ( bOK );
		}
		
		/**
		 * Set text to textbox0
		 * @param	p_sStr string to assign
		 */
		private function setText0( p_sStr:String ):void {
			var sT:String = replaceSubString( p_sStr, "face='customFSS_fnt' ", "" );
			if ( mcMeter.textbox1 != undefined ) {
				mcMeter.textbox1.text1.htmlText = sT;
				//race("\n"+mcMeter.textbox1.text1.htmlText);
			}
		}
		/**
		 * Set text to textbox1
		 * @param	p_sStr string to assign
		 */
		private function setText1( p_sStr:String ):void {
			var sT:String = replaceSubString( p_sStr, "face='customFSS_fnt' ", "" );
			if ( mcMeter.textbox2 != undefined ) {
				mcMeter.textbox2.text1.htmlText = sT;
				//race("\n"+mcMeter.textbox2.text1.htmlText);
			}
		}
		/**
		 * Set text to textbox2
		 * @param	p_sStr string to assign
		 */
		private function setText2( p_sStr:String ):void {
			var sT:String = replaceSubString( p_sStr, "face='customFSS_fnt' ", "" );
			if ( mcMeter.textbox3 != undefined ) {
				mcMeter.textbox3.text1.htmlText = sT;
				//race("\n"+mcMeter.textbox3.text1.htmlText);
			}
		}
		/**
		 * Set text to textbox3
		 * @param	p_sStr string to assign
		 */
		private function setText3( p_sStr:String ):void {
			var sT:String = replaceSubString( p_sStr, "face='customFSS_fnt' ", "" );
			if ( mcMeter.textbox4 != undefined ) {
				mcMeter.textbox4.text1.htmlText = sT;
				//race("\n"+mcMeter.textbox4.text1.htmlText);
			}
		}
		
		// -------------------------------------------------------------------
		// SHOW PRIZES
		// -------------------------------------------------------------------
		
		/*private function showPrizes(list:Array):void {
			if(mcMeter.prizes != undefined) {
				mcMeter.prizes.hideBounds();
				mcMeter.prizes.clearIcons();
				for(var i:int = 0; i < list.length; i++) {
					mcMeter.prizes.loadIconFrom(unescape(list[i]));
				}
			}
		}*/
		
		// -------------------------------------------------------------------
		// SET BACKGOUND IMAGE
		// -------------------------------------------------------------------
		
		/*private function setBG(path:String=null):void {
			if(mcMeter.box != undefined) {
				// remove previous background
				if(ldrBGLoader != null) {
					mcMeter.removeChild(ldrBGLoader);
					ldrBGLoader = null;
				}
				mcMeter.box.visible = true; // show basic box by default
				if(path != null) {
					ldrBGLoader = new Loader(); // create a loader
					// place it on top of the blank background
					var i:int = mcMeter.getChildIndex(mcMeter.box);
					mcMeter.addChildAt(ldrBGLoader,i);
					// start loading the background image
					ldrBGLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBGLoaded);
					var req:URLRequest = new URLRequest(unescape(path));
					ldrBGLoader.load(req);
				}
			}
		}
		
		private function onBGLoaded(ev:Event) {
			if(ldrBGLoader != null) {
				// try to center the background
				ldrBGLoader.x = (mcMeter.box.width - ldrBGLoader.width) / 2;
				ldrBGLoader.y = (mcMeter.box.height - ldrBGLoader.height) / 2;
				mcMeter.box.visible = false; // hide the blank background
			}
		}*/
		
		// -------------------------------------------------------------------
		// PRIZE POP UP FUNCTIONS
		// -------------------------------------------------------------------

		/**
		 * Loads a prize message
		 * @param	code		Prize code
		 */
		private function loadMessage(code:String):void {
			// clear the previous prize pop up
			if(mcPrizes != null) {
				mcMeter.removeChild(mcPrizes);
				mcPrizes = null;
			}
			// create the new pop up if we have a valid code
			if(code != null) {
				// add the pop-up to the game
				//mcPrizes = new mcPrizePopUp(); //-- commented for ASDocs
				var PrizePopupClass:Class = ApplicationDomain.currentDomain.getDefinition("mcPrizePopUp") as Class;
				mcPrizes = new PrizePopupClass();
				
				mcMeter.addChild(mcPrizes);
				// set the pop-up's parameters
				mcPrizes.language = objGameData.sLang;
				mcPrizes.gatewayURL = "http://" + objGameData.sBaseURL + "/amfphp/gateway.php";
				// push our current text into the pop up
				if(aMeterText != null) {
					if(aMeterText.length > 0) {
						// add single line entries
						var limit:int = Math.min(2,aMeterText.length);
						for(var i:int = 0; i < limit; i++) mcPrizes.addText(aMeterText[i]);
						// add the last few entries as a single row
						if(aMeterText.length > 2) mcPrizes.addTextRow(aMeterText.slice(2));
					}
				}
				// have the pop up load it's message from php
				var msg_num:int = int(Number(code));
				if(isNaN(msg_num) == false) {
					mcPrizes.loadMessage(objGameData.iGameID,nShowScore,msg_num,objGameData.iScorePosts);
				}
				// off-set the pop-up to ensure it shows up at our parent's origin.
				mcPrizes.x = -mcMeter.x;
				mcPrizes.y = -mcMeter.y;
				// center the pop-up
				mcPrizes.x += (objGameData.iGameWidth - mcPrizes.width) / 2;
				mcPrizes.y += (objGameData.iGameHeight - mcPrizes.height) / 2;
			}
		}
		
		/**
		 * Displays the prize pop up
		 * @param	b	To display, set to true
		 */
		private function showPopUp(b:Boolean=true):void {
			if(mcPrizes != null) mcPrizes.visible = b;
		}
		
		/**
		 * Replaces a substring with another
		 * @param	p_sString			String to edit
		 * @param	p_sRemove		Substring to replace
		 * @param	p_sReplace		New string to replace the removed substring
		 * @return							The new final string
		 */
		private function replaceSubString( p_sString:String, p_sRemove:String, p_sReplace:String ):String {	
			var sReturn:String = p_sString;
			while ( p_sString.indexOf(p_sRemove,0) >= 0 ) {
				sReturn = p_sString.replace( p_sRemove, p_sReplace );
				p_sString = sReturn;
			}
			
			return ( sReturn );
		}
		
		/**
		 * Creates and initializes the scrollbar for the black score meter
		 * @param	p_bRememberSetting		True if we need to remember the visibility of the scrollbar
		 */
		private function initScrollbar( p_bRememberSetting:Boolean ):void {
			
			if ( mcMeter.textbox2.text1.numLines >= 5 ) {
				
				mcMeter.slider.visible = true;
				mcMeter.slider.alpha = 100; 
				if ( !mcMeter.slider.mcBall.hasEventListener( MouseEvent.MOUSE_DOWN ) ) {
					mcMeter.slider.mcBall.addEventListener( MouseEvent.MOUSE_DOWN, scrollBarActive,   false, 0, true   );
					mcMeter.slider.mcBall.addEventListener( MouseEvent.MOUSE_UP,   scrollBarInactive, false, 0, true );
					mcMeter.slider.mcBall.addEventListener( MouseEvent.MOUSE_OUT,  scrollBarInactive, false, 0, true );
					mcMeter.slider.mcBall.addEventListener( MouseEvent.MOUSE_MOVE, scrollBarChange,   false, 0, true   );
				}
				
			} else mcMeter.slider.visible = false;
			
			if ( p_bRememberSetting ) {
				bSlider = mcMeter.slider.visible;
			}
		}

		/**
		 * Scrollbar function
		 * @param	e
		 */
		private function scrollBarActive( e:MouseEvent ):void {
			bSliderActive = true;	
		}
		/**
		 * Scrollbar function
		 * @param	e
		 */
		private function scrollBarInactive( e:MouseEvent):void {
			bSliderActive = false;	
		}
		/**
		 * Scrollbar function
		 * @param	e
		 */
		private function scrollBarChange( e:MouseEvent):void {

			if ( !bSliderActive ) return;
			
			if ( mcMeter.slider.mouseY < 4 ) mcMeter.slider.mcBall.y = 4;
			else if ( mcMeter.slider.mouseY > 46 ) mcMeter.slider.mcBall.y = 46;
			else mcMeter.slider.mcBall.y = mcMeter.slider.mouseY;
			
			var p:Number = int( (mcMeter.slider.mcBall.y-4) / (42/100) );
			mcMeter.textbox2.text1.scrollV = Math.round(( mcMeter.textbox2.text1.numLines / 100 ) * p);
		}

		/**
		 * Remove all scrollbar listeners
		 */
		public function removeListeners():void {
			
			if ( mcMeter.slider == undefined ) return;
			
			if ( mcMeter.slider.mcBall.hasEventListener( MouseEvent.MOUSE_DOWN ) ) {
				mcMeter.slider.mcBall.removeEventListener( MouseEvent.MOUSE_DOWN, scrollBarActive   );
				mcMeter.slider.mcBall.removeEventListener( MouseEvent.MOUSE_UP,   scrollBarInactive );
				mcMeter.slider.mcBall.removeEventListener( MouseEvent.MOUSE_OUT,  scrollBarInactive );
				mcMeter.slider.mcBall.removeEventListener( MouseEvent.MOUSE_MOVE, scrollBarChange   );
			}
		}		
		
		/**
		 * Displays the scrollbar
		 * @param	p_bShow		Set True to show
		 */
		private function showScrollbar( p_bShow:Boolean ):void {
		
			if ( mcMeter.slider != undefined ) {
				mcMeter.slider.visible = p_bShow;
				if ( p_bShow ) mcMeter.slider.alpha = 100;
			}
		}
		
		/**
		 * Displays the challenge card
		 */
		public function showCCard():void {
			
			// save current scoring meter text
			if ( aSaveTextVars.length == 0 ) {
			
				aSaveTextVars = new Array("","","","");
			
				if ( mcMeter.textbox1 != undefined ) aSaveTextVars[0] = mcMeter.textbox1.text1.htmlText;
				if ( mcMeter.textbox2 != undefined ) aSaveTextVars[1] = mcMeter.textbox2.text1.htmlText;
				if ( mcMeter.textbox3 != undefined ) aSaveTextVars[2] = mcMeter.textbox3.text1.htmlText;
				if ( mcMeter.textbox4 != undefined ) aSaveTextVars[3] = mcMeter.textbox4.text1.htmlText;

				if ( mcMeter.slider != undefined ) mcMeter.slider.visible = false;
			}
			
			// set text fields
			var t_sStr:String = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_sendacard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[0] = t_sStr;
			
			t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_preparecard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[1] = t_sStr;

			// now load user info			
			objCCard.loadUserInfo();
			
			goTo("cardwait");
			addEventListener( "enterFrame", stateChanged, false, 0, true );
		}
		
		/**
		 * Go to the challenge card form when user profile is loaded
		 */
		public function gotoCCard():void {
			
			// set text fields
			var t_sStr:String = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_sendacard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[0] = t_sStr;
			
			t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_submitcard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			var t_sRepl:String = replaceSubString( t_sStr, "_parent._parent.", "" );
			aMeterText[2] = replaceSubString( t_sRepl, "asfunction", "event" );
			
			t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_cancelcard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			t_sRepl = replaceSubString( t_sStr, "_parent._parent.", "" );
			aMeterText[3] = replaceSubString( t_sRepl, "asfunction", "event" );
						
			goTo("challenge");
			addEventListener( "enterFrame", stateChanged, false, 0, true );
		}
		
		/**
		 * Cancels and removes the challenge card form
		 */
		public function cancelCCard():void {

			for ( var i:int=0; i<aSaveTextVars.length; i++ ) {
				aMeterText[i] = aSaveTextVars[i];
				//race("aSaveTextVar "+i+": "+aMeterText[i].substr(0,10)+"...");
				//aSaveTextVars[i] = "";
			}
			
			goTo( sLastMarker );
			sMeterState = "RESETFIELDS";
			addEventListener( "enterFrame", stateChanged, false, 0, true );
		}
		
		/**
		 * Submits the challenge card
		 */
		public function submitCCard():void {
			
			aSaveInputVars = new Array();
			aSaveInputVars.push( mcMeter.input1.text );
			aSaveInputVars.push( mcMeter.input2.text );
			aSaveInputVars.push( mcMeter.input3.text );
			aSaveInputVars.push( mcMeter.input4.text );
			
			objCCard.sendCCard( mcMeter.input1.text, mcMeter.input2.text,
							   mcMeter.input3.text, mcMeter.input4.text,
							   nShowScore );
			
			// set text fields
			var t_sStr:String = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_sendacard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[0] = t_sStr;
			
			t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_sendingcard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[1] = t_sStr;
			
			goTo("cardwait2");
			addEventListener( "enterFrame", stateChanged, false, 0, true );
		}
		
		/**
		 * Displays the challenge card send result
		 */
		private function gotoCCardResult():void {
			
			var sError:String = unescapeMultiByte( objCCard.getErrorMsg() );
			var sSuccess:String = unescapeMultiByte( objCCard.getSuccessMsg() );

			var t_sRepl:String;
			var t_sStr:String
			
			// set text fields
			t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
			t_sStr += objTranslator.getTranslation("IDS_SM_sendacard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
			aMeterText[0] = t_sStr;
			
			// debug
			//sError = "";
			//sSuccess = "Coolio%2C+but+you+have+already+sent+the+maximum+allowed+emails+for+today+but+you+have+already+sent+the+maximum+allowed+emails+for+today+but+you+have+already+sent+the+maximum+allowed+emails+for+today";
			
			if ( sError != "" ) {
				
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
				t_sStr += replaceSubString( sError, "+", " " ) + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				aMeterText[1] = t_sStr;
				
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
				t_sStr += objTranslator.getTranslation("IDS_SM_cardreturn") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				t_sRepl = replaceSubString( t_sStr, "_parent._parent.", "" );
				aMeterText[2] = replaceSubString( t_sRepl, "asfunction", "event" );
				
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
				t_sStr += objTranslator.getTranslation("IDS_SM_cancelcard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				t_sRepl = replaceSubString( t_sStr, "_parent._parent.", "" );
				aMeterText[3] = replaceSubString( t_sRepl, "asfunction", "event" );
				
				goTo("carderror");
			}
			else {
				
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
				t_sStr += replaceSubString( sSuccess, "+", " " ) + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				aMeterText[1] = t_sStr;
				
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
				t_sStr += objTranslator.getTranslation("IDS_SM_mainreturn") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				t_sRepl = replaceSubString( t_sStr, "_parent._parent.", "" );
				aMeterText[2] = replaceSubString( t_sRepl, "asfunction", "event" );
				
				t_sStr = objTranslator.getTranslation("IDS_SM_TAG1_OPEN");
				t_sStr += objTranslator.getTranslation("IDS_SM_anothercard") + objTranslator.getTranslation("IDS_SM_TAG_CLOSE");
				t_sRepl = replaceSubString( t_sStr, "_parent._parent.", "" );
				aMeterText[3] = replaceSubString( t_sRepl, "asfunction", "event" );
				
				goTo("cardsuccess");
			}
			
			addEventListener( "enterFrame", stateChanged, false, 0, true );
		}
		
		/**
		 * Set Challenge Card textfield properties and text
		 */
		private function setCCardTextFields():void {
			
			for ( var i:int=1; i<=4; i++ ) {
				mcMeter["input"+String(i)].text = "";
			}
			
			if ( aSaveInputVars.length > 0 ) {
				mcMeter.input1.text = aSaveInputVars[0];
				mcMeter.input2.text = aSaveInputVars[1];
			} else {
				mcMeter.input1.text = objCCard.getUsername();
				mcMeter.input2.text = objCCard.getUserEmail();
			}
			
			// set text fields
			var t_sStr:String = objTranslator.getTranslation("IDS_SM_CCARD_NAME1");
			var sT:String = replaceSubString( t_sStr, "face='customFSS_fnt' ", "" );
			objTranslator.setTextField( mcMeter.textbox2_1.text1, sT );
			
			t_sStr = objTranslator.getTranslation("IDS_SM_CCARD_EMAIL1");
			sT = replaceSubString( t_sStr, "face='customFSS_fnt' ", "" );
			objTranslator.setTextField( mcMeter.textbox2_2.text1, sT );

			t_sStr = objTranslator.getTranslation("IDS_SM_CCARD_NAME2");
			sT = replaceSubString( t_sStr, "face='customFSS_fnt' ", "" );
			objTranslator.setTextField( mcMeter.textbox2_3.text1, sT );

			t_sStr = objTranslator.getTranslation("IDS_SM_CCARD_EMAIL2");
			sT = replaceSubString( t_sStr, "face='customFSS_fnt' ", "" );
			objTranslator.setTextField( mcMeter.textbox2_4.text1, sT );
			
			// hide user email field if age < 13
			if ( objGameData.iAge13 != 1 ) {
				mcMeter.textbox2_1.visible = false;
				mcMeter.input1.visible = false;
				mcMeter.textbox2_2.visible = false;
				mcMeter.input2.visible = false;
				// re-position other fields
				mcMeter.textbox2_3.y = 39;
				mcMeter.input3.y = 39;
				mcMeter.textbox2_4.y = 57;
				mcMeter.input4.y = 57;
			}
		}
		
		/**
		 * Polls and checks if all display children are initialized
		 * @param	p_MC	The display object whos children are to be checked
		 * @return
		 */
		private function allObjectsInitialized( p_MC:Object ):Boolean {
			
			var bOK:Boolean = true;
			
			for ( var i:Number=0; i<p_MC.numChildren; i++ ) {
				if ( p_MC.getChildAt(i) == null ) {
					bOK = false;
				}
			}
			
			return ( bOK );
		}
	}
}
