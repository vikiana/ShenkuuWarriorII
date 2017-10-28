/**
 *	Main landing page for the sixflags destination
 *	Also collection quest also resides in this page
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

	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPage
	import abelee.resource.easyCall.QuickFunctions;
	import caurina.transitions.Tweener;
	
	
	public class MainPage extends AbstractPage {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mUserLoggedIn:Boolean = false	
		private var mGenericClue:String = "Six flags are hidden around the Six Flags of Fun destination.\nFind all six flags and win a fun virtual prize!"
		
		private var mHintArray:Array = [
									   "Play this game, or fun will coast to a stop at Six Flags.",
									   "Watch for towering fun and you will find this hidden flag.",
									   "Is the fun near you?\nIt's time to get informed.",
									   "Six Flags is your ticket to more flags and more fun.",
									   "Get your feet wet with this fun game.",
									   "Can't find this flag?\nTake a break and have a snack.",
									   "Good job!\nYou've found this flag!"
									   ]
		private var mLoginString:String = "Please login to collect all six flags!"
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function MainPage(pLoggedIn:Boolean) {
			super()
			mUserLoggedIn = pLoggedIn
			setupMainPage()	//Main look and feel of the page
			buttonInitSetup()
			flagSetup()
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true)
			hideHint()
		
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	All the "unfound" (false) flags are color tinted as black. If found (true) show the flag
		 *	@PARAM		pArray		Array of boolean values.  array is generated from SixFlagsDatabaseComm.
		 **/
		public function showFlags(pArray:Array):void
		{
			var flags:MovieClip = getChildByName("Flags") as MovieClip
			var children:int = flags.numChildren
			for (var i:int = 0; i < children; i++)
			{
				var flag:MovieClip = flags.getChildByName("flag" + (i+1).toString()) as MovieClip
				flag.gotoAndStop(i+1)
				if (!pArray[i])
				{
					var colorTransform:ColorTransform = flag.transform.colorTransform;
					colorTransform.color = 0x000000;
					flag.transform.colorTransform = colorTransform;
					flag.buttonMode = true
				}
			}
			
			//below is the text box on the forground: used only for test purposes
			var fg:MovieClip = getChildByName("fg") as MovieClip
			fg.testText.text = ""
			fg.testText.visible = false
			
		}
		
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//place, buttons, background, etc.
		private function setupMainPage():void
		{
			addBackground("MainBackground", "bg", 390, 265);
			
			placeImageButton("Btn_WaterSlide", "Btn_WaterSlide", -146.9, -230.9)
			placeImageButton("Btn_RollerCoaster", "Btn_RollerCoaster",  415.3, -21.9)
			placeImageButton("Btn_FeedAPet", "Btn_FeedAPet",  -60.8, 185.6)
			placeImageButton("Btn_Info", "Btn_Info",  525.6, 227.4)
			placeImageButton("Btn_Tower", "Btn_Tower",  310, 50)
			placeImageButton("Btn_Gate", "Btn_Gate",  213.7, 339.9)
			addBackground("MainForeground", "fg", 390, 450);
			
			
			placeFlags("Flags", "Flags", 447, 307.1)
			addBackground("GenericPopup", "hint", 10, 10)
			addBackground("GenericPopupLong", "clue", 390, 440)
			
			
		}
		
		// set all the buttons on "out" (mouse out) state
		private function buttonInitSetup():void
		{
			var children:int = numChildren
			for (var i:int = 0; i < children; i++)
			{
				var mc:MovieClip = getChildAt(i) as MovieClip
				if (mc.btnArea != null)
				{
					mc.gotoAndStop("out")
				}
			}
		}
		
		/**
		 *	Set the flags
		 *	@PARAM 		pClass		name of the libraray object class
		 *	@PARAM		pName		new name you are giving (for reference it later)
		 *	@PARAM		px, py		x, y position
		 **/
		private function placeFlags(pClass:String, pName:String, px:Number, py:Number):void
		{
			var flagClass:Class = getDefinitionByName(pClass) as Class
			var flags:MovieClip = new flagClass ();
			flags.x = px;
			flags.y = py;
			flags.name = pName;
			addChild(flags)
		}
		
		//	Initially sets all the flags as they should appear (then later either hide or show)
		private function flagSetup():void
		{
			var flags:MovieClip = getChildByName("Flags") as MovieClip
			var children:int = flags.numChildren
			for (var i:int = 0; i < children; i++)
			{
				var flag:MovieClip = flags.getChildByName("flag" + (i+1).toString()) as MovieClip
				flag.gotoAndStop(i+1)
				//flag.buttonMode = true
			}
		}
		
		
		// hide the small hint hox as well sa the bottom clue box
		private function hideHint():void
		{
			var hintBox:MovieClip = getChildByName("hint") as MovieClip
			hintBox.visible = false
			
			var clueBox:MovieClip = getChildByName("clue") as MovieClip
			clueBox.y = 500;
			clueBox.alpha = 0
			clueBox.visible = false
		}
		
		/** 
		 *	Show the hint and the clue if the flag is not found.
		 *	Otherwise only show the hint with you've found this flag text
		 *	@PARAM		px, py		position x and y 
		 *	@PARAM		hint		hint pulled from hintArray
		 *	@PARAM		showClue	if true, show the generic clue
		 **/
		private function showHint(px:Number, py:Number, hint:String, showClue:Boolean):void
		{
			var posX:Number = px > 650? px-80: px;
			var hintBox:MovieClip = getChildByName("hint") as MovieClip
			hintBox.visible = true
			hintBox.x = posX
			hintBox.y = py-50;
			hintBox.alpha = 0
			hintBox.descriptionText.text = mUserLoggedIn ? hint: mLoginString;
			Tweener.addTween(hintBox, {alpha:1, x:posX, y:py, time:.5});
			
			if (showClue)
			{
				var clueBox:MovieClip = getChildByName("clue") as MovieClip
				clueBox.visible = true
				clueBox.descriptionText.text = mGenericClue
				Tweener.addTween(clueBox, {alpha:1, y:440, time:.5});
			}
			
		}
		
				
		
		
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		//For generic buttons, simply show the glow, for flags show the hint as well
		private function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)]
			}
			trace (evt.target.name)
			if (evt.target.name== "flag")
			{
				var flag:MovieClip = evt.target.parent as MovieClip
				var flagNumber:int = int (flag.name.substr(flag.name.length-1,flag.name.length))
				var myPoint:Point = evt.target.parent.parent.localToGlobal (new Point (evt.target.parent.x, evt.target.parent.y))
				if (evt.target.parent.transform.colorTransform.redMultiplier == 0)
				{
					showHint(myPoint.x, myPoint.y-130, mHintArray[flagNumber-1], true);
				}
				else 
				{
					showHint(myPoint.x, myPoint.y-130, mHintArray[mHintArray.length-1], false);
				}
			}
		}
		
		//if mouseout on flag, hide hint
		private function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				MovieClip(mc.parent).filters = null
			}
			if (evt.target.name == "flag")
			{
				hideHint()
			}
		}
	}
}
		