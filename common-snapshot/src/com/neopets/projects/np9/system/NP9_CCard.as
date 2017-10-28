// ---------------------------------------------------------------------------------------
// Scoring Meter - Challenge Card Class
//
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Tracer;
	
	/**
	 * Challenge Card class
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_CCard
	{
		private var objTracer:NP9_Tracer;

		private var sServer:String;
		private var nGameID:Number;
		
		private var sProfileURL:String;
		private var infoIsLoaded:Boolean;
		private var infoLoader:URLLoader;
		private var aInfoVars:Array;

		private var sSendCardURL:String;
		private var cardWasSent:Boolean;
		private var cardSender:URLLoader;
		private var aSendVars:Array;
		
		/**
		 * @Constructor
		 * @param	p_bTrace	True if NP_Tracer function is used
		 * @see NP9_Tracer
		 */
		public function NP9_CCard( p_bTrace:Boolean ):void {

			// tracer object
			objTracer = new NP9_Tracer( this, p_bTrace );
			objTracer.out( "Instance created!", true );
		}
		
		/**
		 * Initialization
		 * @param	p_sServer		Game script server - eg. http://www.neopets.com
		 * @param	p_nGameID	Game ID - eg. 1234
		 */
		public function init( p_sServer:String, p_nGameID:Number ):void {
		
			sServer = p_sServer;
			nGameID = p_nGameID;
			
			sProfileURL = sServer + "high_scores/fg_get_info.phtml?game_id="+nGameID+"&type=8;9";
			infoIsLoaded = false;
			infoLoader = new URLLoader();
			aInfoVars = new Array();
			
			sSendCardURL = sServer + "games/email_flash_challenge.phtml?";
			cardWasSent = false;
			cardSender = new URLLoader();
			aSendVars = new Array();
		}
		
		/**
		 * Starts request for user information
		 */
		public function loadUserInfo():void {
		
			if ( !infoIsLoaded ) {
				
				var request:URLRequest = new URLRequest();
				request.url = sProfileURL;
				request.method = URLRequestMethod.POST;
				infoLoader.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				infoLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
				infoLoader.load( request );
			}
		}
		
		/**
		 * Checks if the user information is loaded.
		 * @return True if user information is loaded
		 */
		public function profileLoaded():Boolean {
			
			return ( infoIsLoaded );
		}
		
		// -----------------------------------------------
		public function getUsername():String {
			
			var sReturn:String = "";
			if ( aInfoVars['username'] != undefined ) sReturn = aInfoVars['username'];
			
			return ( sReturn );
		}
		
		/**
		 * Gets the user's email info
		 * @return	User's email string value
		 */
		public function getUserEmail():String {
			
			var sReturn:String = "";
			if ( aInfoVars['user_email'] != undefined ) sReturn = aInfoVars['user_email'];
			
			return ( sReturn );
		}

		/**
		 * Load user information completed. Data is saved into aInfoVars.
		 * @param	event
		 */
		private function completeHandler(event:Event):void {
			
			infoIsLoaded = true;
			
			removeLoadListeners();
			
			var sResult:String = String(event.target.data);
			
			var aResult:Array = sResult.split("&");
			aInfoVars = new Array();
			
			for ( var i:Number=0; i<aResult.length; i++ ) {
				var aPair:Array = aResult[i].split("=");
				aInfoVars[aPair[0]] = aPair[1];
				objTracer.out( "aInfoVars['"+aPair[0]+"'] = "+aPair[1], false );
			}
		}

		/**
		 * @private
		 * security error
		 */
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			infoIsLoaded = true;
			removeLoadListeners();
			objTracer.out( "securityErrorHandler: "+event.text, true );
        }
        
		/**
		 * Remove all listeners for user info loading
		 */
		private function removeLoadListeners():void {
			
			infoLoader.removeEventListener(Event.COMPLETE, completeHandler);
			infoLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		/**
		 * Sends Challenge Card data
		 * @param	fromName		Sender's name
		 * @param	fromEmail		Sender's email
		 * @param	toName			Receipient's name
		 * @param	toEmail			Receipient's email
		 * @param	p_Score		Score obtained by sender
		 */
		public function sendCCard( fromName:String, fromEmail:String, toName:String, toEmail:String, p_Score:Number ):void {
			
			cardWasSent = false;
			
			var sVars:String = "";
			sVars += "flash=1";
			sVars += "&game_id=" + escape( String( nGameID ) );
			sVars += "&score=" + escape( String( p_Score ) );
			sVars += "&sender_name=" + escape( fromName );
			sVars += "&sender_email=" + escape( fromEmail );
			sVars += "&recipient_name=" + escape( toName );
			sVars += "&recipient_email=" + escape( toEmail );
			
			var request:URLRequest = new URLRequest();
			request.url = sSendCardURL + sVars;
			request.method = URLRequestMethod.POST;
			cardSender.addEventListener(Event.COMPLETE, completeHandler2, false, 0, true);
			cardSender.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler2, false, 0, true);
			cardSender.load( request );
		}

		/**
		 * Poll this function to check if Challenge Card data has been sent.
		 * @return	True if sent
		 * @see #sendCCard()
		 */
		public function cardSent():Boolean {
			
			return ( cardWasSent );
		}
		
		/**
		 * Obtains error feedback if sending failed
		 * @return	Error feedback string
		 */
		public function getErrorMsg():String {
			
			var sReturn:String = "";
			if ( aSendVars['error_str'] != undefined ) sReturn = aSendVars['error_str'];
			
			return ( sReturn );
		}
		
		/**
		 * Obtains success feedback when sending succeeds
		 * @return Success text
		 */
		public function getSuccessMsg():String {
			
			var sReturn:String = "";
			if ( aSendVars['msg'] != undefined ) sReturn = aSendVars['msg'];
			
			return ( sReturn );
		}
		
		/**
		 * Challenge Card sending completed
		 * @param	event
		 */
		private function completeHandler2(event:Event):void {
			
			cardWasSent = true;
			
			removeSendListeners();
			
			var sResult:String = String(event.target.data);
			
			var aResult:Array = sResult.split("&");
			aSendVars = new Array();
			
			for ( var i:Number=0; i<aResult.length; i++ ) {
				var aPair:Array = aResult[i].split("=");
				aSendVars[aPair[0]] = aPair[1];
				objTracer.out( "aSendVars['"+aPair[0]+"'] = "+aPair[1], false );
			}
		}
		
		/**
		 * Challenge card sending error
		 * @param	event
		 */
		private function securityErrorHandler2(event:SecurityErrorEvent):void {
			
			cardWasSent = true;
			removeSendListeners();
			objTracer.out( "securityErrorHandler: "+event.text, true );
        }
        
		/**
		 * Remove all challenge card sending event listeners
		 */
		private function removeSendListeners():void {
			
			infoLoader.removeEventListener(Event.COMPLETE, completeHandler2);
			infoLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler2);
		}
	}
}
