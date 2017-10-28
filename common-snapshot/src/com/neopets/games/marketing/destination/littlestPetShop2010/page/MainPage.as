/**
 *	Main landing page for littlest pet pet shop
 *	When the page is first create it calls amfphph call
 *	When a user answers a trivia quesiton it makes amfphp call
 *	Both calls return same properties that need to be used to show most upto date use status and popup messages
 *
 *	@NOTE: Due to time constraint, the error check is not perfect.  It sort of assumes everything is working perfectly fine.  be sure to login to your accouont
 *	
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.marketing.destination.littlestPetShop2010.page
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.filters.GlowFilter;
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;

	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.tracker.NeoTracker;
	
	
	public class MainPage extends PageDesitnationBase {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		protected var popup:PopupPage	//popup board
		protected var mQuestID:String;	//flashvar.  store it and send it when makeing a call php call
		protected var mWorld:String;	//flashvar.  store it and send it when makeing a call php call
		protected var mHash:String;		//flashvar.  store it and send it when makeing a call php call
		
		protected var mRibbonBox:MovieClip;	//ribbon box for trivia questions
		protected var mWheel:MovieClip; //main wheel of carts
		
		//amfphp call properties I would be getting and need to use to show proper visual elements
		protected var mFoundAll:Boolean; //refers if the person found all
		protected var mTriviaCorrect:int; //number of trivia q answered correctly
		protected var mFinalPrize:Boolean; // if true, then show the final gift (via popup)
		protected var mPrizeImage:String; //imge url for final image
		protected var mFoundBanners:Array; //array to indicate which banner are found and not found
		protected var mJustFound:int; // indicate which banner has been just found (returns 0, 1, 2, 3) 0= false, 1 = snow, 2 = farm, 3 = jungle
		protected var mCorrectAnswer:Boolean; // the user just answered the question correctly
		
		
		// for trivia (continuation of amfphp properties)
		protected var mCampaign_id:int = 6;
		protected var mTriviaHash:String;	//hash used for trivia sepecifically
		protected var mTriviaID:Number;	//trivia quesiton ID
		protected var mTriviaQ:String;	// question itself
		protected var mTriviaA:Array;	// array containing answers and each answer's ID in pairs
		
		//loader
		protected var mLoader:Loader;	//loader to load final prize image
		
		//login
		protected var mLoginWarning:String = "Please Login to your account to play Daily Trivia"
		
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	when the page is called, load assets to build main page
		 **/
		public function MainPage(pName:String = null) 
		{
			super(pName)
			
			setupFlashVars();						
			loadAsset( "/workingPrep.swf", "MainPageAsset")		
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	Retrieve necessary flash vars to call amfphp
		 **/
		protected function setupFlashVars():void
		{
			var quest:String = FlashVarsFinder.findVar(Parameters.view.stage, "questID");
			var world:String = FlashVarsFinder.findVar(Parameters.view.stage, "world");
			var hash :String = FlashVarsFinder.findVar(Parameters.view.stage, "hash");
			
			mQuestID = quest == null? "lilpetshop_10" : quest;
			mWorld = world == null? "0" : world;
			mHash = hash == null? "" : hash;
		}
		
		/**
		 *	@NOTE:	In this case, before setting things up, i need to connect to amfphp first to get necessary parameters
		 **/
		protected override function setupPage():void
		{
			getStatus();
		}
		
		/**
		 *	@NOTE:	instantiate all the visual elements to show the main page 
		 **/
		protected function setupDisplay():void
		{
			NeoTracker.instance.trackNeoContentID(15679)
			trace ("main page, setup display")
			var loadingSign:MovieClip = MovieClip(Parameters.view.getChildByName("loadingSign"));
			Parameters.view.dispatchEvent(new CustomEvent({DATA:loadingSign},AbsView.REMOVE_DISPLAY_OBJ))
			
			addImage("MC_background", "bg",0, 0);
			addImage("MC_wheel", "wheel",0, 0);
			addImage("MC_background_Frame", "bgf",0, 0);
			addImage("MC_quizBox", "quiz",0, 277);
			addImage("MC_logo", "logo",0, 0);
			placeTextButton("MC_navButton", "trivia", "Trivia", 288, 2, 0, "out");
			placeTextButton("MC_navButton", "video", "Video", 458, 2, 0, "out");
			placeTextButton("MC_navButton", "info", "Info", 628, 2, 0, "out");
			placeTextButton("MC_textButton", "inst", "Instructions", 650, 50, 0, "out");
			
			mWheel = MovieClip(getChildByName("wheel"));
			mRibbonBox = MovieClip(getChildByName("quiz"));
		}
		
		/**
		 *	@NOTE:	Show the ribbon (trivia question answered correctly) and the casousel cart (banner status)
		 **/
		protected function displayStatus():void
		{
			//for ribbons
			var correct:int = mTriviaCorrect
			if (correct >= 5) correct = 5;
			for (var i:int = 0; i < correct; i++)
			{
				trace (mRibbonBox["ribbon" + (i+1)])
				mRibbonBox["ribbon" + (i+1)].gotoAndStop("found")
			}
			
			//carts
			if (mFoundBanners[1])mWheel.snowCart.gotoAndStop("found");
			if (mFoundBanners[2])mWheel.farmCart.gotoAndStop("found");
			if (mFoundBanners[3])mWheel.jungleCart.gotoAndStop("found");
		}
		
		
		/**
		 *	update the stage according to amfphp's return value
		 **/
		protected function setupAmfphpResult(pObj:Object):void
		{
			trace ("success!");
			trace (pObj == false)
			if (pObj != false)
			{
				setupDisplay()
				mapObjs(pObj, showFeedback)
			}
			else 
			{
				//trace ("eh...")
				//showFeedback();
				setupDisplay();
			}
			
		}
		
		/**
		 *	@NOTE:	based on returned object (via amfphp), map the variables to object's property
		 *	@PARAM		pObj		Object		returned object via amfphp call
		 *	@PARAM		callback	Function	
		 **/
		protected function mapObjs(pObj:Object, callback:Function):void
		{
			mFoundAll = pObj.foundAll;
			mTriviaCorrect = pObj.triviaCorrect;
			mFinalPrize = pObj.finalPrize;
			mPrizeImage = pObj.prizeImg;
			mFoundBanners = pObj.foundBanners;
			mJustFound = pObj.justFound;
			mCorrectAnswer = pObj.correctAnswer;
			//trivia
			mTriviaHash = pObj.question.hash
			mTriviaID = pObj.question.qid
			mTriviaQ = pObj.question.question 
			mTriviaA = pObj.question.answers
			
			displayStatus();

			if (callback != null)	callback();
			
		}
		
		/**
		 *	@NOTE:	get user's progress status
		 **/
		protected function getStatus():void
		{

			var responder:Responder = new Responder(setupAmfphpResult, amfphpError);
			Parameters.connection.call("LittlePetShop2010Service.getProgress", responder, mQuestID, mWorld, mHash);
		}
		
		/**
		 *	@NOTE: call should amfphp should return error
		 **/
		protected function amfphpError(error:*):void
		{
			trace ("an error has occured", error)
			for (var i:String in error)
			{
				trace (i, error[i]);
			}
		}
		
		/**
		 *	Show basic popup message and stop that given frame name
		 *	@PARAM		pStatus		String		frame lable name (in movie clip) it needs to gotoAndStop to
		 **/
		protected function showpopup(pState:String):void
		{
			if (popup != null)
			{
				popup.cleanup()
				removeChild(popup)
				popup = null;
			}
			popup = new PopupPage ();
			popup.messages.gotoAndStop(pState)
			addChild (popup);
		}
		
		/**
		 *	amfphp call to submit user's answer
		 *	@PARAM		pValue		int		Asnwer ID that's paired with the selected answer
		 *	@NOTE:	When trivia question and answers are given by php (this is retrieved via amfphph call)
		 *			Each answer is assigned to an ID and that ID needs to be sent when user select the answer
		 **/	
		protected function submitAnswer (pValue:int):void
		{
			var aid:int = mTriviaA[pValue].aid
			trace (aid)
			var responder:Responder = new Responder(answerReceived, amfphpError);
			Parameters.connection.call("LittlePetShop2010Service.submitAnswer", responder, mCampaign_id,mTriviaID , aid, mTriviaHash);
		}
		
		/**
		 *	@NOTE:	When user's answer is submited, the call returns an object with new user progress status.
		 *			So map it and update teh user status
		 *	@PARAM:			pObj		Object		object that amfphp returned 
		 **/	
		protected function answerReceived(pObj:Object):void
		{
			trace ("answer received")
			mapObjs(pObj, showAnswerFeedBack)
			
		}
		
		/**
		 *	@NOTE:	show if user's submitted answer was correct or wrong
		 **/	
		protected function showAnswerFeedBack():void
		{
			// if trivia popup is on, remove it first
			var trivia:TriviaPopup = TriviaPopup(getChildByName ("triviaPage"));
			if (trivia != null)
			{
				trivia.cleanup();
				removeChild (trivia)
			}
			
				
			if (mCorrectAnswer)
			{
				if (mTriviaCorrect >= 5 && !mFinalPrize)
				{
					showpopup("answered5")
					NeoTracker.instance.trackNeoContentID(15687)
				}
				else
				{
					showpopup("correctAnswer")
					NeoTracker.instance.trackNeoContentID(15687)
				}
				
			}
			else 
			{
				showpopup("incorrectAnswer")
			}
			
		}
		
		/**
		 *	@NOTE:	when banner quest is just found, show hte correct popup to reflect it
		 **/	
		protected function showFeedback():void
		{
			//mJustFound 0 is false by default
			switch (mJustFound)
			{
				case 1:
					showpopup("winter_element");
					NeoTracker.instance.trackNeoContentID(15689)
					break;
					
				case 2:
					showpopup("farm_element");
					NeoTracker.instance.trackNeoContentID(15688)
					break;
				case 3:
					showpopup("safari_element");
					NeoTracker.instance.trackNeoContentID(15690)
					break;
			}
		}
		
		/**
		 *	When ever user status is returned check if the user has won the final prize
		 *	If so, load the pinal prize image and show the popup for it
		 **/
		protected function checkFinalPrize():void
		{
			if (mFinalPrize)
			{
				NeoTracker.instance.trackNeoContentID(15691)
				mFinalPrize = false;
				var url:URLRequest = new URLRequest (mPrizeImage)
				mLoader = new Loader ()
				mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, showFinalPrize)
				if (url != null)
				{
					mLoader.load(url) 
				}
			}
			else if (mLoader != null)
			{
				mLoader.unload();
				mLoader = null;
			}
			
		}
		
		/**
		 *	Once final prize image is loaded show it with the popup message
		 **/
		protected function showFinalPrize(e:Event):void
		{
			mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, showFinalPrize)
			showpopup("finalGift")
			popup.addChild(mLoader)
			mLoader.x = 420;
			mLoader.y = 180;
			
		}
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		/**
		 *	based on what users clicks on the page, carry out various tasks
		 **/
		override protected function handleObjClick(e:CustomEvent):void
		{
			switch (e.oData.DATA.parent.name)
			{
				case "trivia":
					var triviaPage:TriviaPopup = new TriviaPopup ();
					triviaPage.name = "triviaPage"
					addChild(triviaPage);
					if("what is", Parameters.userName == AbsView.GUEST_USER)
					{
						triviaPage.setQuestions(mLoginWarning, [])
					}
					else 
					{
						triviaPage.setQuestions(mTriviaQ, mTriviaA)
					}
					break;
				
				case "video":
					NeoTracker.instance.trackNeoContentID(15683)
					var videoPage:VideoPopup = new VideoPopup ();
					addChild(videoPage);
					break;
				
				case "info":
					popup = new PopupPage ();
					popup.messages.gotoAndStop("info")
					popup.urlButton.visible = true;
					addChild (popup);
					NeoTracker.instance.trackNeoContentID(15685)
					break;
				
				case "inst":
					NeoTracker.instance.trackNeoContentID(15684)
					popup = new PopupPage ();
					popup.messages.gotoAndStop("instructions")
					addChild (popup);
					break;
				
				case "popupBg":
					popup.cleanup()
					removeChild(popup)
					popup = null;
					checkFinalPrize()
					break;
				case "messages":
					popup.cleanup()
					removeChild(popup)
					popup = null;
					checkFinalPrize()
					break;
				
				case "urlButton":
					trace ("do navigation")
					//NeoTracker.processURL("http://www.lpspetsonparade.com/")
					NeoTracker.processClickURL(15681)
					break;
					
				case "submitBtn":
					var trivia:TriviaPopup = TriviaPopup(getChildByName ("triviaPage"));
					submitAnswer(trivia.answerNumber)
					NeoTracker.instance.trackNeoContentID(15686)
					break;
			}
		}
		
		/**
		 *	show the progress bar
		 **/
		override protected function onLoadingProgress(e:CustomEvent):void
		{
			//loading sign is added at Destination control level, at initChild
			var loadingSign:MovieClip = MovieClip(Parameters.view.getChildByName("loadingSign"));
			var percent:Number = e.oData.BYTES_LOADED/e.oData.BYTES_TOTAL
			loadingSign.bar.scaleX = percent;
		}

	}
}
		