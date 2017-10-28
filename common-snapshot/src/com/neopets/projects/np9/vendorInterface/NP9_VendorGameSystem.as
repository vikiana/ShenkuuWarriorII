
/* AS3
	Copyright 2009 - Neopets
*/

package com.neopets.projects.np9.vendorInterface
{
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.util.trace.TraceOut;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.system.ApplicationDomain;
	
	/**
	 *	This is a Class to Mimic the NP9_GamingSytem for local (Non JIRA) Testing of Neopets Site Games
	 *	The Only Functional New Code for this Class is the Translation System Based on Chris Avallis Code from PPP
	 * 
	 * >>NOTE:
	 * The Game Score Box is the Only Display Element in this Flash Movie.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern NP9_GameSystem
	 * 
	 *	@author Clive Henrick
	 *	@since  6.30.2009
	 */
	 
	public class NP9_VendorGameSystem extends MovieClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const RESTART_CLICKED:String = "TheRestartBtnClicked";
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		protected var mVGSVersion:String = "v1";
		protected var mcScoreMeter:NP9_SimpleScoreMeter;
		protected var objGameData:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NP9_VendorGameSystem():void
		{
			super();
			TraceOut.out("Instance created of the Vendor GamingSystem!" + mVGSVersion);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		// USER FUNCTION - GET SCRIPT/IMAGE SERVER
		public function getScriptServer():String { return ( objGameData.FG_SCRIPT_BASE ); }
		public function getImageServer():String { return ( objGameData.FG_GAME_BASE ); }
		
		// USER FUNCTION - GET FLASH VAR
		public function getFlashParam( p_sID:String ):String 
		{
			if( !objGameData.hasOwnProperty(p_sID))
			{
				return null;
			}
			else
			{
				return ( String( objGameData[ p_sID ] ) );
			}

		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * This is the Startup of the Vendor Game System. Online this is called by the Loader Class.
		 * @param		pGameDataBIOS		Object			The Passedin BIOS from the Game
		 * @param		pTraceFlag			Boolean			To Use allow for Trace Commands to Show
		 */
		 
		public function init( pGameDataBIOS:Object):void 
		{
			
			//TraceOut.out( "Game Data initialized - Game ID: "+pGameDataBIOS.iGameID, false );
			
			objGameData = pGameDataBIOS;
			
			var ScoreMeterClass:Class= ApplicationDomain.currentDomain.getDefinition("mcInclude") as Class
			mcScoreMeter = new ScoreMeterClass() as NP9_SimpleScoreMeter;
			mcScoreMeter.addEventListener(mcScoreMeter.RESTARTBTN_CLICKED, restartBtnClicked);
			addChild( mcScoreMeter );
			
			showScoringMeter( false );
			
		}
		
		
		/**
		 * @Note: Creates an Encrypted Variable (EVAR) used to Store the Score to stop Hacking
		 * */
		
		public function createEvar( xVar:* ):Object 
		{
			
			var objEvar:NP9_Evar = new NP9_Evar( xVar );
			
			return ( objEvar );
		}
		
		/**
		 * @Note: Sends the Score to the Server. This is a Fake call for now as without JIRA access
		 * @Note: this will not work. This is Not how the Game System Works, But for Vendors it is fine.
		 * 
		 * @param p_nVal		Number		The Total Score
		 * */
		 
		public function sendScore( p_nVal:Number):void 
		{
			showScoringMeter( true );
			var UserID:Number = 1000;
			mcScoreMeter.showMsg( UserID, p_nVal);
			addEventListener(TextEvent.LINK, TextLinkHandler, false, 0, true);
			
		}
		
		/**
		 * @NOTE: This sends a Message to the Neopets Servers
		 *	@param		pMessage			String			The Message to be sent to Neopets Servers
		 */
		 
		public function sendTag(pMessage:String):void
		{
			trace ("SendTag Triggered on Game System");
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: From the SimpleScoreMeter
		 */
		 
		private function restartBtnClicked(evt:Event):void
		{
				restartGame();
		}
		
		
		
		private function TextLinkHandler( e:TextEvent):void 
		{
		
			var t_sEvent:String = e.text.toUpperCase();
			
			switch ( t_sEvent ) 
			{
				case "RESTARTGAME":
					removeEventListener(TextEvent.LINK, TextLinkHandler);
					restartGame();
					break;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		* HIDE SCORING METER AND CONTINUE GAME
		*/
		
		private function restartGame():void 
		{
			TraceOut.out( "Restart Game was called!");
			dispatchEvent(new Event(RESTART_CLICKED));
			showScoringMeter( false );
		}
		
		/**
		 * show and hide scoring meter 
		 * @param		bShow		Boolean		Turns on or off the ScoreMeter
		 */
		
	
		private function showScoringMeter( bShow:Boolean ):void {
			
			if ( bShow ) 
			{
				
				var tGameWidth:Number = objGameData.hasOwnProperty("iGameWidth") ? objGameData.iGameWidth : objGameData.iBIOSWidth;
				var tGameHeight:Number = objGameData.hasOwnProperty("iGameHeight") ? objGameData.iGameHeight : objGameData.iBIOSHeight;
				
				if (objGameData.hasOwnProperty("iGameWidth"))
				{
					tGameWidth	
				}
				var t_nRatioX:Number = tGameWidth / objGameData.iBIOSWidth;
				var t_nRatioY:Number = tGameHeight / objGameData.iBIOSHeight;
				
				var tMeterX:Number = objGameData.hasOwnProperty("iMeterX") ? objGameData.iMeterX : objGameData.meterX;
				var tMeterY:Number = objGameData.hasOwnProperty("iMeterY") ? objGameData.iMeterY : objGameData.meterY;
				
				mcScoreMeter.width  = int(300 * t_nRatioX);
				mcScoreMeter.height = int(120 * t_nRatioY);
				
				mcScoreMeter.x = int(tMeterX * t_nRatioX);
				mcScoreMeter.y = int(tMeterY * t_nRatioY);
				
			} 
			
			mcScoreMeter.visible = bShow;
		}
		
	}
	
}
