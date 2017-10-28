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
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.games.marketing.destination.despicableMe.DestinationControl;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	public class VideoPageLink extends PageLink
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoPageLink():void {
			var dest_con:DestinationControl = Parameters.control as DestinationControl;
			if(dest_con != null) targetPage = dest_con.videoPageURL;
			super();
			// new rollover functionality
			//this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			//this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			//ADLinkID = "Main to Video Page";
			var ids:Object = {au:16684,fr:16685,de:16686,nl:16687,nz:16688,es:16689,uk:16690,us:16252};
			neoContentID = int(Number(DestinationView.getEntryByCC(ids)));
			//trace("Main to Video Page");
			
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
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Main to Video Gallery')");
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