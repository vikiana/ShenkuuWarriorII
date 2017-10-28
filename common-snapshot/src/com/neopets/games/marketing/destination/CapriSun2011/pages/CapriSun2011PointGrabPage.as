
/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/ Viviana Baldarelli / Clive Henrick
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.CapriSun2011.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	//import com.neopets.games.marketing.destination.CapriSun2011.SixFlagsConstants;
	import com.neopets.games.marketing.destination.CapriSun2011.CapriSun2011Constants;
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.FlagsOfFrenzyCountdown;
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.FlagsOfFrenzyGame;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SharedLinksSixFlags2010;
	import com.neopets.games.marketing.destination.CapriSun2011.subElements.SixFlags2010Popup;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.loading.LibraryLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.net.SharedObject;
	import flash.external.ExternalInterface;
	
	public class CapriSun2011PointGrabPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//Onstage
		public var pointGrabBackBtn:MovieClip; 
		public var pointGrabLinkBtn:MovieClip;
		public var instructionsBtn:MovieClip;
		public var target_mc:MovieClip;
		public var startPointGrabBtn:MovieClip;
		public var arrow_mc:MovieClip;
		public var straw_mc:MovieClip;
		public var nick_btn:MovieClip;
		public var respect_btn:MovieClip;
		public var start_btn:MovieClip;
		public var welcome_mc:MovieClip;
		
		public var pointGrabCompletePopup:MovieClip;
		public var pointGrabAlreadyPlayedPopup:MovieClip;
		public var pointGrabPoints_txt:TextField;
		public var alreadyPlayedPopup:MovieClip;
		
		
		
		//btns
		public var close_btn:MovieClip;
		public var pointGrabLogin_btn:MovieClip;
		public var pointGrabSignup_btn:MovieClip;
		public var alreadyPlayedClose_btn:MovieClip;
		
		public var pointGrabInstructionBtn:MovieClip;
		
		// Timer stuff
		public var timer_txt:TextField;
		public var click_txt:TextField;
		private var numOfClicks:int;
		private var timerCount:int;
		public var myTimer:Timer; // needs to be accessed in Destination Control
		
		// Popups
		protected var instructionsPopupMC:MovieClip;
		protected var pointGrabPopup:MovieClip;
	
		protected var mLargeDisplayCheck:Boolean = false;
		protected var strawPoints:int;
		private const setupX:Number = 0;
		private const setupY:Number = 0;
		protected var loadRecord:SharedObject;
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CapriSun2011PointGrabPage (pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			this.x = setupX;
			this.y = setupY;
			
			numOfClicks = 0;
			setupListeners();
			
			
			// Login Popup if the user is not logged in. After closing, instructions should popup
			// If the user is logged in, the instructions will still popup the first time
			checkFirstTime();
			//checkIfPointGrabPlayed();
			
			
			
			// make complete popup invisible at first
			pointGrabCompletePopup.visible = false; // invisible until timer ends
			pointGrabAlreadyPlayedPopup.visible = false;
			 
			/*
			    Viv's code for getting MCs from library
				version 1 - playButton:Class = ApplicationDomain.currentDomain.getDefinition (playbutton) as Class
			    version 2 - playButton:Class = LibraryLoader.getLibrarySymbol("playbutton");
			
			*/
					
		}
		
     //Popup appears if the user hasn't logged in already 
		
	// Dave's code plus new stuff
	protected function checkFirstTime():void
		{
		  		
			trace ("UserLogin:" + Parameters.userName);
			
			if (Parameters.userName == AbsView.GUEST_USER || Parameters.userName == "false")
			{
				Parameters.loggedIn = false;	
			} 
			else
			{
				Parameters.loggedIn = true;
			}
			
			trace ("UserLogin:" + Parameters.userName, "LOGGEDIN:", Parameters.loggedIn);
			
			// open Instructions if they are logged in
			if (Parameters.loggedIn)
			{
				// Open instructions, if shared object exists
				
				checkSharedObject()
				
			}
			
			// open Login popup if user is not logged in
			else
			{
				if (!Parameters.loggedIn)
				{
					//mLargeDisplayCheck = true;
					

					// Add signup/login popup
					var tClass1:Class = LibraryLoader.getLibrarySymbol("pointGrabLogin");
					pointGrabPopup = new tClass1();	
					pointGrabPopup.x = 0;
					pointGrabPopup.y = 0;
				
				    addChildAt(pointGrabPopup,numChildren);
					
					pointGrabPopup.pointGrabLogin_btn.addEventListener(MouseEvent.CLICK, goToPointGrabLogin,false,0,true);
					pointGrabPopup.pointGrabSignup_btn.addEventListener(MouseEvent.CLICK, goToPointGrabSignup,false,0,true);
					//pointGrabPopup.pointGrabClose_btn.addEventListener(MouseEvent.CLICK, closePointGrabPopup,false,0,true);
					
					
				}
			}
		}
	

	
	// Check shared object
	protected function checkSharedObject():void
	{
		trace("==== checkSharedObject()in PointGrabPage ====");
		
		loadRecord = SharedObject.getLocal("CapriSunPointGrabPage_SharedO"); // Randomly created name
		if(loadRecord != null) {
			var info:Object = loadRecord.data;
			
			if("last_load" in info) 
			{
				trace("==== Shared Object exists, close instructions ====");
				closeInstructionsTwo();
			}
				
		// Open the instructions if user is logged in and it's their first time visiting the page
			else
			{
				trace("==== Shared Object doesn't exist, open instructions ====");
				openInstructions();
			}
			
			info.last_load = new Date();
		}
	}
	
		// AMFPHP - see if the user has already played the game. 
	    // If so, have a popup appear saying that they can only play once a day.
	    // Will be used in LandingPage.as
		public function checkIfPointGrabPlayed():void
		{
			trace("==== checkIfPointGrabPlayed() ====");
			var responderTwo:Responder = new Responder(gamePlayedReturn, gamePlayedError); // 
			Parameters.connection.call("CapriSun2011Service.PlaceStrawStatus", responderTwo);	
		}
		
		// If user has already played, have popup happen
		protected function gamePlayedReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("gamePlayedReturn result:",result);
			
			// Returns true if eligible
			if(result)
			{
				trace("=== User hasn't played Point Grab today ===");
				pointGrabAlreadyPlayedPopup.visible = false;
			}
			
			else
			{
				trace("=== User has already played Point Grab today ===");
				pointGrabAlreadyPlayedPopup.visible = true;
				trace (pointGrabAlreadyPlayedPopup.visible);		
			}
		}
		
		// What happens if the call fails
		protected function gamePlayedError(msg:Object):void
		{
			trace("gamePlayedError: ", msg.toString());
		}
	
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function init(pName:String = null):void
		{
			this.name = pName;	
		}
		
		// Used in Destination Control
		public function resetPage():void
		{
			// reset the page
			//arrow_mc.visible = false;
			
			straw_mc.y = 133;
			arrow_mc.y = 425;
			timer_txt.text = "10";
			target_mc.buttonMode = true;
			
			
			
			// If timer is still running when user clicks back button, turn it off
			if(myTimer)
			{
				myTimer.stop();
			}
			
			numOfClicks = 0;
			
			
			// reset Event Listeners
			target_mc.addEventListener(MouseEvent.CLICK, startPointGrab,false,0,true);
			target_mc.addEventListener(MouseEvent.CLICK, startTimer,false,0,true);
		}
		
		
		
		//----------------------------------------
		//	METHODS
		//----------------------------------------
		
		protected function setupListeners():void
		{
			// Links
			nick_btn.addEventListener(MouseEvent.CLICK,goToNickSite,false,0,true);
			respect_btn.addEventListener(MouseEvent.CLICK,goToCapriSite,false,0,true);
			
			//trace("WTF: "+pointGrabInstructionBtn);
			// Instruction Btn
			pointGrabInstructionBtn.addEventListener(MouseEvent.CLICK,openInstructionsFromButton,false,0,true);
			
			// Two event listeners - one for timer, one for the point grab game
			target_mc.addEventListener(MouseEvent.CLICK, startTimer,false,0,true);
			target_mc.addEventListener(MouseEvent.CLICK, startPointGrab,false,0,true);
			target_mc.buttonMode = true;
			
			// Close the welcome popup if it exists
			if(close_btn)
			{
				close_btn.addEventListener(MouseEvent.CLICK,closeIntroPopup,false,0,true);
			}
			
			// Instructions Popup
			// instructionsPopupMC.close_btn.buttonMode = true;
			// instructionsPopupMC.close_btn.addEventListener(MouseEvent.CLICK,closeInstructions,false,0,true);
			
			
			
		}
		
		private function startTimer(evt:MouseEvent):void
		{
			
			myTimer = new Timer(1000,10); // countdown from 9 to 0
			myTimer.addEventListener(TimerEvent.TIMER, countdown);
			myTimer.start();
			
			// tracking, make sure it only happens once
			ExternalInterface.call("window.top.sendADLinkCall('CapriSun2011 - Destination - Place the Straw')");
			//trace("=== PointGrab Start Tracking Added Here ===");	
				
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);	
			
			
		}
		
		private function countdown(event:TimerEvent):void {
			
			// countdown from 10 to 1, the text '10' is already on the stage
			timer_txt.text = String(10 - myTimer.currentCount); 
			
			
			//once counter has counted down
			if(myTimer.currentCount >= 10)
			{
				/*  Moved to the timerDone function
				target_mc.removeEventListener(MouseEvent.CLICK, clickTarget);
				target_mc.removeEventListener(MouseEvent.CLICK, startPointGrab);
				myTimer.stop();
				target_mc.buttonMode = false;
				*/
			}
				
		}
		
		private function timerDone(e:TimerEvent):void
		{
			trace("--------Timer finished!------");
			trace("Number of Clicks "+numOfClicks);
			// check how many times the user clicked the target, then award points
			
			// Used if/else since the switch statement was buggy
			if(numOfClicks <= 4)
			{
				// no points given
				getNeopoints(0);
				trace("Neopoints = 0");
			}
			
			else if(numOfClicks > 4 && numOfClicks <= 8)
			{
				getNeopoints(100);
				trace("Neopoints = 10");
			}
			
			else if(numOfClicks > 8 && numOfClicks <= 12)
			{
				getNeopoints(200);
				trace("Neopoints = 20");
			}
			
			else if(numOfClicks > 12 && numOfClicks <= 17)
			{
				getNeopoints(300);
				trace("Neopoints = 30");
			}
			
			else if(numOfClicks > 17 && numOfClicks <= 22)
			{
				getNeopoints(400);
				trace("Neopoints = 40");
			}
			
			else if(numOfClicks > 22 && numOfClicks <= 27)
			{
				getNeopoints(500);	
				trace("Neopoints = 50");
			}
			
			else if(numOfClicks > 27 && numOfClicks <= 33)
			{
				getNeopoints(600);	
				trace("Neopoints = 60");
			}
			
			else if(numOfClicks > 33 && numOfClicks <= 40)
			{
				getNeopoints(700);
				trace("Neopoints = 70");
			}
			
			else if(numOfClicks > 40 && numOfClicks <= 48)
			{
				getNeopoints(800);
				trace("Neopoints = 80");
			}
			
			else if(numOfClicks > 48 && numOfClicks <= 56)
			{
				getNeopoints(900);	
				trace("Neopoints = 90");
			}
			
			else if (numOfClicks > 56)
			{
				getNeopoints(1000);
				trace("Neopoints = 100");
				
			}
			
			else 
			{
				trace("Error in timerDone()");
			}
			
			
			
			target_mc.removeEventListener(MouseEvent.CLICK, clickTarget);
			
			target_mc.removeEventListener(MouseEvent.CLICK, startPointGrab);
			
			myTimer.stop();
			
			target_mc.buttonMode = false;
			
		}
			
			
	
	
		private function startPointGrab(evt:MouseEvent):void
		{
			target_mc.addEventListener(MouseEvent.CLICK, clickTarget,false,0,true);
			
			if(numOfClicks <= 1)
			 {
			   //Timer - make sure it doesn't restart when user clicks target after the first click	
				target_mc.removeEventListener(MouseEvent.CLICK, startTimer);
				
			}
			   
		}
		
		protected function clickTarget(evt:MouseEvent):void
		{
			numOfClicks++;
			moveArrow(evt);
			straw_mc.y += 2;
		}
		
		protected function goToCapriSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.respectthepouch.com");
			navigateToURL(request);	
			
			//amfphp
			var responder:Responder = new Responder(getCapriSiteReturn, getCapriSiteError);
			Parameters.connection.call("CapriSun2011Service.Activity", responder)
			
			
		}
		
		protected function goToNickSite(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.nick.com");
			navigateToURL(request);
			
			//amfphp
			var responder:Responder = new Responder(getNickSiteReturn, getNickSiteError);
			Parameters.connection.call("CapriSun2011Service.Activity", responder)
			
		}
		
		protected function getNickSiteReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("getNeopointsReturn result:",result);
		}
		
		// What happens if the call fails
		protected function getNickSiteError(msg:Object):void
		{
			trace("getNeopointsError: ", msg.toString());
		}
		
		protected function getCapriSiteReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("getNeopointsReturn result:",result);
		}
		
		// What happens if the call fails
		protected function getCapriSiteError(msg:Object):void
		{
			trace("getNeopointsError: ", msg.toString());
		}
		
		protected function goToPointGrabLogin(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.neopets.com/loginpage.phtml?destination=");
			navigateToURL(request);	
		}
		
		protected function goToPointGrabSignup(e:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("http://www.neopets.com/signup/index.phtml?");
			navigateToURL(request);	
		}
		
		/*
		protected function closePointGrabPopup(e:MouseEvent):void
		{
			pointGrabPopup.visible = false;
		}
		*/
		
		// Popup version
		protected function openInstructions():void
		{
			
			var tClass3:Class = LibraryLoader.getLibrarySymbol("instructionsPopup");
			instructionsPopupMC = new tClass3();	
			
			instructionsPopupMC.x = -8;
			instructionsPopupMC.y = 10;
			
			addChildAt(instructionsPopupMC,numChildren); 
			
			//instructionsPopupMC.close_btn.buttonMode = true;
			instructionsPopupMC.pointGrabClose_btn.addEventListener(MouseEvent.CLICK,closeInstructions,false,0,true);
			
		}
		
		// MouseClick version
		protected function openInstructionsFromButton(evt:MouseEvent):void
		{
			
			var tClass4:Class = LibraryLoader.getLibrarySymbol("instructionsPopup");
			instructionsPopupMC = new tClass4();	
			
			instructionsPopupMC.x = -8;
			instructionsPopupMC.y = 10;
			
			addChildAt(instructionsPopupMC,numChildren); 
			
			//instructionsPopupMC.close_btn.buttonMode = true;
			instructionsPopupMC.pointGrabClose_btn.addEventListener(MouseEvent.CLICK,closeInstructions,false,0,true);
			
		}
		
		// close from button click
		protected function closeInstructions(evt:Event):void
		{
			instructionsPopupMC.visible = false;
			ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
		}
		
		// close in shared object - popup close btn
		protected function closeInstructionsTwo():void
		{
			if(instructionsPopupMC != null)
			{
				instructionsPopupMC.visible = false;
			}
			
		}
		
		
		protected function closeIntroPopup(evt:Event):void
		{
			
			//welcome_mc.visible = false;	
			//close_btn.visible = false;	
			
		}
		
		
		// The number of clicks required to get points progresses as the timer counts down
		protected function moveArrow(evt:MouseEvent):void
		{
			// 5 Clicks ----------------------------------------
			// 10 points
			if (numOfClicks > 4 && numOfClicks < 8)
			{
				   //arrow_mc.visible = true;
				   arrow_mc.y = 410;
				   
			}
			
			// 20 points
			else if (numOfClicks > 8 && numOfClicks < 12)
			{
				arrow_mc.y = 378;
			}
			
			// 6 Clicks -----------------------------------------
			// 30 points
			else if (numOfClicks > 12 && numOfClicks < 17)
			{
				arrow_mc.y = 347;
			}
			
			// 40 points
			else if (numOfClicks > 17 && numOfClicks < 22)
			{
				arrow_mc.y = 312;
			}
			
			// 50 points
			else if (numOfClicks > 22 && numOfClicks < 27)
			{
				arrow_mc.y = 278;
			}
			
			
			// 7 Clicks ------------------------------------------
			// 60 points
			else if (numOfClicks > 27 && numOfClicks < 33)
			{
				arrow_mc.y = 244;
			}
			
			// 8 Clicks --------------------------------------------
			// 70 points 
			else if (numOfClicks > 33 && numOfClicks < 40)
			{
				arrow_mc.y = 214;
			}
			
			// 9 Clicks --------------------------------------------
			// 80 points
			else if (numOfClicks > 40 && numOfClicks < 48)
			{
				arrow_mc.y = 184;
			}
			
			
			// 90 points
			else if (numOfClicks > 48 && numOfClicks < 56)
			{
				arrow_mc.y = 155;
			}
			
			
			// Final --------------------------------------------
			// 100 points
			else if (numOfClicks > 56)
			{
				arrow_mc.y = 126;
			}
			
			else
			{
				//arrow_mc.y = 360;
			}
		}
		
		
		// Add points after timer ends
		protected function getNeopoints (strawPoints:int):void
		{ 
			var responder:Responder = new Responder(getNeopointsReturn, getNeopointsError); // needs two methods to check for success and failure
			 trace("----- STRAWPOINTS in getNeopoints(): "+strawPoints); // works here
			 
			 // Pass the number of points earned
			 Parameters.connection.call("CapriSun2011Service.PlaceStrawPoints", responder, strawPoints );
			 
			 // add popup with Neopoints here since it's not working in pointGrabStartReturn() 
			 pointGrabCompletePopup.visible = true;
			 pointGrabCompletePopup.pointGrabPoints_txt.text = String(strawPoints);
			 pointGrabCompletePopup.pointGrabCompleteClose_btn.addEventListener(MouseEvent.CLICK,closeCompletePopup,false,0,true);
		}
		
		
		// What happens if the call succeeds
		protected function getNeopointsReturn (msg:Object):void
		{
			var result:int = msg.result.valueOf();
			trace("getNeopointsReturn result:",result);
			trace("----- STRAWPOINTS in pointGrabStartReturn(): "+strawPoints); // Not working
			
			//addCompletePopup();  
			// strawPoints not being passed because local variable/
			
		}
		
		// What happens if the call fails
		protected function getNeopointsError(msg:Object):void
		{
			trace("getNeopointsError: ", msg.toString());
		}
		
		
		
		// calculate points and add popup - not working in pointGrabStartReturn() 
		protected function addCompletePopup():void
		{
			// add popup with Neopoints
			pointGrabCompletePopup.visible = true;
			
			//strawPoints not being passed for some reason
			trace("----- STRAWPOINTS in addCompletePopup: "+strawPoints)
			//pointGrabCompletePopup.pointGrabPoints_txt.text = String(strawPoints);
			
			//pointGrabCompletePopup.pointGrabCompleteClose_btn.addEventListener(MouseEvent.CLICK,closeCompletePopup,false,0,true);
			
			
		}
		
		
		protected function closeCompletePopup(evt:Event):void
		{
			pointGrabCompletePopup.visible = false;
			ExternalInterface.call("window.top.sendReportingCall('Main','CapriSun2011')");
			
		}
	
		
		
		/*
			Notes from Bruce about the CapriSun Service
		
			The overall service is called CapriSun2011Service
		
			For the Point Grab, there are two methods you need to call. 
		
			First, you need to call 
		    - PlaceStrawStatus()
		
			That will return true if the user hasn't already played for the day. 
			If the user has already played, it will return false.
		
			Assuming the first call returns true and the game starts playing, 
			then when the game is over and you want to award points 
		
			- PlaceStrawPoints(points)
		
			So for this one, you'll provide the points parameter and it will award the points. 
			It will return true if the points were awarded successfully.
		
			There is also another method you might want to call first. It is getStatus(). 
			This will return 3 true/false values about the user. 
			The second 2 are relative to the community challenge, but the first one tells you 
			if the user is logged in:
		
			1. logged_in
			2. prizes_pending (false if none, otherwise array of numeric weeks for pending prizes
			3. joined_stauts (whether or not they've joined the challenge)
	
		*/
		
		
		
	}
	
}