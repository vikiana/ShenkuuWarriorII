// ---------------------------------------------------------------------------------------
// Dynamic Sponsored Game PreLoader - Logo Clickable
//
// Author: Ollie B.
// Last Update: 06/18/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.preloader
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_TTextfields;
	
	// -----------------------------------------------------------------------------------
	public class NP9_Preloader_Control_Sponsored2 extends MovieClip {

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
		
		private var sSpLogoClickUrl:String = "";
		private var iSpLogoTrackID:Number = 0;

		private var objLogoLoader:Loader;
		private var bLogoLoadComplete:Boolean;
		//private var mcLogo:MovieClip;

		
		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_Preloader_Control_Sponsored2() {
			
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
			
			/*
			if ( mcMain.mcLayer != null ) {
				mcMain.mcLayer.alpha = 0;
			}
			*/
			
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
			
			// initialize ttextfield object
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
										  p_sSpLogoClickUrl:String="",
										  p_iSpLogoTrackID:String=""):void {
			
			iGameWidth  = p_iGameWidth;
			iGameHeight = p_iGameHeight;
			sSpLogoURL  = unescape(p_sSpLogoURL);
			iSpTrackID  = p_iSpTrackID;
			sSpAdURL    = unescape(p_sSpAdURL);
			sSpLogoClickUrl = unescape(p_sSpLogoClickUrl);
			iSpLogoTrackID = p_iSpLogoTrackID;
			
			if ( !bTrackingCalled ) {
				
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
				
				/*var logoClickLoader:URLLoader = new URLLoader();
				var logoClickRequest:URLRequest = new URLRequest( sSpLogoClickUrl );
				logoClickLoader.load( logoClickRequest );*/
				
			}
		}
		
		public function setSpLogoClickUrl( s:String ):void {
			sSpLogoClickUrl = unescape( s );
		}
		
		public function getSpLogoClickUrl():String {
			return sSpLogoClickUrl;
		}

		public function setSpLogoTrackID( n:Number ):void {
			iSpLogoTrackID = n;
		}
		
		public function getSpLogoTrackID():Number {
			return iSpLogoTrackID;
		}
		
		// ---------------------------------------------------------------
		public function setLegalText( sText:String ):void {
			
			/*
			if ( mcMain.mcFields.txtLegal != null ) {
				mcMain.mcFields.txtLegal.embedFonts = true;
				mcMain.mcFields.txtLegal.htmlText = sText;
			}
			*/
		}
		
		// ---------------------------------------------------------------
		public function setHeaderText( sText:String ):void {
			
			/*
			if ( mcMain.mcFields.txtHeader != null ) {
				objTTextfields.setFont( "myJoker" );
				objTTextfields.setTextField( mcMain.mcFields.txtHeader, sText );
			}
			*/
		}
		
		// ---------------------------------------------------------------
		public function showLoadingProcess( sText:String, iPercent:int=0 ):void {
			
			if ( !bTextSet ) {
				
				/*
				if ( mcMain.mcAni.ad_txt != null ) {
					mcMain.mcAni.ad_txt.htmlText = _level0.IDS_PRELOADER_ADVERT;
				}
				if ( mcMain.mcAni.featureTxt.feat_txt != null ) {
					mcMain.mcAni.featureTxt.feat_txt.htmlText = _level0.IDS_PRELOADER_FEATURED2;
				}
				if ( mcAni.sponTxt.spon_txt != undefined ) {
					mcAni.sponTxt.spon_txt.htmlText = _level0.IDS_PRELOADER_SPONSORED2;
				}
				*/
				
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
			
			/*
			if ( mcMain.mcFields.txtProgress == null ) return;
			
			if ( !bTextInit ) {
			
				bTextInit = true;	
				objTTextfields.setFont( "myVerdana" );
				objTTextfields.setTextField( mcMain.mcFields.txtProgress, "" );
			}
			
			mcMain.mcFields.txtProgress.htmlText = sText;
			
			if ( mcMain.mcLayer != null ) {
				if ( mcMain.mcLayer.alpha != 0.5 ) { 
					mcMain.mcLayer.alpha = 0.5;
				}
			}
			*/
		}
		
		// ---------------------------------------------------------------
		public function onLogoLoaded( e:Event ):void {
			
			bLogoLoadComplete = true;
			objLogoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLogoLoaded);
			setLogoSize();
			
			// make logo clickable
			objLogoLoader.addEventListener(MouseEvent.CLICK, onLogoClicked);
			mcMain.mcAni.logoLoader.useHandCursor = true;
			mcMain.mcAni.logoLoader.buttonMode = true;
		}
		
		// ---------------------------------------------------------------
		public function onLogoClicked( e:MouseEvent ):void {

			// URL should be dynamic at some point
			//navigateToURL( new URLRequest("http://www.neopets.com"), "_blank" );
			navigateToURL( new URLRequest( sSpLogoClickUrl ), "_blank" );
		}
		
		// ---------------------------------------------------------------
		private function onPreloaderEnterFrame( e:Event ):void {
			
			if ( !bLogoLoaded ) {
				
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