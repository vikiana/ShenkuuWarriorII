/**
 * Modified version of Rob's loadPet class
 * (Difference: This class should be instantiated instead of being linked to a MC in the library)
 *
 *	============================================================================================
 *	IMPORTANT: BE SURE TO NOTIFY PHP PERSON AND HAVE HIM OR HER ADD YOUR FEEDCODE AS A LEGIT ID
 *	============================================================================================
 * 
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
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee 
 *	@since  03.26.2009
 **/


package com.neopets.projects.destination.feedapet{

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.events.*;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	

	public class AbstractFeedAPetAMFPHP extends MovieClip{

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		private const FEED_CODE:String = "TYPE14ITEM0000"	//a defult code for testing		
		public const PET_DATA_IN:String = "pet_date_in";	// pet data came in
		public const PET_FED:String ="pet_fed_successfully";	// fed pet is recorded successfully
		public const ERROR_OCCURED:String = "There was an error" // whenever amfphp returns an error
		public const NONE_ERROR_PROBLEM:String = "cannot feed a pet due to none error problem"
		
		private var mConnection:NetConnection;	//new connection for amfphp
		private var mPetDataArray:Array;	//amfphp gives pet data as array: contains imge url, fed status, etc.
		protected var mID:String	//projtect unique ID: type ID + project ID.  in amfphp, this is teh "feedcode",  ex. TYPE14ITEM1509 


		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		
		/**
		 *	Make the connection and retrieve user name to confirm it's login status
		 *	If all things go well, when the (child) class is instantiated,
		 *	it will eventualy dispatch "PET_DATA_IN"
		 *	get username (check for login) --> loadData --> getPetURL (users pet data) --> dispatch event
		 **/
		public function AbstractFeedAPetAMFPHP(pID:String = null) {
			if (pID == null)trace ("\n==========  UPDATE THE FEED CODE ========\n");
			mID = pID == null? FEED_CODE: pID
			mPetDataArray = new Array ()
			trace("FUNCTION: loadPet()");
			mConnection = new NetConnection();
			mConnection.objectEncoding = ObjectEncoding.AMF0;
			//mConnection.connect("/amfphp/gateway.php");
			mConnection.connect("http://www.neopets.com/amfphp/gateway.php");
			getUsername();
		}
		
		//----------------------------------------
		// GETTER AND SETTER
		//----------------------------------------
		public function get petDataArray():Array
		{
			return mPetDataArray
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------

		// for test purpose only (whenever amfphp returns boolean value)
		private function temp(b:Boolean):void
		{
			trace ("fed reset:", b)
		}

		// Checks to make sure user is logged in.
		protected function getUsername() 
		{
			var responder = new Responder(returnUsername, usernameError);
			mConnection.call("FeedAPet.getUsername", responder);
		}
		
		/**
		 * Only if the user is logged in, load pet data...
		 * @PARAM		p		if loggedin, it returns user name otherwise returns "false" string
		 **/
		protected function returnUsername(p:String) 
		{
			trace("USERNAME = " + p);
			var problem:String = "PLEASE LOGIN TO YOUR ACCOUNT"
			p != "false" ? loadData():  handleNoneErrorProblem(problem);
		}
		
	
		/**
		 * Should error occur while retrieving user name, show the error message
		 * @PARAM		f		Object is the return value of the amfphp call
		 **/
		protected function usernameError(f:Object) 
		{
			trace("USERNAME ERROR: " + f.description);
		}
		
		
		/**
		 * Load the pet data
		 **/
		protected function loadData() 
		{
			
			trace("FUNCTION: loadData()");
			var responder = new Responder(getPetUrl, onFault);
			var feedcode = mID
			mConnection.call("FeedAPet.getPets", responder, feedcode, 3);
		}
		
		/**
		 * Get petUrl (the array contatins pet image url, swf url, fed status, etc.)
		 * @PARAM		p		Array is the return value of the amfphp call
		 **/
		protected function getPetUrl(p:Array) 
		{
			trace ("get pet url", p)
			if (p[0].name != "Error") 
			{
				mPetDataArray = p;
				dispatchEvent(new Event(PET_DATA_IN))
			} 
			else 
			{
				//backdrop_mc.textbox.htmlText="<P align='center'>You do not have any pets to feed.</P>";
			}
		}
		
		/**
		 * call amfphp to feed a pet
		 * @PARAM		petname		name of the pet
		 **/
		public function feedPet(petname:String):void 
		{
			var responder = new Responder(afterFeed, onFault);
			var feedcode = mID
			trace (petname, feedcode)
			mConnection.call("FeedAPet.feedPet", responder, petname, feedcode);
			trace("FEEDING: " + petname);
		}
		
		/**
		 * amfphp return function
		 * @PARAM		p_result		return true if pet was fed, otherwise false
		 **/
		private function afterFeed(p_result:Boolean):void {
			trace("FEED RESULT: " + p_result);
			dispatchEvent(new Event (PET_FED))	
		}
		
		//In case of error
		function onFault(f:Object ) 
		{
			trace ("error", f)
			for (var i:String in f)
			{
				trace (f[i]);
			}
			dispatchEvent(new Event (ERROR_OCCURED));
			//status_txt.text = "There was a problem: " + f.description;
		}
		
		function handleNoneErrorProblem(pMessage:String):void
		{
			trace ("\n========", pMessage, "========\n")
			dispatchEvent(new CustomEvent({MESSAGE:pMessage}, NONE_ERROR_PROBLEM))
		}
	}
}