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
	
	public class ImageGalleryLink extends PageLink
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ImageGalleryLink():void {
			var dest_con:DestinationControl = Parameters.control as DestinationControl;
			if(dest_con != null) targetPage = dest_con.imageGalleryPageURL;
			super();
			
			// new rollover functionality
			//this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			//this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			//ADLinkID = "Main to Image Gallery";
			var ids:Object = {au:16691,fr:16692,de:16693,nl:16694,nz:16695,es:16696,uk:16697,us:16253};
			neoContentID = int(Number(DestinationView.getEntryByCC(ids)));
			//trace("Main to Image Gallery");
			
			this.addEventListener(MouseEvent.CLICK, processTracking);
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
			var url:String = "http://ad.doubleclick.net/clk;224982218;15177704;j?http://www.neopets.com/sponsors/despicableme/index.phtml?page=image";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Main to Image Gallery')");
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