package com.neopets.games.marketing.destination.lunchablesAwards
{
	
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.lunchablesAwards.feedAPet.*;
	import com.neopets.games.marketing.destination.lunchablesAwards.AbstractPageCustom;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	


	public class FeedAPetPage extends AbstractPageCustom 
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
		private var mFoodArray:Array = ["Food1", "Food2"];
		private var mFoodNameArray:Array = ["Turkey and Cheese Sub", "Extra Cheesy Pizza" ]
		private var mLocalTesting:Boolean = false	//false for live, true for local testing
		private var mSelectedPet:DefaultPet
		private var mSelectedFood:String = mFoodNameArray[0]
	
		private var _bkg:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedAPetPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			setupPage();
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected override function setupPage():void
		{
			addBackgroundCustom ();
			addImageButton ("placeholder", "subs", 108, 400);
			addImageButton ("placeholder", "pizzas", 450, 390);
			setupAMFPHP();
			/*popup: not used for now
			mFoodPopup = new FoodPopup("Feed my pet", 30, 100);
			addChild(mFoodPopup)
			mFoodPopup.hide();*/
		}
		
		
		

		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		//Using a custom class to add the background since this project loads a library.
		private function addBackgroundCustom ():void {
			var bkgClass:Class = getClass("FeedAPetPage");
			_bkg = new bkgClass ();
			addChild (_bkg);
		}
		
		private function setupAMFPHP():void
		{
			amfphp = new DefaultAMFPHP();
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
			//TODO:add message box
			trace (this+" onNoneErrorProblem: "+evt.oData.MESSAGE);
			//var popup:PopupSimple = new PopupSimple(evt.oData.MESSAGE, 80, 100);
			//addChild(popup)
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
	}
}