/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.games.marketing.destination.kidCuisine.pcCollectionQuest.*;
	import com.neopets.games.marketing.destination.kidCuisine.challengeCard.AS3CardSender;
	import com.neopets.games.marketing.destination.kidCuisine.KidDatabase;
	import com.neopets.util.events.CustomEvent;
	import caurina.transitions.Tweener;
	import com.neopets.projects.destination.destinationV2.NeoTracker
	
	public class PageQuest extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		private const PC_RELEASED:String = "postcard_released";
		private const PC_INACTIVE:String = "postcard_inactive";
		private const PC_FOUND:String = "postcard_found";
		private const PC_CLAIMED:String = "postcard_claimed";
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mPHP:PHPRequest;
		private var mXML:XMLProcessor;
		//private var mStartUpURL:String = "http://dev.neopets.com/sponsors/kidcuisine/service.php?method=startup"
		private var mStartUpURL:String = "/sponsors/kidcuisine/service.php?method=startup"
		private var mNickURL:String		//to jump to nickURL from hint box
		
		private var mPostcardsArray:Array;
		
		private var mHint:PopupHint
		private var mHintX:Number = 200;
		private var mHintY:Number = 100;
		private var mUserName:String
		private var mDatabaseID:String
		private var mNickClickID:int	//click id used to track users clicking on "goto nick.com"
		private var mDoubleClickID:String		//third party tracking
		private var mDatabase:KidDatabase
		
		private var mCardName:Array = ["pc1","pc2","pc3","pc4","pc5","pc6","pc7","pc8","pc9","pc10","pc11","pc12","pc13","pc14","pc15"]
		
		private var mOverview:String = "KC is zooming through space and Neopia and Nick.com on his search for amazing food, and he's leaving planetary postcards on all the pages that he's visited. Join the hunt for KC's postcards and you can win great prizes!"
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageQuest(pName:String = null, pView:Object = null, pUserName:String = null, pID:String = null):void
		{
			super(pName, pView);
			mUserName = pUserName;
			mDatabaseID = pID
			setVars()
			setupDatabase()
			loaderSetup();
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
			addImage("PostCardPage", "postCardPage");
			setupHintPopup();
			mHint.hide();
			if (mUserName == "GUEST_USER_ACCOUNT")
			{
				colorTransform()
				var nickBtn:MovieClip = MovieClip(getChildByName("postCardPage")).gotoNick;
				var loginNick:MovieClip  =MovieClip(getChildByName("postCardPage")).loginNick;
				nickBtn.visible = false
				loginNick.visible = false
			}
			else
			{
				setupData();
			}
			
			
		}
		
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				
				//Mouse over or out shouldn't change filters on post cards (colorTransform filters applied)
				if (mc.parent.name.substr(0, 2) != "pc")
				{
					MovieClip(mc.parent).gotoAndStop("over")
					MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 5), new GlowFilter(0x3399FF, 1, 8, 8, 5, 5)]
				}
			}
		}
	
		override protected function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (mc.parent.name.substr(0, 2) != "pc")
				{
					MovieClip(mc.parent).gotoAndStop("out")
					MovieClip(mc.parent).filters = null
				}
			}
		}
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//setup separate data base to check if it's user's first time visiting this page
		private function setupDatabase():void
		{
			trace ("data base kick in")
			mDatabase = new KidDatabase (mUserName, mDatabaseID)
			mDatabase.addEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate, false, 0, true)
			mDatabase.myInit()
		}
		
		
		private function handleDatabaseUpdate (evt:Event):void
		{
			trace ("do something with database")
			if (mDatabase.firstTime == "true")
			{
				setupInstructionBox()
			}
			else if (mDatabase.firstTime == "false")
			{
				//move on
				trace ("moving on")
				mDatabase.removeEventListener(mDatabase.ACTION_CONFIRMED, handleDatabaseUpdate);
				mPHP.addEventListener(mPHP.RESULT_RECEIVED, handlePHPResult);
				mPHP.processURL(mStartUpURL);
			}
		}
		
		private function onCloseOverviewPopup(evt:Event):void
		{
			mDatabase.updateDatabase()
			if (mUserName == "GUEST_USER_ACCOUNT")
			{
				mPHP.addEventListener(mPHP.RESULT_RECEIVED, handlePHPResult);
				mPHP.processURL(mStartUpURL);
			}
		}
		
		private function setupInstructionBox():void
		{
			if (getChildByName("overviewPopup") == null)
			{
				var simplePopup:PopupSimple = new PopupSimple ("", 80, 100);
				simplePopup.name = "overviewPopup"
				simplePopup.updateText (mOverview, 500)
				simplePopup.addEventListener(simplePopup.CLOSE_BUTTON, onCloseOverviewPopup)
				addChild (simplePopup)
			}
		}
		
		
		
		
		private function setVars():void
		{
			mPHP = new PHPRequest ();
			mXML = new XMLProcessor();
		}
		
		private function loaderSetup():void
		{
			addImage("Preloader", "loaderSign", 390, 265)
		}
		
		
		//parces xml and retrieves relative data (including error/login check)
		private function setupData():void
		{
			var dataObj:Object = mXML.myObject
			
			// if user not logged in, how error
			if (dataObj.myError)
			{
				setupErrorMessage(dataObj.errorMessage)
				colorTransform();
				var nickBtn:MovieClip = MovieClip(getChildByName("postCardPage")).gotoNick
				nickBtn.visible = false
			}
			//else show pop up if user has unclaimed gift. and show user postcards status
			else 
			{
				checkForUnclaimedCard()
				mPostcardsArray = dataObj.postcardsArray.concat(dataObj.inactiveArray);
				var latestCard:Array = dataObj.postcardsArray[dataObj.postcardsArray.length -1];
				setupHintBox(latestCard);
				setupPostcardStatus(dataObj.postcardsArray, dataObj.inactiveArray);
				
			}
		}
		
		//If there are unclaimed gifts, show the popup
		private function  checkForUnclaimedCard(pRepeat:Boolean = false):void
		{
			var postcardsArray:Array = mXML.myObject.postcardsArray
			var lastFoundCard:Array = null

			for (var i:String in postcardsArray)
			{
				if (postcardsArray[i][2] == 1 && postcardsArray[i][3] == 0)
				{
					lastFoundCard = postcardsArray[i]
				}
			}
			
			if (lastFoundCard != null)
			{
				setupClaimPopup(lastFoundCard, pRepeat)
			}
			else if (mXML.myObject.finalPrizeOn)
			{
				//trace ("final prize is on", mXML.myObject.finalPrizeArray)
				setupClaimPopup(mXML.myObject.finalPrizeArray, pRepeat, true)
			}
		}
		
		
		// create popup to claim unclaimed prize
		private function setupClaimPopup(pCard:Array, pRepeat:Boolean, pFinalPrize:Boolean = false):void
		{
			var prizePopup = new PopupClaimPrize (pCard, 100, 110,pRepeat, pFinalPrize);
			prizePopup.addEventListener(prizePopup.RESULT_IN, handleResultIn)
			prizePopup.addEventListener(prizePopup.POPUP_CLOSED, checkForCardStatus)
			addChild(prizePopup)
		}
		
		
		// reflect postcards' status accordingly
		private function setupPostcardStatus(pActiveCardArray:Array, pInactiveCardArray:Array):void
		{
			//for active ones
			var id:int;
			trace (pActiveCardArray.length)
			for (var j:String in pActiveCardArray)
			{
				id = int(pActiveCardArray[j][1])
				var stat:String = PC_RELEASED
				if (int(pActiveCardArray[j][2]) == 1 && int(pActiveCardArray[j][3]) == 0)
				{
					stat = PC_FOUND
				}
				else if (int(pActiveCardArray[j][2]) == 1 && int(pActiveCardArray[j][3]) == 1)
				{
					stat = PC_CLAIMED
				}
				setPostcard(id, stat)
			}
			
			// for inactives ones
			for (var i:String in pInactiveCardArray)
			{
				id = int(pInactiveCardArray[i][1])
				setPostcard(id, PC_INACTIVE)
			}
		}
		
		private function setupHintBox(pArray:Array):void
		{
			var textBox:MovieClip = MovieClip(getChildByName("postCardPage")).hintTextBox;
			var nickBtn:MovieClip = MovieClip(getChildByName("postCardPage")).gotoNick;
			var loginNick:MovieClip  =MovieClip(getChildByName("postCardPage")).loginNick;
			
			textBox.myText.text = pArray[5]
			//check if it's for nick, if so crate nick.com button
			if (pArray[6] != undefined)
			{
				mNickURL = pArray[6];
				mNickClickID = setNickClickID(int(pArray[1]));
				mDoubleClickID = setDoubleClickURL(int(pArray[1]))
						
				nickBtn.visible = true;
				loginNick.visible = true;
			}
			else 
			{
				nickBtn.visible = false;
				loginNick.visible = false;
				
			}
			
		}
		
		private function setupErrorMessage(mMessage:String):void
		{
			var popup:PopupSimple = new PopupSimple(mMessage, 80, 100);
			addChild(popup)
		}
		
		
		private function setupHintPopup():void
		{
			mHint = new PopupHint("text", mHintX, mHintY);
			addChild(mHint)
		}
		
		
		/**
		 *	When hover overing postcards, show the pop up accordingly
		 *	@PARAM		pPostCard		MC			postcard mouse clicked
		 *	@PARAM		pError			Boolean		If user not logged in error is set to true via xml
		 *	@PARAM		pMessage		String		Should there be error, this message will be shown
		 **/
		private function showHint(pPostCard:MovieClip, pError:Boolean, pMessage:String):void
		{
			// place the pop up where post card is at
			mHint.hide();
			mHint.nickBtnOn(false)
			mHint.x = pPostCard.x -30;
			mHint.y = pPostCard.y -30;
			mHint.scaleX = mHint.scaleY = .3
			mHint.show()
			
			
			var hintText:String
			if (pError)
			{
				hintText = pMessage
			}
			else 
			{
				// extract postcard's number from its name and retrieve data from the postcard array
				var cardNum:int = int(pPostCard.name.substr(2, pPostCard.name.length))
				var postcardData:Array = mPostcardsArray[cardNum - 1]
				
				
				// check if post card is active 
				if (postcardData[0])
				{
					hintText = postcardData[5]
					
					if (postcardData[6] != undefined)
					{
						var clickID:int = setNickClickID(int(postcardData[1]))
						var doublicClickID:String = setDoubleClickURL(int(postcardData[1]))
						mHint.nickBtnOn(true, postcardData[6], clickID, doublicClickID) 
					}
				}
				else 
				{
					hintText = "This postcard will be sent on:\n\n" + postcardData[2] + ".\n\nBe sure to check back then to discover where you may find it."				
				}
			}
			
			// set the content of the hint box based on postcard data
			mHint.updateText(hintText, 200)
			mHint.textBox.alpha = 0
			
			// Bring it to final position
			Tweener.addTween (mHint, {scaleX:1, scaleY:1, x:mHintX, y:mHintY, time:.5});
			Tweener.addTween (mHint.textBox, {alpha:1, time:.2, delay:.5})
		}
		
		//for tracking each nick link
		private function setNickClickID(pPosecardID:int):int
		{
			var id:int
			switch (pPosecardID)
			{
				case 3:
				id = 14547
				break;
				
				case 6:
				id = 14548
				break;
				
				case 9:
				id = 14549
				break;
				
				case 12:
				id = 14550
				break;
				
				case 15:
				id = 14551
				break;
			}
			return id;
		}
		
		private function setDoubleClickURL(pPosecardID:int):String
		{
			var url:String
			switch (pPosecardID)
			{
				case 3:
				url = "http://ad.doubleclick.net/clk;216245885;15177704;m?http://www.nick.com/ads/kidcuisine/scavengerhunt/"
				break;
				
				case 6:
				url = "http://ad.doubleclick.net/clk;216245886;15177704;n?http://www.nick.com/ads/kidcuisine/scavengerhunt/"
				break;
				
				case 9:
				url = "http://ad.doubleclick.net/clk;216245887;15177704;o?http://www.nick.com/ads/kidcuisine/scavengerhunt/"
				break;
				
				case 12:
				url = "http://ad.doubleclick.net/clk;216245888;15177704;p?http://www.nick.com/ads/kidcuisine/scavengerhunt/"
				break;
				
				case 15:
				url = "http://ad.doubleclick.net/clk;216212161;15177704;t?http://www.nick.com/ads/kidcuisine/scavengerhunt/"
				break;
			}
			return url;
		}
		
		
		// if error (not logged in, etc.), show popup otherwise set challenge card
		private function setupChallengeCard(pError:Boolean, pMessage:String):void
		{
			if (pError)
			{
				var popup:PopupSimple = new PopupSimple(pMessage, 80, 100);
				addChild(popup)
			}
			else 
			{
				trace ("//////////////////////////////////////////")
				NeoTracker.triggerTrackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=213746384;sz=1x1")
				NeoTracker.sendTrackerID(14569);
				var cc:ChallengeCardMC = new ChallengeCardMC();
				cc.init(this, 200, 130);
			}
		}
		
		private function colorTransform():void
		{
			var matrix:Array = new Array();
			matrix=matrix.concat([0.5,0.5,0.5,0,0]);// red
			matrix=matrix.concat([0.5,0.5,0.5,0,0]);// green
			matrix=matrix.concat([0.5,0.5,0.5,0,0]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha

			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);

			var bg:MovieClip = MovieClip(getChildByName("postCardPage"));
			
			for (var i:int = 0; i < mCardName.length; i ++)
			{
				var postcard:MovieClip = bg[mCardName[i]]
				postcard.check.visible = false
				postcard.filters = [my_filter];
			}
		}
		
		private function setPostcard(pcID:int, cardStatus:String):void
		{
			var matrix:Array = new Array();
			var myFilter:ColorMatrixFilter;
			var bg:MovieClip = MovieClip(getChildByName("postCardPage"));
			var postcard:MovieClip = bg["pc" + pcID.toString()];
			postcard.check.visible = false;
			
						
			switch (cardStatus)
			{
				case PC_INACTIVE:
					matrix=matrix.concat([0.18,0.18,0.18,0,0]);// red
					matrix=matrix.concat([0.18,0.18,0.18,0,0]);// green
					matrix=matrix.concat([0.18,0.18,0.18,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
					myFilter = new ColorMatrixFilter(matrix);
					postcard.filters = [myFilter];
					break;
				
				case PC_RELEASED:
					matrix=matrix.concat([0.5,0.5,0.5,0,0]);// red
					matrix=matrix.concat([0.5,0.5,0.5,0,0]);// green
					matrix=matrix.concat([0.5,0.5,0.5,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
					myFilter = new ColorMatrixFilter(matrix);
					postcard.filters = [myFilter];
					break;
				
				case PC_FOUND:
					
					break;
					
				case PC_CLAIMED:
					postcard.check.visible = true;
					break;

			}
		}
		
		private function gotoNickPage():void
		{
			var url:URLRequest = new URLRequest (mNickURL)
			try {            
                navigateToURL(url, "_self")
            }
            catch (e:Error) {
                // handle error here
            }

		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		private function handlePHPResult(evt:Event):void
		{
			removeChild(getChildByName("loaderSign"))
			mXML.processXML(mPHP.xmlData)
			setupPage ();
		}
		
		// after prize request is successfully performed, it shots back an updated xml, so reprocess xml
		private function handleResultIn(evt:CustomEvent):void
		{
			trace ("handleResultin")
			mXML.processXML(evt.oData.DATA)
			trace ("//////////////////////////////////////////////")
			trace (evt.oData.DATA)
			trace ("//////////////////////////////////////////////")
			
		}
		
		//when the prize popup is clsoed, run the checkForUnclaimedCard function again to see there are more unclaimed cards
		private function checkForCardStatus(evt:Event):void
		{
			trace ("check for more unclaimed cards")
			var dataObj:Object = mXML.myObject
			checkForUnclaimedCard(true)
			mPostcardsArray = dataObj.postcardsArray.concat(dataObj.inactiveArray);
			var latestCard:Array = dataObj.postcardsArray[dataObj.postcardsArray.length -1];
			setupHintBox(latestCard);
			setupPostcardStatus(dataObj.postcardsArray, dataObj.inactiveArray);
		}
		
				
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			trace ("    FROM ABS PAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)
			var objName:String = e.oData.DATA.parent.name;
			
			//if clicked obj is post card, handle it how the hint
			if (objName.substr(0, 2) == "pc")
			{
				showHint(MovieClip(e.oData.DATA.parent), mXML.myObject.myError,  mXML.myObject.errorMessage)
			}
			else 
			{
				switch (objName)
				{
					case "challenge":
					trace("challenge");
						setupChallengeCard(mXML.myObject.myError,  mXML.myObject.errorMessage)
						break;
					
					case "gotoNick":
						NeoTracker.triggerTrackURL(mDoubleClickID)
						NeoTracker.sendTrackerID(mNickClickID)
						gotoNickPage()
						break;
						
					case "backpack":
						NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216212274;15177704;y?http://www.kidcuisine.com/realFun/promotions/index.jsp")
						NeoTracker.sendTrackerID(14571);
						break;
						
					case "sweepstake":
						NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211630;15177704;t?http://www.nick.com/neopets/sweepstakes/kidcuisine/")
						NeoTracker.sendTrackerID(14568);
						break;
				}
			}
		}
		
	}
	
}