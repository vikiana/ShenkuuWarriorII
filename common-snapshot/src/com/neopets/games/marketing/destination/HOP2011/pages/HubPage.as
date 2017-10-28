/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.HOP2011.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------/**/
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.Responder;
	
	import com.neopets.util.servers.NeopetsServerManager;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	import com.neopets.util.sound.SoundManager;
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;
	
	import com.neopets.games.marketing.destination.HOP2011.HOP_Translation;
	import com.neopets.games.marketing.destination.HOP2011.HOPTrackingManager;
	import com.neopets.games.marketing.destination.HOP2011.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.HOP2011.widgets.IntroPopUp;
	import com.neopets.games.marketing.destination.HOP2011.widgets.MessagePopUp;
	import com.neopets.games.marketing.destination.HOP2011.widgets.downloads.DownloadableData;
	
	//import com.neopets.projects.destination.destinationV3.AbsPage;
	
	public class HubPage extends AbsPage
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// web constants
		public static const SERVICE_ID:String = "Hop2011Service";
		public static const GAME_URL:String = "/games/play.phtml?game_id=1285";
		public static const CLIENT_SITE_URL:String = "http://www.iwantcandy.com/";
		public static const PLAYLIST_URL:String = "http://www.nick.com/videos/playlist/play/ladies-of-kcas-playlist.html";
		public static const TRAILER_URL:String = "/moviecentral/theatre.phtml?movie=hop";
		public static const PRIZE_DATA:String = "prizeConditions";
		// asset constants
		public static const MUSIC_ID:String = "IWantCandySong";
		// event IDs
		public static const GET_STATUS_RESULT:String = "getStatus_result";
		public static const RECORD_ACTIVITY_RESULT:String = "recordActivity_result";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// components
		public var gameButton:MovieClip;
		public var clientButton:MovieClip;
		public var playlistButton:MovieClip;
		public var trailerButton:MovieClip;
		public var downloadButton:MovieClip;
		public var aboutButton:MovieClip;
		public var musicButton:MovieClip;
		// state variables
		protected var _greetingShown:Boolean = false;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function HubPage():void
		{
			// get flash var data
			FlashVarManager.instance.initVars(root);
			// set up translation
			var translator:TranslationManager = TranslationManager.instance;
			var lang:String = String(FlashVarManager.instance.getVar("lang"));
			var t_data:TranslationData = new HOP_Translation();
			translator.init(lang,4001,14,t_data);
			// set up amf connection
			NeopetsConnectionManager.instance.connect(this);
			// set up event listeners
			addEventListener(RECORD_ACTIVITY_RESULT,onRecordResult);
			// set up tracking
			HOPTrackingManager.instance.init();
			// finish initializing
			super();
			// do a status check
			checkStatus();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function getDownloadables():Array {
			var list:Array = new Array();
			// set up links
			var np_path:String = NeopetsServerManager.instance.imageServer + "/sponsors/hop/destination/";
			var translator:TranslationManager = TranslationManager.instance;
			var info:Object;
			var desc:String;
			// set up maze link
			desc = translator.getTranslationOf("IDS_DL_MAZE");
			info = new DownloadableData("hop_maze2",desc,np_path+"hop_maze2.pdf");
			list.push(info);
			// set up "connect the dots" link
			desc = translator.getTranslationOf("IDS_DL_DOTS");
			info = new DownloadableData("hop_connect_the_dots2",desc,np_path+"hop_connect_the_dots2.pdf");
			list.push(info);
			// set up "word search" link
			desc = translator.getTranslationOf("IDS_DL_SEARCH");
			info = new DownloadableData("hop_word_search",desc,np_path+"hop_word_search.pdf");
			list.push(info);
			// set up "coloring book" link
			desc = translator.getTranslationOf("IDS_DL_COLORING");
			info = new DownloadableData("hop_coloring5",desc,np_path+"hop_coloring5.pdf");
			list.push(info);
			// set up "bunny ears" link
			desc = translator.getTranslationOf("IDS_DL_EARS");
			info = new DownloadableData("bunnyears",desc,np_path+"bunnyears.pdf");
			list.push(info);
			return list;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this to set up all child objects.
		
		override protected function initChildren():void {
			// set up url links
			var np_path:String = NeopetsServerManager.instance.scriptServer;
			initSiteLink(gameButton,np_path + GAME_URL);
			initSiteLink(clientButton,CLIENT_SITE_URL);
			initSiteLink(trailerButton,np_path + TRAILER_URL);
			initSiteLink(playlistButton,PLAYLIST_URL);
			// set up pop up links
			var translator:TranslationManager = TranslationManager.instance;
			var msg_str:String = translator.getTranslationOf("IDS_ABOUT_HOP");
			initEventButton(aboutButton,MessagePopUp.MESSAGE_REQUEST,msg_str);
			// set up downloadables pop up
			var list:Array = getDownloadables();
			initEventButton(downloadButton,MessagePopUp.MESSAGE_REQUEST,list);
			// set up music toggle
			musicButton.addMusic(MUSIC_ID);
		}
		
		// This function asks php for an update on the player's status.
		
		protected function checkStatus():void {
			var func_path:String = SERVICE_ID + ".getStatus";
			var responder:Responder = new Responder(onStatusResult, onStatusFault);
			NeopetsConnectionManager.instance.callRemoteMethod(func_path,responder);
		}
		
		// Try to display our greeting message if we haven't already done so, based on the provided
		// status data from php.
		
		protected function showResults(info:Object) {
			// check if there's a prize pending
			var prizes:Array;
			if(info != null && PRIZE_DATA in info) prizes = info[PRIZE_DATA] as Array;
			if(prizes != null && prizes.length > 0) {
				// check if we've shown a greeting yet
				if(_greetingShown) {
					// show the prizes directly
					dispatchEvent(new CustomEvent(info,MessagePopUp.QUEUE_MESSAGE));
				} else {
					// check if the user found something
					var found:Object = FlashVarManager.instance.getVar("found");
					if(found != null) {
						var translator:TranslationManager = TranslationManager.instance;
						var id:String = String(found);
						id = "IDS_FOUND_" + id.toUpperCase();
						var msg_str:String = translator.getTranslationOf(id);
						dispatchEvent(new CustomEvent(msg_str,MessagePopUp.MESSAGE_REQUEST));
					} else {
						// request intro pop up
						dispatchEvent(new Event(IntroPopUp.INTRO_REQUEST));
					}
					_greetingShown = true;
					// set the prizes to display after the greeting clears
					dispatchEvent(new CustomEvent(info,MessagePopUp.QUEUE_MESSAGE));
				}
			} else {
				// request intro pop up
				if(!_greetingShown) {
					dispatchEvent(new Event(IntroPopUp.INTRO_REQUEST));
					_greetingShown = true;
				}
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// "getStatus" responder functions
		
		protected function onStatusResult(msg:Object):void {
			trace("getStatus success: " + msg);
			showResults(msg);
			// broadcast results to listeners
			dispatchEvent(new CustomEvent(msg,GET_STATUS_RESULT));
		}
		
		protected function onStatusFault(msg:Object):void {
			trace("getStatus fault: " + msg);
			showResults(msg);
		}
		
		// "record activity" responses
		
		protected function onRecordResult(ev:CustomEvent):void {
			// show found message
			if(ev.oData != null) {
				var translator:TranslationManager = TranslationManager.instance;
				var id:String = String(ev.oData);
				id = "IDS_FOUND_" + id.toUpperCase();
				var msg:String = translator.getTranslationOf(id);
				dispatchEvent(new CustomEvent(msg,MessagePopUp.MESSAGE_REQUEST));
			}
			// check if a prize was found
			checkStatus();
		}
		
	}
	
}