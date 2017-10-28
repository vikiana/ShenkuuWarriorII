/**
 *	Handles main control of click destination project
 *	This project has only one page so most of the things are happening in main page.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.littlestPetShop2010
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsControl	//must include
	import com.neopets.projects.destination.destinationV3.AbsView	//must include
	import com.neopets.projects.destination.destinationV3.Parameters	//must include
	import com.neopets.games.marketing.destination.littlestPetShop2010.page.*

	import com.neopets.util.events.CustomEvent;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	
	public class DestinationControl extends AbsControl
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var mSixFlagsDatabase:SixFlagsDatabase
		
		
	
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DestinationControl():void
		{
			super ();
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		
		
		/**
		*	Depends on what you need to do start here.
		*	By default you would create a main landing page.
		**/
		protected override function childInit ():void
		{
			var loadingSign:MC_LoadingSign = new MC_LoadingSign ();
			loadingSign.x = 390;
			loadingSign.y = 250;
			loadingSign.name = "loadingSign";			
			Parameters.view.dispatchEvent(new CustomEvent({DATA:loadingSign},AbsView.ADD_DISPLAY_OBJ))
			setupMainPage()
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up MAIN LANDING page\n")
			var mainPage:MainPage = new MainPage("mainPage")
			Parameters.view.dispatchEvent(new CustomEvent({DATA:mainPage},AbsView.ADD_DISPLAY_OBJ))
		}
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		


		/**
		 *	@NOTE:	ALL of the items/objects clicked from the stage will be reported here.
		 *			You simply has to choose to what you will process what you will ignore 
		 *			Here I choose to pick up on most of buttons (that has "btnArea" movie clip within)
		 *			And respond appropriately.  Some buttons are handled by the "page" itself if neccessary.
		 **/
		protected override function handleObjClick(e:CustomEvent):void
		{
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
				}
			}
		}
	}
	
}