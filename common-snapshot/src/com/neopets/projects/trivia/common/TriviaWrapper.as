/* AS3
	Copyright 2008
*/
package com.neopets.projects.trivia.common
{
	import com.neopets.projects.mvc.view.NeopetsScene;
	import com.neopets.projects.support.trivia.cmds.TriviaExternalCmds;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.timer.ExtendedTimer;
	import com.neopets.util.tranistion.TransitionObject;
	
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;

	/**
	 *	This is the Basic Trivia Component Class. This Class does most of the Setup for a Trivia Game
	 * 	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick
	 *	@since  01.21.2008
	 */
	 
	public class TriviaWrapper extends TriviaEngine

	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const RESET_DELAY:uint = 3000;
		public const SETUP_SCENE:String = "STARTING_SCENE";
		public static const TRIVIA_COMPLETED:String = "TriviaISDoneCloseMe";
		
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
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TriviaWrapper():void
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
		 
		
		 
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------
		
 		/**
		 * @Note: This is after everything else is set in the Parent Classes
		 */
		 
		protected override function initChild():void
		{
			mExternalCommand = new TriviaExternalCmds(this,mConfigXML);
			
			for each (var tXML:XML in mConfigXML.TRIVIA.QUESTIONS..QUESTION)
			{
				mQuestionArray.push(tXML);
			}
			
			mIncorrectTrysAllowed = mQuestionArray[mCurrentQuestion].allowedWrongCount;
			
			setupStartDisplay();
			
		}
		
		 /**
		 * @Note: This goes through all the Objects and Translates the Text
		 */
		 
		protected override function translateObjects():void
		{
			
			if (GeneralFunctions.convertBoolean(mConfigXML.SERVER.translation))
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
			mCurrentTryCount = 0;
			mCurrentQuestion = 0;
			mQuestionArray = [];
			mTimer = new ExtendedTimer(RESET_DELAY);
			mTimer.addEventListener(TimerEvent.TIMER, onDelayReset,false,0,true);
			mAnswerTrackingArray = [];
			mScoreLoader = new URLLoader();
		}
		
		/**
		 * @Note: Setups the starting Display of the Trivia Part
		 */
		 
		private function setupStartDisplay():void
		{
			mNeopetsInterfaceScene = getNeopetsScene(this.DISPLAY_SCENE);
			
			if (!checkForFunctions(mConfigXML.TRIVIA.OPENINGTEXT[0],this))
			{
				runStartSequence();
			}
		}
		
		
		
		/**
		 * @Note: Setups the Display for the QUESTIONS in the Correct Text Fields
		 * @param		pXML		XML		The XML for a QUESTION
		 */
		 
		private function setupQuestionDisplay(pXML:XML):void
		{
			mNeopetsInterfaceScene.getTextObject(pXML.QUESTIONTEXT.mapto).text = pXML.QUESTIONTEXT.text.toString();
			
			for each (var tButtonXML:XML in pXML.BUTTONTEXT.*)
			{
				mNeopetsInterfaceScene.getButton(tButtonXML.mapto).setText(tButtonXML.text.toString());
				mNeopetsInterfaceScene.getButton(tButtonXML.mapto).reset();	
			}
		}
		
		
		 
		/**
		 * @Note: This is for checking to see if the trivia QUESTION is Correct
		 * @param		pAnswer		String		The Button which was pressed
		 */
		 
		public function checkAnswer(pAnswer:String):void
		{
			var tQUESTIONXML:XML = 	mQuestionArray[mCurrentQuestion];
			
			mAnswerTrackingArray.push(pAnswer);
			
			if (pAnswer == tQUESTIONXML.answer.toString())
			{
				correctAnswer();
			}
			else
			{
				wrongAnswer();
			}
		}	
		
		/**
		 * @Note: They got the answer correct
		 */
		 
		private function correctAnswer():void
		{
			if (mQuestionArray[mCurrentQuestion].hasOwnProperty("SOUND"))
			{
				mSoundManager.soundPlay(mQuestionArray[mCurrentQuestion].SOUND.id.toString());			
			}
			
			mNeopetsInterfaceScene.getTextObject(mQuestionArray[mCurrentQuestion].CORRECTTEXT.mapto.toString()).text = mQuestionArray[mCurrentQuestion].CORRECTTEXT.text.toString();
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
		 * @param		pResult		Boolean		True = Answered correct / false = answered wrong
		 * @param		pValue		uint		Neopoint Value
		 * @param		pQUESTION	uint		The Number of the QUESTION
		 */
		 
		 /**
		 * SENDING DATA REF
		 * @param		campId_g		uint		The Campaign ID
		 * @param		userId_g		String		The User Name
		 * @param		result_g		Boolean		The True = Got it right, False = got it wrong
		 * @param		ans_g			Array		The Campaign ID
		 * @param		points_g		uint		The Neopoint Value
		 * @param		QUESTIONNum		Boolean		The QUESTION Number
		 */
		 
		private function sendData(pResult:Boolean, pValue:Number, pQUESTION:uint):void
		{
			var tServerInfo:XMLList = mConfigXML.TRIVIA;
			
			var sURL:String = tServerInfo.sendScoreURL.toString();
			
			// prevent caching
			sURL += "?r="+String( Math.round((Math.random()*1000000)));
			
		
			//sURL += "&campId_g="+tServerInfo.campaignId+"&userId_g="+tServerInfo.sUsername+"&result_g="+pResult+"&ans_g="+mAnswerTrackingArray.toString()+"&points_g="+pValue+"&QUESTIONNum="+pQUESTION;
			sURL += "&campId_g="+mConfigXML.SERVER.campaignId+"&userId_g="+mConfigXML.SERVER.sUsername+"&result_g="+pResult+"&ans_g="+mAnswerTrackingArray[mAnswerTrackingArray.length - 1]+"&points_g="+pValue+"&QUESTIONNum="+pQUESTION;
			
			
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
		 
		 private function runEndSequence():void
		 {
		 	var tStartScene:NeopetsScene = getNeopetsScene(SETUP_SCENE);
		 	tStartScene.getTextObject(mConfigXML.TRIVIA.OPENINGTEXT.mapto.toString()).text = mEndMessageFromServer;
			
			addEventListener(TRANSITION_COMPLETE, onEndTrivia, false,0,true);
			sceneTransition(tStartScene,mNeopetsInterfaceScene,mConfigXML.TRIVIA.ENDTRIVIA.resultEffect.type.toString(),mConfigXML.TRIVIA.ENDTRIVIA.resultEffect.time.toString());	
		 }
		 
		  /**
		 * @Note: The Interface has been taken care off send Message to the Parent time to clean up shop
		 */
		 
		 private function dispatchClose():void
		 {
		 	this.dispatchEvent(new CustomEvent({CMD:TRIVIA_COMPLETED},SEND_THROUGH_CMD));
		 }
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
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
					sendData(false,Number(mQuestionArray[mCurrentQuestion].neoValue.toString()),mCurrentQuestion);
				break;
				case "correct":
					sendData(true,Number(mQuestionArray[mCurrentQuestion].neoValue.toString()),mCurrentQuestion);
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
			
			runEndSequence();
			
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
							TransitionObject.startTransition(tEffect,{ITEM:viewContainer,TIME:tTime,FUNCTION:dispatchClose});	
						}	
						else
						{
							viewContainer.visible = false;
							dispatchClose();	
						}
					}				
		 		break;
		 	}			
		 }
		 
		 /**
		 * @Note: The Last Text has been displayed so now it is going to Close.
		 */
		 
		 private function onEndTrivia(evt:Event):void
		 {
		 	mTransitionTimer.delay = mConfigXML.TRIVIA.ENDTRIVIA.resultWaitTime.toString();
		    mTransitionTimer.object = {STATE:"end"};
		 	mTransitionTimer.start();	
		 }
		 
		
	}
	
}
