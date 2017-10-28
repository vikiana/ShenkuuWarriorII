/**
 *	The core portion of the slot machine
 *	Slot machine flow
 *	1) create slots (5), and create control panel(but invisible) (and other variables and classes)
 *	2) call for php request to retrieve initial set up (jackpot, user NP, etc.)
 *	3) once set, show the control panel and wait for user input
 *	4) when user input is made, mGameStatus (in controlPanel class) is updated
 *	5) if user clicks on play or max bet php request is called again to retrieve slot result
 *	6) once data is in, the slots are set accordingly and "roll" slot reels to show the result
 *	7) if own NP or bonus, appropriate animation follows
 *	8) wait for user input and repeat from step 4
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@Pattern SlotMachine
 **/
 
package com.neopets.games.inhouse.blackPawkeetSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
		
	import caurina.transitions.Tweener;
	import com.neopets.users.abelee.resource.mask.EasyMask;
	import com.neopets.users.abelee.resource.easyCall.QuickFunctions;
	import com.neopets.users.abelee.resource.bmd.BMDFollow;

	
	
	
	public class SlotMachineCore extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------		
		
		private var mMainGame:Object;
		private var mSlotArray:Array;	// array of slots
		private var mSlotContainer:MovieClip;	// where slots will be place at
		private var mControlPanel:ControlPanel;		// control panel for slot (bet, line, play, etc.)
		private var mGameStatus:Object;	// contains info regarding user input
		private var mSlotRequest:SlotRequestPHP;	//handles requesting php side of slot machine
		private var mResultProcessor:SlotResultXMLProcessor //
		private var mXMLResult:Object;	//object containing slot info for each round
		private var mLastRollArray:Array; //Array containing set of last result of slot roll
		private var mSlotRoller:SlotRoller; //in charge of rolling slots
		private var mSlotStopped:int;		//5 slot reels. All must stop to proseed to next turn/bet
		private var mLineManager:LineManager;	//show betting lines
		
				
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SlotMachineCore(pMainGame:Object):void
		{
			mMainGame = pMainGame;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		public function get slots():Array
		{
			return mSlotArray;
		}
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		/**
		 *	Start the main Slot game
		 *	Init top part initiates:
		 *	1) SlotRequestPHP: to deal with PHP url request
		 *	2) SlotResultsXMLProcessor: in charge of processing all XML that php request returns
		 *	3) Slot compoments
		 *		(slot roller, line manager (to show the betting  and winning lines), backgrounds)
		 *	4) ControlPanel: Main UI component (buttons, bets, lines, score/number displays, etc.)
		 *	5) Message board: popup message borad for error reports, winning messages, etc.
		 *	
		 *	Once all features are set, it calls for starup phprequest to retrieve user info.
		 * 	Upon receiving the data, it start the game (or throws an eror if not logged in)
		 **/
		public function init(pSlots:int = 5):void
		{
			var xml:XMLList = mMainGame.configXML.GAME
			var itemWidth:Number = Number(xml.ArtAssetSize.@itemWidth);
			var itemHeight:Number = Number(xml.ArtAssetSize.@itemHeight);
			
			//set up php requestor
			mSlotRequest = new SlotRequestPHP (mMainGame);
			mSlotRequest.addEventListener("phpReqeustIsIn", processPHPrequest)
			
			// class that will break down xml (from server side)
			mResultProcessor = new SlotResultXMLProcessor ()
			mXMLResult = new Object();
			
			//class that will roll the slots
			mSlotRoller = new SlotRoller (mMainGame)
			
			//container where all slots are in
			mSlotContainer = new MovieClip
			mSlotContainer.x = 85;
			mSlotContainer.y = 375;
			mSlotStopped = 0;
			mSlotArray = new Array();
			
			//line manager--shows lines when selecting lines and when won
			mLineManager = new LineManager (itemWidth,itemHeight)
			mLineManager.x = mSlotContainer.x
			mLineManager.y = mSlotContainer.y - itemHeight * 3
			mLineManager.makeLine(1)
			
			createSlots(pSlots);
			mSlotRoller.addEventListener("rollCompleted", handleEndOfRound)
			
			//background
			var slotsBg:MovieClip
			if (xml.hasOwnProperty("slotBackground"))
			{
				var slotsBgClass:Class = mMainGame.assetInfo.getDefinition(xml.slotBackground.@className) as Class;
				slotsBg = new slotsBgClass ();
				slotsBg.x = Number(xml.slotBackground.@x);
				slotsBg.y = Number(xml.slotBackground.@y);
			}
			
			//slot shade
			var slotsShade:MovieClip
			if (xml.hasOwnProperty("slotShade"))
			{
				var slotsShadeClass:Class = mMainGame.assetInfo.getDefinition(xml.slotShade.@className) as Class;
				slotsShade = new slotsShadeClass ();
				slotsShade.x = Number(xml.slotShade.@x);
				slotsShade.y = Number(xml.slotShade.@y);
			}
			
			//frame
			var slotMachineFrame:MovieClip
			if (xml.hasOwnProperty("slotFrame"))
			{
				var slotMachineFrameClass:Class = mMainGame.assetInfo.getDefinition(xml.slotFrame.@className)as Class;
				slotMachineFrame = new slotMachineFrameClass ();
				slotMachineFrame.x = Number(xml.slotFrame.@x);
				slotMachineFrame.y = Number(xml.slotFrame.@y);
			}
			
			//add child in necessary order
			if (slotsBg != null )addChild(slotsBg);
			addChild(mLineManager);
			addChild(mSlotContainer);
			if (slotsShade != null )addChild(slotsShade);
			if (slotMachineFrame != null )addChild(slotMachineFrame);
			createControlPanel();
			mControlPanel.visible = false
			
			//create message board
			createMessageBoard();
			
			//show "loading personal settings" message
			showMessageBoard(mMainGame.system.getTranslation("IDS_GAME_MESSAGE_SETUP"), false) 
			mSlotRequest.requestStartupStats()
		}
		
		
		// there is no end game button but in case for the future
		public function cleanup():void
		{
			
			mControlPanel.removeEventListener("statusUpdate", checkForUserInput)
			mControlPanel.cleanup();
			
			for (var i in mSlotArray) 
			{
				mSlotArray[i].cleanup()
			}
			
			mLineManager.cleanup();
						
			var util:QuickFunctions = new QuickFunctions();
			util.removeChildren(mSlotContainer)
			
			util.removeChildren(this)
			util = null;
			
			mSlotArray = null;
			mSlotContainer = null;
			mControlPanel = null;
			mGameStatus = null;
			
			mXMLResult = null;
			mLastRollArray = null;
			mSlotRoller = null;
			mLineManager = null;
			
		}
			
	
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		////
		//	reset all the slots.  If the previous result exists then reset the slots 
		//	with previous result showing at the beginning  
		//
		//	@PARAM		initialArray		Array of previous result from php
		////
		private function resetSlots(initialArray:Array = null):void
		{
			for (var i in mSlotArray)
			{
				var slot = mSlotArray[i]
				initialArray != null ? slot.resetSlot(initialArray[i]): slot.resetSlot();
			}
		}
		
		////
		//	creates a message board.
		//	@NOTE: The message board is never removed simply visibility is turned on of off once created
		////
		private function createMessageBoard():void
		{
			var messageBoardClass:Class = mMainGame.assetInfo.getDefinition("MessageBoard")as Class;
			var messageBoard = new messageBoardClass ();
			messageBoard.x = 325;
			messageBoard.y = 250;
			messageBoard.name = "messageBoard"
			mMainGame.setText("headerFont", 
							  messageBoard.button.btnText, 
							  mMainGame.system.getTranslation("IDS_GAME_BUTTON_CLOSE")
							  )
			messageBoard.button.buttonMode = true;
			messageBoard.button.btnText.mouseEnabled = false
			messageBoard.button.button.mouseEnabled = false
			messageBoard.button.button.gotoAndStop("out")
			addChild(messageBoard)
			messageBoard.visible = false
		}
		
		
		////
		// 	make message board visible
		//
		//	@PARAM		mssg		Text that'll be shown
		//	@PARAM		buttonOn	When set true, additional board area and a "close" button will show up
		////
		private function showMessageBoard(mssg:String, buttonOn:Boolean):void
		{
			var mb:MovieClip = getChildByName("messageBoard") as MovieClip
			mb.visible = true
			
			
			mMainGame.setText("bodyFont", mb.messageText, mssg)
			if (buttonOn)
			{
				mb.button.visible = true
				mb.extrabg.visible = true;
				mb.button.addEventListener(MouseEvent.MOUSE_DOWN, closeMessageBoard)
				mControlPanel.visible = false
			}
			else 
			{
				mb.button.visible = false
				mb.extrabg.visible = false;
				mGameStatus.abled = false
			}
		}
		
		
		////
		//	creates slots
		//
		//	@PARAM 		pSlots		Number of slots
		////
		private function createSlots(pSlots:int):void
		{
			var itemWidth:Number = Number(mMainGame.configXML.GAME.ArtAssetSize.@itemWidth);
			var itemHeight:Number = Number(mMainGame.configXML.GAME.ArtAssetSize.@itemHeight);
			
			var maskX:Number =  -itemWidth //* .5;
			var maskY:Number = itemHeight * .5;
			var maskWidth:Number = itemWidth * 2
			var maskHeight:Number = -itemHeight * 3
			var stackArray:Array = mMainGame.configXML.GAME.gameSetup.@slot.split("||")
			for (var i:int = 0; i < pSlots; i++) {
				var slot:Slot = new Slot (mMainGame, i * itemWidth, 0, stackArray[i]);				
				// Each slot needs its own mask.  Otherwise slot MC is too bit to apply filters
				var slotMask:EasyMask = new EasyMask (
													  mSlotContainer, 
													  slot, 
													  i * itemWidth + maskX, 
													  maskY, 
													  maskWidth, 
													  maskHeight
													  )	
				slotMask.name = "slotMask" + i
				slot.name = i.toString()
				mSlotArray.push(slot)
				mSlotContainer.addChild(slot)
			}
		}
		
	
		//create control panel
		private function createControlPanel():void
		{
			mControlPanel = new ControlPanel (mMainGame);
			mGameStatus = mControlPanel.gameStatus
			addChild(mControlPanel)
			mControlPanel.addEventListener("statusUpdate", checkForUserInput)
		}
		
		//if there is any win, show wins
		private function showWins():void
		{
			if (mXMLResult.hasOwnProperty("winIndicator"))
			{
				var winArray:Array = mXMLResult.winIndicator
				if (winArray.length > 0) 
				{
					mMainGame.playThisSound(mMainGame.soundBank.winLong,mMainGame.soundOn);
					for (var i:String in winArray)
					{
						var winningLine:int = winArray[i][0]
						var matchItems:int = winArray[i][1]
						mLineManager.makeLine(winningLine)
						WinIndicator.showWins(winningLine,matchItems,mSlotArray)
					}
				}
			}
		}
		
		//if win (itmes are playing animation) stop the win animation on items
		private function stopWins():void
		{
			trace ("stopWins")
			if (mXMLResult.hasOwnProperty("winIndicator"))
			{
				var winArray:Array = mXMLResult.winIndicator
				//var winIndicator:WinIndicator = new WinIndicator ();
				if (winArray.length > 0)
				{
					for (var i:String in winArray)
					{
						var winningLine:int = winArray[i][0]
						var matchItems:int = winArray[i][1]
						WinIndicator.stopWins(winningLine, matchItems, mSlotArray);
					}
				}
			}
		}
		
		//not used but here for future purposes
		private function endGame():void
		{
			dispatchEvent(new Event ("endGame"));
		}
		
		//shoot pawkeets up from the bottom when this bonus is active
		private function handlePawkeetBonus(num:int):void
		{	
			if (num > 0)
			{
				var xml:XMLList = mMainGame.configXML.GAME
				var pawkeetBonusMC:MovieClip = new MovieClip ();
				pawkeetBonusMC.name = "pBonus"
				var pawkeetBonusItem:String = xml.ArtAssetItems.@pawkeetBonus;
				var itemClass:Class = mMainGame.assetInfo.getDefinition(pawkeetBonusItem)
				var centerPoint:Number = Number(xml.gameSetup.@width) / 2
				var startingPoint:Number = centerPoint - (Number(xml.ArtAssetSize.@itemWidth) * num / 2) + Number(xml.ArtAssetSize.@itemWidth) /2
				var endPointY:Number = - Number (xml.ArtAssetSize.@itemHeight)
				
				
				for (var i:int = 0; i < num ; i++)
				{
					var item:MovieClip = new itemClass ();
					
					item.x = startingPoint + i * item.width
					item.y = Number(xml.gameSetup.@width) + Number(xml.ArtAssetSize.@itemHeight)
					Tweener.addTween(item, {y:endPointY, time:10, onComplete:removePawkeetBonus})
					pawkeetBonusMC.addChild(item)		
				}
				
				addChild(pawkeetBonusMC)
				
			}
		}
		
		//remove pawkeet bonus
		private function removePawkeetBonus():void
		{	var pawkeetBonusMC:MovieClip = getChildByName("pBonus") as MovieClip
			if ( pawkeetBonusMC!= null)
			{
				var util:QuickFunctions = new QuickFunctions();
				util.removeChildren(pawkeetBonusMC)
				removeChild(pawkeetBonusMC)
			}
		}
		
		// should user win treasure bonus, show it on the message board
		private function handleTreasureBonus(array:Array):void 
		{
			var type:String = array[0]
			var bonusMessage:String = array[1]
			var messageBoard:MovieClip = getChildByName("messageBoard") as MovieClip
			switch (type)
			{
				case "none":
				//do nothing
				break;
				
				case "dubloon":
				showMessageBoard(bonusMessage, false)
				Tweener.addTween(
								 messageBoard, 
								 {
									 scaleX:.5 , 
									 scaleY:.5, 
									 alpha:0, 
									 time:.8, 
									 delay:1.5,
									 onComplete:closeMessageBoard
								 }
								);
				break;
				
				case "np":
				showMessageBoard(bonusMessage, false)
				Tweener.addTween(
								 messageBoard, 
								 {
									 scaleX:.5 , 
									 scaleY:.5, 
									 alpha:0, 
									 time:.8, 
									 delay:1.5, 
									 onComplete:closeMessageBoard
								 }
								);
				break;
			}
		}
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		//hide message board
		private function closeMessageBoard(evt:MouseEvent = null):void
		{
			var mb:MovieClip = getChildByName("messageBoard") as MovieClip
			mb.visible = false
			mb.scaleX = mb.scaleY = 1
			mb.alpha = 1
			mb.button.removeEventListener(MouseEvent.MOUSE_DOWN, closeMessageBoard)
			mControlPanel.visible = true
			mGameStatus.abled = true
			mGameStatus.playSlot = false

		}
		
		////
		//	after php XML is processed via slotResultXMLprocessor and data is placed into an object
		//	It takes the result and takes appropriate actions
		////
		private function processPHPrequest(evt:Event):void
		{
			mXMLResult = mResultProcessor.processXML(mSlotRequest.slotResult)
			if (mXMLResult.error)
			{
				showMessageBoard(mXMLResult.message, true)
			}
			else if (mXMLResult.setup)
			{
				mGameStatus.np = mXMLResult.userNP
				mGameStatus.jackpot = mXMLResult.jackpot
				mControlPanel.updateJackpot();
				mControlPanel.updateNp();
				mGameStatus.abled = true
				mControlPanel.visible = true
				closeMessageBoard();
			}
			else
			{
				mLineManager.cleanup();
				mGameStatus.np = mGameStatus.np - mGameStatus.totalBet;
				mControlPanel.updateNp();
				mGameStatus.abled = false;
				mGameStatus.playSlot = false;
				
				if (mLastRollArray != null) 
				{
					resetSlots(mLastRollArray)
				}
				
				mLastRollArray = mXMLResult.slotResult 
				
				for (var i in mSlotArray) 
				{
					var slot = mSlotArray[i];
					slot.substitudeFromLast(mXMLResult.slotResult[i]);
					mSlotRoller.rollReel(slot, 3+(i* .3));
				}
				if (mMainGame.soundOn)
				{
					mMainGame.changeThisVolume(mMainGame.soundBank.bg, .15);
				}
				mMainGame.playThisSound(mMainGame.soundBank.roll,mMainGame.soundOn, true);
				mMainGame.system.sendTag("Game Started");
			}
		}
		
		////
		// every time users interacts with control panel, this function is called and acts accordingly
		////
		private function checkForUserInput(evt:Event):void
		{
			trace ("user input made")
			if (mGameStatus.abled)
			{
				//no matter what, update lines
				removePawkeetBonus()
				mLineManager.cleanup();
				stopWins();
				for (var i:int = 0; i < mGameStatus.lines; i++)
				{
					mLineManager.makeLine(i + 1)
				}				
				if (mGameStatus.gameEnd)
				{
					endGame();
				}
				else if (mGameStatus.playSlot)
				{
					trace ("play the slot")
					mGameStatus.abled = false
					mSlotRequest.returnResult(mGameStatus.bet, mGameStatus.lines)
				}
			}
		}

		////
		// When all slot reels come to a stop and the results are down, this updates various numbers
		// and show winning lines and play animation, etc.
		////
		private function handleEndOfRound(evt:Event):void
		{
			mSlotStopped ++
			if (mSlotStopped == mSlotArray.length) 
			{
				trace ("all slots stopped rolling")
				if (mMainGame.soundOn)
				{
					mMainGame.changeThisVolume(mMainGame.soundBank.bg, .3);
				}
				mMainGame.stopThisSound(mMainGame.soundBank.roll);
				mSlotStopped = 0
				mGameStatus.won = mXMLResult.pointsWon
				mGameStatus.np = mXMLResult.userNP
				mGameStatus.jackpot = mXMLResult.jackpot
				mControlPanel.updateWon();
				mControlPanel.updateJackpot();
				mControlPanel.updateNpInTime();
				mGameStatus.abled = true
				if (int(mXMLResult.pointsWon) > 0)handlePawkeetBonus(mXMLResult.pawkeetBonus);
				handleTreasureBonus(mXMLResult.treasureBonus)
				showWins();
				mMainGame.system.sendTag("Game Finished");
			}
		}
	}
	
}