//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.sega
{
	import com.neopets.games.marketing.destination.sega.pages.PopupError;
	import com.neopets.games.marketing.destination.sega.pages.PopupGetPrize;
	import com.neopets.games.marketing.destination.sega.pages.PopupNotLoggedIn;
	import com.neopets.games.marketing.destination.sega.pages.SegaAboutPage;
	import com.neopets.games.marketing.destination.sega.pages.SegaGalleryPage;
	import com.neopets.games.marketing.destination.sega.pages.SegaLandingPage;
	import com.neopets.games.marketing.destination.sega.pages.SegaTriviaPage;
	import com.neopets.games.marketing.destination.sega.pages.SegaVideoPage;
	import com.neopets.games.marketing.destination.sega.pages.TriviaPopup;
	import com.neopets.games.marketing.destination.sega.widgets.ReleaseDate;
	import com.neopets.projects.destination.destinationV3.AbsControl;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	/**
	 * public class GuardiansControl extends AbsControl
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class SegaControl extends AbsControl
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------
		//events
		
		var overrideLogin: Boolean = false;
		
		
		public static const PAGE_DISPLAY:String = "PageIsDisplayed";
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
	
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class GuardiansControl extends AbsControl instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function SegaControl()
		{
			super();
			Parameters.view.addEventListener(SegaView.LIB_LOADED, handleLibLoaded, false, 0, true);	
			
			if (overrideLogin) {
				trace("****************************************************");
				trace("****************************************************");
				trace("*******  OVERRIDE LOGIN IN SEGACONTROL.AS  *********");
				trace("****************************************************");
				trace("****************************************************");
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		override protected function handleObjClick(e:CustomEvent):void
		{
			//trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnAreaLink")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				
				trace("control/handleClick 0 " + objName);
				switch (objName)
				{
					case "gallery_btn":
						gotoPage("gallery");
					break;
					case "trivia_btn":
						if (Parameters.loggedIn || overrideLogin){
							var responder:Responder = new Responder (onTriviaCanPlaySuccess, onTriviaCanPlayFault);
							//Parameters.connection.call ("MovieCentral.getLottery", responder, "Guardians");				
							Parameters.connection.call ("TriviaService.canPlay", responder, TriviaPopup.CAMPAIGN_ID);
						} else {
							gotoPage("notloggedinpopup");
						}
					break;
					case "about_btn":						
						gotoPage("about");
					break;
					case "triviaclose_btn":
						Parameters.view.getChildByName("trivia").trivia_mc.cleanup();						
						gotoPage ("landing");
					break;
					case "website_btn":
						//gets website
						navigateToURL(new URLRequest ("http://www.soniccolors.com/"), "_blank");
						TrackingProxy.sendADLinkCall('SonicColors2010 - Hub to SonicColors.com')
					break;
					case "clips_btn":
						gotoPage("video");
						//gets MovieCentral
					break;
					case "close_btn":
						gotoPage ("landing");
					break;
					case "videoclose_btn":
						Parameters.view.getChildByName("video").closeVideo();						
						gotoPage ("landing");
					break;
					case "login_btn":
						navigateToURL(new URLRequest("http://www.neopets.com/loginpage.phtml?destination=/sponsors/soniccolors/index.phtml"), "_self");
					break;
					case "signup_btn":
						navigateToURL(new URLRequest("http://www.neopets.com/signup/index.phtml?destination=/index.phtml"), "_self");
					break;
					case "inventory_btn":
						navigateToURL(new URLRequest(Parameters.baseURL+"/objects.phtml?type=inventory"), "_blank");
					break;
				}
			}
		
		};
		
		protected function gotoLanding(e:Event):void {
			gotoPage ("landing");
		}
		
		
		protected function createPages():void{
			setupMainPage();
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up pages\n");
			Parameters.view.addChild (new SegaLandingPage ("landing", Parameters.view));
			Parameters.view.addChild (new SegaTriviaPage ("trivia", Parameters.view ));
			Parameters.view.addChild (new SegaAboutPage ("about", Parameters.view ));			
			Parameters.view.addChild (new SegaVideoPage ("video", Parameters.view ));
			Parameters.view.getChildByName ("trivia").init();
			Parameters.view.addChild (new SegaGalleryPage ("gallery", Parameters.view ));
			Parameters.view.getChildByName("gallery").startLoading();
			Parameters.view.addChild (new PopupNotLoggedIn ("notloggedinpopup", Parameters.view ));
			Parameters.view.getChildByName ("notloggedinpopup").init();
			Parameters.view.addChild (new PopupGetPrize ("getprize", Parameters.view ));
			Parameters.view.addChild (new PopupError ("errorpopup", Parameters.view ));
			

			gotoPage("landing");
			if (!Parameters.loggedIn && !overrideLogin){
				gotoPage ("notloggedinpopup");
			} else {
			//check for prize
				var responder:Responder = new Responder (onPrizeCallSuccess, onPrizeCallFailure);
				//Parameters.connection.call ("MovieCentral.getLottery", responder, "Guardians");				
				Parameters.connection.call ("SonicColorsService.giveaway", responder, 12);
			}
		}
		
		private function onTriviaCanPlaySuccess(msg:Object):void {
			trace (msg);
			switch(msg){
				case 1:
					gotoPage("trivia");
					Parameters.view.getChildByName("trivia").trivia_mc.showTrivia();
					break;
				case 2:
					Parameters.view.getChildByName ("errorpopup").init("Please login or sign up top Neopets to play this game.");
					gotoPage ("errorpopup");
					break;
				case 3:
					Parameters.view.getChildByName ("errorpopup").init("There are no questions today.\n Please try again tomorrow.");
					gotoPage ("errorpopup");
					break;
				default:
					Parameters.view.getChildByName ("errorpopup").init("You already answered this question today.\n Please try again tomorrow.");
					gotoPage ("errorpopup");
			}
		}
		
		private function onTriviaCanPlayFault(msg:Object):void {
			//todo: handle this
			trace ("AMF SERVICE ERROR");
		}
		
		private function onPrizeCallSuccess(msg:Object):void {
			if (msg){
				if (msg.reward==true){
					trace ("you won a prize!");
					Parameters.view.getChildByName ("getprize").init(msg.name, msg.image_url);
					//tracking
					trace("*** PRIZE INFO: name= " + msg.name + "   image_url= " + msg.image_url + "  item_id= " + msg.item_id);
					switch (msg.item_id){
						case 8052:
						case "8052":
							TrackingProxy.sendADLinkCall('SonicColors2010 - Prize 1 Awarded');
							trace("Tracking: SonicColors2010 - Prize 1 Awarded");
							break;
						case 33623:
						case "33623":
							TrackingProxy.sendADLinkCall('SonicColors2010 - Prize 2 Awarded');
							trace("Tracking: SonicColors2010 - Prize 2 Awarded");
							break;
						case 15777:
						case "15777":
							TrackingProxy.sendADLinkCall('SonicColors2010 - Prize 3 Awarded');
							trace("Tracking: SonicColors2010 - Prize 3 Awarded");
							break;
					}
					gotoPage ("getprize");
				} 
			}
		}

		private function onPrizeCallFailure(msg:Object):void {
			trace ("Ooops! getLottery call failed.");
		}
		
		protected function gotoPage(pName:String):void {
			var currentPage:Sprite = Parameters.view.getChildByName(pName);
			///show the page
			currentPage.visible = true;
			
			if (currentPage != null)
			{
				currentPage.dispatchEvent(new Event(PAGE_DISPLAY));	
			}
			
			//hide everything on top
			var currentIndex:int = Sprite(Parameters.view).getChildIndex(currentPage);
			for (var i:int = 0; i< Sprite(Parameters.view).numChildren; i++){
				if (i > currentIndex){
					Sprite(Parameters.view).getChildAt(i).visible = false;
				}
			}
		}
					
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function handleLibLoaded (e:Event):void {
			Parameters.view.removeEventListener(SegaView.LIB_LOADED, handleLibLoaded);	
			createPages();
		}
		
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}