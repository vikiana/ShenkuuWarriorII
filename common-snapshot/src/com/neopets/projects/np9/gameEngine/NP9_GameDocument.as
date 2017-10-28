// ---------------------------------------------------------------------------------------
// GAME DOCUMENT CLASS
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------


package com.neopets.projects.np9.gameEngine
{
	// SYSTEM IMPORTS
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.projects.np9.system.NP9_Loader_Control;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	//import virtualworlds.lang.TranslationData;
	//import virtualworlds.lang.TranslationManager;
	
/**
 * <p>The GameEngine Flash Shell must extend this Class
 * In Combination with this Class and NP9_LoaderControl loads the NP9 System
 * If you think this is a headache, you are right.
 * 
 *  Added the New Translation System. You can now access this system.</p>
 * <p>This class is not in use now.</p>
 * @see com.neopets.projects.np9.gameEngine.NP9_DocumentExtension
 * 
 */
	public class NP9_GameDocument extends MovieClip {

		public var _GS:MovieClip;
		protected var LoadingSignOn:Boolean;
		
		public var bOffline:Boolean;
		
		public const START_LOADING:String = "NP9_PRELOADER_tellingGametoStart";
		public const START_GAME_MSG:String = "Game Started";
		public const END_GAME_MSG:String = "Game Finished";
		public const TRANSLATION_COMPLETE:String = "TranslationSystemComplete";
		
		// ONLY USED IN OFFLINE MODE
		private var objBIOS:NP9_BIOS;
		private var objLoaderControl:NP9_Loader_Control;
		
		public var _ROOT:Object;
		public var _GAMINGSYSTEM:MovieClip;
		public var _SOUND:Object;

		private var __GS_INDEX:Number;
		
		
		/**
		 * @Constructor
		 */
		public function NP9_GameDocument() {
			LoadingSignOn = false
			trace("\n**"+this+": "+"Instance created!");
			
			bOffline = false;
			this.addEventListener(START_LOADING,NP9systemLoaded,false,0,true);
			addEventListener("setup_loading_sign", setupLoaderSign, false, 0, true);
			//setupLoaderSign()
		}
		
		/**
		 * Initialization
		 * @param	p_mcBIOS		The NP9_BIOS instance
		 * @return	Always returns true
		 */
		public function init( p_mcBIOS:NP9_BIOS ):Boolean {

			objBIOS = p_mcBIOS;

			// are we offline?
			
			if (this.parent != null)
			{
				if ( this.parent.toString().toUpperCase().indexOf("STAGE",0) >= 0 ) 
				{
					triggerOfflineMode();
				}	
			}
			
			//Trace out the Time Stamp for the Project in a Message for Testing
			trace(	objBIOS.game_infostamp, " ", objBIOS.game_datestamp, " ", objBIOS.game_timestamp);
			
			// get bios props
			//objBIOS.visible = bOffline;
			
			// keep track of scoring meter index
			__GS_INDEX = 0;
			_ROOT = this;
			
			
			
			return ( true );
		}
		
		/**
		 * @return Returns the BIOS
		 */
		public function getBIOS():NP9_BIOS {
			
			return ( objBIOS );
		}
		
		// -------------------------------------------------------------------
		// TRIGGER OFFLINE MODE
		// -------------------------------------------------------------------
		
		/**
		 *  This is to Trigger the Flash NP9 System to use OfflineMode
		 */
		 
		public function triggerOfflineMode():void
		{
			bOffline = true;
			offlineMode();	
		}
		
		
		public function offlineMode():void 
		{
			trace("--------------------");
			trace("offlineMode()");
			trace("--------------------");
			objLoaderControl =  new NP9_Loader_Control( this );
			trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			// if the game is launched offline, we need to 
			// pass the BIOS settings to the loader class
			objLoaderControl.setEnvironment("offline");
			objLoaderControl.setOfflineBiosParams( objBIOS );
			
			this.addEventListener( Event.ENTER_FRAME, main, false, 0, true );
		}
		
		/**
		 * ######## NEEDS TO BE RE-WORKED ######################
		 *  Sends a Function Call to its Child to Continue the Process.
		 */
		 
		private function main( e:Event ):void
		{
			if ( !objLoaderControl.main() ) {
				this.removeEventListener( Event.ENTER_FRAME, main );
			}
		}
		
		// -------------------------------------------------------------------------------
		// PROTECTED FUNCTIONS
		// -------------------------------------------------------------------------------
		
		protected function NP9systemLoaded(evt:Event = null):void
		{
			trace("NP9systemLoaded Called ");
			NP9_GameBase();
			this.addChildAt(_GS,__GS_INDEX);
			gameEngineUpdate();	
		}
		
		/**
		 *  This should be OVERRIDED in you Game so that you know its time to continue
		 * Code after the NP9 System has been loaded.
		 *  This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		 *		>This is Triggered by the NP9_Loader_Control
		 *		>At function Main - _STARTGAME:
		**/
		
		 
		protected function gameEngineUpdate():void
		{
			
		}
		
		
		/**
		 *  places loading sign on the stage.  The event is dispatched from GameEngineSupport class
		**/
		protected function setupLoaderSign(evt:Event = null):void
		{
			if (!LoadingSignOn)
			{
				LoadingSignOn = true
				var loadingSignClass:Class = getDefinitionByName("LoadingSign") as Class
				var loadingSign:MovieClip = new loadingSignClass ();
				loadingSign.name = "loadingSign";
				addChild(loadingSign)
				loadingSign.x = stage.stageWidth/2
				loadingSign.y = stage.stageHeight/2
				addEventListener("remove_loading_sign", removeLoaderSign, false, 0, true);
			}
		}
		
		/**
		 *  remove loading sign from the stage.  
		 * The event is dispatched from both GameEngineSupport and GameEngine class
		**/
		protected function removeLoaderSign(evt:Event = null):void
		{
			if (hasEventListener("setup_loading_sign")) removeEventListener("setup_loading_sign", setupLoaderSign);
			if (hasEventListener("remove_loading_sign"))removeEventListener("remove_loading_sign", removeLoaderSign);
			if (getChildByName("loadingSign") != null)
			{
				removeChild(getChildByName("loadingSign"));
			}
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/** 
		 *  Once the Transition Object is Ready, Fires this Event
		 */
		 
		protected function translationComplete(evt:Event):void
		{
			trace ("translation complete");
			dispatchEvent(new Event(TRANSLATION_COMPLETE));
		}
		
		
		/**
		 * Pass in the GamingSystem instance
		 * @param	p_mcGS GamingSystem instance
		 */
		
		public function setGamingSystem( p_mcGS:MovieClip ):void 
		{
			_GS = p_mcGS;
			_GAMINGSYSTEM = p_mcGS;
		}
		
		/**
		 * Returns the gamingsystem instance
		 *
		 */
		public function getGamingSystem():MovieClip
		{
			return( _GS );
		}
		

		/**
		 * Used when offline
		 */
		public function NP9_GameBase():void {
			
			_GAMINGSYSTEM = getGamingSystem();
			
			_SOUND = _GAMINGSYSTEM._SOUND;
			
	
		}
		
	
		/**
		 * Sends scoring meter to the front - only offline
		 */
		public function sendScoringMeterToFront():void {

			trace(" NP9_GameDocument > sendScoringMeterToFront bOffline>",bOffline);
			
			//if ( bOffline ) {
				
				var nNumLastChild:Number = (numChildren-1);
				
				
				_GS.visible = true;
				
				// make sure scoring meter is always top DisplayObject
				if ( __GS_INDEX != nNumLastChild ) {
					setChildIndex( getChildAt(__GS_INDEX), nNumLastChild );
					__GS_INDEX = nNumLastChild;
				}
				trace("INFO SendScoreingMeterToFront>", nNumLastChild," GSINDEX>",__GS_INDEX, " GSVIS>",_GS.visible);
			//}
		}
		
		/**
		 * Sends scoring meter to the back - only offline
		 */
		
		public function sendScoringMeterToBack():void {
			
			if ( bOffline ) {
				if ( __GS_INDEX != 0 ) {
					setChildIndex( getChildAt(__GS_INDEX), 0 );
					__GS_INDEX = 0;
				}
				
				trace("INFO sendScoringMeterToBack>  GSVIS>",_GS.visible);
			}
		}
	}
}


