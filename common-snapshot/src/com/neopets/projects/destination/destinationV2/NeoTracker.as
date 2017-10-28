/**
 *	Handles various neocontent tracking issues.
 *	@NOTE:  If you are using this class, Please use NeoTracker in com.neopets.util.traker.NeoTracker
 			This class is only here to support older destinations.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  04.27.2009
 */

 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------
 
 
package com.neopets.projects.destination.destinationV2
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class NeoTracker
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private static const NEOCONTENT_URL:String = "http://www.neopets.com/process_click.phtml?noredirect=1&item_id=";	//URL for processing click URL
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function NeoTracker():void
		{	
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
		 * Call this method if marketing needs to simply track a button click without any 
		 * special follow up actions
		 *
		 * @PARAM		trackID		neocontent ID you've created		
		 **/
		public static function sendTrackerID(trackID:int):void 
		{
			triggerNeoContentTracker(trackID)
		}
		
		
		/**
		 * Sends URLrequest with specified neocontent ID
		 * @PARAM		trackID		neocontent ID you've created		
		 **/
		private static function triggerNeoContentTracker(trackID:uint):void 
		{
			if (!isNaN(trackID)) 
			{
				var str:String = NEOCONTENT_URL + String(trackID);
				var req:URLRequest = new URLRequest(str);
				var lv:URLLoader = new URLLoader();
				lv.addEventListener(Event.COMPLETE, onTriggerComplete, false, 0, true);
				try 
				{
					lv.load(req);
				} 
				catch (e:Error) 
				{
				}
				trace ("click URL: sending click URL", str)
			}
		}
		
		
		/**
		 * Sends URLrequest with specified neocontent ID
		 * @PARAM		pURL		custom tracking URL to get		
		 **/
		public static function triggerTrackURL(pURL:String):void 
		{
			var req:URLRequest = new URLRequest(pURL);
			var lv:URLLoader = new URLLoader();
			lv.addEventListener(Event.COMPLETE, onTriggerComplete, false, 0, true);
			try 
			{
				lv.load(req);
			} 
			catch (e:Error) 
			{
				trace ("Trigger Track URL Error:", e)
			}
			trace ("TiggerTrackURL Sending:", req)
		}
		
		
		
		/**
		 *	Removes listener once neocontent tracker request has been successful	
		 **/
		private static function onTriggerComplete(e:Event):void 
		{
			trace ("click URL: tracked successfully")
			e.target.removeEventListener(Event.COMPLETE, onTriggerComplete);
		}
		
		
		/**
		 *	This is to process neocontent url click (and direct to a certain page)
		 *	@PARAM		pLocation		String		tells where the content should open in.
		 **/
		public static function processClickURL(linkID:int, pLocation:String = '_blank'):void
		{
			var url:String = "http://www.neopets.com/process_click.phtml?item_id="+linkID.toString();
			var requestURL:URLRequest = new URLRequest(url);
			navigateToURL (requestURL, pLocation);
		}
		
	}
	
}