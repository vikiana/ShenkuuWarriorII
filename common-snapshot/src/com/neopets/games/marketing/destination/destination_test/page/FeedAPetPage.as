/**
 *	When the page is first created, it calls an amfphph call
 *	When a user answers a trivia question, it makes an amfphp call
 *	Both calls return same properties that need to be used to show most up to date use status and popup messages
 *
 *	@NOTE: Due to time constraint, the error check is not perfect.  It sort of assumes everything is working perfectly fine.    Be sure to login to your account in IE
 *	
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.marketing.destination.destination_test.page
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.loading.LoadingManager;
	
	import com.neopets.games.marketing.destination.destination_test.feedPet.*
	
	
	
	public class FeedAPetPage extends PageDestinationBase {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var amfphp:DefaultAMFPHP;
		private var mLocalTesting:Boolean = true; // set to false when going live
		private var feedBtn:MovieClip;
		private var feedBox:MovieClip;
		private var selectedFood:String = "";
		private var selectedPet:DefaultPet;
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	when the page is called, load the assets from the FeedAPetAssets  fla
		 **/
		public function FeedAPetPage(pName:String = null) 
		{
			super(pName);
			trace ("FeedAPetPage - Constructor");
			setupPage();
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
		
		
		
		/**
		 *	@NOTE:	In this case, before setting things up, I need to connect to amfphp first to get necessary parameters
		 *  Called in AbsPageWithLoader
		 **/
		protected override function setupPage():void
		{
			
			trace("-------- setupPage() - FeedAPetPage----------");
			addImage("BG", "background");
			addImage("PetsBox", "petBox", 590, 60);
			addImage("FeedBox", "feedBox",75, 300);
			addImageButton("food1", "foodItem1", 75, 100);
			addImageButton("food2", "foodItem2", 200, 100);
			addTextButton("GenericButton", "feedBtn", "Feed me", 350, 375);
			feedBtn = getChildByName("feedBtn") as MovieClip;
			feedBox = getChildByName("feedBox") as MovieClip;
			feedBtn.visible = false;
			
			// New back button
			// (buttonClass:String, pName:String,pText:String, px:Number, py:Number, pAngle:Number = 0, pFrame:String = null)
			placeTextButton("MC_navButton", "feedpageBackBtn", "Back", 600, 450, 0, "out")
			
			setupAMFPHP();
		}
		
		protected function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP("TYPE14ITEM0000");
			amfphp.addEventListener(amfphp.PET_DATA_IN, onPetDataIn, false, 0, true)
			
			/*
			 This is not the best way to retrieve pet responses because it might be possibile that user might be able to feed              a pet before we get responses... but in most cases it should be fine... will coem back later when I have time.  
			 For now such error should happen, it won't break anything. Users simply won't see any feedback popup boxes.
			*/
			
			amfphp.addEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem, false, 0, true)
		}
		
		// Add food item name 
		private function onFoodSelected(foodName:String):void
		{
			feedBox.foodText.text = foodName;
			selectedFood = foodName; // empty string?
			feedReady();
		}
		
		// Add pet name once it is selected if it hasn't been fed already
		private function onPetSelected(pet:DefaultPet):void
		{
			if(!pet.alreadyFed)
			{
				feedBox.petText.text = pet.getName;
				selectedPet = pet;
				feedReady();
			}
			
		}
		
		// Make Feed Btn visible and active
		private function feedReady():void
		{	
		   if( selectedFood != "" && selectedPet != null)
		   {
			 feedBtn.visible = true;
			 feedBtn.addEventListener(MouseEvent.MOUSE_DOWN, feedMyPet);
		   }
		}
		
		
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		// AMFPHP - Feed Pet
		private function feedMyPet(event:MouseEvent):void
		{
			 feedBtn.removeEventListener(MouseEvent.MOUSE_DOWN, feedMyPet);
			 feedBtn.visible = false;
			 amfphp.addEventListener(amfphp.PET_FED,onPetFed);
			 //add error check 
			 amfphp.feedPet(selectedPet.getName);
		}
		
		private function onPetFed(event:Event):void
		{
			// deactivate pet
			amfphp.removeEventListener(amfphp.PET_FED, onPetFed)
			//amfphp.removeEventListener(amfphp.ERROR_OCCURED, onFeedFail)
			selectedPet.removeChild(selectedPet.getChildByName("btnArea"))
			selectedPet.alpha = .3
			selectedPet.alreadyFed = true
			
			feedBox.foodText.text = "";
			selectedFood = "";
			feedBox.petText.text = "";
			selectedPet = null;
			
			// show feedback message 
			
		}
		
		/**
		 *	based on what user clicks on the page, carry out various tasks
		 **/
		override protected function handleObjClick(e:CustomEvent):void
		{
			//trace (e.oData.DATA.parent.hasOwnProperty("getName"))
			//if clicked obj has getName, it means it's a AbsPet object so treat it differently.
			if (e.oData.DATA.parent.hasOwnProperty("getName"))
			{
				//pset selected
				onPetSelected(e.oData.DATA.parent)
			}
			trace("clicked: "+e.oData.DATA.parent.name); // which food item, feedBox, or Pet clicked
			switch (e.oData.DATA.parent.name)
			{
				
				case "feedBtn":
				// feed my pet
				break;
				
				case "foodItem1":
				onFoodSelected("Hawaiian bbq");
				
				// select some food
				break;
				
				case "foodItem2":
				// select some food
				onFoodSelected("Hog maw");
				break;
				
			}
		}
		
		/**
		 *	show the progress bar
		 **/
		 /*
		override protected function onLoadingProgress(e:CustomEvent):void
		{
			
			//loading sign is added at Destination control level, at initChild
			trace (LoadingManager.instance.hasEventListener(LoadingManager.instance.LOADING_COMPLETE));
			var percent:Number = e.oData.BYTES_LOADED/e.oData.BYTES_TOTAL
			trace("Percent: "+percent);
		}
		*/
		
		private function onPetDataIn(evt:Event):void
		{
			trace ("\n=========	SETUP PETS =======\n")
			//amfphp.petResponse();
			var petArray:Array = amfphp.petDataArray
			for (var i:String in petArray)
			{
				//create preloader movie clip (pulled from library)
				var preloaderClass:Class = getDefinitionByName("Preloader") as Class
				var preloader:MovieClip = new preloaderClass ()
				preloader.name = "preloader"
				
				//create pet image space 
			 var petDisplay = new DefaultPet (petArray[i].name, petArray[i].pngurl, petArray[i].swfurl, petArray[i].fed_recently,    mLocalTesting);
				
				var borderClass:Class = getDefinitionByName("PetBorder") as Class
				var border:MovieClip = new borderClass ()
				petDisplay.addChild(border)
				
				petDisplay.addChild(preloader)
				addChild(petDisplay);
				petDisplay.x = 600;
				petDisplay.y = (Number(i) * 95) + 84;
				petDisplay.addEventListener(petDisplay.PET_LOADED, displayPet, false, 0, true)
			}
		}
		
		
		private function onNoneErrorProblem(evt:CustomEvent):void
		{
			
			trace("Feed a pet error: " +evt.oData.MESSAGE);
			amfphp.removeEventListener(amfphp.PET_DATA_IN, onPetDataIn)
			amfphp.removeEventListener(amfphp.NONE_ERROR_PROBLEM, onNoneErrorProblem)
		}
		
		// Displays pet and checks if it has been fed in the past 24 hours (PHP backend)
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
				var btnArea:MovieClip = new btnAreaClass ();
				btnArea.name = "btnArea";
				btnArea.width = evt.target.width;
				btnArea.height = evt.target.height;
				btnArea.buttonMode = true;
				btnArea.x = 0; //evt.target.width/2
				btnArea.y = 0; //evt.target.height/2
				evt.target.addChild(btnArea)
			}
		}
		
		

	}
}
		