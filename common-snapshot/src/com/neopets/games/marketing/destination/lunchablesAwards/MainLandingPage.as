/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana  Baldarelli / Abraham Lee
 *	@since  09.19.2009
 */
package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import flash.external.ExternalInterface;
	
	
	public class MainLandingPage extends AbstractPageCustom 
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mWelcomeTxt:String = "Welcome to the Golden LUNCHABLES Awards Red Carpet! The GLAs is an award show that turns real kids into stars. While walking the Red Carpet, discover swanky games and activities, feed your Neopet, or go to the show! You can even instantly win an award!"
		private var mDatabase:LADatabase;
		private var mUserName:String;
		private var mDatabaseID:String;
		
		//collection quest items on the page
		private var _trophy2Found:Boolean = false;
		private var _trophy1Found:Boolean = false;
		private var _trophy4Found:Boolean = false;
		
		//Gift Bag redemption
		private var _popupgiftStand:PopupGiftsStand;
		private var _responder:Responder;
		
		//text format for larger hints
		private var _textFormatSpecial:TextFormat;
		
		private var _bagRequested:Number;
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MainLandingPage(pName:String = null, pView:Object = null, pUserName:String = null, pID:String = null):void
		{
			super(pName, pView);
			mUserName = pUserName;
			mDatabaseID = pID;
			
			//Badges popup hint bubbles need a smnaller size text
			_textFormatSpecial = new TextFormat (null, 12);
			
			
			setupPage ();
			createPopup("star");
			runJavaScript2("Red Carpet");
			
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
			//get classes
			addImageButton("VIPTent_button", "tentButton", 570, 196)
			addImageButton("VoteSign_button", "signButton", 595, 438);
			addImageButton("StepSign_button", "stepButton", 23, 205);
			addImageButton("GLAwardsLogo_button", "logoButton", 260, 68);
			addImageButton("CameraMan_button", "cameraButton", 82, 350);
			addImageButton("GiftBags_button", "giftstandButton",528, 271);
			//Is this supposed to be a button?
			addImage ("GLABoy_mc", "GLAboy", 195, 280); 
			var mc:MovieClip = this.getChildByName("GLAboy") as MovieClip;
			mc.scaleX = mc.scaleY = 0.2;
			//
			mc = this.getChildByName("signButton") as MovieClip;
			mc.init ("11/15/2009", "12/02/2009", "12/18/2009");
			trace ("Vote Sign Text: "+mc.title_txt.text);
		}
		
		protected override function addBackButton():void {
			//no back button
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function createPopup(type:String):void
		{
			trace (this+"create popup"+type);
			var popup:AbstractPageCustom;
			switch (type){
				case "star":
					popup = new PopupStar ("", 119, 11, 3);
					popup.updateText(mWelcomeTxt, 242)
				break;
				case "simple":
					popup = new PopupSimple ("", 119, 11, 3);
				break;
				case "giftstand":
					checkEligibility ();
				break;
				case "VIP":
					popup = new PopupBadges ("", 60, 30, 3);
				break;
			
			}
			if (popup){
				addChild (popup)
			}
		}
		
		
		//GIFT BAG REDEMPTION
		private function checkEligibility():void
		{
			var baseURL:String = "http://www.neopets.com"//mView.control.baseURL;//"http://dev.neopets.com" 	// this info should come via flashvar
			Amfphp.instance.init(baseURL)  // Where to connect to
			_responder = new Responder(returnEligible, returnError);	// make an appropriate responder  for your proj
			Amfphp.instance.connection.call("Lunchables2009.eligible", _responder);	//make a call
			
		}
		
		
		
		private function returnEligible (obj:Object):void 
		{
			var eligible:Boolean;
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i])
				if (i == "eligible"){
					eligible = obj[i];
				}
			}
			 _popupgiftStand = new PopupGiftsStand ("", 60, 30, 3, false, eligible);
			addChild (_popupgiftStand)
		}
		
		
		
		private function claimPrize(id:int):void {
			if (_popupgiftStand.miononno){
				var baseURL:String = "http://dev.neopets.com"//mView.control.baseURL;//"http://dev.neopets.com" 	// this info should come via flashvar
				Amfphp.instance.init(baseURL)  // Where to connect to
				_responder = new Responder(returnGift, returnError);	// make an appropriate responder  for your proj
				Amfphp.instance.connection.call("Lunchables2009.give", _responder, id);	//make a call
				_bagRequested = id;
			}
		}
		
		
		
		private function returnGift (obj:Object):void {
		trace ("Returning gift status"+obj);
			for (var i:String in obj)
			{
				trace ("returning obj:     "+i+" : "+obj[i]);
				if (i == "result"){
					switch (Number (obj[i]))
					{
						case 1:
							trace ("gift bag was awarded");
							var message:MovieClip = _popupgiftStand.getChildByName("message2") as MovieClip
							message.gotoAndStop(2);
							_popupgiftStand.updateOtherText("message1", "You've received a gift bag!");
							//tracking gift bag received
							NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471143;sz=1x1");
							NeoTracker.instance.trackNeoContentID(15224);
							switch (_bagRequested){
								case 1:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471533;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15225);
								break;
								case 2:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471597;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15226);
								break;
								case 3:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218471920;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15227);
								break;
								case 4:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218472586;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15228);
								break;
								case 5:
									NeoTracker.instance.trackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=218472762;sz=1x1");
									NeoTracker.instance.trackNeoContentID(15229);
								break;
								//action = 1, superstar = 2, brain = 3, helper = 4, artist = 5
							}
						break;
						default:
							trace ("NO PRIZE WAS AWARDED: response was"+obj[i]);
						break;
					}
				}
			}
		
		}
		
		
		private function returnError (obj:Object):void {
			trace ("Error in connection or communication with AMFPHP");
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i]);
			}
		}
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		//MOUSE EVENTS
		protected override function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndStop("over")
				switch (MovieClip(mc.parent).name)
				{
					case "giftstandButton":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Click here to get your swag bag full of golden goodies!";
					break;
					case "tentButton":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Click here for VIP access to special activities and treats!";
					break;
					
					case "BTSBadge":
						MovieClip(mc.parent).hintBubble.bubble.myText.defaultTextFormat = _textFormatSpecial;
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Check out the Behind-the-Scenes room for more special activities and snacks!"
					break;
					case "TrophyBadge":
						MovieClip(mc.parent).hintBubble.bubble.myText.defaultTextFormat = _textFormatSpecial;
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Visit the Trophy Room to help find the missing trophies for a reward!"
					break;
					
			
					case "action_btn":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Best Action Hero";
					break;
					case "superstar_btn":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Best Superstar";
					break;
					case "brain_btn":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Best Brain";
					break;
					case "helper_btn":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Best Helper";
					break;
					case "artist_btn":
						MovieClip(mc.parent).hintBubble.bubble.myText.text = "Best Artist";
					break;
				}
			}
		}
		
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			var objName:String = e.oData.DATA.parent.name;
			var mData:Object;
			var tName:String;
			switch (objName)
			{
				case "logoButton":
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211074;15177704;v?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=feedapet")
					NeoTracker.processClickURL(15034);
					break;
					
				case "tentButton":
					createPopup ("VIP");
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211011;15177704;m?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=games")
					//NeoTracker.sendTrackerID(14523);
					break;
				
				case "signButton":
					//Link to Nicktropolis
					NeoTracker.processClickURL(15060);
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211310;15177704;o?http://www.kidcuisine.com/realFun/promotions/index.jsp")
					//NeoTracker.sendTrackerID(14527);
					if (!_trophy4Found){
						mData = {tName:"t4"};
						tName = "t4"
						mView.updateDatabaseWithTrophy(tName)
						//mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy4Found = true;
					}
					break;
					
				case "stepButton":
					//Link to game 1142
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/clk;218467067;15177704;m?http://www.neopets.com/games/play.phtml?game_id=1142");
					NeoTracker.processClickURL(15045);
					if (!_trophy2Found){
						mData = {tName:"t2"};
						tName = "t2"
						mView.updateDatabaseWithTrophy(tName)
						//mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy2Found = true;
					}
					break;
					
				case "cameraButton":
				trace("Camera Man");
					//link to game 1143
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/clk;218467110;15177704;b?http://www.neopets.com/games/play.phtml?game_id=1143");
					NeoTracker.processClickURL(15046);
					if (!_trophy1Found){
						mData = {tName:"t1"};
						tName = "t1"
						mView.updateDatabaseWithTrophy(tName)
						//mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
						_trophy1Found = true;
					}
					break;
					
				case "giftstandButton":
					createPopup ("giftstand");
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216210974;15177704;d?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=adventure")
					//NeoTracker.sendTrackerID(14522);
					break;
				
				
				//GIST BAG ICON BUTTONS
				case "superstar_btn":
					claimPrize (2);
				break;
				case "action_btn":
					claimPrize (1);
				break;
				case "brain_btn":
					claimPrize (3);
				break;
				case "helper_btn":
					claimPrize (4);
				break;
				case "artist_btn":
					claimPrize (5);
				break;
				
				
				case "inv_button":
					var baseURL:String = "http://dev.neopets.com"//mView.control.baseURL
					var urlreq:URLRequest = new URLRequest (baseURL+"/objects.phtml?type=inventory");
					var uloader:URLLoader = new  URLLoader (urlreq);
					uloader.load(urlreq);
				break;
				
				case "BTSBadge":
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/clk;218466905;15177704;m?http://www.neopets.com/sponsors/lunchables/bts.phtml");
				break;
				case "TrophyBadge":
					NeoTracker.instance.trackURL("http://ad.doubleclick.net/clk;218466984;15177704;t?http://www.neopets.com/sponsors/lunchables/trophy-room.phtml");
				break;
				
				
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