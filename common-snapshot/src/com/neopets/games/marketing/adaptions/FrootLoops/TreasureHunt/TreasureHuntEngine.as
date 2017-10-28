/* AS3
	Copyright 2008
*/

package  com.neopets.games.marketing.adaptions.FrootLoops.TreasureHunt
{
	import com.neopets.examples.gameEngineExample.gameObjects.IGameObject;
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.games.marketing.adaptions.FrootLoops.TreasureHunt.GameShellScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.examples.gameEngineExample.reference.SoundID_demo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 *	This is an Example of the Main Game Code for a Demo. 
	 *  @NOTE: The GameEngine is going to do it own process first, then once it is done, it will trigger
	 *  this class through the initChild() Function.
	 * 
	 *	@NOTE: This extends GameEngine so you have access to most of the GameEngine Functions.
	 *  	>The GameEngine has the SoundManager
	 * 		>The GameEngine has the Loader with has loaded all the external Files
	 * 		>The GameEngine is the way you communicate to the NP9 GameEngine
	 * 
	 * 	@NOTE: TreasureHuntEngine eventually extends EventDispatcher not a DisplayObject.
	 * 		>So to add items to a Stage, You are going to need to add them to the GameEngine mViewContainer
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  4.02.2009
	 */
	 
	public class TreasureHuntEngine extends GameEngine
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function TreasureHuntEngine():void
		{
			super();
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is called by GameEngine once:
		 * 		>All soundFiles are loaded, 
		 * 		>Congfig file is ready,
		 * 		>All external assets are loaded and can be in this ApplicationDomain (Depends on the Config.xml)
		 * @Note: This is the start of your Games Setup
		 */
		 
		  protected override function initChild():void 
		  {
		  	completedSetup();
		  }
		  
		
		 //--------------------------------------
		//  OVERRIDE PROTECTED INSTANCE METHODS (FROM THE GAME ENGINE)
		//--------------------------------------
		
		/** 
		 * @Note: the main game class should call this as the last step in the setup of the GameEngine object
		 * @Note: this will:
		 * 		  - order the objects in the main view container mViewContainer
		 *          -> by default, there is only one object contained in mViewContainer and that is
		 *             mMenuHolder. all screens are added to it
		 *        - add the main view container to the root movieclip
		 *        - get the language and set the logo to the appropriate frame
		 *        - put the intro screen into the foreground
		 */		
		protected override function completedSetup( ):void 
		{
			trace( "GameEngine says: completedSetup called" );
			
			mViewContainer.reOrderDisplayList( );
			mRootMC.addChildAt( mViewContainer, mRootMC.numChildren );
			
			dispatchEvent(new CustomEvent({CMD:mGameShell_Events.CMD_PRELOADER_DONE},SEND_THROUGH_CMD));
		}
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: this is called in parent class GameEngineSupport
		 * @Note: the artAsset SWF should be loaded by the parent before this is called
		 */		
		protected override function localInit( ):void 
		{
			trace( "GameEngine says: localInit called" );
			
			//mRootMC.dispatchEvent( new Event( REMOVE_LOADING_SIGN ) ); //this is redundant but sometimes necessary
			mViewContainer.ID = mID;
			//setupSounds( ); // not need for adapted game
			continueSetup( );
		}
		
		/**
		 * @Note: this should be overridden in your main game
		 * @Note: called when Restart Game link in scoring meter is clicked
		 * @Note: takes player back to intro screen
		 */		
		protected override function restartGame( ):void { trace("restartGame");}
		 
		 /**
		 * @Note: called from continueSetup after sounds are loaded and menu manager is instantiated
		 * @Note: handles standard translation for menus 
		 * @Note: one centeral location to have all the text strings converted menus 
		 * @Note: these are the default values for the default objects
		 * @Note: if game class extends VendorGameExtension then this function may be overridden to extend the menus
		 * @Note: if you just want to add menus or translated text, then override extendMenus function instead
		 */	
		override protected function setupMenus( ):void
		{		
			trace( "GameEngine says: setupMenus called" );
			
			extendMenus( );
		}
		
		  
	}
	
}
