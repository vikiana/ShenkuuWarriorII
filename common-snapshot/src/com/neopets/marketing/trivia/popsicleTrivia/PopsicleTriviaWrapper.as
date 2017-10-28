/* AS3
	Copyright 2008
*/
package com.neopets.marketing.trivia.popsicleTrivia
{
	import com.neopets.projects.mvc.view.NeopetsScene;
	import com.neopets.projects.support.trivia.button.RadioSelectedButton;
	import com.neopets.projects.support.trivia.cmds.TriviaExternalCmds;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.timer.ExtendedTimer;
	import com.neopets.util.tranistion.TransitionObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	/**
	 *	This is the Basic Trivia Component Class. This Class does most of the Setup for a Trivia Game.
	 *  This is the Meat and Guts of the Application. This script is linked to the Flash Component in 
	 *  the FLA Library.
	 * 	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern TriviaEngine
	 * 
	 * 
	 *	@author Clive Henrick
	 *	@since  01.21.2008
	 */
	 
	public class PopsicleTriviaWrapper extends PopsicleTriviaEngine

	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const RESET_DELAY:uint = 3000;
		public const SETUP_SCENE:String = "STARTING_SCENE";
		
		public const TRIVIA_CLOSE:String = "CloseTrivia";
		public const TRIVA_OPEN:String = "OpenTrivia";
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
			
		private var mCurrentQuestion:int;
		private var mQuestionArray:Array;
		private var mNeopetsInterfaceScene:NeopetsScene;
		private var mTimer:ExtendedTimer;
		private var mIncorrectTrysAllowed:int;
		private var mCurrentTryCount:int;
		private var mAnswerTrackingArray:Array;
		private var mScoreLoader:URLLoader;
		private var mTransitionTimer:ExtendedTimer;
		private var mEndMessageFromServer:String;
		
		private var mCurrentPickedQuestionID:int;
		
		private var mAllReadyOnStage:Boolean;
		
		private var mSetupComplete:Boolean;
		
		//--------------------------------------
		//  PUBLIC VARIABLES (ITEMS ON STAGE)
		//--------------------------------------
		
		public var myCloseBtn:CloseBtn;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PopsicleTriviaWrapper():void
		{
			setupVarslocal();
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		 //--------------------------------------
		//  PUBLIC INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is for the Document Class to Call to start the Trivia to Faidup and
		 * and start the Trivia sequence
		 */
		 
		public function showTrivia():void
		{
			visible = true;
			setupStartDisplay();
		}
		
		/**
		 * @Note: Close Btn Clicked
		 */
		 
		public function closeTrivia(evt:Event = null):void
		{
			var tEffect:String = mConfigXML.TRIVIA.ENDTRIVIA.closeEffect.type.toString();
			var tTime:Number = mConfigXML.TRIVIA.ENDTRIVIA.closeEffect.time.toString();
					
			if (tEffect != "none")
			{
				TransitionObject.startTransition(tEffect,{ITEM:this,TIME:tTime,FUNCTION:deactivateInterface});				
			}
			else
			{
				deactivateInterface();	
			}
		}
		 
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------
		
 		/**
		 * @Note: This is after everything else is set in the Parent Classes
		 */
		 
		protected override function initChild():void
		{
			
			mExternalCommand = new TriviaExternalCmds(this,mConfigXML);
			
			mQuestionArray.push(mQuestionXML);
			

			addChild(viewContainer);
			
			mIncorrectTrysAllowed = mConfigXML.TRIVIA.SETUP.allowedWrongCount;
			
			
		}
		
		 /**
		 * @Note: This goes through all the Objects and Translates the Text
		 */
		 
		protected override function translateObjects():void
		{
			
			if (GeneralFunctions.convertBoolean(mConfigXML.SERVER.translationFlag))
			{
				setDictionary();
				mTranslateItems.addEventListener(Event.COMPLETE,finishedTranslation,false,0,true);
				mTranslateItems.externalURLforTranslation = mConfigXML.SETUP.SETUP_INFO.translationURL;
				mTranslateItems.init(mConfigXML.SEVER.sLang.toString(),mConfigXML.SERVER.iGameID.toString(),mTranslationDictionary,mConfigXML.SERVER.iTypeID.toString());
			}
			else
			{
				completedSetup();	
			}
			
		}
		
		/**
		 * @NOTE: This is a bit Change from the normal style as the TRIVA Section has all the Text to be Converted.
		 * 	#1)	Goes through the config XML and swaps out each String with the correct string from the Translation
		 * 
		 * NOTE: That the TranslationObject wants the following format:
		 * TranslationObject(a_resName:String, a_fontName:String, a_TF:TextField)
		 * 		@param		a_resName		String		The resname in the Neopets returned XML
		 * 		@param		a_fontName		String		The Name of the Font you want the TextField Mapped to.
		 * 												This Font Should be in your FLA Library with Export 
		 * 												for ActionScript and the Same name as in a_fontName.
		 *		@param		a_TF			TextField	The TextField That you want to be Translated 	
		*/
		 
		protected override function setDictionary():void
		{
			var tDictionary:Dictionary = new Dictionary(true);
			mTranslationDictionary = tDictionary;	
		}
		
		/**
		 * 
		 * @NOTE: This is after the translation is finished.
		 * @Note: Go through the translation list and replace the XML string with the 
		 */
		 
		 protected override function finishedTranslation(evt:Event):void
		 {
		 	for each (var tSection:XML in mConfigXML.TRIVIA..*.(hasOwnProperty("translationId")))
		 	{
		 		tSection.text = mTranslateItems.getTranslationString(tSection.translationId);		
		 	}
		 	
			completedSetup();
		 }
		 
		 //--------------------------------------
		//  PRIVATE / PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVarslocal():void
		{	
			
			mCurrentPickedQuestionID = -1000;
			mCurrentTryCount = 0;
			mCurrentQuestion = 0;
			mQuestionArray = [];
			mTimer = new ExtendedTimer(RESET_DELAY);
			mTimer.addEventListener(TimerEvent.TIMER, onDelayReset,false,0,true);
			mAnswerTrackingArray = [];
			mScoreLoader = new URLLoader();
			
			myCloseBtn = new CloseBtn();
			myCloseBtn.init({},"CloseBtn");
			addChild(myCloseBtn);
			myCloseBtn.x = 223.7;
			myCloseBtn.y = 15.5;
			myCloseBtn.addEventListener(MouseEvent.MOUSE_UP, closeTrivia, false,0,true);
			
		}
		
		/**
		 * @Note: Setups the starting Display of the Trivia Part
		 */
		 
		private function setupStartDisplay():void
		{
			mNeopetsInterfaceScene = getNeopetsScene(this.DISPLAY_SCENE);
			
			if (mConfigXML.TRIVIA.OPENINGTEXT[0])
			{
				if (!checkForFunctions(mConfigXML.TRIVIA.OPENINGTEXT[0],this))
				{
					runStartSequence();
				}
			}
		}
		
		/** 
		 * @Note: This is to have the Main Text Show up for a set period of time then fade out and be replaced by
		 * The Main QUESTION Text. Needs to be Public as it is called by XML.
		 * @param		pTime		Number 		The Amount to Wait till the Transition happens
		 */
		 
		 public function runStartSequence(pTime:Number = 3000):void
		 {
		 	
		 	mTransitionTimer = new ExtendedTimer(pTime);
		 	mTransitionTimer.addEventListener(TimerEvent.TIMER,onTransitionTimerCompleted,false,0,true);
		 	var tStartScene:NeopetsScene = getNeopetsScene(SETUP_SCENE);
		 	tStartScene.getTextObject(mConfigXML.TRIVIA.OPENINGTEXT.mapto.toString()).text = mConfigXML.TRIVIA.OPENINGTEXT.text.toString();
			mCurrentScene = tStartScene;
			setupQuestionDisplay(mQuestionArray[mCurrentQuestion]);
			
			mTransitionTimer.object = {STATE:"start"};
			mTransitionTimer.start();	
		 }
		 
		
		/**
		 * @Note: Setups the Display for the QUESTIONS in the Correct Text Fields
		 * @param		pXML		XML		The XML for a QUESTION
		 */
		 
		private function setupQuestionDisplay(pXML:XML):void
		{
			//mNeopetsInterfaceScene.getTextObject(pXML.QUESTIONTEXT.mapto).text = pXML.QUESTIONTEXT.text.toString();
			var tQuestion:String = pXML.question.text.toString();
			mNeopetsInterfaceScene.getTextObject(mConfigXML.TRIVIA.SETUP.FORMAT.QUESTIONTEXT.mapto).text = tQuestion;
			
			var tCount:int = 0;
			
			for each (var tButtonXML:XML in mConfigXML.TRIVIA.SETUP.FORMAT.BUTTONTEXT.*)
			{
				var tText:String = pXML.question.answer[tCount].toString();
				mNeopetsInterfaceScene.getButton(tButtonXML.mapto).setText(tText);
				mNeopetsInterfaceScene.getButton(tButtonXML.mapto).reset();	
				tCount++;
			}
		}
		
		/**
		 * @Note: This is for the Submit Button when its clicked
		 */
		 
		public function submitAnswer():void
		{
			
			if (mCurrentPickedQuestionID == -1000)
			{
				mSoundManager.soundPlay("TryAgainSound");	
			}
			else
			{
				var tQUESTIONXML:XML = 	mQuestionArray[mCurrentQuestion];
				var tPickedAnswerID:Number = Number(tQUESTIONXML.question.answer[mCurrentPickedQuestionID].@id);
				var tCorrectAnswer:Number = Number(tQUESTIONXML.question.correct);
				var tQuestionID:Number = Number(tQUESTIONXML.question.@id);
				var tQuestionHash:String = tQUESTIONXML.hash;
				
				mAnswerTrackingArray.push(tPickedAnswerID);
				
				if (tPickedAnswerID == tCorrectAnswer)
				{
					correctAnswer();
				}
				else
				{
					wrongAnswer();
				}
				
				sendData(tQuestionID,tPickedAnswerID,tQuestionHash);
			}
			
		}	
		 
		/**
		 * @Note: This is for checking to see if the trivia QUESTION is Correct
		 * @param		pAnswer		String		The Button which was pressed
		 */
		 
		public function checkAnswer(pAnswerIndex:Number):void
		{
			mCurrentPickedQuestionID = pAnswerIndex;
			
			for each (var tButtonXML:XML in mConfigXML.TRIVIA.SETUP.FORMAT.BUTTONTEXT.*)
			{
				mNeopetsInterfaceScene.getButton(tButtonXML.mapto).reset();	
			}
			
			var tSelectedBtn:RadioSelectedButton = mNeopetsInterfaceScene.getButton(mConfigXML.TRIVIA.SETUP.FORMAT.BUTTONTEXT.BUTTON[pAnswerIndex].mapto) as RadioSelectedButton;
			tSelectedBtn.setState("selected");
		}	
		
		/**
		 * @Note: They got the answer correct
		 */
		 
		private function correctAnswer():void
		{
			
			
			if (mConfigXML.TRIVIA.CORRECTTEXT.hasOwnProperty("SOUND"))
			{
				mSoundManager.soundPlay(mConfigXML.TRIVIA.CORRECTTEXT.SOUND.id.toString());			
			}
			
			mNeopetsInterfaceScene.getTextObject(mConfigXML.TRIVIA.CORRECTTEXT.mapto.toString()).text = mConfigXML.TRIVIA.CORRECTTEXT.text.toString();
			
			if (mConfigXML.TRIVIA.CORRECTTEXT.hasOwnProperty("waitTime"))
			{
				mTimer.delay = 	mConfigXML.TRIVIA.CORRECTTEXT.waitTime;
			}
				
			mTimer.object = {STATE:"correct"};
			mTimer.start();	
		}
		
		/**
		 * @Note: They got the answer wrong
		 */
		 
		private function wrongAnswer():void
		{
			if (mCurrentTryCount >= mIncorrectTrysAllowed)
			{
				mTimer.object = {STATE:"end"};
				
				if (mConfigXML.TRIVIA.FINALFALSETEXT.hasOwnProperty("waitTime"))
				{
					mTimer.delay = 	mConfigXML.TRIVIA.FINALFALSETEXT.waitTime;
				}
				
				mNeopetsInterfaceScene.getTextObject(mConfigXML.TRIVIA.FINALFALSETEXT.mapto.toString()).text = mConfigXML.TRIVIA.FINALFALSETEXT.text.toString();	
				
				if (mConfigXML.TRIVIA.FINALFALSETEXT.hasOwnProperty("SOUND"))
				{
					mSoundManager.soundPlay(mConfigXML.TRIVIA.FINALFALSETEXT.SOUND.id.toString());		
				}
			
			}
			else
			{
				mCurrentTryCount++;
				mTimer.object = {STATE:"wrong"};
				
				if (mConfigXML.TRIVIA.FALSETEXT.hasOwnProperty("waitTime"))
				{
					mTimer.delay = 	mConfigXML.TRIVIA.FALSETEXT.waitTime;
				}
				
				mNeopetsInterfaceScene.getTextObject(mConfigXML.TRIVIA.FALSETEXT.mapto.toString()).text = mConfigXML.TRIVIA.FALSETEXT.text.toString();		
				
				if (mConfigXML.TRIVIA.falseAnsSnd.hasOwnProperty("SOUND"))
				{
					mSoundManager.soundPlay(mConfigXML.TRIVIA.falseAnsSnd.SOUND.id.toString());		
				}
				
			}
			
			mTimer.start();	
		}
		
		/**
		 * @Note: Sending the Data to the Severs. For Sec the user ID is pulled from the PHP Script
		 * @param		pQuestionID			Number		The Questions ID Value
		 * @param		pPickedAnswerID		Number		The Answer's ID Value
		 * @param		pQuestionHash		String		The Hash Value Sent by PHP
		 */
		 
		 /**
		 * SENDING DATA REF
		 * @param		qid				Number		pQuestionID
		 * @param		aid				Number		pPickedAnswerID
		 * @param		hash			String		The Hash ID provided by PHP (pQuestionHash)
		 */
		 
		
		private function sendData(pQuestionID:Number, pPickedAnswerID:Number, pQuestionHash:String):void
		{
			var sURL:String = mConfigXML.SERVER.sendScoreURL.toString();
			
			sURL += "&qid="+pQuestionID+"&aid="+pPickedAnswerID+"&hash="+pQuestionHash+"&r="+String( Math.round((Math.random()*1000000)));
			
			trace("sendData> ", sURL);
			
			// call scoring script
			var request:URLRequest = new URLRequest();
			request.url = sURL;
			request.method = URLRequestMethod.POST;
			mScoreLoader.addEventListener(Event.COMPLETE, completeHandler);
			mScoreLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			mScoreLoader.load( request );

		}
		
		/** 
		 * @Note: This is to happen after the Trivia Comp is Done. Needs to be Public as it is called by XML.
		 * @param		pTime		Number 		The Amount of time for the transition
		 * @param		pEffect		String 		The Effect that you want at the End of the Trivia Experience
		 */
		 
		 private function runEndSequence(evt:Event = null):void
		 {
		 	var tStartScene:NeopetsScene = getNeopetsScene(SETUP_SCENE);
		 	tStartScene.getTextObject(mConfigXML.TRIVIA.OPENINGTEXT.mapto.toString()).text = mEndMessageFromServer;
			
			addEventListener(TRANSITION_COMPLETE, onEndTrivia, false,0,true);
			sceneTransition(tStartScene,mNeopetsInterfaceScene,mConfigXML.TRIVIA.ENDTRIVIA.resultEffect.type.toString(),mConfigXML.TRIVIA.ENDTRIVIA.resultEffect.time.toString());	
		 }
		 
		 
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		/**
		 * Note: When the Close Btn is Clicked on the Trivia Main Menu
		 */
		 
		private function onCloseTriviaBtn(evt:Event):void
		{
			soundManager.soundPlay("BtnSound");
			onEndTrivia();
		}
		
		/**
		 * @Note: When the Delay (Timer) is complete does something for the QUESTIONS
		 */
		 
		private function onDelayReset(evt:TimerEvent):void
		{
			switch (evt.currentTarget.object.STATE)
			{
				case "wrong":
					setupQuestionDisplay(mQuestionArray[mCurrentQuestion]);			
				break;
				case "end":
					runEndSequence();
				break;
				case "correct":
					runEndSequence();
				break;
			}
			
			mTimer.reset();
			mTimer.stop();
		}
		
		/** 
		* @Note: send score data received
		*/ 
		private function completeHandler(event:Event):void 
		{

			var sResult:String = String(event.target.data);
			
			// !!DEBUG!!
			// sResult = "eof=0&np=1,479,743&success=1&errcode=0&avatar=&plays=1&eof=1&call_url=&sk=0e34701c3a4df4e74c52&sh=f963c971ef9f4f82e5bd";
			trace("Score received:> ",sResult);
			mScoreLoader.removeEventListener(Event.COMPLETE, completeHandler);
			mScoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			//#### TO DO ######
			/* Get a Return Message and Display it instead of this generic one */
			//mEndMessageFromServer = sResult;
			mEndMessageFromServer = sResult;
			
			//runEndSequence();
			
		}
		
		/** 
		* @Note: Handles an Error
		*/ 
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("Score security Error:> ",event.text);
			mScoreLoader.removeEventListener(Event.COMPLETE, completeHandler);
			mScoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			//#### TO DO ######
			/* Get a Return Message and Display it instead of this generic one */
			//mEndMessageFromServer = sResult;
			
			mEndMessageFromServer = mConfigXML.TRIVIA.QUESTIONS.ENDTRIVIA.ERRORTEXT.text.toString();
			runEndSequence();
			
        }
        
         /**
		 * @Note: After the Starting Text is to Fade out. Setup the Text QUESTIONS the Fadeup the Buttons and QUESTION.
		 */
		 
		 private function onTransitionTimerCompleted(evt:TimerEvent):void
		 {
		 	mTransitionTimer.stop();
		 	
		 	switch (evt.currentTarget.object.STATE)
		 	{
		 		case "start":
		 			sceneTransition(mNeopetsInterfaceScene,mCurrentScene,mConfigXML.TRIVIA.OPENINGTEXT.effect.toString());		
		 		break;
		 		case "end":
		 			if (!checkForFunctions(mConfigXML.TRIVIA.ENDTRIVIA[0]))
					{
						//DEFAULT CHOICE (FADE OUT)
						
						var tTime:Number = mConfigXML.TRIVIA.ENDTRIVIA.endEffect.time.toString();
						var tEffect:String = mConfigXML.TRIVIA.ENDTRIVIA.endEffect.type.toString();
						
						if (tEffect != "none")
						{
							TransitionObject.startTransition(tEffect,{ITEM:this,TIME:tTime,FUNCTION:deactivateInterface});	
							
						}	
						else
						{
							//viewContainer.visible = false;
							//visible = false;
							
							deactivateInterface();	
						}
					}				
		 		break;
		 	}			
		 }
		 
		 /**
		 * @Note: The Last Text has been displayed so now it is going to Close.
		 */
		 
		 private function onEndTrivia(evt:Event = null):void
		 {
		 	mTransitionTimer.delay = mConfigXML.TRIVIA.ENDTRIVIA.resultWaitTime.toString();
		    mTransitionTimer.object = {STATE:"end"};
		 	mTransitionTimer.start();	
		 }
		 
		
		 
		
	}
	
}
