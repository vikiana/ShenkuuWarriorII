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


package com.neopets.projects.destination.feedapet{
	import flash.display.MovieClip
	import flash.text.TextField
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.events.*
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import com.neopets.projects.destination.feedapet.PetData;
	import com.neopets.projects.destination.feedapet.FoodItem;
	
   public class loadPet extends MovieClip{
    private var myService:NetConnection
	private var _loader: Loader = new Loader();
	private var pet_marker_mc: MovieClip;
	private var food_marker_mc: MovieClip;
	private var backdrop_mc: MovieClip;
	private var feedpet_btn: MovieClip;
	private var food_selected: Boolean = false;
	private var pet_selected: Boolean = false;
	private var targeted_pet: MovieClip;
	
	
	/**
	 * Contructor
	 * 
	 * Note - it's pointing at dev now.
	 */	
	public function loadPet() {
		trace("FUNCTION: loadPet()");
		backdrop_mc = new backdrop();
		backdrop_mc.x = 620;
		backdrop_mc.y = 21;
		addChild(backdrop_mc);
		PetData.register();
		myService = new NetConnection();
		myService.objectEncoding = ObjectEncoding.AMF0;
		myService.connect("http://www.neopets.com/amfphp/gateway.php");
		getUsername();
	}
	
	
	// Checks to make sure user is logged in.
	function getUsername() {
		var responder = new Responder(returnUsername, usernameError);
		myService.call("FeedAPet.getUsername", responder);
	}
	
	//If user is logged in, load pet data...
	function returnUsername(p:String) {
		trace("USERNAME = " + p);
		loadData(true);
	}
	
	//If user is not logged in, show an error message in the pet loading area...
	function usernameError(f:Object) {
		trace("USERNAME ERROR: " + f.description);
		backdrop_mc.gotoAndStop(2);
		backdrop_mc.textbox.htmlText="<P align='center'>You are not logged in.</P>"
	}
	
	//Load the pet data, and set listeners for food clicks and pet clicks.
	function loadData(p_result:Boolean){	
		trace("FUNCTION: loadData()");
		var responder = new Responder(getPetUrl, onFault);
		myService.call("FeedAPet.getPets", responder, 3);
		addEventListener(DisplayPet.CLICKED_PET, selectedPet);
		stage.addEventListener(FoodItem.CLICKED_FOOD, selectedFood);
	}
	
	//If a pet is selected, move the marker next to the pet.
	function selectedPet(evt:Event) {
		trace("SELECTED PET");
		trace(">  NAME = " + evt.target.petname);
		targeted_pet = evt.target;
		if (pet_marker_mc == null) {
			pet_marker_mc = new pet_marker();
			addChild(pet_marker_mc);
		}
		pet_marker_mc.x = evt.target.x;
		pet_marker_mc.y = evt.target.y;
		pet_selected = true;
		if (food_selected) {
			activateFeedPetButton();
		}
	}
	
	//If a food is selected, move the marker next to the food.
	function selectedFood(evt:Event) {
		trace("SELECTED FOOD");
		if (food_marker_mc == null) {
			food_marker_mc = new food_marker();
			addChild(food_marker_mc);
		}
		trace("evt.target = " + evt.target);
		food_marker_mc.x = evt.target.x;
		food_marker_mc.y = evt.target.y;
		food_selected = true;
		if (pet_selected) {
			activateFeedPetButton();
		}
	}
	
	//Loads the PNGs into DisplayPet objects.
	function getPetUrl(p:Array){
		if (p[0].name != "Error") {
			status_txt.text = "";		
			setBackdrop(p.length);
			setFeedpetBtn(p.length);
			for (var i=0; i <p.length; i++) {
				var _mcDisplay = new com.neopets.projects.destination.feedapet.DisplayPet;
				_mcDisplay.init(p[i].name, p[i].pngurl, p[i].swfurl, p[i].fed_recently);
				addChild(_mcDisplay);
				_mcDisplay.x = 620;
				_mcDisplay.y = (i * 115) + 21;
				trace(i + ". position = " + _mcDisplay.x + "," + _mcDisplay.y);			
			}
		} else {
			backdrop_mc.gotoAndStop(2);
			backdrop_mc.textbox.htmlText="<P align='center'>You do not have any pets to feed.</P>"
		}
	}
	
	
	//Makes the backdrop behind the pets larger if there are multiple pets.
	function setBackdrop(numPets: int) {
		backdrop_mc.gotoAndStop(numPets + 1);
		
	}
	
	//places the Feed Pet button
	function setFeedpetBtn(numPets: int) {
		feedpet_btn = new btn_feedpet();
		feedpet_btn.x = 589;
		feedpet_btn.y = (numPets * 115) + 15;
		addChild(feedpet_btn);
	}
	
	//If a pet and food are selected, the Feed Pet button is activated.
	function activateFeedPetButton() {
		feedpet_btn.gotoAndStop("active");
		feedpet_btn.buttonMode = true;
		feedpet_btn.mouseChildren = false;
		trace("LOADPET::TOGGLEFEEDPETBUTTON: targeted_pet = " + targeted_pet);
		feedpet_btn.addEventListener(MouseEvent.MOUSE_OVER, showFeedPetHighlight);
		feedpet_btn.addEventListener(MouseEvent.MOUSE_OUT, hideFeedPetHighlight);		
		feedpet_btn.addEventListener(MouseEvent.MOUSE_DOWN, feedSelectedPet);
	}
	
	//If a pet is deselected, the Feed Pet button is deactivated.
	function deactivateFeedPetButton() {
		feedpet_btn.gotoAndStop("inactive");
		feedpet_btn.buttonMode = false;
		feedpet_btn.removeEventListener(MouseEvent.MOUSE_OVER, showFeedPetHighlight);
		feedpet_btn.removeEventListener(MouseEvent.MOUSE_OUT, hideFeedPetHighlight);		
		feedpet_btn.removeEventListener(MouseEvent.MOUSE_DOWN, feedSelectedPet);
	}
	
	//Feed Pet highlight on mouseover
	public function showFeedPetHighlight(evt:MouseEvent):void {
		feedpet_btn.gotoAndStop("highlight");
	}
		
	public function hideFeedPetHighlight(evt:MouseEvent):void {
		feedpet_btn.gotoAndStop("active");
	}
	
	//calls Feed Pet PHP functionality
	public function feedSelectedPet(evt:MouseEvent):void {
		trace("LOADPET::FEEDPET");
		trace("LOADPET::FEEDPET: targeted_pet = " + targeted_pet.petname);
		targeted_pet.feedPet();
		deactivateFeedPetButton();
	}
	
	function getPetNames(p:Array){
		trace("p=" + p);
	}

	//In case of error
	function onFault(f:Object ){
		status_txt.text = "There was a problem: " + f.description
	}
   }
}	