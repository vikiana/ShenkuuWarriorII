/**
 *	Tracking system, singleton pattern
 *	When you call the any tracking call, it'll add the url(s) in an array and calls each array at a time
 *	Should an address throw an error, it'll trace a statement and continue on to the next one 
 *	@NOTE: currently it supports url based tracking system only
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.29.2009
 *
 *	----------------------------------------
 *	@TODO
 *	-Java cript calling.
 *	-Account for navigate to _self command... what happens it's still processing click urls and suddendly it needs to open up another html page... trackign can be potentially lost...
 *	----------------------------------------
 */
 
 /**
  *	EXAMPLE 
  *	Use one of the function below
  *	NeoTracker.instance.trackURL("http://www.trackurl.com")
  *	NeoTracker.instance.trackURLArray(["url1", "url2", ...,])
  *	NeoTracker.instance.trackNeoContentID(12345)
  *	NeoTracker.instance.processClickURL(12345, "_self")
  **/
 
 
 
package com.neopets.util.tracker
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class NeoTracker extends EventDispatcher
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		private static const NEOCONTENT_NO_DIRECT_URL:String = "http://www.neopets.com/process_click.phtml?noredirect=1&item_id=";
		private static const NEOCONTENT_URL:String = "http://www.neopets.com/process_click.phtml?item_id="
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance : NeoTracker;	
		private var mUrlArray:Array = [];	//	All the urls that needs to be tracked will be added here;
		private var mLoader:URLLoader;	
		private var mLoaderActive:Boolean = false;
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function NeoTracker(pPrivCl : PrivateClass):void
		{
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		/**
		 *	a singleton instance, when the instance is created, a urlLoader is also created 
		 **/
		public static function get instance( ):NeoTracker
		{
			if( NeoTracker.mReturnedInstance == null ) 
			{
				NeoTracker.mReturnedInstance = new NeoTracker( new PrivateClass( ) );
				NeoTracker.mReturnedInstance.setupTrackerLoader();
				trace ("create tracker")
			}
			
			return NeoTracker.mReturnedInstance
		}
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	Tracks a single URL
		 *	@PARAM		pURL		String			url you need to call
		 **/
		public function trackURL(pURL:String):void
		{
			mUrlArray.push(pURL)
			checkTracking()
		}
		
		/**
		 *	Track urls in an array
		 *	@PARAM		pURLArray		Array		This array contains urls strings
		 **/
		public function trackURLArray(pURLArray:Array):void
		{
			if (pURLArray != null && pURLArray.length > 0)
			{
				mUrlArray = mUrlArray.concat(pURLArray)
				checkTracking()
			}
			else 
			{
				trace ("Class: NeoTracker under com.noepets.uitl.tracker [url Array is empty or null]")
			}
		}
		
		/**
		 *	for neo content click ID, simply put ID and it'll track
		 *	@PARAM		pID		INT			neoContent click ID
		 **/
		public function trackNeoContentID(pID:int):void
		{
			mUrlArray.push(NEOCONTENT_NO_DIRECT_URL + pID.toString())
			checkTracking()
		}
		
		
		/**
		 *	use thit is neocontent ID is a process click (i.e. need to open up a page
		 *	@PARAM		pID			INT			neoContent click ID
		 *	@PARAM		pLocation	String		"_blank" is new html window, "_self" for the same window
		 **/
		public static function processClickURL(linkID:int, pLocation:String = '_blank'):void
		{
			trace ("PROCESS CLICK"+linkID.toString());
			var url:String = "http://www.neopets.com/process_click.phtml?item_id="+linkID.toString();
			var requestURL:URLRequest = new URLRequest(url);
			navigateToURL (requestURL, pLocation);
		}
		
		/**
		 *	Call this just for navigating to a url page (usually for testing period.before tracking kicks in)
		 *	@PARAM		pURL		String		URL to navigate to...
		 *	@PARAM		pLocation	String		"_blank" is new html window, "_self" for the same window
		 **/
		public static function processURL(pURL:String, pLocation:String = '_blank'):void
		{
			var url:String = pURL;
			var requestURL:URLRequest = new URLRequest(url);
			navigateToURL (requestURL, pLocation);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	setup one url loader to handle all the loads
		 **/
		private function setupTrackerLoader():void
		{
			mLoader = new URLLoader ()
			mLoader.addEventListener(Event.COMPLETE, onTriggerComplete, false, 0, true);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true)
		}
		
		
		/**
		 *	If the loader is already in the process of calling URLs, don't do anything
		 *	Otherwise start process the array and track url(s)
		 **/
		private function checkTracking():void
		{
			if (!mLoaderActive)
			{
				mLoaderActive = true
				startTracking()
			}
		}
		
		/**
		 *	Start Tracking all the urls in the array until it's empty
		 *	@NOTE:	The url is physically poped out from the array in the order it came.
		 *			Thus, should an error occur with a particular url, it'll simply by pass it and move on
		 *			
		 **/
		private function startTracking():void
		{
			if (mUrlArray.length > 0)
			{
				var url:String = mUrlArray.shift()
				var rURL:URLRequest = new URLRequest (url)
				try
				{
					mLoader.load(rURL)
				}
				catch (e:Error)
				{
					trace ("Error in tracking URL, Class: NeoTracker, Func: startTracking()", e)
					trace ("Will skip this particular array and continue")
					startTracking()
				}
				trace ("click URL: sending click URL", url)
			}
			else 
			{
				trace ("Current Batch of Url Array is done")
				mLoaderActive = false
			}
		}
		
		
		/**
		 *	after a load call(track) has been successful, continue with the tracking process
		 **/
		private function onTriggerComplete(e:Event):void 
		{
			trace ("URL: tracked successfully")
			startTracking()
		}
		
		/**
		 *	if error should occur, skip and move on to next
		 **/
		private function ioErrorHandler(evt:IOErrorEvent):void 
		{
			trace (evt)
			trace ("Error Occured, skip this url and continue")
			startTracking()
		}
		
		
	}
	
}

//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} 