/**
 *	SIMPLE POPUP
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 **/

package com.neopets.games.marketing.destination.lunchablesAwards
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.lunchablesAwards.feedAPet.DefaultPet;
	import com.neopets.users.abelee.utils.SupportFunctions;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//import com.neopets.util.events.CustomEvent;
	
	
	public class FeedAPetPopup extends AbstractPageCustom
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var xPos:Number
		private var yPos:Number
		
		
		private var _selectedPet:Bitmap;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedAPetPopup(pMessage:String = null, px:Number = 0, py:Number = 0):void
		{
			super();
			xPos = px;
			yPos = py;
			setupPage ();
			setupMessage(pMessage);
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function show():void
		{
			visible = true
		}
		
		public function hide():void
		{
			visible = false 
		}
		
		
		public function get textBox():MovieClip
		{
			return MovieClip(getChildByName("textBox"))
		}
		
		/*public function loadSelectedPet (pet:DefaultPet):void {
			getChildByName("box2").visible = false;
			//get selected pet image
			var ipmc:MovieClip = new MovieClip ();
			ipmc.addChild(pet.image);
			var petImage:BitmapData = new BitmapData (ipmc.width, ipmc.height, true);
			petImage.draw(ipmc);
			var petImageClone:BitmapData = new BitmapData (petImage.width, petImage.height);
			var rect:Rectangle = new Rectangle (0, 0, petImage.width, petImage.height);
			var p:Point = new Point (0, 0);
			petImageClone.copyPixels(petImage, rect, p);
			_selectedPet = new Bitmap (petImageClone);
			//duplicate pet image
			/*var petImage:DisplayObject = pet.image;
			var selectedPet:DisplayObject  = duplicateDisplayObject(petImage);
			_selectedPet.x = xPos+220;
			_selectedPet.y = yPos+40;
			addChild (_selectedPet);
		}*/
		
	
		
				
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("FeedAPet_infopanel", "bkg", xPos, yPos);
			addImage ("FeedAPetPage_selectBox1", "box1", xPos+16, yPos+5);
			addImage ("FeedAPetPage_selectBox2", "box2", xPos+7, yPos+69);
			
			addImageButton("FeedAPet_button","feedButton", xPos+123, yPos+160);
			var mc:MovieClip = getChildByName("feedButton") as MovieClip;
			mc.visible = false;
			
			mc = getChildByName("bkg") as MovieClip;
			addTextBox("LASmallTextBox", "textBox", "",  xPos+30, yPos+30);
			
			
			addTextButton("Text_button", "cancelButton", "Cancel", xPos + 123, yPos + 230);
			mc = getChildByName("cancelButton") as MovieClip;
			SupportFunctions.getChildAsMovieClip(this, "cancelButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
			mc.visible = false;
			//SupportFunctions.getChildAsMovieClip(this, "cancelButton").addEventListener(MouseEvent.MOUSE_DOWN, closePopup, false, 0, true)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function setupMessage(pMessage:String):void
		{
			//addTextBox("KidGenericTextBox", "textBox", pMessage, xPos + 50, yPos + 130 );
		}
		
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function closePopup(evt:MouseEvent):void
		{
			var mc:MovieClip = getChildByName("cancelButton") as MovieClip;
			mc.visible = false;
			
			mc = getChildByName("textBox") as MovieClip;
			mc.visible = false;
			
			mc = getChildByName("box1") as MovieClip;
			mc.visible = true;
			mc.gotoAndStop(1);
			
			mc = getChildByName("box2") as MovieClip;
			mc.visible = true;
				
			mc = getChildByName("feedButton") as MovieClip;
			mc.visible = false;
			
			//_selectedPet.visible = false;
		}
		
		
		
		
		private function closePopup2(evt:MouseEvent):void
		{
			SupportFunctions.getChildAsMovieClip(this, "closeButton").removeEventListener(MouseEvent.MOUSE_DOWN, closePopup)
			cleanup();
		}
		
		private  function duplicateDisplayObject(target:DisplayObject):DisplayObject {
			//TODO: not working
        	// create duplicate
        	var targetClass:Class = Object(target).constructor;
        	var duplicate:DisplayObject = new targetClass();
        
        	// duplicate properties
        	duplicate.transform = target.transform;
        	duplicate.filters = target.filters;
        	duplicate.cacheAsBitmap = target.cacheAsBitmap;
        	duplicate.opaqueBackground = target.opaqueBackground;
        	
        	return duplicate;
    	}
	}
	
}