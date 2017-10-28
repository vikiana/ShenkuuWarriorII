
/* AS3
	Copyright 2008
*/
package 
{
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.games.inhouse.G1156.managers.ExtendedEmbededObjectsManager;
	import com.neopets.util.managers.EmbededObjectsManager;
	import com.neopets.games.inhouse.G1156.translation.TranslationG1156;
	import com.neopets.projects.np9.gameEngine.NP9_DocumentExtension;
	import com.neopets.projects.np9.system.NP9_BIOS;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	@Pattern GameEngine (Flex)
	 * 
	 *	@author Clive Henrick
	 *	@since  9.22.2009
	 */
	 
	 [SWF(width='650',height='600',backgroundColor='0x000000',frameRate='30')]
	 	
	public class G1156 extends NP9_DocumentExtension
	{
		//--------------------------------------
		// FLEX EMBED TAGS
		//--------------------------------------
		
	
		
		[Embed(source="baseAssets.swf")]  
		private var mBaseAssets:Class;
		
		[Embed(source="G1156_GameAssets_v3.swf")]  
		private var mG1156_GameAssets:Class;
		
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const SEND_ACTIVE_EVENT:String = "ActivateTheObject";
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		protected var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mEmbededObjectsManager:ExtendedEmbededObjectsManager;
		protected var mTranslationData:TranslationG1156;
		protected var mGameEngine:GameCore;
		
		public var mcBIOS:NP9_BIOS;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function G1156():void
		{
			trace("Constructor G1156");
			
			var square:Shape = new Shape();
			square.graphics.beginFill(0x000000, 1);
			square.graphics.drawRect(0, 0, 650, 600);
			this.addChild(square);
			
			setupVars();
			super();
			
			this.mBIOS = mcBIOS;
			
			init(mcBIOS);		
		
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		/** 
		 * @Note: The EmbededObjectsAreReady to use in the project.
		 */
		 
		private function onEmbededObjectsReady(evt:Event):void
		{
			
	
			if (bOffline)
			{
				mcBIOS.finalPathway = mcBIOS.localPathway;	
			}
			else
			{
				mcBIOS.finalPathway = _GAMINGSYSTEM.getImageServer() + mcBIOS.localPathway;	
			}	
			trace("onEmbededObjectsReady: " , mcBIOS.finalPathway, " offline:", bOffline);
			mGameEngine.init(this, mcBIOS.finalPathway, mTranslationData);	
			

		}
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mGameEngine = GameCore.instance;
			
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			mEmbededObjectsManager = ExtendedEmbededObjectsManager.instance;
			mEmbededObjectsManager.addEventListener(EmbededObjectsManager.EVENT_EMBEDED_READY, onEmbededObjectsReady, false,0, true);
		
			mcBIOS = (mcBIOS != null) ? mcBIOS : new NP9_BIOS();
			
			//Setup BIOS
			mcBIOS.debug = true;																//Change this to True or False
			mcBIOS.translation = false; 														//Do Not Change
			mcBIOS.trans_debug =  false; 													//Do Not Change
			mcBIOS.dictionary = false;														//Do Not Change
			mcBIOS.game_id =  1156; 											//This Number will be provided by Neopets, For Demo its 13000, GameEngineTest is 1105
			mcBIOS.game_lang = "en"; 														//Do Not Change
			mcBIOS.meterX = 200;																//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.meterY = 200;   															//This will be the location of the Score Reporting Window From Neopets
			mcBIOS.script_server = "dev.neopets.com";								//Do Not Change
			mcBIOS.game_server = "images50.neopets.com"; 						//Do Not Change
			mcBIOS.metervisible = true; 														//Do Not Change
			mcBIOS.localTesting = true;														//Will always be true for local Testing for Vendors
			mcBIOS.localPathway =  "games/g"+mcBIOS.game_id+"/";		//All supplemental Assets must be in a folder with a path name in this format "games/g1212/artwork.swf"
			mcBIOS.game_datestamp =  "09/28/09";									//for testing only
			mcBIOS.game_timestamp = "11:31AM";									//for testing only
			mcBIOS.game_infostamp = "G1156";       									 //for testing only
			mcBIOS.iBIOSWidth = 650;														//Width of the Game
			mcBIOS.iBIOSHeight = 600;														//Height of the Game
			mcBIOS.width = mcBIOS.iBIOSWidth;
			mcBIOS.height = mcBIOS.iBIOSHeight;
			mcBIOS.useConfigFile = true;													//Do Not Change unless Game uses a config.xml File
			mcBIOS.useFlexEmbed = true;
			bOffline = false;

			mTranslationData = new TranslationG1156();
		}
		
		/**
		 * @Note: that you know its time to continue Code after the NP9 System has been loaded.
		 * @Note: This is called from the Game on Frame 2, when its triggered by the NP9_Loader_Control
		 *		>This is Triggered by the NP9_Loader_Control
		 *		>At function Main - _STARTGAME:
		 * 	@Note: If This will use local Files for loading if offline.
		**/
		 
		protected override function gameEngineUpdate():void
		{
	
			trace("gameEngineUpdate");
			mcBIOS.localTesting = bOffline;
			var ClassArray:Array =  [mBaseAssets,mG1156_GameAssets];
			mEmbededObjectsManager.setupEmdedItems(ClassArray);
			
		}
	}
	
}

