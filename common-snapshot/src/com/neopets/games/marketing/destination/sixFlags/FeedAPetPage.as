/**
 *	Page that deals with FeedAPet
 *	Work flow:
 *	1 instantiate six flag feedapet main (handles all amfphp side of feedapet)
 *	2 via amfphp, load pet data and create pets (via SixFlagsPet.as, this class will load pet image to self)
 *	3 create rest of the page
 *	4 based on user input take action (user must choose food and a pet, then he/she can click on feed btn)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.marketing.destination.sixFlags
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	//import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	

	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPage
	import abelee.resource.easyCall.QuickFunctions;
	import caurina.transitions.Tweener;
	import com.neopets.util.events.CustomEvent;
	
	
	public class FeedAPetPage extends AbstractPage {
		
		public const FOOD_SELECTED:String = "food_selected";
		public const PET_WAS_FED:String = "pet_was_fed";
		public const FEED_MY_PET:String = "user_clicked_on_feed_button"
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var feedControl:SixFlagsAMFPHP;
		private var mSelectedFood:String
		private var mSelectedPet:Object
		private var mLocalTesting:Boolean = false		//false for live, true for local testing
		
		//responses a pet will give after being fed
		private var mPetMessageArray:Array = [
											  "Yum, I give this food six out of six flags!",
											  "This was so tasty. Can we bring friends next time?",
											  "Thanks! This is so much fun!",
											  "Oh yeah! This is delicious. I'm glad we came here.",
											  "This place is so much fun! Let's come every day!",
											  "I can't wait to tell my friends about Six Flags!",
											  "After this, can we go on a roller coaster?",
											  "That filled me up! I'm ready for more fun!",
											  "Great food! Three cheers for Six Flags!",
											  "This food is a lot more fun than what I usually get.",
											  "Six Flags is the best! I'm having so much fun!",
											  "I want to come and have fun here every day!"
											  ]
		private var mUserLoggedIn:Boolean
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function FeedAPetPage(pID:String, pLoggedIn:Boolean) {
			super()
			mUserLoggedIn = pLoggedIn
			setupMainPage()
			
			addEventListener(FOOD_SELECTED, onFoodSelected, false, 0 , true);
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true)
			feedControl = new SixFlagsAMFPHP (pID);
			feedControl.addEventListener(feedControl.PET_DATA_IN, onPetDataIn, false, 0, true)
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
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//look and feel of the page
		private function setupMainPage():void
		{
			addBackground("FeedAPetBackground", "bg", 0, 0);
			placeImageButton("Btn_popcorn", "popcorn", 443.6, 252.9);
			addImage("ImageSoda", "soda", 273.9, 251.2);
			addImage("ImageFridge", "fridge",84.7, 227.4);
			placeImageButton("Btn_grill", "grill", -210, 50);
			placeImageButton("Btn_hotdog", "hotdog", 515, 60);
			addImage("FeedAPetForeground", "fg", 0, 0);
			addImage("ImagePetBox", "petbox", 630, 50);
			addImage("FeedBox", "feedBox", 180, 380);
			placeImageButton("Btn_back", "goBack", 80, 490, 0, "out");
			setupFeedBox()
		}
		
		//feed box will show the message, food and/or pet user picked,etc.
		private function setupFeedBox():void
		{
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			if (mUserLoggedIn)
			{
				feedBox.foodText.text = "1. Please select food"
				feedBox.petText.text = "2. Please select pet"
				feedBox.feedBtn.visible = false;
				mSelectedFood = ""
				mSelectedPet = null
			}
			else
			{
				feedBox.foodText.text = "Please login to feed your pet"
				feedBox.petText.text = ""
				feedBox.feedBtn.visible = false;
				mSelectedFood = ""
				mSelectedPet = null
			}
		}

		// every time when there is user input, this checks if a pet is ready to be fed
		// i.e. both bood and the pet is picked.  if it is, show the feed button
		private function checkFeed():void
		{
			trace ("check feed");
			if(mSelectedFood != "" && mSelectedPet != null)
			{
				var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
				feedBox.feedBtn.visible = true;
				feedBox.feedBtn.btnText.text = "Feed"
				feedBox.feedBtn.addEventListener(MouseEvent.MOUSE_DOWN, feedMyPet, false, 0, true)
				feedControl.addEventListener(feedControl.PET_FED, onPetFed, false, 0, true)
				feedControl.addEventListener(feedControl.ERROR_OCCURED, onFeedFail, false, 0, true)
			}
		}
		
		/**
		 *	once a pet is fed, show pet's reaponse
		 *	@PARAM		petMessage		randomly picked from the array
		 **/
		private function setupNextMessage(petMessage:String):void
		{
			removeFood();
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			feedBox.feedBtn.removeEventListener(MouseEvent.MOUSE_DOWN, feedMyPet)
			feedBox.feedBtn.addEventListener(MouseEvent.MOUSE_DOWN, feedBoxReset, false, 0, true)
			feedBox.feedBtn.visible = true;
			feedBox.feedBtn.btnText.text  = "Next"
			feedBox.foodText.text = petMessage
			feedBox.petText.text = ""
			mSelectedFood = ""
			mSelectedPet = null			
		}
		
		
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		//reset the feed box to original setup
		private function feedBoxReset(evt:MouseEvent):void
		{
			removeFood();
			removePet();
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			feedBox.feedBtn.removeEventListener(MouseEvent.MOUSE_DOWN, feedBoxReset)
			feedBox.feedBtn.visible = false;
			setupFeedBox();
		}

		//tell feedControl (amfphp) to feed a pet
		private function feedMyPet (evt:MouseEvent):void
		{
			feedControl.feedPet(mSelectedPet.getName)
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			feedBox.feedBtn.removeEventListener(MouseEvent.MOUSE_DOWN, feedMyPet)
			feedBox.feedBtn.visible = false;
			dispatchEvent(new Event (FEED_MY_PET))
			
		}
		
		//This method is called once amfphp returns confirmation that a pet is fed
		private function onPetFed (evt:Event):void
		{
			feedControl.removeEventListener(feedControl.PET_FED, onPetFed)
			feedControl.removeEventListener(feedControl.ERROR_OCCURED, onFeedFail)
			mSelectedPet.removeChild(mSelectedPet.getChildByName("btnArea"))
			mSelectedPet.alpha = .3
			mSelectedPet.removeEventListener(MouseEvent.MOUSE_DOWN, onPetSelected)
			setupNextMessage(mPetMessageArray[Math.floor(Math.random()* mPetMessageArray.length)])
			dispatchEvent(new Event (PET_WAS_FED));
		}
		
		// is called when feeding a pet has failed on amfphp side
		private function onFeedFail (evt:Event):void
		{
			removePet();
			removeFood();
			feedControl.removeEventListener(feedControl.PET_FED, onPetFed)
			feedControl.removeEventListener(feedControl.ERROR_OCCURED, onFeedFail)
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			feedBox.feedBtn.removeEventListener(MouseEvent.MOUSE_DOWN, feedMyPet)
			feedBox.feedBtn.visible = true;
			feedBox.feedBtn.btnText.text  = "Next"
			feedBox.foodText.text = "There was an erorr.  Please try again."
			feedBox.petText.text = ""
			mSelectedFood = ""
			mSelectedPet = null
		}
		
		
		private function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 3)]
			}
		}
		
		private function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				MovieClip(mc.parent).filters = null
			}
		}
		
		
		// once pet data is retrieved from amfphp, set up the pets 
		// and tell each pet (SixFlagPet) to load its img
		private function onPetDataIn(evt:Event):void
		{
			var petArray:Array = feedControl.petDataArray
			for (var i:String in petArray)
			{
				//create preloader movie clip (pulled from library)
				var preloaderClass:Class = getDefinitionByName("Preloader") as Class
				var preloader:MovieClip = new preloaderClass ()
				preloader.name = "preloader"
				
				//create pet image space 
				var petDisplay = new SixFlagsPet (petArray[i].name, petArray[i].pngurl, petArray[i].swfurl, petArray[i].fed_recently, mLocalTesting);
				petDisplay.addChild(preloader)
				addChild(petDisplay);
				petDisplay.x = 658;
				petDisplay.y = (Number(i) * 100) + 90;
				petDisplay.addEventListener(petDisplay.PET_LOADED, setupPet, false, 0, true)
			}
			
		}
		
		//	once each pet loads its image, it removes the preloader movie clip 
		//	and make itself clickable if it can be fed, otherwise alpha to .3
		private function setupPet(evt:Event):void
		{
			evt.target.removeEventListener (evt.target.PET_LOADED, setupPet)
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
				evt.target.addEventListener(MouseEvent.MOUSE_DOWN, onPetSelected)
			}
		}
		
		//	remove currenly selected pet from the feedBox
		private function removePet():void
		{
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			if (feedBox.getChildByName("pet") != null) 
			{
				feedBox.removeChild(feedBox.getChildByName("pet"));
			}
		}
		
		//	show the pet in the feedBox when selected
		private function onPetSelected(evt:MouseEvent):void
		{
			removePet()
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			if (evt.target.parent.alreadyFed)
			{
				feedBox.petText.text = evt.target.parent.getName +" has been already fed."
			}
			else 
			{
				
				var petSource:Bitmap =  evt.target.parent.image
				var petData:BitmapData = new BitmapData(petSource.width, petSource.height, true, 0x000000)
				petData.draw(petSource)
				var pet:Bitmap = new Bitmap (petData)
				pet.name = "pet"
				mSelectedPet = evt.target.parent
				
				feedBox.addChild(pet)
				feedBox.petText.text = ""
				pet.x = 180
				pet.y = 10
			}
			
			checkFeed()
		}
		
		//	remove currently selected food from the feedBox
		private function removeFood():void
		{
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			if (feedBox.getChildByName("food") != null) 
			{
				feedBox.removeChild(feedBox.getChildByName("food"));
			}
		}
		
		//	show the food user has selected in the feedBox
		private function onFoodSelected(evt:CustomEvent):void
		{
			if (mUserLoggedIn)
			{
				var foodName:String
				switch (evt.oData.FOOD)
				{
					case "grill":
						foodName = "Food_burger";
						break;
					case "popcorn":
						foodName = "Food_popcorn";
						break;
					case "hotdog":
						foodName = "Food_hotdog";
						break;
				}
				
				removeFood();
				var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
				var foodClass:Class = getDefinitionByName(foodName) as Class
				var food:MovieClip = new foodClass ()
				food.name = "food"
				mSelectedFood = evt.oData.FOOD
				
				feedBox.addChild(food)
				feedBox.foodText.text = ""
				food.x = 80
				food.y = 50
				
				checkFeed()
			}
		}
		
	}
}
		