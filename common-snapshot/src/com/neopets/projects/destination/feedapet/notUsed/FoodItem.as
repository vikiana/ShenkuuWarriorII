/**
 * To use Rob's version of feedAPet, use: PetData.as, FoodItem.as, loadPet.as, DisplayPet.as
 *	PetData.as: A movieclip in the library (a pet image will be loaded into) should have petdata.as its Class
 *	FoodItem.as: A movieclip in the library (linked with food item) should have FoodItem.as its Class
 *	loadPet.as: Main driving force of the peedAPet.  A document class for the feedAPet swf/fla if you will
 *	DisplayPet.as: in charge of grabbing the url image of the pet and loading/displaying it
 * 
 *@langversion ActionScript 3.0
 *@playerversion Flash 9.0 
 *@author Robert Briggs
 *@since  03.26.2009
 */




package com.neopets.projects.destination.feedapet {
	import flash.display.MovieClip
	import flash.text.TextField
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.events.*
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Stage;
	import com.neopets.projects.destination.feedapet.PetData;
	
   public class FoodItem extends MovieClip {
		public static const CLICKED_FOOD: String = "CLICKED_FOOD";
		
		
		
		public function FoodItem() {
			this.outline.visible = false;
			this.buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER, showHighlight);
			addEventListener(MouseEvent.MOUSE_OUT, hideHighlight);					
			addEventListener(MouseEvent.MOUSE_DOWN, clickedOnFood);
		}
		
		
		public function showHighlight(evt:MouseEvent):void {
			this.outline.visible = true;			
		}
		
		public function hideHighlight(evt:MouseEvent):void {
			this.outline.visible = false;
		}
		
		public function clickedOnFood(evt:MouseEvent):void {
			trace("clicked on food");
			this.dispatchEvent(new Event(FoodItem.CLICKED_FOOD, true));
		}
		
	
   }
}