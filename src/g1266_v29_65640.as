//Marks the right margin of code *******************************************************************
package
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.ShenkuuWarrior2_Game;
	import com.neopets.games.inhouse.shenkuuwarrior2.ShenkuuWarrior2_GameEngine;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.SW2_TranslationData;
	import com.neopets.games.inhouse.shenkuuwarrior2.utils.control_panel;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadingEngineXML;
	import com.neopets.util.loading.XMLLoader;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * public class g1266_v0_65640 extends NP9_DocumentExtension: Shenkuu Warrior 2
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	[SWF(width="500", height="600", frameRate="32", backgroundColor="0x000000", scale="exactfit" ,align="t", salign="tl")] 
	public class g1266_v29_65640 extends NP9_DocumentExtension
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public const GAME_USECONFIGFILE:Boolean = true;
		public const GAME_CONFIGFILEVERSION:int = 6;
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_ToParent";
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public var mcBIOS:NP9_BIOS;
		
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//private var _controller:controlpanel;
		private var _gameengine:ShenkuuWarrior2_GameEngine;
		private var mTranslationData:SW2_TranslationData;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class g1266_v0_65640 extends NP9_DocumentExtension instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function g1266_v29_65640()
		{
			
			flexHacks();
			
			setupVars();                                                                                        
			
			super();
			
			if (mcBIOS.localTesting)
			{
				init(mcBIOS);
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
		/**
		 * @Note: that you know its time to continue Code after the NP9 System has been loaded.
		 * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		 *		>This is Triggered by the NP9_Loader_Control
		 *		>At function Main - _STARTGAME:
		 * 	@Note: If This will use local Files for loading if offline.
		 **/
		
		protected override function gameEngineUpdate():void
		{
			mcBIOS.localTesting = bOffline;
			
			if (bOffline)
			{
				mcBIOS.finalPathway = mcBIOS.localPathway;	
			}
			else
			{
				mcBIOS.finalPathway = _GS.getImageServer() + mcBIOS.localPathway;	
			}	
			_gameengine.init (this, mcBIOS.finalPathway, new SW2_TranslationData());
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function flexHacks():void {
			//this is to add something to the stage of Flash will not understand stage properties
			var mc:Sprite = new Sprite ();
			var s:Shape = new Shape();
			s.graphics.beginFill (0x000000);
			s.graphics.drawRect(0, 0, 550, 600);
			s.graphics.endFill(); 
			mc.addChild (s);
			addChild (mc);
			
			//this is a trick for Flex to recognize classes called with getDefinitionByName (only when assets are embedded other than loaded)
			var loadingSign:LoadingSign = null;
		}
		
		
		/**
		 * Setup Class Variables for the Neopets Gaming System. You Must Have this.
		 */
		
		private function setupVars():void
		{
			_gameengine = new ShenkuuWarrior2_GameEngine();	
			_gameengine.addEventListener(_gameengine.SEND_THROUGH_CMD,sendThroughEvent,false,0,true);	
			
			
			
			mcBIOS 		= (mcBIOS != null) ? mcBIOS : new NP9_BIOS();
			
			//Setup BIOS
			mcBIOS.debug = true;									//Change this to True or False
			mcBIOS.translation = true; 								//Do Not Change
			mcBIOS.trans_debug =  false; 							//Do Not Change
			mcBIOS.dictionary = false;								//Do Not Change
			mcBIOS.game_id =  1266; 								//This Number will be provided by Neopets, For Demo its 13000
			mcBIOS.game_lang = "en"; 								//Do Not Change
			mcBIOS.meterX = 100;									//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY = 200;   									//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server = "dev.neopets.com";				//Do Not Change
			mcBIOS.game_server = "images50.neopets.com"; 			//Do Not Change
			mcBIOS.metervisible = true; 							//Do Not Change
			mcBIOS.localTesting = true;								//Will always be true for local Testing for Vendors
			mcBIOS.localPathway =  "games/g"+mcBIOS.game_id+"/";	//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp =  "10/18/10";					//for testing only
			mcBIOS.game_timestamp = "11:31AM";						//for testing only
			mcBIOS.game_infostamp = "Shenkuu Warrior 2";        //for testing only
			mcBIOS.iBIOSWidth = 500;								//Width of the Game
			mcBIOS.iBIOSHeight = 600;								//Height of the Game
			mcBIOS.width = mcBIOS.iBIOSWidth;
			mcBIOS.useConfigFile = GAME_USECONFIGFILE;                               //Do Not Change unless Game uses a config.xml File
			mcBIOS.configFileVersion = GAME_CONFIGFILEVERSION;						//Do Not Change unless Game doesn't use a config.xml File
			bOffline = true;
		}
		
		
		
		/**
		 * Cleanup Memory for Quiting the Shell.
		 * 	> Cleanup the DisplayList
		 *  > mGameEngineDemo to Null
		 * 	> Dispatch the Event Saying it is Done with memeory CleanUp
		 */
		
		private function cleanupGameEngineShell(evt:CustomEvent = null):void
		{
			
			while (numChildren) 
			{    
				removeChildAt(0);
			}	
			
			_gameengine = null;
			var tPassedObj:Object = evt.oData;
			this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
		}
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * @Note: Sends Message Through the Shell to anything listening
		 * @param	evt.oData.CMD		String		The Desired Command
		 * @param	evt.oData.PARAM		Object		The Desired Paramaters
		 */
		
		public function sendThroughEvent(evt:CustomEvent):void
		{
			if (evt.oData.CMD == _gameengine.GAME_ENGINE_CLEANED)
			{
				cleanupGameEngineShell(evt);		
			}
			else
			{
				var tPassedObj:Object = evt.oData;
				this.dispatchEvent(new CustomEvent(tPassedObj,SEND_THROUGH_CMD));	
			}
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}