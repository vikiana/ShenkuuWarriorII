package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.utils.getTimer;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * Handles the sending of legacy game start and game end tags for the Neopets Gaming System. 
	 * As of Flash 9 and 10, there are only 2 tags to send - Game Start and Game End
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Neostatus {

		private var objTracer:NP9_Tracer;
		
		private var objGameData:Object;
		
		private var aEvents:Object;
		
		private var nGameStartTime:Number;
		private var nGameEndTime:Number;
		
		private var sNS_URL:String;
		private var sPHP_URL:String;
		
		private var nNSID:Number;
		private var nNSMultiple:Number;
		
		private var flashLoader:URLLoader;
		private var neostatusLoader:URLLoader;
	
		/**
		 * @Constructor
		 * @param	p_bTrace	True if debug output is needed
		 */
		public function NP9_Neostatus( p_bTrace:Boolean ) {
			
			// tracer object
			objTracer = new NP9_Tracer( this, p_bTrace );
			objTracer.out( "Instance created!", true );
			
			aEvents = new Object();
			
			nGameStartTime = getTimer();
			nGameEndTime = nGameStartTime; 
			
			flashLoader = new URLLoader();
			neostatusLoader = new URLLoader();

			// create event types
			addEvent ("Game Started", 900);
			for ( var p:Number=1; p<=4; p++ ) {
				addEvent ("Multiplayer Game Started "+p, 900+p);
			}
			addEvent ("Game Finished", 1000);
			addEvent ("Sent Score", 1001);
			for ( var l:Number=1; l<=100; l++ ) {
				addEvent ("Reached Level "+l, Number(7000 + l));
			}
			addEvent ("Sponsor Item Shown", 8010);
			addEvent ("Sponsor Logo Shown", 8020);
			addEvent ("Sponsor Item Collected", 8030);
			addEvent ("Sponsor Banner Shown", 8040);
		}
		
		/**
		 * Pass in NP9_Game_Data object
		 * @param	p_GameData	The NP9_Game_Data instance
		 * @see NP9_Game_Data
		 */
		public function init( p_GameData:Object ):void {
			
			objGameData = p_GameData;
			
			sNS_URL  = objGameData.FG_SCRIPT_BASE + "neostatus.phtml";
			sPHP_URL = objGameData.FG_SCRIPT_BASE + "track_plays.phtml";
			
			nNSID  = objGameData.iNsid;
			nNSMultiple = objGameData.iNsm;
		}
		
		/**
		 * Add a Neostatus event
		 * @param	p_tagName		Event name
		 * @param	p_statusCode		Event code
		 */
		private function addEvent( p_tagName:String, p_statusCode:Number ):void {
			
			//create new event
			var objE:Object = new Object();
			objE.tagName    = p_tagName;
			objE.statusCode = p_statusCode;
			
			aEvents[p_tagName] = objE;
		}
		
		/**
		 * Sends a Neostatus tag to the backend system
		 * @param	tagName	Name of the tag to send
		 */
		public function sendTag( tagName:String ):void {
			
			trace("NP9_Neostatus.sendTag( " + tagName+")");
			
			var t_sURL:String = "";
			
			// ------------
			// PHP TRACKING
			// ------------
			if ( objGameData.iTracking == 1 ) {
				
				t_sURL = sPHP_URL + "?game_id=" + objGameData.iGameID;
				var bNewTracking:Boolean = false;
				if ( tagName == "Game Started" ) {
					bNewTracking = true;
					t_sURL += "&dowhat=game_starts&multiple=" + objGameData.iMultiple;
				}
				else if ( tagName == "Game Finished" ) {
					bNewTracking = true;
					t_sURL += "&dowhat=game_ends&multiple=" + objGameData.iMultiple;
				}
				if ( bNewTracking ) {
					
					t_sURL += "&r=" + int(Math.random()*1000000);
					trace("**"+this+": "+"PHP tracking: "+t_sURL);

					var request:URLRequest = new URLRequest();
					request.url = t_sURL;
					request.method = URLRequestMethod.POST;
					
					try
					{
						flashLoader.load( request );
					}
					catch (error:Error)
					{
						trace("**"+this+": "+"Unable to load URL "+t_sURL);
					}
				}
			}
					
			trace("NeoStatus tracking");
			// ------------------
			// NeoStatus Tracking
			// ------------------
			if ( aEvents[tagName].tagName == undefined ) {
				traceMSG("Tagname(" + tagName + ") does not exist!");
			} else {
				
				//sending successfully if nNSID is valid
				if ( nNSID > 0 ) {
					
					t_sURL = sNS_URL + "?item_id=" + nNSID + "&multiple=" + nNSMultiple;
					t_sURL += "&status=" + aEvents[tagName].statusCode;
					t_sURL += "&r=" + int(Math.random()*1000000);
					
					// track time
					if ( aEvents[tagName].statusCode == 900 ) {
						nGameStartTime = getTimer();
					} else if ( aEvents[tagName].statusCode == 1000 ) {
						nGameEndTime = getTimer();
						// add game length
						t_sURL += "&gamelen="+String( int((nGameEndTime-nGameStartTime) / 1000) );
					}
					
					traceMSG("Sending tag for Event (" + aEvents[tagName].tagName + ") = "+ t_sURL);
					
					var request2:URLRequest = new URLRequest();
					request2.url = t_sURL;
					request2.method = URLRequestMethod.POST;
					trace("after...");
					try
					{
						neostatusLoader.load( request2 );
					}
					catch (error:Error)
					{
						trace("**"+this+": "+"Unable to load URL "+t_sURL);
					}
					
				} else {
					traceMSG("Item_id = " + nNSID + ". Event (" + aEvents[tagName].tagName + ") will not be sent!");
				}
			}
		}
		
		/**
		 * Internal message trace
		 * @param	p_sMsg	Trace message
		 */
		private function traceMSG( p_sMsg:String ):void {
			trace("**"+this+": "+p_sMsg);
		}
		
		// -------------------------------------------------------------------------------
		//
		// -------------------------------------------------------------------------------
	}
}
