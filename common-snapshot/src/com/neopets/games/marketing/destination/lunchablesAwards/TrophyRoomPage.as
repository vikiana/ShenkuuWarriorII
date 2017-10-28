/**
 *	TROPHY ROOM PAGE  - COLLECTION QUEST
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli / Abraham Lee
 *	@since  09.19.2009
 */

package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.kidCuisine.pcCollectionQuest.*;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.external.ExternalInterface;
	
	public class TrophyRoomPage extends AbstractPageCustom
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		//events
		public static const TROPHY_FOUND:String = "trophy_found";
		
		//copy
		private const INSTRUCTIONS_MESSAGE:String = "Help find the Golden LUNCHABLES Awards! Five Trophies have been lost around the Red Carpet destination. Find all five trophies and win a jackpot of Neopoints! ";
		private const PLEASE_LOGIN_MESSAGE:String = "Please log in to your Neopets account to access this section";
		private const CONGRATULATIONS_ROLLOVER:String = "Good job! You've found this trophy!";
		private const CONGRATULATIONS_MESSAGE:String = "Congratulations, you've found a trophy!";
		private const CONGRATULATIONS_MESSAGE_FINAL:String = "Congratulations, you've found all the missing trophies! You've been awarded 1500 Neopoints for having completed this quest.";
		private const QUESTFINSHED_MESSAGE:String = "The trophies have all been found. Thanks for helping!";
		//layout
		private const TY:Number = 138;
		
		//----------------------------------------
		//	VARIABLES
		//---------------------------------------
		private var _loggedIn:Boolean = false;
		//TRACKING
		private var mNickClickID:int			//click id used to track users clicking on "goto nick.com"
		private var mDoubleClickID:String		//third party tracking
		//DATABASE
		private var mUserName:String;
		private var mDatabaseID:String;
		private var mDatabase:LADatabase;
		
		private var _trophies:Array = ["t1","t2", "t3", "t4", "t5"];
		private var _emptytrophies:Array = ["te1","te2", "te3", "te4", "te5"];
		private var _tXpos:Array = [229,299, 376,450, 522];
		//gets populated by the DB everytime the page loads
		private var _foundTrophies:Array = [];
		private var _dbData:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TrophyRoomPage(pName:String = null, pView:Object = null, pUserName:String = null, pID:String = null):void
		{
			super(pName, pView);
			mUserName = pUserName;
			mDatabaseID = "TYPE14ITEM1651" //pID;

			if (mUserName == "GUEST_USER_ACCOUNT")
			{
				setupPage();
				setupInstructionBox(PLEASE_LOGIN_MESSAGE);
			} else {
				_loggedIn = true;
				setupDatabase();
			}
			runJavaScript2("Trophy Room");
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			var btn:MovieClip;
			addImageButton("GLAwardsLogo_button", "logoButton", 254, -30);
			btn = this.getChildByName("logoButton") as MovieClip;
			btn.scaleX = btn.scaleY = 1.4;
			//Trophy stand
			addImage("TrophyStandPage", "trophyStandPage", 194, 158);
			//add trophies mcs according to database data
			var found:Boolean;
			for (var i:int = 0; i < _trophies.length; i++)
			{
				found = false;
				for (var j:int=0; j<_foundTrophies.length;j++)
				{
					if (_trophies[i] == _foundTrophies [j]){
						addImageButton ("Trophy_button",_trophies[i] , _tXpos[i], TY);
						found = true;
					}
				}
				if (!found){
					addImageButton ("Trophy_empty_button",_emptytrophies[i] , _tXpos[i], TY+20);
				}
			}
			
			
			//add big trophy-boy
			addImage("GLABoy_mc", "GLAboy",602, 130);
			btn = this.getChildByName("GLAboy") as MovieClip;
			btn.scaleX = btn.scaleY = 0.7;

		}
		
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------

		//setup separate data base to check if it's user's first time visiting this page
		private function setupDatabase():void
		{
			trace (this+"Data base kick in")
			mDatabase = new LADatabase (mUserName, mDatabaseID)
			mDatabase.addEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate, false, 0, true);
			//mDatabase.resetVars();
			mDatabase.myInit();
			
		}
		
		private function setupInstructionBox(messageText:String):void
		{
			if (getChildByName("message") == null)
			{
				addImage ("message", "message", 200, 356);
				addTextBox("LASmallTextBox", "textBox",messageText, 235, 384, 337, 100);
			}
		}
	
	
		
		private function setupErrorMessage(mMessage:String):void
		{
			var popup:PopupSimple = new PopupSimple(mMessage, 80, 100);
			addChild(popup)
		}

		
		//----------------------------------------
		//	EVENT HANDLERS
		//----------------------------------------
		private function setUpListeners(e:Event=null):void {
			if (!mView.hasEventListener(TROPHY_FOUND)){
				mView.addEventListener(TROPHY_FOUND, updateDatabaseWithTrophy);
			}
		}
		
		
		private function handleDatabaseUpdate (evt:Event):void
		{
			//trace (this+" - Opening Page DB info received: setting up page");
			mDatabase.removeEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate);
			
			
			_dbData = evt.target.objData;
			
			//create array of found trophies
			for each (var str:String in _dbData){
				if (str){
					if (str.charAt(0) == "t" && str.charAt(1) != "r"){
						_foundTrophies.push (str);
					}
				}
				trace ("found trophies array",_foundTrophies)
			}
			//trace ("found trophies array from db check"+_foundTrophies);
			setupPage ();
			
			//trace ("CHECKING IS NEW TROPHIES ARE FOUND"+_dbData.trophyFound+", "+typeof(_dbData.trophyFound));

			//trace ("found?"+found);
			if (_dbData.trophyFound=="true"){
				if (_foundTrophies.length >= 5)
				{
					setupInstructionBox(CONGRATULATIONS_MESSAGE_FINAL)
					//awards Neopoints
					NeoTracker.sendTrackerID(15048);
					mDatabase.endQuestSetup();
				} else {
					setupInstructionBox(CONGRATULATIONS_MESSAGE);
					mDatabase.removeEventListener(mDatabase.ACTION_CONFIRMED, setUpListeners);
					mDatabase.resetTrophyFound();
				}
			} else if (_dbData.trophyFound =="false") {
				//trace ("NO NEW TROPHY FOUND");
				setupInstructionBox(INSTRUCTIONS_MESSAGE);
				//the quest will work only after the trophy room has been visited at least one time and got the instructions?
				setUpListeners();
			} else if (_dbData.trophyFound == "finished"){
				setupInstructionBox(QUESTFINSHED_MESSAGE);
			}else {
				setupInstructionBox(INSTRUCTIONS_MESSAGE);
				setUpListeners();
			}
		}

		
		private function updateDatabaseWithTrophy(e:CustomEvent):void {
			trace (this+" - Updating Database with found trophy"+e.oData.tName);
			mDatabase.updateTrophiesDatabase(e.oData.tName);	
			switch (e.oData.tName){
				case "superstar":
					
				break;
				case "helper":
					
				break;
				case "artist":
					
				break;
				case "brain":
					
				break;
				case "action":
					
				break;
			}
		}



		//MOUSE EVENTS - 9/29 - Marketing asked that the main popups links be removed
		protected override function handleMouseOver(evt:MouseEvent):void
		{
			if (_loggedIn == true){
				if (evt.target.name == "btnArea")
				{
					var mc:MovieClip = evt.target as MovieClip
					if (!mc.buttonMode) mc.buttonMode = true;
					MovieClip(mc.parent).gotoAndStop("over")
					//trace (mc.parent+" mouse over");
					//MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)]
					//uglieeeeeeee!! FIX sintax
					switch (MovieClip(mc.parent).name)
					{
						case "te1":
						//MovieClip(mc.parent).hintBubble.bubble.alpha = 0;
							MovieClip(mc.parent).hintBubble.bubble.myText.text = "You can find more than trivia in this game.";
						break;
						case "te2":
							MovieClip(mc.parent).hintBubble.bubble.myText.text = "Spot the difference -- this trophy doesn't belong.";
						break;
						case "te3":
							MovieClip(mc.parent).hintBubble.bubble.myText.text = "This trophy got its own Behind the Scenes pass.";
						break;
						case "te4":
							MovieClip(mc.parent).hintBubble.bubble.myText.text = "This trophy was sent to the Red Carpet early.";
						break;
						case "te5":
							MovieClip(mc.parent).hintBubble.bubble.myText.text = "Trophies don't get hungry, but Neopets do.";
						break; 
						default:
							 if (MovieClip(mc.parent).hintBubble){
							 	MovieClip(mc.parent).hintBubble.bubble.myText.text = CONGRATULATIONS_ROLLOVER;
							 }
						break;
					}
				}
			}
		}
		
				
		//Trophies clicks are handled at the control level
		override protected function handleObjClick(e:CustomEvent):void
		{
			trace ("    FROM ABS PAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)
			var objName:String = e.oData.DATA.parent.name;
			
			//if clicked obj is post card, handle it how the hint
			if (objName.substr(0, 2) == "pc")
			{
				//showHint(MovieClip(e.oData.DATA.parent), mXML.myObject.myError,  mXML.myObject.errorMessage)
			}
			else 
			{
				switch (objName)
				{
					/*case "trophyStandButton":
						//setupChallengeCard(mXML.myObject.myError,  mXML.myObject.errorMessage)
						break;*/
					
					case "logoButton":
						NeoTracker.processClickURL(15038);
						//NeoTracker.triggerTrackURL(mDoubleClickID)
						//NeoTracker.sendTrackerID(mNickClickID)
						//gotoNickPage()
					break;
					
				}
			}
		}
		
		
		//Omniture
		private function runJavaScript2(scriptID:String):void
		{

			trace (this+" run javascript"+scriptID);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("sendReportingCall", scriptID,"Lunchables");
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JaraScript")
				}
			}
		}
		
	}
	
}