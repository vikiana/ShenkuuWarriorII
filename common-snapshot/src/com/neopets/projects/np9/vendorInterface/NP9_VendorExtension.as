
/* AS3
	Copyright 2009
*/
package com.neopets.projects.np9.vendorInterface
{
	import com.neopets.examples.vendorShell.translation.TranslationInfo;
	import com.neopets.projects.np9.system.NP9_BIOS;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.trace.TraceOut;
	
	import fl.transitions.TransitionManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	
	/**
	 *	This is used to extend the Document Class of your Projects
	 *	This Gives you access to Neopets Related Code
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	@Pattern NP9 Neopets Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  5.25.2009
	 */
	
	public class NP9_VendorExtension extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const RESTART_CLICKED:String = "TheRestartBtnClicked";
		public const START_GAME_MSG:String = "Game Started";
		public const END_GAME_MSG:String = "Game Finished";
		public const TRANSLATION_COMPLETE:String = "TranslationSystemComplete";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		private var __GS_INDEX:Number;
		private var mBIOS:NP9_BIOS;
		
		protected var mNP9_VendorGameSystem:NP9_VendorGameSystem;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var bOffline:Boolean;
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NP9_VendorExtension():void 
		{
			setupVars();
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get translationManager():TranslationManager
		{
			return TranslationManager.instance;
		}
		

		public function get neopets_GS():MovieClip
		{
			if (mNP9_VendorGameSystem == null)
			{
				throw new Error("mNP9_VendorGameSystem is Null in the VendorExtension");
				return false;
			}
			else
			{
				return mNP9_VendorGameSystem;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @NOTE: This is the translation Setup
		 * 	@param		pTranslationInfo			TranslationData		The List of Files to Translate
		 * 	@param		pTranslationURL			String					The dev or live web servers to use for translation
		 */
		 
		 public function setupTranslation(pTranslationInfo:TranslationData, pTranslationURL:String = "www.neopets.com"):void
		 {
			var tManager:TranslationManager = TranslationManager.instance;
			tManager.addEventListener(Event.COMPLETE, translationComplete, false, 0, true);
			tManager.init( mBIOS.game_lang, mBIOS.game_id, TranslationManager.TYPE_ID_GAME, pTranslationInfo, pTranslationURL);
		 }
		 
		 
		/**
		 * @Note: This is an example
		 * @param		pCMD			String 		This is an Example of a Passed parameter
		 * @param		pBuyHowMuch		uint 		This is an Example of a Passed parameter
		 */
		 
		
		
		public function sendScoringMeterToFront():void {

			TraceOut.out(" NP9_GameDocument > sendScoringMeterToFront bOffline>" + bOffline);
			
				var nNumLastChild:Number = (numChildren-1);
				
				mNP9_VendorGameSystem.visible = true;
				
				// make sure scoring meter is always top DisplayObject
				if ( __GS_INDEX != nNumLastChild ) {
					setChildIndex( getChildAt(__GS_INDEX), nNumLastChild );
					__GS_INDEX = nNumLastChild;
				}
		
		}
		
		
		public function sendScoringMeterToBack():void {
			
			if ( bOffline ) {
				if ( __GS_INDEX != 0 ) {
					setChildIndex( getChildAt(__GS_INDEX), 0 );
					__GS_INDEX = 0;
				}
			}
		}
	
		/**
		 * @NOTE: This starts the Game and the Game System to startup
		 * @param		p_mcBIOS			NP9_BIOS			Has most of the Startup Info in it. 
		 * 																	In an Online enviroment much of this gets replaced by FlashVars by the System.
		 *	@param	pTraceFlag		Boolean				To Have Trace Statesment Fire
		 */
		 
		public function init ( p_mcBIOS:NP9_BIOS):void 
		{

			mBIOS = p_mcBIOS;
			TraceOut.traceFlag = mBIOS.debug;
			offlineMode();
			
			//Trace out the Time Stamp for the Project in a Message for Testing
			TraceOut.out (mBIOS.game_infostamp + " "+mBIOS.game_datestamp+" "+mBIOS.game_timestamp);
			
			// keep track of scoring meter index
			__GS_INDEX = 0;
			
		}
		
		/**
		 * @Note: This is to Trigger the Flash NP9 System to use OfflineMode
		 * @Note: Game System is Ready to be used. Dispatches an Event to tell others that it it Ready.
		 */
		 
		public function offlineMode():void 
		{
			bOffline = true;
		
			mNP9_VendorGameSystem = new NP9_VendorGameSystem();
			mNP9_VendorGameSystem.init(mBIOS);
			addChildAt(mNP9_VendorGameSystem,__GS_INDEX);
			gameEngineUpdate();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/** 
		 * @Note: Once the Transition Object is Ready, Fires this Event
		 */
		 
		protected function translationComplete(evt:Event):void
		{
			dispatchEvent(new Event(TRANSLATION_COMPLETE));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			bOffline = false;
			__GS_INDEX = 0;
			
		}
		
		/**
		 * @Note: This should be OVERRIDED in you Game so that you know its time to continue
		 * Code after the NP9 System has been loaded.
		 * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control In the Live Mode.
		 * @Note: Vendors need to have this in there document Class to know its time to continue with the game setup
		**/
		
		protected function gameEngineUpdate():void
		{
			
		}
	
	}
	
}
