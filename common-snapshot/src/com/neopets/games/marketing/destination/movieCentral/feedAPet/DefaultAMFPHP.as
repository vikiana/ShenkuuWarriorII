/**
 *	It simply extends feedAPetMain (abstract class to deal with amfphp side of feedapet)
 *
 *	IMPORTANT: BE SURE TO NOTIFY PHP PERSON (JOE) AND HAVE HIM OR HER ADD YOUR FEEDCODE AS A LEGIT ID
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.6.2009
 */

package com.neopets.games.marketing.destination.movieCentral.feedAPet
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.net.Responder;
	import flash.net.NetConnection;
	import com.neopets.util.events.CustomEvent;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.feedapet.AbsFeedAPetAMFPHP;
		
	public class DefaultAMFPHP extends AbsFeedAPetAMFPHP
	{
		
		//----------------------------------------
		//	CONSTANT
		//----------------------------------------
		public const PET_RESPONSE:String = "Movie_central_Pet_responses_are_in" 
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function DefaultAMFPHP(pID:String = null):void
		{
			super(pID);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function petResponse():void 
		{
			trace ("get pet response")
			var responder = new Responder(onPetResponseReceived, onFault);
			mConnection.call("FeedAPet.getMessages", responder, "movie");
		}
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		protected function onPetResponseReceived(pArray:Array)
		{
			dispatchEvent(new CustomEvent({DATA:pArray}, PET_RESPONSE))
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}