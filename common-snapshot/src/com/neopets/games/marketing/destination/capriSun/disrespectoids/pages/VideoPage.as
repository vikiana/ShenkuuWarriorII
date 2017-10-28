/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.util.servers.NeopetsAmfManager;
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class VideoPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const VIDEO_RESULT:String = "getVideoReleases_result";
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// finish loading
			DisplayUtils.cacheImages(this);
			// dispatch tracking when shown by preloader
			addEventListener(DestinationView.SHOW,onShown);
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
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function is triggered by the preloader when this page is shown.
		
		public function onShown(ev:Event) {
			// dispatch tracking requests
			var req_event:CustomEvent = new CustomEvent("VideoGallery",DestinationView.REPORTING_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent("videoGallery",DestinationView.URCHIN_REQUEST);
			dispatchEvent(req_event);
			req_event = new CustomEvent(16130,DestinationView.NEOCONTENT_IMPRESSION_REQUEST);
			dispatchEvent(req_event);
			// get video info
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
			var responder:Responder = new Responder(onVideoResult,onVideoFault);
			delegate.callRemoteMethod("CapriSun2010Service.getVideoReleases",responder);
		}
		
		// "Item Info" Response Listeners
		
		protected function onVideoResult(msg:Object):void {
			trace("onVideoResult: " + msg);
			// send result out to listeners
			var transmission:CustomEvent = new CustomEvent(msg,VIDEO_RESULT);
			dispatchEvent(transmission);
		}
		
		protected function onVideoFault(msg:Object):void {
			trace("onVideoFault: " + msg);
		}

	}
	
}