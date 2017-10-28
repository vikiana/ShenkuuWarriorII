/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieCentral.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.movieCentral.feedAPet.*
	import com.neopets.util.events.CustomEvent;
	import com.neopets.users.abelee.utils.ViewManager_v2;
	import com.neopets.util.tracker.NeoTracker;
	
	
	public class PageFeedAPet extends AbsMovieCentralPage
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
		private var mLocalTesting:Boolean = false		//false for live, true for local testing
		private var mSelectedPet:DefaultPet
		private var mSelectedFood:String
		private var mPetFeedBackArray:Array;
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageFeedAPet(pName:String = null):void
		{
			super(pName);
			setupPage ()
			mPetFeedBackArray = [];
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
			addImage("FeedAPetMC", "feedapet", 390, 265);
			addImage("Popup_FeedAPet", "feedBox", 210, 360);
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			feedBox.btnFeed.visible = false

			//mFoodPopup = new FoodPopup("Feed my pet", 30, 100);
			//addChild(mFoodPopup)
			//mFoodPopup.hide();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP("TYPE14ITEM1652");
			amfphp.addEventListener(amfphp.PET_RESPONSE, onPetResponseRecieved, false, 0, true)
			amfphp.addEventListener(amfphp.PET_DATA_IN, onPetDataIn, false, 0, true)
			
			//this is not the best way to retrieve pet responses because it mightbe possibile that user might be able to feed a pet before we get responses... but in most cases it should be fine... will coem back later when I have time.  For now such error should happen, it won't break anything.  users sipmly won't see any feedback popup boxes.  
			amfphp.addEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem, false, 0, true)
			amfphp.petResponse()
			
		}
		
		
		
		
		private function onPetDataIn(evt:Event):void
		{
			trace ("\n=========	SETUP PETS =======\n")
			amfphp.petResponse();
			var petArray:Array = amfphp.petDataArray
			for (var i:String in petArray)
			{
				//create preloader movie clip (pulled from library)
				var preloaderClass:Class = getDefinitionByName("Preloader") as Class
				var preloader:MovieClip = new preloaderClass ()
				preloader.name = "preloader"
				
				//create pet image space 
				var petDisplay = new DefaultPet (petArray[i].name, petArray[i].pngurl, petArray[i].swfurl, petArray[i].fed_recently, mLocalTesting);
				
				var borderClass:Class = getDefinitionByName("PetBorder") as Class
				var border:MovieClip = new borderClass ()
				petDisplay.addChild(border)
				
				petDisplay.addChild(preloader)
				addChild(petDisplay);
				petDisplay.x = 688;
				petDisplay.y = (Number(i) * 95) + 84;
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
			
			var popup:PopupSimple = new PopupSimple(evt.oData.MESSAGE);
			addChild(popup)
			
			amfphp.removeEventListener(amfphp.PET_DATA_IN, onPetDataIn)
			amfphp.removeEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem)
		}
		
		
		//tell amfphp (amfphp) to feed a pet
		private function feedMyPet ():void
		{
			amfphp.feedPet(mSelectedPet.getName)
		}
		
		
		//This method is called once amfphp returns confirmation that a pet is fed
		private function onPetFed (evt:Event):void
		{
			amfphp.removeEventListener(amfphp.PET_FED, onPetFed)
			amfphp.removeEventListener(amfphp.ERROR_OCCURED, onFeedFail)
			mSelectedPet.removeChild(mSelectedPet.getChildByName("btnArea"))
			mSelectedPet.alpha = .3
			mSelectedPet.alreadyFed = true
			resetFeedBox();
			dispatchEvent(new Event (PET_WAS_FED));
			NeoTracker.instance.trackNeoContentID(14774)
			
			showFeedBack()
		}
		
		//Once the pet has been fed, show the pop up window!
		private function showFeedBack():void
		{
			var popup:PopupSimple
			if (mPetFeedBackArray.length > 0)
			{
				var num:int = Math.floor(Math.random()* mPetFeedBackArray.length)
				popup = new PopupSimple(mPetFeedBackArray[num]);
				addChild(popup)
			}
			
		}
		
		
		private function onPetResponseRecieved(evt:CustomEvent):void
		{
			amfphp.removeEventListener(amfphp.PET_RESPONSE, onPetResponseRecieved)
			mPetFeedBackArray = evt.oData.DATA
		}
		
		
		// is called when feeding a pet has failed on amfphp side
		private function onFeedFail (evt:Event):void
		{
			
			amfphp.removeEventListener(amfphp.PET_FED, onPetFed)
			amfphp.removeEventListener(amfphp.ERROR_OCCURED, onFeedFail)
			//var popup:PopupSimple = new PopupSimple(evt);
			//addChild(popup)
		}
		
		//if there is pet image in teh feedBox ,remove the pet image
		private function removeFromFeedBox(pName:String):void
		{
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			if (feedBox.getChildByName(pName) != null) 
			{
				feedBox.removeChild(feedBox.getChildByName(pName));
			}
			if (pName == "petImage") mSelectedPet = null;
			if (pName == "foodImage") mSelectedFood = null;
		}
		
		/**
		 *	Show feed button if both pet and the food is selected
		 **/
		private function FeedAllegeable():void
		{
			trace (mSelectedFood, mSelectedPet)
			if (mSelectedFood != null && mSelectedPet != null)
			{
				var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
				feedBox.btnFeed.visible = true
			}
			
		}
		
		private function resetFeedBox():void
		{
			removeFromFeedBox("petImage")
			removeFromFeedBox("foodImage")
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			feedBox.btnFeed.visible = false
		}
				
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		
		
		
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
					case "hamburger":
						onFoodSelected("Food_Burger", "hamburger")
						break;
					
					case "soda":
						onFoodSelected("Food_Soda", "soda")
						break;
						
					case "popcorn":
						onFoodSelected("Food_Popcorn", "popcorn")
						break;
					
					case "btnClear":
						resetFeedBox()
						break;
						
					case "btnFeed":
						amfphp.addEventListener(amfphp.PET_FED, onPetFed, false, 0, true)
						amfphp.addEventListener(amfphp.ERROR_OCCURED, onFeedFail, false, 0, true)
						feedMyPet()
						break;
					
				}
			}
		}
		
		
		
		//	show the pet in the feedBox when selected
		private function onPetSelected(pPet:DefaultPet):void
		{
			if (!pPet.alreadyFed)
			{
				removeFromFeedBox("petImage")
				var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
				var petSource:Bitmap =  Bitmap(pPet.image)
				var petData:BitmapData = new BitmapData(petSource.width, petSource.height, true, 0x000000)
				petData.draw(petSource)
				var pet:Bitmap = new Bitmap (petData)
				pet.name = "petImage"
				mSelectedPet = pPet
				feedBox.addChild(pet)
				pet.x = 30
				pet.y = 28
				
				FeedAllegeable()
			}
		}
		
		/**
		 *	When food is selected, show the selected food on the feed box
		 *	@PARAM		pClassName		String		export class name from the library
		 **/
		private function onFoodSelected(pClassName:String, pFood:String):void
		{
			removeFromFeedBox("foodImage")
			var feedBox:MovieClip = getChildByName("feedBox") as MovieClip
			var foodClass:Class = Class(getDefinitionByName(pClassName))
			var food:MovieClip = new foodClass ();
			
			food.name = "foodImage"
			
			feedBox.addChild(food)
			food.x = 185
			food.y = 65
			
			mSelectedFood = pFood
			FeedAllegeable()
		}
		
		
		
	}
	
}