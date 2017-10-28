/**
 *	Destination example shell class (document class for the project)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.despicableMe
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.Responder;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.servers.NeopetsServerFinder;
	import com.neopets.marketing.collectorsCase.DebugTracer;
	import virtualworlds.net.AmfDelegate;
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;
	import com.neopets.games.marketing.destination.despicableMe.DespicableMe_Translation;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class DestinationView extends AbsView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		// constants
		public static const IMAGE_PATH:String = "/sponsors/despicableme/";
		public static const LOAD_PAGE_REQUEST:String = "load_page_request";
		public static const NEOCONTENT_LINK_REQUEST:String = "navigateToNeoContent_request";
		public static const NEOCONTENT_TRACKING_REQUEST:String = "sendNeoContentClick_request";
		public static const NEOCONTENT_IMPRESSION_REQUEST:String = "sendNeoContentImpression_request";
		public static const ADLINK_REQUEST:String = "sendADLinkCall_request";
		public static const REPORTING_REQUEST:String = "sendReportingCall_request";
		public static const URCHIN_REQUEST:String = "urchinTracker_request";
		public static const SHOW:String = "show";
		// flash var constants
		public static const NUM_CHARACTERS:String = "characterNumber";
		public static const ALWAYS_WELCOME:String = "show_welcome";
		// private variables
		private var mNeoContentProjectID:String = "0000"	//please obtain legit NeoContentID from Producer
		private var mGroupMode:Boolean = true;
		// protected variables
		protected var _servers:NeopetsServerFinder;
		protected var _tracker:TrackingProxy
		protected var _pages:Array;
		protected var _currentPage:Loader;
		protected var _delegate:AmfDelegate;
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		*	instantiate control class and set up project ID
		**/
		public function DestinationView():void
		{
			super()
			//DebugTracer.addTextfieldTo(this,800,600); // add in to enable debug overlay
			_pages = new Array(); // create page array
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// figure out our servers
			_servers = new NeopetsServerFinder(this);
			Parameters.baseURL = _servers.scriptServer;
			Parameters.imageURL = _servers.imageServer;
			// set up proxy
			initTracking();
			setupAMFPHP();
			// set up translation
			var translator:TranslationManager = TranslationManager.instance;
			var lang:String = String(FlashVarManager.instance.getVar("lang"));
			var t_data:TranslationData = new DespicableMe_Translation();
			translator.init(lang,4001,14,t_data);
			// initialize view
			init (new DestinationControl (), mNeoContentProjectID, mGroupMode, _servers.isOnline)
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function get currentPage():Loader { return _currentPage; }
		
		// updated 5/12
		public function set currentPage(ldr:Loader) {
			// hide current page
			if(_currentPage != null) {
				_currentPage.visible = false;
			}
			_currentPage = ldr;
			// show new page
			if(_currentPage != null) {
				var cur_content:DisplayObject = _currentPage.content;
				if(cur_content != null) cur_content.dispatchEvent(new Event(SHOW));
				_currentPage.visible = true;
			}
		}
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		public function getPage(id:String):Loader {
			var entry:Loader;
			for(var i:int = 0; i < _pages.length; i++) {
				entry = _pages[i];
				if(entry.name == id) return entry;
			}
			return null;
		}
		
		// This function tries to extract a necontent id from a data object based on the
		// country code flash var.
		
		public static function getEntryByCC(src:Object,default_cc:String="us"):Object {
			if(src == null) return null;
			// if it's neither, treat it as a country code indexed list
			var cc:String = String(FlashVarManager.instance.getVar("cc"));
			if(cc != null) {
				cc = cc.toLowerCase();
				if(cc in src) return src[cc];
			}
			// check default country code
			if(default_cc in src) return src[default_cc];
			// if there's no country code specific entry, return the data as an id
			return src;
		}
		
		public function loadPage(id:String) {
			var page:Loader = getPage(id);
			if(page == null) {
				page = new Loader();
				page.name = id;
				// load the page
				var url:String;
				if(_servers.isOnline) {
					url = _servers.imageServer + IMAGE_PATH + id;
				} else url = id;
				var req:URLRequest = new URLRequest(url);
				page.contentLoaderInfo.addEventListener(Event.COMPLETE,onPageLoaded);
				
				trace("URL: "+url);
				page.load(req);
				// add page to stage
				addChild(page);
				// store page info
				_pages.push(page);
			}
			currentPage = page;
			
		}
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		protected function initTracking():void {
			if(_tracker == null) _tracker = new TrackingProxy();
			_tracker.projectName = "DespicableMe";
			_tracker.projectPath = "/sponsors/despicableme";
			_tracker.serverURL = _servers.scriptServer;
		}
		
		
		/**
		*	This is called after inital prameters are set (view, control, user name and project ID)
		*	remove spinning arrow or do other things as you please
		**/
		protected override function  setupReady ():void
		{
			//trace ("   remove loading arrow sign")
			//if (getChildByName("loaderArrow") != null) removeChild(getChildByName("loaderArrow"));
		}
		
		protected function setupAMFPHP():void {
			_delegate = new AmfDelegate();
			var base_url:String;
			if(Parameters.baseURL != null) base_url = Parameters.baseURL;
			else base_url = "http://dev.neopets.com";
			_delegate.gatewayURL = base_url + "/amfphp/gateway.php";
		    _delegate.connect();
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
				
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		// Use this function to listen for page loading requests.
		
		protected function onLoadPageRequest(ev:CustomEvent) {
			if(ev != null) {
				var id:String = String(ev.oData);
				trace("DestinationView - ID: "+id);
				loadPage(id);
			}
		}
		
		// This function lets us listen for events broadcast by our pages.
		
		protected function onPageLoaded(ev:Event) {
			var info:LoaderInfo = ev.target as LoaderInfo;
			if(info != null) {
				var dobj:DisplayObject = info.content;
				if(dobj != null) {
					dobj.addEventListener(LOAD_PAGE_REQUEST,onLoadPageRequest);
					dobj.addEventListener(NEOCONTENT_LINK_REQUEST,onNeoContentLink); // redirect
					dobj.addEventListener(NEOCONTENT_TRACKING_REQUEST,onNeoContentTracking); // no redirect
					dobj.addEventListener(NEOCONTENT_IMPRESSION_REQUEST,onNeoContentImpression); //
					dobj.addEventListener(ADLINK_REQUEST,onADLinkCall);
					dobj.addEventListener(REPORTING_REQUEST,onReportingCall);
					dobj.addEventListener(URCHIN_REQUEST,onUrchinTracker);
					dobj.dispatchEvent(new Event(SHOW));
				}
			}
		}
		
		// Tracking Functions
		
		protected function onNeoContentImpression(ev:CustomEvent) {
			var id:Object = getEntryByCC(ev.oData);
			if(id != null) _tracker.sendNeoContentImpression(int(Number(id)));
		}
		
		protected function onNeoContentLink(ev:CustomEvent) {
			var id:Object = getEntryByCC(ev.oData);
			if(id != null) _tracker.navigateToNeoContent(int(Number(id)));
		}
		
		protected function onNeoContentTracking(ev:CustomEvent) {
			var id:Object = getEntryByCC(ev.oData);
			if(id != null) _tracker.sendNeoContentClick(int(Number(id)));
		}
		
		protected function onADLinkCall(ev:CustomEvent) {
			_tracker.sendADLinkCall(ev.oData as String);
		}
		
		protected function onReportingCall(ev:CustomEvent) {
			_tracker.sendReportingCall(ev.oData as String);
		}
		
		protected function onUrchinTracker(ev:CustomEvent) {
			_tracker.urchinTracker(ev.oData as String);
		}
		
	}
}