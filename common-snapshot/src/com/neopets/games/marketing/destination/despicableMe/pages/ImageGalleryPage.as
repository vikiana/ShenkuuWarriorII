/**
 *	This class handles the image gallery in the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Neil S. 
 *	@since  05.06.2010
 */


package com.neopets.games.marketing.destination.despicableMe.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class ImageGalleryPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var agnes_mc:MovieClip;
		public var kyle_mc:MovieClip;
		public var gru_mc:MovieClip;
		public var doc_mc:MovieClip;
		public var logo_mc:MovieClip;
		
		public var minion_mc:MovieClip;
		public var margo_mc:MovieClip;
		public var mom_mc:MovieClip;
		public var edith_mc:MovieClip;
		
		public var hattie_mc:MovieClip;
		public var vector_mc:MovieClip;
		public var perkins_mc:MovieClip;
		
		public var dadMom_mc:MovieClip;
		public var fred_mc:MovieClip;
		
		public var bg_mc:MovieClip;
		
		public var back_mc:MovieClip;
		
		protected var delegate:AmfDelegate;
		
		private var agnes:Agnes_Pop = new Agnes_Pop;
		private var gru:Gru_Pop = new Gru_Pop;
		private var edith:Edith_Pop = new Edith_Pop;
		private var hattie:Hattie_Pop = new Hattie_Pop;
		private var kyle:Kyle_Pop = new Kyle_Pop;
		
		private var margo:Margo_Pop = new Margo_Pop;
		private var minion:Minion_Pop = new Minion_Pop;
		private var mom:Mom_Pop = new Mom_Pop;
		private var doc:Nefario_Pop = new Nefario_Pop;
		private var perkins:Perkins_Pop = new Perkins_Pop;
		
		private var vector:Vector_Pop = new Vector_Pop;
		
	    private var fred:Fred_Pop = new Fred_Pop;
		private var momDad:DadMom_Pop = new DadMom_Pop;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ImageGalleryPage(pName:String = null, pView:Object = null):void
		{
			//Standare Destination code
			super(pName, pView);
			setupPage();
			// check if this swf has been loaded previously
			// get flash var data
			FlashVarManager.instance.initVars(root);
			
			//----------------------------
			
			trace("ImageGallery Constructor");
			initEvents();
			bg_mc.visible = false;
			// finish loading
			//DisplayUtils.cacheImages(this);
			
			
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image Gallery','DespicableMe2010')");
				ExternalInterface.call("window.top.urchinTracker('DespicableMe2010/ImageGallery')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function initEvents():void
		{
		  agnes_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  kyle_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  gru_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  perkins_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  
		  edith_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  hattie_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  doc_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  vector_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  
		  margo_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  mom_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  minion_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  
		  fred_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  dadMom_mc.addEventListener(MouseEvent.CLICK, loadImage);
		  
		  agnes_mc.buttonMode = true;
		  kyle_mc.buttonMode = true;
		  gru_mc.buttonMode = true;
		  perkins_mc.buttonMode = true;
		  
		  edith_mc.buttonMode = true;
		  hattie_mc.buttonMode = true;
		  doc_mc.buttonMode = true;
		  vector_mc.buttonMode = true;
		  
		  margo_mc.buttonMode = true;
		  minion_mc.buttonMode = true;
		  mom_mc.buttonMode = true;
		  fred_mc.buttonMode = true;
		  dadMom_mc.buttonMode = true;
		  
		  logo_mc.addEventListener(MouseEvent.CLICK, logoTracking);
		  logo_mc.addEventListener(MouseEvent.CLICK, goToSite);
		  logo_mc.buttonMode = true;
		  
		  back_mc.addEventListener(MouseEvent.CLICK, backMCTracking);
		  
			
		}
		
		protected override function setupPage():void {
			// set up amf delegate for quest notifications
			delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    delegate.connect();
		}
			
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function loadImage(e:Event):void
		{
			trace(e.target.name);
			
			var ids:Object;
		switch(e.target.name)
		{
			
			case "agnes_mc":
			ids = {au:16796,fr:16797,de:16798,nl:16799,nz:16800,es:16801,uk:16802,us:16269};
			addChild(agnes);
			agnes.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			agnes.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			agnes.close_mc.buttonMode = true;
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 7 (Agnes)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
			break;
			
			case "kyle_mc":
			ids = {au:16782,fr:16783,de:16784,nl:16785,nz:16786,es:16787,uk:16788,us:16267};
			addChild(kyle);
			kyle.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			kyle.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			kyle.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 5 (Kyle)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "gru_mc":
			ids = {au:16754,fr:16755,de:16756,nl:16757,nz:16758,es:16759,uk:16760,us:16263};
			addChild(gru);
			gru.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			gru.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			gru.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 1 (Gru)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			
			case "perkins_mc":
			ids = {au:16838,fr:16839,de:16840,nl:16841,nz:16842,es:16843,uk:16844,us:16275};
			addChild(perkins);
			perkins.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			perkins.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			perkins.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 13 (Mr. Perkins)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "edith_mc":
			ids = {au:16803,fr:16804,de:16805,nl:16806,nz:16807,es:16808,uk:16809,us:16270};
			addChild(edith);
			edith.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			edith.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			edith.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 8 (Edith)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "hattie_mc":
			ids = {au:16810,fr:16811,de:16812,nl:16813,nz:16814,es:16815,uk:16816,us:16271};
			addChild(hattie);
			hattie.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			hattie.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			hattie.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 9 (Miss Hattie)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "doc_mc":
			ids = {au:16775,fr:16776,de:16777,nl:16778,nz:16779,es:16780,uk:16781,us:16266};
			addChild(doc);
			doc.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			doc.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			doc.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 4 (Dr. Nefario)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "vector_mc":
			ids = {au:16768,fr:16769,de:16770,nl:16771,nz:16772,es:16773,uk:16774,us:16265};
			addChild(vector);
			vector.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			vector.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			vector.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 3 (Vector)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "margo_mc":
			ids = {au:16789,fr:16790,de:16791,nl:16792,nz:16793,es:16794,uk:16795,us:16268};
			addChild(margo);
			margo.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			margo.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			margo.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 6 (Margo)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "mom_mc":
			ids = {au:16824,fr:16825,de:16826,nl:16827,nz:16828,es:16829,uk:16830,us:16273};
			addChild(mom);
			mom.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			mom.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			mom.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 11 (Grus Mom)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "minion_mc":
			ids = {au:16761,fr:16762,de:16763,nl:16764,nz:16765,es:16766,uk:16767,us:16264};
			addChild(minion);
			minion.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			minion.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			minion.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 2 (Minions)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			
			case "fred_mc":
			ids = {au:16817,fr:16818,de:16819,nl:16820,nz:16821,es:16822,uk:16823,us:16272};
			addChild(fred);
			fred.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			fred.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			fred.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 10 (Fred McDade)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			
			case "dadMom_mc":
			ids = {au:16831,fr:16832,de:16833,nl:16834,nz:16835,es:16836,uk:16837,us:16274};
			addChild(momDad);
			momDad.x = 200;
			bg_mc.visible = true;
			bg_mc.play();
			momDad.close_mc.addEventListener(MouseEvent.CLICK, changeBG);
			momDad.close_mc.buttonMode = true;
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendReportingCall('Image 12 (Tourist Mom and Dad)','DespicableMe2010')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			break;
			

			default:
			trace ("loadImage() error");
			}
			
			// Trigger neocontent link
			if(ids != null) {
				var target_id:Object = DestinationView.getEntryByCC(ids);
				//var req_event:CustomEvent = new CustomEvent(target_id,DestinationView.NEOCONTENT_LINK_REQUEST);
				
				//	9/15 change so there isn't a redirect
				//trace('no redirect');
				var req_event:CustomEvent = new CustomEvent(target_id,DestinationView.NEOCONTENT_TRACKING_REQUEST);
				dispatchEvent(req_event);
			}
			
			// let php know we've taken a step to completing a task
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("DespicableMe2010Service.recordActivity",responder,"image");
			
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordResult(msg:Object):void {
			trace("onRecordResult: " + msg);
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		public function onRecordFault(msg:Object):void {
			trace("onRecordFault: " + msg);
		}
		
		private function changeBG(e:Event):void
		{
			//trace(e.target.name);
			//trace(e.target.parent);
			removeChild(e.target.parent); // removes the popup
			bg_mc.visible = false;
		}
		
		private function goToSite(e:Event):void 
		{
			// direct url version
			var req:URLRequest = new URLRequest("http://www.neopets.com/sponsors/despicableme/redir.phtml?dest=web");
			navigateToURL(req);
			
			// neocontent version
			//var req_event:CustomEvent = new CustomEvent(16261,DestinationView.NEOCONTENT_LINK_REQUEST);
			//dispatchEvent(req_event);
			
		}
		
		private function backMCTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224987286;15177704;t?http://www.neopets.com/sponsors/despicableme/index.phtml";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
		}
		
		private function logoTracking(e:Event):void
		{
			// Metric tracking
			var url:String = "http://ad.doubleclick.net/clk;224987619;15177704;t?http://www.despicable.me/";
			var request:URLRequest = new URLRequest(url);
			sendToURL(request);
			
			//omniture, google tracking
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.top.sendADLinkCall('DespicableMe Destination Image Gallery to Despicable.Me Microsite')");
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
			
		}

		
		
	}
	
}
