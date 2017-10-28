/**
 *	SIMPLE POPUP
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
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.net.URLLoader;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.users.abelee.utils.SupportFunctions
	import caurina.transitions.Tweener;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV2.NeoTracker
	
	
	public class PopupClaimPrize extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public const RESULT_IN:String = "result_in";
		public const POPUP_CLOSED:String = "popup_closed";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var xPos:Number;
		var yPos:Number;
		var mGreetingA:String = "Congrats!\nYou've won a virtual prize."
		var mGreetingB:String = "You have another virtual prize to claim."
		var mGreetingC:String = "Congratulations!\nYou have completed KC's Space Scavenger Hunt."
		var mInstruction:String = "Click below to accept your prize."
		var mInstructionB:String = "Click below to accept your grand prize."
		var mNotice:String = "Brought to you by Kid Cuisine!"
		//var mURLPath:String = "http://dev.neopets.com/sponsors/kidcuisine/service.php?method=claim"
		var mURLPath:String = "/sponsors/kidcuisine/service.php?method=claim"
		
		var mSuccessMessage:String = "You have successfully received the prize"
		var mErrorMessage:String = "Error occured: Please try again later."
		
		var mPostcardID:String = "0";
		var mHash:String = "0";
		var mLoader:Loader;
		var mPrizeName:String;
		var mRepeat:Boolean;		//if thre are multible unclaimed prizes
		var mFinalPrize:Boolean;
		var mClickID:int ;
		var mDoubleClickLink:String;	//third party tracking urls

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopupClaimPrize(pCardArray:Array, px:Number = 0, py:Number = 0, pRepeat:Boolean = false, pFinalPrize:Boolean = false):void
		{
			super();
			xPos = px
			yPos = py
			mFinalPrize = pFinalPrize
			
			if (!pFinalPrize)
			{
				mPostcardID = pCardArray[1]
				mHash = pCardArray[4]
				mPrizeName = pCardArray[7];
				handleImageLoad(pCardArray[8])
				setClickID(pCardArray[1])
			}
			else 
			{
				mPrizeName = pCardArray[2];
				handleImageLoad(pCardArray[3])
				setClickID("finalItem")
			}
			mRepeat = pRepeat
			setupPage ()			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function updateText(pMessage:String = null, pWidth = 300)
		{
			var textBox:MovieClip = getChildByName("textBox") as MovieClip;
			textBox.myText.text = pMessage;
			textBox.myText.width = pWidth;
			textBox.myText.autoSize = "left";
			textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("BlackBackDrop", "shade", 0, 0);
			addImage("PopUp", "background", xPos, yPos);
			addTextButton("KidGenericButton", "closeButton", "Close", xPos + 485, yPos + 275);
			addTextButton("KidGenericButton", "receiveButton", "Accept", xPos + 260, yPos + 240);
			if (!mFinalPrize)
			{
				var greeting:String = mRepeat ? mGreetingB: mGreetingA; 
				setupMessage (greeting, "greeting", 50, 40)
				setupMessage (mInstruction, "instruction", 50, 200)
			}
			else 
			{
				setupMessage (mGreetingC, "greeting", 50, 40)
				setupMessage (mInstructionB, "instruction", 50, 200)
			}
			
			addImage("Preloader", "preloader", xPos + 270, yPos + 105)
			
			
			var btn:MovieClip = getChildByName("closeButton") as MovieClip
			btn.visible = false;
			btn.scaleX = btn.scaleY = .6
			btn.addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			
			var rbtn:MovieClip = getChildByName("receiveButton") as MovieClip
			rbtn.scaleX = rbtn.scaleY = .6
			rbtn.addEventListener(MouseEvent.MOUSE_DOWN, claimPrize, false, 0, true)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function setClickID(pID:String):void
		{
			switch (pID)
			{
				case "1":
				mClickID = 14552
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216212246;15177704;x?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "2":
				mClickID = 14553
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245142;15177704;y?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "3":
				mClickID = 14554
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245143;15177704;z?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "4":
				mClickID = 14555
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245144;15177704;a?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "5":
				mClickID = 14556
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245145;15177704;b?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "6":
				mClickID = 14557
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245147;15177704;d?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "7":
				mClickID = 14558
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245398;15177704;l?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "8":
				mClickID = 14559
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245397;15177704;k?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "9":
				mClickID = 14560
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245396;15177704;j?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "10":
				mClickID = 14561
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245395;15177704;i?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "11":
				mClickID = 14562
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245393;15177704;g?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "12":
				mClickID = 14563
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245626;15177704;f?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "13":
				mClickID = 14564
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245625;15177704;e?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "14":
				mClickID = 14565
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245623;15177704;c?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "15":
				mClickID = 14566
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245622;15177704;b?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				case "finalItem":
				mClickID = 14567
				mDoubleClickLink = "http://ad.doubleclick.net/clk;216245621;15177704;a?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt"
				break;
				
				
			}
		}
		
		private function setupMessage(pMessage:String, pName:String, px:Number, py:Number, pTextSize:int = 2 ):void
		{
			switch  (pTextSize)
			{
				case 1:
					addTextBox("KidTitleTextBox", pName, pMessage, xPos + px , yPos + py);
					break;
					
				case 2:
					addTextBox("KidCenteredTextBox", pName, pMessage, xPos + px , yPos + py, 500, 80, "left");
					break;
				
				case 3:
					addTextBox("KidSmallCenteredTextBox", pName, pMessage, xPos + px, yPos + py);
					break;
			}
		}
		
		private function cleanMeUp():void
		{
			clearVars()
			cleanup()
		}
		
		private function handleImageLoad(pImageURL:String):void
		{
			trace (pImageURL)
			mLoader = new Loader();
			configureListeners(mLoader.contentLoaderInfo);
			
			var url:URLRequest = new URLRequest (pImageURL);
			mLoader.load(url)
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void 
		{
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

		
		//drwas outline on the obj
		private function drawBorder(displayObject:DisplayObject):void
		{
			
            var child:Shape = new Shape();
            child.graphics.lineStyle(2, 0x000000);
            child.graphics.drawRect(
									displayObject.x, 
									displayObject.y, 
									displayObject.width, 
									displayObject.height
									);
            addChild(child);
		}
		
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function closePopup(evt:MouseEvent = null):void
		{
			SupportFunctions.getChildAsMovieClip(this, "closeButton").removeEventListener(MouseEvent.MOUSE_DOWN, closePopup)
			clearVars()
			dispatchEvent(new Event (POPUP_CLOSED));
			cleanup();
			
		}
		
		private function clearVars():void
		{
			xPos = undefined;
			yPos = undefined;
		}
		
		private function completeHandler(event:Event):void {
            var preloader:MovieClip = MovieClip(getChildByName("preloader"))
			addChild(mLoader);
			mLoader.x = preloader.x;
			mLoader.y = preloader.y;
			removeChild(preloader)
			drawBorder(mLoader)
			setupMessage (mPrizeName, "prizeName", 110, 185, 3)
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
		
		//call to claim prize
		
		private function claimPrize(evt:MouseEvent):void
		{
			removeChild (getChildByName("receiveButton"))
			removeChild (getChildByName("greeting"))
			removeChild (getChildByName("instruction"))
			
			//for neo tracking purposes
			var urlLoader:URLLoader = new URLLoader ()
			var url:URLRequest
			if (mFinalPrize)
			{
				url = new URLRequest (mURLPath + "_final")
			}
			else 
			{
				url = new URLRequest (mURLPath + "&pcid=" + mPostcardID + "&ch=" + mHash)
			}
			urlLoader.addEventListener(Event.COMPLETE, giftReceived)
			try 
			{
				trace ("prize claim")
				NeoTracker.triggerTrackURL(mDoubleClickLink)
				NeoTracker.sendTrackerID(mClickID)
                urlLoader.load(url)
            }
            catch (e:Error) {
                trace ("claim gift error occured", e)
            }
		}
		
		private function giftReceived (evt:Event):void
		{
			var xml:XML = XML(evt.target.data)
			trace (xml)
			var feedBack:String
			if(xml.claim.@success == "1")
			{
				feedBack = mSuccessMessage;
				dispatchEvent(new CustomEvent ({DATA:xml}, RESULT_IN));
				var btn:MovieClip = getChildByName("closeButton") as MovieClip
				btn.visible = true;
			}
			else 
			{
				feedBack = mErrorMessage
				Tweener.addTween(this, {delay:1, onComplete:cleanup})
			}
			setupMessage(feedBack, "feedBack", 50, 40)
			if (mFinalPrize)
			{
				setupMessage (mNotice, "notice", 50, 200)
			}
		}
	}
	
}