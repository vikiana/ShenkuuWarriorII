/**
 *	This class handles links to other pages in the same destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.nav
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.games.marketing.destination.despicableMe.DestinationControl;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	
	public class FeedAPetLink extends PageLink
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FeedAPetLink():void {
			var dest_con:DestinationControl = Parameters.control as DestinationControl;
			if(dest_con != null) targetPage = dest_con.feedPageURL;
			super();
			
			this.addEventListener(MouseEvent.CLICK, processTracking);
			
			//ADLinkID = "Main to Feed A Pet";
			var ids:Object = {au:16670,fr:16671,de:16672,nl:16673,nz:16674,es:16675,uk:16676,us:16249};
			neoContentID = int(Number(DestinationView.getEntryByCC(ids)));
			//trace("Main to Feed A Pet");
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function processTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224982081;15177704;h?http://www.neopets.com/sponsors/despicableme/index.phtml?page=gadget";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Main to Feed-a-Pet')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}