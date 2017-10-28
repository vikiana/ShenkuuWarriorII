package com.neopets.games.inhouse.FreakyFactoryAS3
{	
	/**
	 * This is the structure class of the game. It provides functionality for all
	 * the game's menus and anything else not directly related to the gameply itself. 
	 *  @NOTE: The GameEngine is going to do it own process first, then once it is done, it will trigger
	 *  this class through the initChild() Function.
	 * 
	 * @NOTE: This extends GameEngine so you have access to most of the GameEngine Functions.
	 * >The GameEngine has the SoundManager
	 * >The GameEngine has the Loader with has loaded all the external Files
	 * >The GameEngine is the way you communicate to the NP9 GameEngine
	 * 
	 * @NOTE: gameEngineDemo eventually extends EventDispatcher not a DisplayObject.
	 * >So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @Pattern GameEngine
	 * 
	 * @author Clive Henrick
	 * @since  4.02.2009
	 */
	
	//=============================================
	//	CUSTOM IMPORTS
	//=============================================	
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.display.ViewContainer;
	
	import flash.utils.getDefinitionByName;
	
	public class FreakyFactoryAS3_Engine extends GameEngine 
	{		
		//=============================================
		//	CLASS CONSTANTS
		//=============================================
		
		//=============================================
		//  PRIVATE & PROTECTED VARIABLES
		//=============================================
		private var mGameObjectVC  : ViewContainer;
		
		protected var mLockButtons : Boolean;
		
		//=============================================
		//  GETTERS/SETTERS
		//=============================================	
		
		//=============================================
		//  CONSTRUCTOR
		//=============================================	
		public function FreakyFactoryAS3_Engine( ):void 
		{
			super( );
			
			trace( "FreakyFactoryAS3_Engine says: FreakyFactoryAS3_Engine constructed" );
			
		}	
		
		//=============================================
		//  PUBLIC METHODS
		//=============================================	
		
		//=============================================
		//  EVENT HANDLERS
		//=============================================
		
		//=============================================
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//=============================================
		
		/**
		 * @Note: called from GameEngine once:
		 *        - all sound files are loaded 
		 *        - congfig file is ready
		 *        - all external assets are loaded and are accessible in this ApplicationDomain (depends on the config.xml)
		 * @Note: This is the start of your Games Setup
		 */		
		protected override function initChild( ):void 
		{
			setupVars( );
			startGameSetup( );
			trace (this+": initChild called.");
		}
		
		/**
		 * @Note: pulls objects out of the external fla library
		 * @Note: since external assets are loaded into the parent application domain 
		 *        you can access an item in the library.
		 */		
		protected override function startGameSetup( ):void 
		{
			trace( "FreakyFactoryAS3_Engine says: startGameSetup called" );
			
			//var tTestMCClass : Class = getDefinitionByName( "TestAsset" ) as Class;
			//var tTestMC : MovieClip = new tTestMCClass( );
			//mGameObjectVC.addChild( tTestMC );
			//mGameObjectVC.addDisplayObjectUI( tTestMC, 10, "testMC" );
			/*  
			var tID:String;
			
			var tHexArea:Rectangle = new Rectangle(0,0,300,300);
			var tSquareArea:Rectangle = new Rectangle(0,0,600,500);
			
			var tHexClass:Class = ApplicationDomain.currentDomain.getDefinition("mcHexagon") as Class;
			var tSquareClass:Class = ApplicationDomain.currentDomain.getDefinition("mcSquare") as Class;
			
			
			for (var tCount:int = 0; tCount < 10; tCount++)
			{
			if (tCount & 1)
			{
			tID = "HexObj"+tCount;
			//var tHexsObject:HexagonObject = new tHexClass(); FLEX SUPPORTS THIS BUT FLASH DOES NOT
			var tHexsObject:MovieClip = new tHexClass(); 
			
			mGameObjectArray.push(tHexsObject);
			tHexsObject.init(tID,tHexArea,.6);
			tHexsObject.addEventListener(tHexsObject.SEND_SCORE, addScore, false,0,true);
			mGameObjectVC.addDisplayObjectUI(tHexsObject,tCount,tID,new Point(tHexsObject.x,tHexsObject.y),true);
			
			}
			else
			{
			tID = "SquareObj"+tCount;
			//var tSqrGameObj:SquareObject = new tSquareClass();
			var tSqrGameObj:MovieClip = new tSquareClass();
			
			mGameObjectArray.push(tSqrGameObj);
			tSqrGameObj.init(tID,tSquareArea,.5);
			
			tSqrGameObj.addEventListener(tSqrGameObj.SEND_SCORE, addScore, false,0,true);
			mGameObjectVC.addDisplayObjectUI(tSqrGameObj,tCount,tID,new Point(tSqrGameObj.x,tSqrGameObj.y),true);
			}
			}*/
			
			//mFreakyFactoryAS3_Core = new FreakyFactoryAS3_Core( );
			//mFreakyFactoryAS3_Core.setRoot( mRootMC );
			//mFreakyFactoryAS3_Core.setup();
			//mFreakyFactoryAS3_Core.init( );
			
			gameSetupDone( );
		}
		
		/**
		 * @Note: game is set up completely and ready to tell the shell it's done
		 *        - re-orders the view containers
		 *        - adds mGameObjectVC to GameEngine's ViewContainer
		 *        - tells GameEngine it is ready
		 */
		protected function gameSetupDone( ):void 
		{
			trace( "FreakyFactoryAS3_Engine says: gameSetupDone called" );
			//mGameObjectVC.reOrderDisplayList( );
			//var tMainMenu : OpeningScreen = MenuManager.instance.getMenuScreen( MenuManager.MENU_INTRO_SCR );
			//tMainMenu.addChildAt( mGameObjectVC, tGameScreen.numChildren );
			//tGameScreen.addChild( mFreakyFactoryAS3_Core );
			completedSetup( );
			
		}
		
		private function setupVars( ):void 
		{			
			//trace( "FreakyFactoryAS3_Engine says: setupVars called" );
			//mGameObjectArray = [];
			mGameObjectVC    = new ViewContainer( "GameScreen" );
			mLockButtons     = false;
			
		}		
		
	}
}