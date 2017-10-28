/**
 *	Popsicle Destination Document Class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooths.popsiclebooth
{
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationView;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.servers.NeopetsServerFinder;
	
	import flash.net.Responder;

	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class PopsicleDestinationView extends AltadorAlleyDestinationView
	{
		//----------------------------------------
		// 	CONSTANTS
		//-----------------------------------------
		private const NEOCONTENT_ID:String = "1710";
		private const LIB_PATH:String = "sponsors/altadoralley/popsicle_assets.swf";
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		*	instantiate control class and set up project ID
		**/
		public function PopsicleDestinationView():void
		{
			super();
			Parameters.assetPath = LIB_PATH;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		

		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		

		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		override protected function initialize ():void {
			init (new PopsicleDestinationControl(), NEOCONTENT_ID, true, mServers.isOnline)
		}
		/**
		 *	additional setup?
		 **/
		/*override protected function customSetup ():void {
			//add code here, then call this
			super.customSetup();
		}*/
		
		override protected function createLoadingSign():void{
			var ls:PopsiclePreloader = new PopsiclePreloader ();
			ls.name = "preloader";
			addChild(ls);
		}
		
		/**
		 *	This version doesn't need an username so it just checks if it is logged in
		 **/
		override protected function getUsername():void
		{
			var responder:Responder = new Responder(returnLoggedIn, usernameError);
			Parameters.connection.call("AltadorAlley2010Service.popStatus", responder);
		}
		
		/**
		 *	Returns the user name if successfully connected.
		 *	@Note:	Object - it contains a userInfo obj that has a String (auth) indicating the user status
		 **/
		override protected function returnLoggedIn(p:Object):void 
		{
			//userInfo
			if (p.userInfo.auth.toString() == "false")
			{
				Parameters.userName = AbsView.GUEST_USER
				Parameters.loggedIn = false;
			}
			else 
			{
				Parameters.loggedIn = true;
			}
			
			//stacksInfo
			///these is called again and parsed when the quest opens
			
			
			readyForSetup();
		}
	
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
				
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

		
	}
}