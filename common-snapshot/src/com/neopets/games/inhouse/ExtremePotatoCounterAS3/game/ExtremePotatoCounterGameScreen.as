
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.ExtremePotatoCounterAS3.game
{
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.managers.FocusManager;
	import flash.utils.getTimer;
	
	import com.neopets.util.sound.SoundManager;
	import com.neopets.util.general.GeneralFunctions;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.events.CustomEvent;
	
	// negg quest imports
	import com.neopets.util.flashvars.FlashVarsFinder;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	import flash.external.ExternalInterface;
	
	/**
	 *	This is a Simple Menu for the InGame Sceen
	 *	The Button Click Commands are not handled at this level but at the Insatiation of this Class.
	 *	Most code from the original flash 6 game is imported here.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  1.04.2010
	 */
	 
	public class ExtremePotatoCounterGameScreen extends GameScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const LEVEL_SOUND:String = "levelsound";
		public static const GUESS_SOUND:String = "guesssound";
		public static const BUZZER_SOUND:String = "buzzersound";
		public static const WARNING_SOUND:String = "warningsound";
		public static const WIN_SOUND:String = "winsound";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// These variables and their names are imported from the flash 6 version of the game
		public var xxx:Number;
		public var aPlacement:Array;
		public var aAdjSpeeds:Array;
		public var noMusic:int; //  Music sorta-global.
		public var aRotSpeeds:Array;
		public var aScales:Array;
		public var aSpawnTimer:Array;
		public var msgCount:Number;
		public var aEKZ:Array;
		public var aKartoffeln:Array;
		public var roundActive:int;
		public var timerText:String;
		public var endLevelPrompt:String;
		public var radicalPrompt:String;
		// variables from game over screen in flash 6
		public var displayFinalScoreTextField:String;
		// new protected variables
		protected var _enterFrameFunction:Function;
		protected var focusManager:FocusManager;
		// new public variables
		public var gamingSystem:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ExtremePotatoCounterGameScreen():void
		{
			super();
			// inherited from base class
			//quitGameButton.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "GameScene";
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		// This accessor mimics the outdated onEnterFrame call in flash 6
		
		public function get enterFrameFunction():Function { return _enterFrameFunction; }
		
		public function set enterFrameFunction(func:Function) {
			if(_enterFrameFunction != func) {
				// clear previous function
				if(_enterFrameFunction != null) {
					removeEventListener(Event.ENTER_FRAME,_enterFrameFunction);
				}
				// set new function
				_enterFrameFunction = func;
				if(_enterFrameFunction != null) {
					addEventListener(Event.ENTER_FRAME,_enterFrameFunction,false,0,true);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Imported functions from flash 6 version
		 */
		 
		public function attachKartoffel():void {
			var randPlace = Math.floor(Math.random()*4);
			
			// spawn position
			var randPotX = r2d2( aPlacement[randPlace][0], aPlacement[randPlace][1] );
			var randPotY = r2d2( aPlacement[randPlace][2], aPlacement[randPlace][3] );
			var randPotXSpeed = 0;
			var randPotYSpeed = 0;
			
			// speeds
			if ( randPlace == 0 ) {
				// TOP SPAWN - NOT USED
				randPotXSpeed = r2d2( (aAdjSpeeds[0]/aEKZ[0]) - ((aAdjSpeeds[0]/aEKZ[0]) / 1.5), (aAdjSpeeds[1]/aEKZ[0]) - ((aAdjSpeeds[1]/aEKZ[0]) / 1.5)) * r2d2(-1, 1);
				randPotYSpeed = r2d2( (aAdjSpeeds[2]/aEKZ[0]), (aAdjSpeeds[3]/aEKZ[0]));
			}
			else if ( randPlace == 1 ) {
				//  RIGHT SPAWN
				randPotXSpeed = r2d2( (aAdjSpeeds[0]/aEKZ[0]), (aAdjSpeeds[1]/aEKZ[0])) * -1;
				randPotYSpeed = r2d2( (aAdjSpeeds[2]/aEKZ[0]) - ((aAdjSpeeds[2]/aEKZ[0]) / 1.5), (aAdjSpeeds[3]/aEKZ[0]) - ((aAdjSpeeds[3]/aEKZ[0]) / 1.5)) * r2d2(-1, 1);
			}
			else if ( randPlace == 2 ) {
				//  BOTTOM SPAWN
				randPotXSpeed = r2d2( (aAdjSpeeds[0]/aEKZ[0]) - ((aAdjSpeeds[0]/aEKZ[0]) / 1.5), (aAdjSpeeds[1]/aEKZ[0]) - ((aAdjSpeeds[1]/aEKZ[0]) / 1.5)) * r2d2(-1, 1);
				randPotYSpeed = r2d2( (aAdjSpeeds[2]/aEKZ[0]), (aAdjSpeeds[3]/aEKZ[0])) * -1;
			}
			else {
				//  LEFT SPAWN
				randPotXSpeed = r2d2( (aAdjSpeeds[0]/aEKZ[0]), (aAdjSpeeds[1]/aEKZ[0]));
				randPotYSpeed = r2d2( (aAdjSpeeds[2]/aEKZ[0]) - ((aAdjSpeeds[2]/aEKZ[0]) / 1.5), (aAdjSpeeds[3]/aEKZ[0]) - ((aAdjSpeeds[3]/aEKZ[0]) / 1.5)) * r2d2(-1, 1);
			}
		
			// random scale and rotation speed
			var randRotSpeed = r2d2( aRotSpeeds[0], aRotSpeeds[1] );
			var randPotScale = r2d2( aScales[0], aScales[1] ) / 100; // adjust to 0 to 1 scale from 100 point scale
		
			// increment object counter - also used as mc depth
			aEKZ[4]+=aEKZ[0];
			var cPotName:String = "p"+(aEKZ[4]/aEKZ[0]);
		
			// get mc linkage name
			var cPotMC = getKartoffel();
			// original flash 6 code
			//_root.attachMovie( cPotMC, cPotName, (aEKZ[4]/aEKZ[0]), {_x:randPotX, _y:randPotY, _xscale:randPotScale, _yscale:randPotScale, Xspeed:randPotXSpeed, Yspeed:randPotYSpeed, rotationSpeed:randRotSpeed});
			// updated flash 9 code
			var inst:Object = GeneralFunctions.getInstanceOf(cPotMC);
			if(inst != null && inst is MovieClip) {
				// set clip properties
				var clip:MovieClip = inst as MovieClip;
				clip.name = cPotName;
				clip.x = randPotX;
				clip.y = randPotY;
				clip.scaleX = randPotScale;
				clip.scaleY = randPotScale;
				clip.Xspeed = randPotXSpeed;
				clip.Yspeed = randPotYSpeed;
				clip.rotationSpeed = randRotSpeed;
				// add clip to stage
				addChild(clip);
			}
			// Put that attachment out here, set the variables in the case statment...
			aKartoffeln.push( cPotName );
		}
		
		public function awardPoints():void {
			// update score
			var score:ScoreManager = ScoreManager.instance;
			score.changeScore(aEKZ[2]/aEKZ[0]);
			// go to new frame
			gotoAndPlay("endRoundCorrect");
		}
		
		public function beginRound():void
		{
			// stop sounds
			var sounds:SoundManager = SoundManager.instance;
			sounds.stopAllCurrentSounds();
			// adapted flash 6 code
			roundPreProcess();
			enterFrameFunction = update;
		}
		
		public function checkTime(ev:Event=null):void {
			var sounds:SoundManager = SoundManager.instance;
			var t = getTimer();
			if ( t > aEKZ[8] ) {
				sounds.soundPlay(BUZZER_SOUND);
				enterFrameFunction = null;
				endGame();
			}
			else if ( t > aEKZ[9] ) {
				var translator:TranslationManager = TranslationManager.instance;
				if ( msgCount == 0 ) timerText = translator.getTranslationOf("IDS_HURRY");
				else if ( msgCount == 1 ) timerText = translator.getTranslationOf("IDS_SERIOUS");
				var clip:MovieClip = getChildByName("mcHowMany") as MovieClip;
				if(clip != null) {
					clip.howmany1.howmanywhite_txt.htmlText = timerText;
					clip.howmany2.howmanywhite_txt.htmlText = timerText;
				}
				msgCount++;
				aEKZ[9] += 5000;
			}
			
			if ( t > aEKZ[10] ) {
				sounds.soundPlay(WARNING_SOUND);
				aEKZ[10] += 1000;
			}
		}
		
		public function compareAnswer():void {
			// stop sound
			if(!noMusic) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.stopSound(GUESS_SOUND);
			}
			// get guess
			var txt:TextField = getChildByName("box") as TextField;
			if(txt != null) {
				var val:Number = Number(txt.text);
				if(!isNaN(val)) {
					// modified to support Festival of the Neggs
					var t_val:Number = aEKZ[2]/aEKZ[0];
					if(val == t_val) guessCorrect();
					else guessIncorrect();
					// check for Negg quest formula
					if(val == (t_val - 4)*3) checkNeggQuest();
				} else guessIncorrect();
			}
		}
		
		public function endGame():void {
			// clear listeners
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyPress);
			// store correct answer
			displayFinalScoreTextField = String(aEKZ[3]/aEKZ[0]);
			// make menu navigation call
			var menus:MenuManager = MenuManager.instance;
			menus.menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
		}
		
		public function endRound():void {
			var sounds:SoundManager = SoundManager.instance;
			sounds.stopSound(LEVEL_SOUND);
			guessMusic();
			var translator:TranslationManager = TranslationManager.instance;;
			timerText = translator.getTranslationOf("IDS_HOWMANY");
			enterFrameFunction = null;
			gotoAndPlay("endRoundframe");
		}
		
		public function getKartoffel():String {
			var cPot = "";
			
			var rnd = (aEKZ[1]/aEKZ[0]);
		
			if ( rnd >= 3 ) {
				var potPerc = r2d2(1,100);
				if ( potPerc <= aEKZ[7] ) {
					cPot = VeggieChoice();
				} else {
					cPot = KartoffelChoice();
				}
			} else {
				cPot = KartoffelChoice();
			}
			
			return ( cPot );
		}
		
		public function guessCorrect():void {
			victoryMusic();
			awardPoints();
		}
		
		public function guessIncorrect():void {
			var sounds:SoundManager = SoundManager.instance;
			sounds.stopAllCurrentSounds();
			sounds.soundPlay(BUZZER_SOUND);
			endGame();
		}
		
		public function guessMusic():void {
			if(!noMusic) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(GUESS_SOUND,true);
				sounds.changeSoundVolume(GUESS_SOUND,0.4);
			}
		}
		
		public function initUserInput():void {
			// debug start
			// trace( "potatoes: "+(aEKZ[2]/aEKZ[0]) );
			// _root.box.text = String( (aEKZ[2]/aEKZ[0]) );
			// debug end
		
			// user has 10 seconds to enter correct number
			var t = getTimer();
			aEKZ[8]  = t + 15000;
			aEKZ[9]  = t + 5000;
			aEKZ[10] = t + 1000;
			msgCount = 0;
			enterFrameFunction = checkTime;
		
			//create listeners
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyPress);
			
			// set up submit button
			var btn:SimpleButton = getChildByName("submitButton") as SimpleButton;
			if(btn != null) btn.addEventListener(MouseEvent.CLICK,userSubmitted);
			
			// set focus on text box
			var txt:TextField = getChildByName("box") as TextField;
			if(txt != null) {
				if(focusManager == null) focusManager = new FocusManager(this);
				focusManager.setFocus(txt);
			}
		}
		
		public function KartoffelChoice():String {
			var cPot = "";
			
			// 1-4 potatos
			cPot = "xls"+r2d2(1, 4);
			aEKZ[3] += aEKZ[0]; // increment _root.numberOfPotatoesThrown
			
			return ( cPot );
		}
		
		public function levelMusic():void {
			if(!noMusic) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(LEVEL_SOUND,true);
				sounds.changeSoundVolume(LEVEL_SOUND,0.4);
			}
		}
		
		public function levelPromptUpdates():void {
			// set up score text
			var translator:TranslationManager = TranslationManager.instance;;
			endLevelPrompt = translator.getTranslationOf("IDS_YOUWONPOINTSSALL");
			if(endLevelPrompt != null) {
				endLevelPrompt = endLevelPrompt.replace("%1",aEKZ[2]/aEKZ[0]);
				var score:ScoreManager = ScoreManager.instance;
				endLevelPrompt = endLevelPrompt.replace("%2",score.getValue());
			}
			
			// reached last round (15)
			if ( aEKZ[5] != 0 ) {
				radicalPrompt = translator.getTranslationOf("IDS_GAMEBEAT");
				// set up buttons
				var btn_clip:MovieClip = getChildByName("butNextRound") as MovieClip;
				if(btn_clip != null) {
					btn_clip.x = 1000;
					btn_clip.visible = false; // just in case ;)
				}
				btn_clip = getChildByName("butNextRound") as MovieClip;
				if(btn_clip != null) {
					btn_clip.x = 350;
				}
			}
			else
			{
				var randomPhrase = r2d2(1, 12);
				switch (randomPhrase)
				{
					case 1 :
						radicalPrompt = translator.getTranslationOf("IDS_AWESOME");
						break;
					case 2 :
						radicalPrompt = translator.getTranslationOf("IDS_RADICAL");
						break;
					case 3 :
						radicalPrompt = translator.getTranslationOf("IDS_TUBULAR");
						break;
					case 4 :
						radicalPrompt = translator.getTranslationOf("IDS_DUDICAL");
						break;
					case 5 :
						radicalPrompt = translator.getTranslationOf("IDS_GNARLY");
						break;
					case 6 :
						radicalPrompt = translator.getTranslationOf("IDS_OHSNAP");
						break;
					case 7 :
						radicalPrompt = translator.getTranslationOf("IDS_SHEBANG");
						break;
					case 8 :
						radicalPrompt = translator.getTranslationOf("IDS_FAROUT");
						break;
					case 9 :
						radicalPrompt = translator.getTranslationOf("IDS_EXTREME");
						break;
					case 10 :
						radicalPrompt = translator.getTranslationOf("IDS_WHOSBAD");
						break;
					case 11 :
						radicalPrompt = translator.getTranslationOf("IDS_HAYOOO");
						break;
					case 12 :
						radicalPrompt = translator.getTranslationOf("IDS_YEAHHUH");
						break;
					default :
						radicalPrompt = translator.getTranslationOf("IDS_RADICAL");
						break;
				}
			}
		}
		
		public function newKartoffel():void {
			var t = getTimer();
			var iElapsed = t - aSpawnTimer[0];
			if ( iElapsed >= aSpawnTimer[1] ) {
				attachKartoffel();
				aSpawnTimer[0] = t;
				aSpawnTimer[1] = r2d2( aSpawnTimer[3], aSpawnTimer[4] );
			}
		}
		
		public function nextRound(ev:Event=null) {
			// make sure game is not over - 15 rounds
			if ( aEKZ[5] == 0 ) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.stopAllCurrentSounds();
				gotoAndPlay("roundframe");
			} else {
				//_root.sendScoreButton();
			}
		}
		
		public function r2d2(mV,mV2):Number {
			return ( mV+Math.floor(Math.random()*(mV2+1-mV)));
		}
		
		public function roundPreProcess():void {
			//noMusic = 1;
			levelMusic();
			// reset potatoname incrementer :)
			aEKZ[4] = 0;
			// increment round
			aEKZ[1] += aEKZ[0];
			var rnd:Number = aEKZ[1]/aEKZ[0];
			// NeoStatus
			if(gamingSystem != null) gamingSystem.sendTag("Reached Level "+rnd);
			// set number of possible objects for this round
			aEKZ[6] = (3+(Math.ceil(rnd/2))) * aEKZ[0];
			// potato speed adjustments
			aAdjSpeeds[0] = aEKZ[0] * (11+rnd);
			aAdjSpeeds[1] = aEKZ[0] * (10+(rnd*3));
			aAdjSpeeds[2] = aEKZ[0] * (11+rnd);
			aAdjSpeeds[3] = aEKZ[0] * (10+(rnd*3));
			
			// other vars
			roundActive = 1;
			
			// random number of potatoes incrementer ;)
			aEKZ[11] = 3+(rnd*3);
			aEKZ[12] = 5+(rnd*5);
			
			// random number of potatoes for this round
			var rd:Number = r2d2( aEKZ[11], aEKZ[12] );
			aEKZ[2] = (rd*aEKZ[0]);
			// reset number of thrown potatoes
			aEKZ[3] = 0;
		
			// max score debug
			// xxx+=aEKZ[12];
			// trace("Round: "+rnd+", max. Pot's: "+aEKZ[12]+", Sum: "+xxx);
			
			// delete potato mc list
			aKartoffeln = [];
			
			// set calculatedPercentageOfNonPotato
			var adjRnd:Number = (rnd-3);
			var basePercNonPot:Number = 5;
			var percNonPotInc:Number  = 5;
			aEKZ[7] = basePercNonPot + (adjRnd*percNonPotInc);
			// set potato spawn timer stuff
			if (rnd == 1) aSpawnTimer[3] = 500;
			else if (rnd == 2) aSpawnTimer[3] = 250;
			else if (rnd >= 3) aSpawnTimer[3] = 0;
			aSpawnTimer[4] = aSpawnTimer[2] - ( aSpawnTimer[5] * rnd );
		}
		
		public function sendScoreButton(ev:Event=null) {
			dispatchEvent(new  CustomEvent({TARGETID:"reportScoreBtn"},BUTTON_PRESSED));
		}
		
		public function userSubmitted(ev:Event=null):void {
			enterFrameFunction = null;
			compareAnswer();
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyPress);
		}
		
		public function VeggieChoice():String {
			var cPot = "";
			var iSpread = (aEKZ[6]/aEKZ[0]);
			
			// 5-11 fake stuff
			if ( iSpread >= 11 ) {
				iSpread = 11; // just in case :)
				if ( Math.floor(Math.random()*13) == 8 ) {
					// the phantom orange shirt guy shows up
					cPot = "xls"+r2d2( 5, iSpread );
				} else {
					cPot = "xls"+r2d2( 5, (iSpread-1) );
				}
			}
			else {
				cPot = "xls"+r2d2(5, iSpread);
			}
			
			return ( cPot );
		}
		
		public function victoryMusic() {
			if(!noMusic) {
				var sounds:SoundManager = SoundManager.instance;
				sounds.soundPlay(WIN_SOUND);
				sounds.changeSoundVolume(WIN_SOUND,0.4);
			}
		}
		/**
		 * @Note: Checked each time a key is pressed.
		 */
		
		public function onKeyPress(ev:KeyboardEvent) {
			if(ev.keyCode == 13) {
				userSubmitted();
			}
		}
		
		// Flash 9 functions
		
		/**
		 * @Note: Imported from first frame of flash 6 version of game.
		 */
		 
		 public function beginGame():void
		 {
			xxx = 0;
			aPlacement = [];
			// top->bottom movement
			aPlacement.push( [ 80,620,-40,-40] )
			// right->left movement
			aPlacement.push( [740,740, 80,420] )
			// bottom->top movement
			aPlacement.push( [ 80,620,540,540] )
			// left->right movement
			aPlacement.push( [-40,-40, 80,420] )
			aAdjSpeeds = [0,0,0,0];
			aRotSpeeds = [-50,50];
			aScales = [150,300];
			// 0 = var sPotatoTime = getTimer();
			// 1 = var baseRandomSpawnTime;
			// 2 = var baseCeilPotatoSpawnTime = 1100;
			// 3 = var adjustedFloorPotatoSpawnTime;
			// 4 = var adjustedCeilPotatoSpawnTime;
			// 5 = var timeRemovedPerRound = 100;
			aSpawnTimer = [ getTimer(), 0, 1100, 0, 0, 100 ];
			msgCount = 0;
			// -----------------------------------------------------------------
			//  our new variable array
			//  0 = random number for encryption
			//  1 = _root.ROUND
			//  2 = _root.numberOfPotatoes
			//  3 = _root.numberOfPotatoesThrown
			//  4 = i (was used to increment the mc name!)
			//  5 = game over flag - max. 15 rounds
			//  6 = _root.objectSpread
			//  7 = _root.calculatedPercentageOfNonPotato
			//  8 = NEW guess the correct number TIMER
			//  9 = NEW next message TIMER
			// 10 = NEW next beep TIMER
			// 11 = _root.potatoPerRoundFloor
			// 12 = _root.attachPerRoundCeil
			aEKZ = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
			aEKZ[0] = 10+int(Math.random()*1000);
			aKartoffeln = [];
		 }
		 
		 /**
		 * @Note: Called every frame
		 */
		 
		 public function update(ev:Event=null):void {
			// "updateDisplay" just put the current score in a string which wasn't used until
			// the end of a round, so I've replaced this with direct score checking.
			//_root.updateDisplay();
			/*************************FUELS TRACES*****/
			if (roundActive == 0) {
				// max. 15 rounds
				if ( (aEKZ[1]/aEKZ[0]) >= 15 ) aEKZ[5] = 1;
				endRound();
			} else {
				if ((aEKZ[2]/aEKZ[0])>(aEKZ[3]/aEKZ[0])) newKartoffel();
			}
		 }
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Festival of the Neggs Functions
		
		/**
		 * Start amf test for Negg quest.
		*/
		
		protected function checkNeggQuest() {
			// set up communication with php
			var delegate:AmfDelegate = new AmfDelegate();
			var server:String = FlashVarsFinder.findVar(stage,"baseurl");
			if(server == null) server = "www.neopets.com";
			delegate.gatewayURL = "http://" + server + "/amfphp/gateway.php";
		    delegate.connect();
			// make amf-php call
			var responder:Responder = new Responder(onNeggResult, onNeggFault);
		    delegate.callRemoteMethod("Neggfest2010Service.potato",responder);
		}
		
		/**
		 * Amf success for getMonthList call
		*/
		public function onNeggResult(msg:Object):void
		{
			trace("success: event: " + msg);
			// make javascript call
			if(ExternalInterface.available) {
				ExternalInterface.call("flash_trigger",{hash:msg});
			}
		}
		
		/**
		 * Amf fault for getMonthList call
		*/
		public function onNeggFault(msg:Object):void
		{
			trace("fault: event: " + msg);
		}
		
	}
	
}
