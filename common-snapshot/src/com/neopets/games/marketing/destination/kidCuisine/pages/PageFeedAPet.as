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
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.external.ExternalInterface;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.games.marketing.destination.kidCuisine.feedAPet.*
	import com.neopets.util.events.CustomEvent;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.projects.destination.destinationV2.NeoTracker
	
	
	public class PageFeedAPet extends AbsPageWithBtnState
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
		private var mFoodArray:Array = ["Food1", "Food2", "Food3"]
		private var mFoodNameArray:Array = ["Planet 51 Mac & Cheese", "Planet 51 Chicken Breast Nuggets", "Campfire Hot Dog"]
		private var mLocalTesting:Boolean = false		//false for live, true for local testing
		private var mSelectedPet:DefaultPet
		private var mSelectedFood:String = mFoodNameArray[0]
		private var mFoodPopup:FoodPopup	//popup that allows users to feed a selected pet
		private var mPetMessageArray:Array = [
											  "This is the tastiest food in the galaxy!",
											  "Yum! That treat was full of galactic goodness.",
											  "I have officially eaten the best food on the planet.",
											  "Wow, I guess space is the place for great food.",
											  "I'd travel light years for another treat like this.",
											  "I thought my stomach was a black hole, but now I'm full!",
											  "Stellar food! I'm glad you brought me here.",
											  "Do you think we could go asteroid hopping after this?",
											  "Let's come back tomorrow for more of this cosmic food!",
											  "That was the best food I've ever had on a rocket ship.",
											  "I think food tastes better without gravity.",
											  "Yum! Watch me finish eating this at the speed of light.",
											  "Thanks for feeding me! You're a star."
											  ]
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageFeedAPet(pName:String = null, pView:Object = null):void
		{
			trace ("/////////////////what is my settting", pName, pView)
			super(pName, pView);
			setupPage ()
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
			setupAMFPHP()
			addImage("FeedAPetPage", "feedapet");
			setupFoodUI()
			mFoodPopup = new FoodPopup("Feed my pet", 30, 100);
			addChild(mFoodPopup)
			mFoodPopup.hide();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP();
			amfphp.addEventListener(amfphp.PET_DATA_IN, onPetDataIn, false, 0, true)
			amfphp.addEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem, false, 0, true)
		}
		
		private function setupFoodUI():void
		{
			var trailerButtonArray:Array = createFoodArray ()
			var arrowButtonArray:Array = createArrowButtonArray()
			
			var buttonMenu: ViewManager_v3 = new ViewManager_v3(trailerButtonArray, arrowButtonArray, 1)
			buttonMenu.x = 210;
			buttonMenu.y = 150;
			buttonMenu.addEventListener(buttonMenu.CURRENT_INDEX, setFoodName)
			addChild(buttonMenu)
		}
		
		private function createFoodArray():Array
		{
			var foodArray:Array = new Array ();
			for (var i:String in mFoodArray)
			{
				var foodClass:Class = Class(getDefinitionByName(mFoodArray[i]))
				var food:MovieClip = new foodClass ();
				food.name = mFoodArray[i]
				foodArray.push(food)
			}
			
			return foodArray
		}
		
		private function createArrowButtonArray():Array
		{
			var leftClass:Class = getDefinitionByName("LeftArrow") as Class
			var left:MovieClip = new leftClass ();
			left.gotoAndStop("out")
			left.name = "left arrow"
		
			var rightClass:Class = getDefinitionByName("RightArrow") as Class
			var right:MovieClip = new rightClass ();
			right.gotoAndStop("out")
			right.name = "right arrow"
			
			return [left, right]
		}
		
		private function onPetDataIn(evt:Event):void
		{
			trace ("\n=========	SETUP PETS =======\n")
			var petArray:Array = amfphp.petDataArray
			for (var i:String in petArray)
			{
				//create preloader movie clip (pulled from library)
				var preloaderClass:Class = getDefinitionByName("Preloader") as Class
				var preloader:MovieClip = new preloaderClass ()
				preloader.name = "preloader"
				
				//create pet image space 
				var petDisplay = new DefaultPet (petArray[i].name, petArray[i].pngurl, petArray[i].swfurl, petArray[i].fed_recently, mLocalTesting);
				petDisplay.addChild(preloader)
				addChild(petDisplay);
				petDisplay.x = 663;
				petDisplay.y = (Number(i) * 109) + 72;
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
		}
		
		
		private function onNoneErrorProblem(evt:CustomEvent):void
		{
			var popup:PopupSimple = new PopupSimple(evt.oData.MESSAGE, 80, 100);
			addChild(popup)
		}
		
		//show pop up box to feed a pet
		private function foodPopup():void
		{
			mFoodPopup.show();
			mFoodPopup.getChildByName("feedButton").visible = true
			MovieClip(mFoodPopup.getChildByName("closeButton")).btnText.text = "Cancel"
			mFoodPopup.updateText("Would you like to feed " + mSelectedFood +" to " + mSelectedPet.getName + "?")
			amfphp.addEventListener(amfphp.PET_FED, onPetFed, false, 0, true)
			amfphp.addEventListener(amfphp.ERROR_OCCURED, onFeedFail, false, 0, true)
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
			mFoodPopup.updateText(mPetMessageArray[Math.floor(Math.random()* mPetMessageArray.length)])
			MovieClip(mFoodPopup.getChildByName("closeButton")).btnText.text = "Close"
			dispatchEvent(new Event (PET_WAS_FED));
		}
		
		
		
		// is called when feeding a pet has failed on amfphp side
		private function onFeedFail (evt:Event):void
		{
			amfphp.removeEventListener(amfphp.PET_FED, onPetFed)
			amfphp.removeEventListener(amfphp.ERROR_OCCURED, onFeedFail)
			mFoodPopup.updateText("There was an error.  Please try again later.")
			MovieClip(mFoodPopup.getChildByName("closeButton")).btnText.text = "Close"
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndPlay("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 5), new GlowFilter(0x3399FF, 1, 8, 8, 5, 5)]
			}
		}
		
		
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			
			//if clicked obj has getName, it means it's a AbsPet object so treat it differently.
			if (e.oData.DATA.parent.hasOwnProperty("getName"))
			{
				onPetSelected(e.oData.DATA.parent)
			}
			else 
			{
				var objName:String = e.oData.DATA.parent.name;
				switch (objName)
				{
					case "feedButton":
						feedMyPet()
						if (mSelectedFood == mFoodNameArray[0])
						{
							//Phase III
							NeoTracker.triggerTrackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=219134319;sz=1x1");
							NeoTracker.sendTrackerID(14991);
							//Omniture tracking on selected food item
							runJavaScript('Planet 51 Mac and Cheese Meal  Clicks');
							
						}
						else if (mSelectedFood == mFoodNameArray[1])
						{
							//Phase III
							NeoTracker.triggerTrackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=219134451;sz=1x1")
							NeoTracker.sendTrackerID(14533);
							//Omniture tracking on selected food item
							runJavaScript('Planet 51 Chicken Nugget Meal  Clicks');
						}
						else 
						{
							//Phase II
							NeoTracker.triggerTrackURL("http://ad.doubleclick.net/ad/neopets.nol;adid=213743588;sz=1x1")
							NeoTracker.sendTrackerID(14532);
							//Omniture tracking on selected food item
							runJavaScript('Kid Cuisine Hot Dog Meal Clicks');
						}
						break;
				}
			}
		}
	
		
		
		private function onPetSelected(pet:DefaultPet):void
		{
			//trace (pet.getName)
			mSelectedPet = pet
			foodPopup()
		}
		
		private function setFoodName(evt:CustomEvent):void
		{
			var fp:MovieClip = getChildByName("feedapet") as MovieClip;
			var index:int = int(evt.oData.DATA)
			fp.foodText.text = mFoodNameArray[index]
			mSelectedFood = mFoodNameArray[index]
		}
		
			/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		private function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				trace ("External Interface is available");
				try
				{
					ExternalInterface.call("sendADLinkCall", scriptID) ;
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
				}
			}
		}
		
		
	}
	
}