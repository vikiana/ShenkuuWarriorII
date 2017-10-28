package com.neopets.projects.np9.preloader
{
	// SYSTEM IMPORTS
	import com.neopets.projects.np9.system.NP9_TTextfields;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.net.sendToURL;
	
	// -----------------------------------------------------------------------------------
	public class NP9_Preloader_SponsoredAll extends MovieClip {

		private var mcMain:mcPreloader;
		
		private var objTTextfields:NP9_TTextfields;
		private var bTextInit:Boolean;
		
		private var bLoggedIn:Boolean;
		private var bPlayGame:Boolean;
		private var bTextSet:Boolean;
		private var bLogoLoaded:Boolean;
		private var bDelayActive:Boolean;
		private var bTrackingCalled:Boolean;
		
		private var iDelayGamestart:int;
		
		// dynamic sponsored preloader data
		private var	iGameWidth:Number;
		private var	iGameHeight:Number;
		private var sSpLogoURL:String;
		private var iSpTrackID:Number;
		private var sSpAdURL:String;
		
		private var sSpClickUrl:String = "";
		private var iSpLogoTrackID:Number = 0;
		
		private var objLogoLoader:Loader;
		private var bLogoLoadComplete:Boolean;
		
		private var mTestingURL:String = "http://breitkra.dev.neopets.com/test.php?url=http://www.google.com&redir=1";

		
		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		
		public function NP9_Preloader_SponsoredAll() {
			
			trace("\n**"+this+": "+"Instance created");
			
			objTTextfields = new NP9_TTextfields( true );
			bTextInit = false;
			
			bLoggedIn   = true;
			bPlayGame   = false;
			
			bTextSet        = false;
			bLogoLoaded     = false;
			bDelayActive    = false;
			bTrackingCalled = false;
			
			iDelayGamestart = 0;
			
			// dynamic sponsored preloader data
			iGameWidth  = 0;
			iGameHeight = 0;
			sSpLogoURL  = "";
			iSpTrackID  = -1;
			sSpAdURL    = "";
			
			bLogoLoadComplete = false;
		}
		
		// ---------------------------------------------------------------
		public function addAnimation():void {
		
			mcMain = new mcPreloader();
			mcMain.x = 0;
			mcMain.y = 0;
			addChild( mcMain );
			
			mcMain.trans_box.visible = false;
			
			mcMain.addEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
		}
		
		// ---------------------------------------------------------------
		public function setData( p_bIsLoggedIn:Boolean,
		                         p_bStartGame:Boolean ):void {
		                         	
			bLoggedIn = p_bIsLoggedIn;
			bPlayGame = p_bStartGame;
		}
		
		// ---------------------------------------------------------------
		public function isLoggedIn():Boolean {
			return ( bLoggedIn );
		}
		
		// ---------------------------------------------------------------
		public function startGame():Boolean {
			return ( bPlayGame );
		}
		
		// ---------------------------------------------------------------
		public function setStart( p_b:Boolean ):Boolean {
			bPlayGame = p_b;
		}
		
		// ---------------------------------------------------------------
		public function initTextFields( p_bIsWesternLang:Boolean ):void {
			
			objTTextfields.init( p_bIsWesternLang );
			
			objTTextfields.addFont( new _internalVerdana(), "myVerdana" );
			objTTextfields.addFont( new _internalJokerman(), "myJoker" );
			objTTextfields.addFont( new _internalFutura(), "myFutura" );
			
			trace("\n**"+this+": "+"initTextFields: "+p_bIsWesternLang);
		}
		
		// ---------------------------------------------------------------
		public function initLogoTracking( p_iGameWidth:Number=640,
										  p_iGameHeight:Number=480,
										  p_sSpLogoURL:String="",
										  p_iSpTrackID:Number=-1,
										  p_sSpAdURL:String="",
										  p_sSpClickUrl:String="",
										  p_iSpLogoTrackID:String=""):void 
		{
			
			iGameWidth  = p_iGameWidth;
			iGameHeight = p_iGameHeight;
			sSpLogoURL  = unescape(p_sSpLogoURL);
			iSpTrackID  = p_iSpTrackID;
			sSpAdURL    = unescape(p_sSpAdURL);
			sSpClickUrl = unescape(p_sSpClickUrl);
			iSpLogoTrackID = p_iSpLogoTrackID;
			
			if ( !bTrackingCalled ) 
			{
				
				bTrackingCalled = true;
				
				var trackingURL = "http://www.neopets.com/process_click.phtml?item_id=" + String(iSpTrackID) + "&noredirect=1";
				var trackingLoader:URLLoader = new URLLoader();
				var trackingRequest:URLRequest = new URLRequest( trackingURL );
				trackingLoader.load( trackingRequest );
	
				var adLoader:URLLoader = new URLLoader();
				var adRequest:URLRequest = new URLRequest( sSpAdURL );
				adLoader.load( adRequest );
				
				var logoTrackingURL = "http://www.neopets.com/process_click.phtml?item_id=" + String(iSpLogoTrackID) + "&noredirect=1";
				var logoTrackingLoader:URLLoader = new URLLoader();
				var logoTrackingRequest:URLRequest = new URLRequest( logoTrackingURL );
				logoTrackingLoader.load( logoTrackingRequest );
				
				
			}
		}
		
		public function setSpLogoClickUrl( s:String ):void {
			sSpClickUrl = unescape( s );
		}
		
		public function getSpLogoClickUrl():String {
			return sSpClickUrl;
		}

		public function setSpLogoTrackID( n:Number ):void {
			iSpLogoTrackID = n;
		}
		
		public function getSpLogoTrackID():Number {
			return iSpLogoTrackID;
		}
		
		// ---------------------------------------------------------------
		public function setLegalText( sText:String ):void {
			
		}
		
		// ---------------------------------------------------------------
		public function setHeaderText( sText:String ):void {
			
		}
		
		// ---------------------------------------------------------------
		public function showLoadingProcess( sText:String, iPercent:int=0 ):void {
			
			if ( !bTextSet ) {
				
				mcMain.trans_box.visible = true;
				if ( bLoggedIn ) mcMain.trans_box.height = 170;
				else mcMain.trans_box.height = 200;
				
				bTextSet = true;
			}
			
			if ( !bTextInit ) {
			
				bTextInit = true;	
				objTTextfields.setFont( "myVerdana" );
				objTTextfields.setTextField( mcMain.mcFields.txtProgress, "Ollie" );
			}
			
			mcMain.mcFields.txtProgress.htmlText = sText;
			
		}
		
		// ---------------------------------------------------------------
		public function onLogoLoaded( e:Event ):void {
			
			bLogoLoadComplete = true;
			objLogoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLogoLoaded);
			setLogoSize();
		}
		
		// ---------------------------------------------------------------
		public function onClicked( e:MouseEvent ):void {
			
			//CURRENT > navigateToURL( new URLRequest( sSpClickUrl ), "_blank" );
			var tUrlRequest:URLRequest = new URLRequest(mTestingURL);
			sendToURL(tUrlRequest);
			
			//############################## CHANGE THIS ###############################################
		}
		
		// ---------------------------------------------------------------
		private function onPreloaderEnterFrame( e:Event ):void {
			
			if ( !bLogoLoaded ) {
				
				// make preloader clickable
				mcMain.mcClick.addEventListener(MouseEvent.CLICK, onClicked);
				mcMain.mcClick.useHandCursor = true;
				mcMain.mcClick.buttonMode = true;
			
				if(sSpLogoURL == "") sSpLogoURL = "http://images.neopets.com/games/preloaders/logos/clientlogo.jpg";
				
				objLogoLoader = new Loader();
				var urlReq:URLRequest = new URLRequest( sSpLogoURL );
				objLogoLoader.load( urlReq );
				objLogoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLogoLoaded, false, 0, true);
				mcMain.mcAni.logoLoader.addChild( objLogoLoader );
				
				bLogoLoaded = true;
			}
			
			// activate delay?
			if ( mcMain.mcAni.currentFrame >= 65 ) {
				if ( !bDelayActive ) {
					iDelayGamestart = getTimer() + 4000;
					bDelayActive = true;
				}
			}
			
			// time to check delay?
			if ( bDelayActive ) {
				
				if ( getTimer() >= iDelayGamestart ) {
					mcMain.removeEventListener( Event.ENTER_FRAME, onPreloaderEnterFrame );
					if ( bLoggedIn ) bPlayGame = true;
				} else {
					if ( bLoggedIn ) bPlayGame = false;
				}
			}
			else {
				bPlayGame = false;
			}
		}
		
		// ---------------------------------------------------------------
		private function setLogoSize():void {
			
			var mcLogo:Loader = objLogoLoader;
			
			var logoOrigW:int = mcLogo.width;
			var logoOrigH:int = mcLogo.height;
			
			var maxw = 527;
			var maxh = 259;
			var ratio = 1;
			
			// adjust scaling of logo depending on window dimensions
			if ( (iGameWidth != 0) && (iGameHeight != 0) ) {
				
				if ( iGameWidth > iGameHeight ) {
					ratio = (iGameHeight / iGameWidth);
					mcLogo.width *= ratio;
				} else if ( iGameHeight > iGameWidth ) {
					ratio = (iGameWidth / iGameHeight);
					mcLogo.height *= ratio;
				}
			}
			
			// make sure logo is not too wide
			if ( mcLogo.width > maxw ) {
				ratio = maxw / mcLogo.width;
				mcLogo.width *= ratio;
				mcLogo.height *= ratio;
			}
			
			// make sure logo is not too high
			if ( mcLogo.height > maxh ) {
				ratio = maxh / mcLogo.height;
				mcLogo.height *= ratio;
				mcLogo.width *= ratio;
			}
			
			// adjust position of logo
			if ( mcLogo.width < maxw ) mcLogo.x += int(((maxw-mcLogo.width)/2));
			if ( mcLogo.height < maxh ) mcLogo.y += int(((maxh-mcLogo.height)/2));
		}
	}
}