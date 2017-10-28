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
	import com.neopets.games.marketing.destination.despicableMe.DestinationControl;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	
	public class QuestPageLink extends PageLink
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function QuestPageLink():void {
			var dest_con:DestinationControl = Parameters.control as DestinationControl;
			if(dest_con != null) targetPage = dest_con.questPageURL;
			
			//ADLinkID = "Main to Collection Quest";
			neoContentID = 16248;
			//trace("Main to Collection Quest");
			
			super();
			
			
			this.addEventListener(MouseEvent.CLICK, processTracking);
			
		
				
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
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
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Main to Collection Quest')");
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