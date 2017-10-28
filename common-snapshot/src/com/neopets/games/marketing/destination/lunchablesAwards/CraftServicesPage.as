/**
 *	Craft Services Page
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Viviana Baldarelli / Abraham Lee
 *	@since  09.17.2009
 **/
 
 
package com.neopets.games.marketing.destination.lunchablesAwards
{
	
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.lunchablesAwards.feedAPet.*;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	import flash.external.ExternalInterface;


	public class CraftServicesPage extends AbstractPageCustom 
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public const FOOD_SELECTED:String = "food_selected";
		public const PET_WAS_FED:String = "pet_was_fed";
		public const FEED_MY_PET:String = "user_clicked_on_feed_button"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var amfphp:DefaultAMFPHP;
		private var mFoodArray:Array = ["Food1", "Food2", "Food3"];
		private var mFoodNameArray:Array = ["Turkey and Cheese Sub", "Extra Cheesy Pizza", "Applesauce" ];
		private var mLocalTesting:Boolean = false;	//false for live, true for local testing
		private var mSelectedPet:DefaultPet;
		private var mSelectedFood:String = "";//mFoodNameArray[0];
		private var mPetsArray:Array = []
		//TODO: add correct verbage
		private var mPetMessageArray:Array = [
											  "You're a great owner. You deserve an award!",
											  "Yum! What did I do to earn a treat like this?",
											  "I'd like to thank everyone who made my snack possible...",
											  "That was delicious! I love award parties.",
											  "Thanks for the snack! You're an award-winning owner.",
											  "Can we come back tomorrow? I want to try more snacks.",
											  "This snack makes me feel like a star!",
											  "Tasty! After this, can we visit the Red Carpet?",
											  "Great food, great show! We should have awards all the time!",
											  "Yum! My snack was so tasty, it should win an award!"
											  ]
		
		private var mFoodPopup:FeedAPetPopup;
		
		private var _trophy5Found:Boolean = false;
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CraftServicesPage(pName:String=null, pView:Object=null,  uN:String=null, dbID:String=null)
		{
			super(pName, pView);
			setupPage();
			runJavaScript2("Craft Services");
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected override function setupPage():void
		{
			addImageButton ("Subs_button", "subs",28, 326);
			addImageButton ("Pizzas_button", "pizzas", 368, 313);
			addImageButton ("Applesauce_button", "applesauces", 241, 400);
			
			setupAMFPHP();
			
			mFoodPopup = new FeedAPetPopup("", 309, 10);
			addChild(mFoodPopup);
			
		}
		
		
		

		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------	
		private function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP("TYPE14ITEM1651");
			amfphp.addEventListener(amfphp.PET_DATA_IN, onPetDataIn, false, 0, true)
			amfphp.addEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem, false, 0, true)
		}
		
		
		
		private function onPetDataIn(evt:Event):void
		{
			trace ("\n=========	SETUP PETS =======\n")
			var petArray:Array = amfphp.petDataArray
			for (var i:String in petArray)
			{
				//create preloader movie clip (pulled from library)
				var preloaderClass:Class = getClass("Preloader");
				var preloader:MovieClip = new preloaderClass ()
				preloader.name = "preloader"
				
				//create pet image space 
				var petDisplay:DefaultPet = new DefaultPet (petArray[i].name, petArray[i].pngurl, petArray[i].swfurl, petArray[i].fed_recently, mLocalTesting);
				petDisplay.addChild(preloader)
				addChild(petDisplay);
				switch (Number (i)){
					case 0:
						petDisplay.x = 659;
						petDisplay.y = 48;
						petDisplay.rotation = -3;
					break;
					case 1:
						petDisplay.x = 657;
						petDisplay.y = 169;
						petDisplay.rotation = 4;
					break;
					case 2:
						petDisplay.x = 662;
						petDisplay.y = 302;
						petDisplay.rotation = -7;
					break;
					case 3:
						petDisplay.x = 661;
						petDisplay.y = 428;
						petDisplay.rotation = 1;
					break;
				}
				petDisplay.addEventListener(petDisplay.PET_LOADED, displayPet, false, 0, true)
			}
		}
		
		private function displayPet(evt:Event):void
		{
			evt.target.removeEventListener (evt.target.PET_LOADED, displayPet)
			evt.target.removeChild(evt.target.getChildByName("preloader"))
			if (evt.target.alreadyFed)
			{
				evt.target.alpha = .3
			}
			else 
			{
				var btnAreaClass:Class = getDefinitionByName("GenericBtnArea") as Class
				var btnArea:MovieClip = new btnAreaClass ()
				btnArea.name = "btnArea"
				btnArea.width = evt.target.width
				btnArea.height = evt.target.height
				btnArea.buttonMode = true
				btnArea.x = evt.target.width/2
				btnArea.y = evt.target.height/2
				
				evt.target.addChild(btnArea)
			}
			mPetsArray.push(evt.target)
			
		}
		
		private function removeHilite():void
		{
			for (var i:String in mPetsArray)
			{
				var pet:DefaultPet = mPetsArray[i]
				var hilite:MovieClip = MovieClip(pet.getChildByName("hilite"))
				hilite.visible = false;
			}
		}
		
		private function onNoneErrorProblem(evt:CustomEvent):void
		{
			//TODO:add message box
			trace (this+" onNoneErrorProblem: "+evt.oData.MESSAGE);
			var popup:PopupError = new PopupError(evt.oData.MESSAGE, 80, 100);
			addChild(popup)
		}
		
		
		//show pop up box to feed a pet
		private function updateFoodPopup():void
		{
			removeHilite();
			mFoodPopup.getChildByName("feedButton").visible = true
			mFoodPopup.getChildByName("cancelButton").visible = true;
			//mFoodPopup.loadSelectedPet(mSelectedPet);
			var hilite:MovieClip = mSelectedPet.getChildByName ("hilite") as MovieClip;
			hilite.visible = true;
			amfphp.addEventListener(amfphp.PET_FED, onPetFed, false, 0, true)
			amfphp.addEventListener(amfphp.ERROR_OCCURED, onFeedFail, false, 0, true)
		}
		
		
			
		override protected function handleObjClick(e:CustomEvent):void
		{
			
			//if clicked obj has getName, it means it's a AbsPet object so treat it differently.
			if (e.oData.DATA.parent.hasOwnProperty("getName"))
			{
				if (mSelectedFood != ""){
					onPetSelected(e.oData.DATA.parent)
				};
			}
			else 
			{
				var objName:String = e.oData.DATA.parent.name;
				switch (objName)
				{
					case "feedButton":
					var adurl:String;
						feedMyPet();
						trace ("mSelectedFood"+mSelectedFood);
						if (mSelectedFood == mFoodArray[0])
						{
							NeoTracker.instance.trackNeoContentID(15090);
							adurl = "http://ad.doubleclick.net/ad/neopets.nol;adid=218473353;sz=1x1";
							//Omniture tracking on selected food item
							//runJavaScript('Kid Cuisine Mac and Cheese Food Item');
						}
						else if (mSelectedFood == mFoodArray[1])
						{
							NeoTracker.instance.trackNeoContentID(15091);
							adurl = "http://ad.doubleclick.net/ad/neopets.nol;adid=218473624;sz=1x1";
							//Omniture tracking on selected food item
							//runJavaScript('Kid Cuisine Chicken Nuggets Food Item');
						}
						else if (mSelectedFood == mFoodArray[2])
						{
							NeoTracker.instance.trackNeoContentID(15092);
							adurl = "http://ad.doubleclick.net/ad/neopets.nol;adid=218473268;sz=1x1";
							//Omniture tracking on selected food item
							//runJavaScript('Kid Cuisine Hot Dog Meal Clicks');
						}
						if (adurl){
							NeoTracker.instance.trackURL(adurl);
						}
					break;
					case "subs":
						
						mSelectedFood = mFoodArray[0];
						updateInfoPanel(1);
					break;
					case "pizzas":
					
						mSelectedFood = mFoodArray[1];
						updateInfoPanel(1);
					break;
					case "applesauces":
					
						mSelectedFood = mFoodArray[2];
						updateInfoPanel(1);
					break;
				}
			}
		}
		
		
		private function updateInfoPanel (stage:int):void {
			switch (stage) {
				case 1:
					var box:MovieClip = mFoodPopup.getChildByName("box1") as MovieClip;
					box.gotoAndStop(mSelectedFood);
				break;
				case 2:
					
				break;
			
			}
		
		}
	
		
		
		private function onPetSelected(pet:DefaultPet):void
		{
			//trace (pet.getName)
			mSelectedPet = pet;
			updateFoodPopup();
		}
		
		private function setFoodName(evt:CustomEvent):void
		{
			var fp:MovieClip = getChildByName("feedapet") as MovieClip;
			var index:int = int(evt.oData.DATA)
			fp.foodText.text = mFoodNameArray[index]
			mSelectedFood = mFoodNameArray[index]
		}
		
		//tell amfphp (amfphp) to feed a pet
		private function feedMyPet ():void
		{
			amfphp.feedPet(mSelectedPet.getName)
			mFoodPopup.getChildByName("feedButton").visible = false;
			var selectedFood:String;
		}
		
		
		//This method is called once amfphp returns confirmation that a pet is fed
		private function onPetFed (evt:Event):void
		{			
			amfphp.removeEventListener(amfphp.PET_FED, onPetFed)
			amfphp.removeEventListener(amfphp.ERROR_OCCURED, onFeedFail)
			mSelectedPet.removeChild(mSelectedPet.getChildByName("btnArea"))
			mSelectedPet.alpha = .3
			mSelectedPet.removeEventListener(MouseEvent.MOUSE_DOWN, onPetSelected)
			
			mFoodPopup.getChildByName("box1").visible = false;
			mFoodPopup.getChildByName("box2").visible = false;
			
			mFoodPopup.updateText(mPetMessageArray[Math.floor(Math.random()* mPetMessageArray.length)], 250)
			
			var hilite:MovieClip = mSelectedPet.getChildByName ("hilite") as MovieClip;
			hilite.visible = false;
			
			MovieClip(mFoodPopup.getChildByName("cancelButton")).btnText.text = "Next"
			dispatchEvent(new Event (PET_WAS_FED));
			//
			if (!_trophy5Found){
				//var mData:Object = {tName:"t5"};
				var tName:String = "t5"
				mView.updateDatabaseWithTrophy(tName)
				//mView.dispatchEvent (new CustomEvent(mData, TrophyRoomPage.TROPHY_FOUND, false, true));
				_trophy5Found = true;
			}
		}
		
		
		
		// is called when feeding a pet has failed on amfphp side
		private function onFeedFail (evt:Event):void
		{
			amfphp.removeEventListener(amfphp.PET_FED, onPetFed)
			amfphp.removeEventListener(amfphp.ERROR_OCCURED, onFeedFail)
			mFoodPopup.updateText("There was an error.  Please try again later.")
			MovieClip(mFoodPopup.getChildByName("closeButton")).btnText.text = "Close"
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
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
	}
}