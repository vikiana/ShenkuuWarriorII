/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieTest.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	//import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;	
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPageWithBtnState;
	import com.neopets.games.marketing.destination.movieTest.feedAPet.*
	import com.neopets.util.events.CustomEvent;
	
	
	public class PageFeedAPet extends AbstractPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var amfphp:MovieAMFPHP;
		private var mLocalTesting:Boolean = true		//false for live, true for local testing
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageFeedAPet(pName:String = null):void
		{
			super(pName);
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
			addTextImage("GenericBackground", "background", "Feed A Pet Page");
			addTextButton("GenericButton", "backToLanding", "Back", 320, 300);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupAMFPHP():void
		{
			amfphp = new MovieAMFPHP();
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
				var preloaderClass:Class = getDefinitionByName("Preloader") as Class
				var preloader:MovieClip = new preloaderClass ()
				preloader.name = "preloader"
				
				//create pet image space 
				var petDisplay = new MoviePet (petArray[i].name, petArray[i].pngurl, petArray[i].swfurl, petArray[i].fed_recently, mLocalTesting);
				petDisplay.addChild(preloader)
				addChild(petDisplay);
				petDisplay.x = 658;
				petDisplay.y = (Number(i) * 100) + 90;
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
				//evt.target.addEventListener(MouseEvent.MOUSE_DOWN, onPetSelected)
			}
		}
		
		
		private function onNoneErrorProblem(evt:CustomEvent):void
		{
			var popup:PopupSimple = new PopupSimple(evt.oData.MESSAGE, 200, 210);
			addChild(popup)
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}