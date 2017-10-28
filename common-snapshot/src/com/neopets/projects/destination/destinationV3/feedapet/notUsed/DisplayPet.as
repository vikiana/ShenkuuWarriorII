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
	
   public class DisplayPet extends MovieClip {
		private var myService:NetConnection
		private var _loader: Loader = new Loader();
		public var petname: String;
		public static const CLICKED_PET: String = "CLICKED_PET";
		
		
		
		public function DisplayPet() {
			PetData.register();		
		}
		
		public function init(p_name: String, p_pngurl: String, p_swfurl:String, p_fed_recently: Boolean) {
			petname = p_name;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.load(new URLRequest(p_pngurl));	
			trace("PNGURL = " + p_pngurl);			
			name_txt.text = petname;
			this.outline.visible = false;
			if (!p_fed_recently) {
				this.buttonMode = true;
				addEventListener(MouseEvent.MOUSE_OVER, showHighlight);
				addEventListener(MouseEvent.MOUSE_OUT, hideHighlight);
				//addEventListener(MouseEvent.MOUSE_DOWN, feedPet);				
				addEventListener(MouseEvent.MOUSE_DOWN, clickedOnPet);
			} else {
				this.alpha = 0.35;
			}
		}
		
		
		public function onComplete(event:Event):void {
			this.preloader.visible = false;
			addChild(_loader.content);
			
		}
		
		public function showHighlight(evt:MouseEvent):void {
			this.outline.visible = true;			
		}
		
		public function hideHighlight(evt:MouseEvent):void {
			this.outline.visible = false;
		}
		
		public function clickedOnPet(evt:MouseEvent):void {
			trace("clicked on pet");
			dispatchEvent(new Event(DisplayPet.CLICKED_PET, true));
		}
		
		public function feedPet():void {
			var responder = new Responder(afterFeed, onFault);
			myService = new NetConnection();
			myService.objectEncoding = ObjectEncoding.AMF0;
			myService.connect("http://dev.neopets.com/amfphp/gateway.php");
			//myService.call("FeedAPet.feedPet", responder, petname);
			myService.call("FeedAPet.feedPet", responder, petname, feedcode);
			trace("FEEDING: " + petname);
		}
		
		public function afterFeed(p_result:Boolean):void {
			trace("FEED RESULT: " + p_result);
			removeEventListener(MouseEvent.MOUSE_OVER, showHighlight);
			removeEventListener(MouseEvent.MOUSE_OUT, hideHighlight);
			removeEventListener(MouseEvent.MOUSE_DOWN, clickedOnPet);
			this.alpha = 0.35;
			this.buttonMode = false;
			this.outline.visible = false;	
		}
		
		function onFault(f:Object ){
			trace("There was a problem: " + f.description);
		}
		
	
   }
}