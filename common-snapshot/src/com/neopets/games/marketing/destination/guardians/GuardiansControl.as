//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.guardians
{
	import com.neopets.games.marketing.destination.guardians.pages.GuardiansGalleryPage;
	import com.neopets.games.marketing.destination.guardians.pages.GuardiansLandingPage;
	import com.neopets.games.marketing.destination.guardians.pages.GuardiansTriviaPage;
	import com.neopets.games.marketing.destination.guardians.pages.PopupGetPrize;
	import com.neopets.games.marketing.destination.guardians.pages.PopupNotLoggedIn;
	import com.neopets.games.marketing.destination.guardians.widgets.ReleaseDate;
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
	public class GuardiansControl extends AbsControl
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------
		//events
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
		public function GuardiansControl()
		{
			super();
			Parameters.view.addEventListener(GuardiansView.LIB_LOADED, handleLibLoaded, false, 0, true);	
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
				switch (objName)
				{
					//close
					case "play_btn":
						//gets game
						TrackingProxy.sendADLinkCall('Guardians2010 - Hub to [game name]')
					break;
					case "gallery_btn":
						gotoPage("gallery");
						//tracking
						TrackingProxy.sendReportingCall('Gallery','Guardians2010');
					break;
					case "trivia_btn":
						if (Parameters.loggedIn){
							gotoPage("trivia");
							Parameters.view.getChildByName("trivia").trivia_mc.showTrivia();
						} else {
							gotoPage("notloggedinpopup");
						}
						//tracking
						TrackingProxy.sendReportingCall("Daily Trivia", "Guardians2010");
					break;
					case "triviaclose_btn":
						Parameters.view.getChildByName("trivia").trivia_mc.cleanup();
						gotoPage ("landing");
					break;
					case "website_btn":
						//gets website
						navigateToURL(new URLRequest ("http://legendoftheguardians.warnerbros.com/"), "_blank");
						TrackingProxy.sendADLinkCall('Guardians2010 - Hub to Website')
					break;
					case "nick_btn":
						//gets club nick
						navigateToURL(new URLRequest ("http://www.nick.com/club/clubhouses/club-cinema/screening.html"), "_blank");
						TrackingProxy.sendADLinkCall('Guardians2010 - Hub to Club Nick')
					break;
					case "clips_btn":
						//gets MovieCentral
						navigateToURL(new URLRequest(" http://www.neopets.com/moviecentral/theatre.phtml?movie=guardians"), "_blank");
						TrackingProxy.sendADLinkCall('Guardians2010 - Hub to Movie Central')
					break;
					case "close_btn":
						gotoPage ("landing");
					break;
					case "login_btn":
						navigateToURL(new URLRequest("http://www.neopets.com/loginpage.phtml"), "_self");
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
		
		
		protected function createPages():void{
			setupMainPage();
		}
		
		// method to create main page (landing page)
		protected override function setupMainPage():void
		{
			trace("\nSet up pages\n");
			Parameters.view.addChild (new GuardiansLandingPage ("landing", Parameters.view));
			Parameters.view.addChild (new GuardiansTriviaPage ("trivia", Parameters.view ));
			Parameters.view.getChildByName ("trivia").init();
			Parameters.view.addChild (new GuardiansGalleryPage ("gallery", Parameters.view ));
			Parameters.view.getChildByName("gallery").startLoading();
			Parameters.view.addChild (new PopupNotLoggedIn ("notloggedinpopup", Parameters.view ));
			Parameters.view.getChildByName ("notloggedinpopup").init();
			Parameters.view.addChild (new PopupGetPrize ("getprize", Parameters.view ));

			gotoPage("landing");
			if (!Parameters.loggedIn){
				gotoPage ("notloggedinpopup");
			} else {
			//check for prize
				var responder:Responder = new Responder (onPrizeCallSuccess, onPrizeCallFailure);
				//Parameters.connection.call ("MovieCentral.getLottery", responder, "Guardians");				
				Parameters.connection.call ("LegendOfGuardiansService.giveaway", responder, "Guardians");
			}
		}
		
		
		private function onPrizeCallSuccess(msg:Object):void {
			if (msg){
				if (msg.reward==true){
					trace ("you won a prize!");
					Parameters.view.getChildByName ("getprize").init(msg.name, msg.image_url);
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
			Parameters.view.removeEventListener(GuardiansView.LIB_LOADED, handleLibLoaded);	
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