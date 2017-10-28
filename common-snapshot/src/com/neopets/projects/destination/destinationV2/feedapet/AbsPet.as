/**
 *	To use this verion, you need FeedAPetMain.as and AbstractPet.as
 *	FeedAPetMain: Only deals with amfphp side of feedapet (retriving data, feed pet, check for login, etc.)
 *	AbstractPet: Class for each pet you'll be feeding.  It hold's pet's unique data.
 *
 *	WorkFlow:
 *	1. Create a feedAPet  "page" (should extend abstract page in destination project)
 *	2. Create an instance of FeedAPetMain (acutally a class that extends FeedAPetMain)
 *	3. Using the instance of FeedAPetMain, create connection with php side, retrieve pet data information
 *	4. With retrieved pet data, create an instance of AbstarctPet for each pet
 *		(actually a pet class that extends AbstractPet)
 *	5. create your own look and feel and logic for the peedapet page and 
 *		again use the instance of FeedAPetMain to feed your pet via amfphp.
 *
 **/

/**
 *	Pets that'll be used in feedapet need to hold some vital information: 
 *	1) pet name, 
 *	2) image url, 
 *	3) swf url, and
 *	4) recently fed status
 *	This class will hold that information per pet.
 *	Each click destination should create a separate pet class and extend this abstract pet class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 **/





package com.neopets.projects.destination.destinationV2.feedapet {
	
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip
	import flash.display.DisplayObject;
	import flash.events.Event
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.ApplicationDomain;
	
	
	
	
	public class AbsPet extends MovieClip {
		
	
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public const PET_LOADED:String = "pet_loaded";	// once peturl is loaded from the server
		public static const CLICKED_PET: String = "CLICKED_PET"; 
		
		
		private var mLoader: Loader = new Loader();	//loader that will load the png or swf image of the pet
		private var mPetName: String;	//name of the pet
		private var mAlreadyFed: Boolean;	//true if the pet is fed already
		private var mLocalTesting:Boolean; //set to false for putting it live
		
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		
		public function AbsPet(p_name: String, p_pngurl: String, p_swfurl:String, p_fed_recently: Boolean, pLocalTesting:Boolean = false) 
		{
			mLocalTesting = pLocalTesting
			// LoaderContext is extremely important to avoid security violation
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;	
			loaderContext.checkPolicyFile = true;
			loaderContext.securityDomain = SecurityDomain.currentDomain;
			
			mPetName = p_name;
			name = p_name;
			mAlreadyFed = p_fed_recently;
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			mLocalTesting ? mLoader.load(new URLRequest(p_pngurl)):mLoader.load(new URLRequest(p_pngurl), loaderContext);
		}
		
		
		//----------------------------------------
		//GETTER AND SETTER
		//----------------------------------------
		public function get getName():String
		{
			return mPetName
		}
		
		public function get image():DisplayObject
		{
			return mLoader.content
		}
		public function get alreadyFed():Boolean
		{
			return mAlreadyFed
		}
		
		public function set alreadyFed(b:Boolean):void
		{
			mAlreadyFed = b
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		private function onComplete(evt:Event):void {
			addChildAt(mLoader.content, 0)
			dispatchEvent(new Event (PET_LOADED));
		}
   }
}