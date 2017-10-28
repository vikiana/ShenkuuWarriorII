package com.neopets.util.tracker
{
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * Class to handle tracking calls for google, omniture, necontent and dart
	 * this class assumes the script http://images.neopets.com/js/omniture_coda.js has been included on the page
	 * 
	 * @author Bill Wetter (wetterb)
	 */
	public class NPStatsTracker 
	{
		protected var projectId:String = "PROJECT NAME HERE"; // this needs to be replaced with a named assigend to track this project
		protected var neoServerUrl:String = "http://dev.neopets.com";
		
		public function NPStatsTracker(pProjectId:String, pNeoServerUrl:String = null):void
		{
			projectId = pProjectId;
			if (pNeoServerUrl) {
				neoServerUrl = pNeoServerUrl;
			}
		}

		/**
		 *  Call this method when you want to track an impression or page view
		 * 
		 * @param	pPage
		 * @param	pDoubleClickAdId
		 * @param	pNeoContentId
		 */
		public function trackPageView(pPage:String, pDoubleClickAdId:int = 0, pNeoContentId:int = 0):void
		{	
			sendGooglePageView(pPage);
			sendOmniturePageView(pPage);
			
			if (pDoubleClickAdId > 0) {
				sendDartPageView(pDoubleClickAdId);
			}
			
			if (pNeoContentId > 0) {
				sendNeoContentPageView(pNeoContentId);
			}
		}
		
		/**
		 * Call this method to track events such as downloading a file, click thrus, button clicks, etc.
		 * 
		 * @param	pEventName
		 * @param	pNeoEventId
		 * @param	pEventType
		 */
		public function trackEvent(pEventName:String, pNeoEventId:int=0, pEventType:String = "o"):void
		{
			sendOmnitureEvent(pEventName, pEventType);
			
			if (pNeoEventId > 0) {
				sendNeoContentEvent(pNeoEventId);
			}
		}
		
		/**
		 * Call specifically for dart 1x1 impression tags. You pass in the adid which you can 
		 * find in the dart url (http://ad.doubleclick.net/ad/neopets.nol/neopets;adid=AD_ID_HERE;sz=1x1
		 * 
		 * @param	pDartAdID
		 */
		public function sendDartPageView(pDartAdID:int):void
		{
			var urlPath:String = "http://ad.doubleclick.net/ad/neopets.nol/neopets;adid=" + pDartAdID + ";sz=1x1;ord=" + Math.floor(Math.random() * 10000000000) + "?";
			sendUrlRequest(urlPath);
			trace("sending dart impression:" + urlPath);
		}
		
		/**
		 * Call to send out a google page view
		 * 
		 * @param	pPage
		 */
		public function sendGooglePageView(pPage:String):void
		{
			if (ExternalInterface.available){
				ExternalInterface.call("window.top.urchinTracker", projectId + "/" + pPage);	
			} else {
				trace("ExternalInterfaceCall Not Available");
			}
			trace("call google:" + pPage);
		}
		
		/**
		 *  Call to track an event(button click, file download, etc) in omniture
		 * 
		 * @param	pEventName
		 * @param	pEventType
		 */
		public function sendOmnitureEvent(pEventName:String, pEventType:String="o"):void
		{
			if (ExternalInterface.available){
				ExternalInterface.call("window.top.sendADLinkCall", projectId + " - " + pEventName);	
			} else {
				trace("ExternalInterfaceCall Not Available");
			}
		}
		
		/**
		 * Call to send out an omniture page view
		 * 
		 * @param	pPage
		 */
		public function sendOmniturePageView(pPage:String):void
		{
			if (ExternalInterface.available){
				ExternalInterface.call("window.top.sendReportingCall", pPage, projectId);	
			} else {
				trace("ExternalInterfaceCall Not Available");
			}
			trace("call omniture:" + pPage);
		}
		
		/**
		 * Call to send out a pageview/impression to neocontent
		 * 
		 * @param	pNeoId
		 */
		public function sendNeoContentPageView(pNeoId:int):void
		{
			var urlPath:String = neoServerUrl + "/nc_track.phtml?noredirect=1&nc_multiple=1&nc_status=10&item_id=" + pNeoId;
			sendUrlRequest(urlPath);
			trace("sending neocontent page view:" + urlPath);
		}

		/**
		 * Call to track an event(button click, file download, etc in neocontent
		 * 
		 * @param	pNeoId
		 */
		public function sendNeoContentEvent(pNeoId:int) 
		{
			var urlPath:String = neoServerUrl + "/process_click.phtml?item_id=" + pNeoId + "&noredirect=1";
			sendUrlRequest(urlPath);
			trace("sending neocontent event:" + urlPath);
		}
		
		/**
		 *  Simply loads the url passed in
		 * 
		 * @param	pUrl
		 */
		public function sendUrlRequest(pUrl:String):void
		{
			var theLoader:URLLoader = new URLLoader();
			var theRequest:URLRequest = new URLRequest(pUrl);
			theLoader.load(theRequest);
		}
		
	}
}