package com.neopets.games.marketing.destination.HOP2011
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.neopets.util.events.SingletonEventDispatcher;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.servers.NeopetsServerManager;
	
	import com.neopets.games.marketing.destination.HOP2011.tracking.AbsTrackingHandler;
	import com.neopets.games.marketing.destination.HOP2011.commands.GoToURLCommand;
	import com.neopets.games.marketing.destination.HOP2011.pages.HubPage;
	import com.neopets.games.marketing.destination.HOP2011.widgets.MessagePopUp;
	import com.neopets.games.marketing.destination.HOP2011.widgets.downloads.DownloadableData;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	This is a class centralizes all tracking calls by listening to the singleton event
	 *  dispatcher for key events.
	 * 		>> Intro Menu
	 * 		>> Instruction Menu
	 * 		>> Game Menu
	 * 		>> Game Over Menu
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author Clive Henrick
	 *	@since 8.27.2009
	 */
	 
	public class HOPTrackingManager extends AbsTrackingHandler
	{
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		private static const mInstance:HOPTrackingManager = new HOPTrackingManager( SingletonEnforcer ); 
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function HOPTrackingManager(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use HOPTrackingManager.instance." ); 
			} else init();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():HOPTrackingManager
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED FUNCTIONS
		//--------------------------------------
		
		override protected function initListeners():void {
			var sed:EventDispatcher = SingletonEventDispatcher.instance;
			sed.addEventListener(GoToURLCommand.ON_NAV_TO_URL,onNavigateToURL);
			sed.addEventListener(MessagePopUp.ON_MESSAGE_SHOWN,onMessageShown);
		}
		
		//--------------------------------------
		//  EVENT LISTENERS
		//--------------------------------------
		
		protected function onNavigateToURL(ev:CustomEvent) {
			// extract neopets server path currently in use
			var np_path:String = NeopetsServerManager.instance.scriptServer;
			// check for tracked URLS
			switch(ev.oData) {
				case (np_path + HubPage.GAME_URL):
					trace("tracking click to linked game..");
					callJavascript("window.top.sendADLinkCall('HOP2011 - Hub to Game 1285')");
					break;
				case HubPage.CLIENT_SITE_URL:
					trace("tracking click to client site..");
					callJavascript("window.top.sendADLinkCall('HOP2011 - Hub to Client Site')");
					break;
				case HubPage.PLAYLIST_URL:
					trace("tracking click to playlist..");
					callJavascript("window.top.sendADLinkCall('HOP2011 - Hub to Nick.com Playlist')");
					break;
				case (np_path + HubPage.TRAILER_URL):
					trace("tracking click to trailer page..");
					callJavascript("window.top.sendADLinkCall('HOP2011 - Hub to MovieCentral HOP Theater')");
					callJavascript("window.top.sendADLinkCall('HOP2011 - Hub Video VIew')");
					break;
			}
		}
		
		protected function onMessageShown(ev:CustomEvent) {
			var info:Object = ev.oData;
			if(info != null) {
				if(info is String) {
					// get translation system
					var translator:TranslationManager = TranslationManager.instance;
					if(String(info) == translator.getTranslationOf("IDS_ABOUT_HOP")) {
						trace("tracking about text displayed..");
						callJavascript("window.top.sendADLinkCall('HOP2011 - Hub to Synopsis')");
					}
				} else {
					if(info is Array) {
						var list:Array = info as Array;
						if(list.length > 0 && list[0] is DownloadableData) {
							trace("tracking click to downloadables..");
							callJavascript("window.top.sendADLinkCall('HOP2011 - Hub to Downloadables')");
						}
					} // end of array check
				}
			} // end of info check
		}
		
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}