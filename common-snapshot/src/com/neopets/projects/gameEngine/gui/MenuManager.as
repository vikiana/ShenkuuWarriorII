
/* AS3
	Copyright 2008
*/
package com.neopets.projects.gameEngine.gui
{

	import com.neopets.examples.vendorShell.translation.TranslationInfo;
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.managers.EmbededObjectsManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	import virtualworlds.lang.TranslationData;
	
	/**
	 *	This Handles Menu Navigation
	 *	Please Extend this class as needed if your menu structure is not the standard template of
	 * 		>> Intro Menu
	 * 		>> Instruction Menu
	 * 		>> Game Menu
	 * 		>> Game Over Menu
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern NP9 System
	 * 
	 *	@author Clive Henrick
	 *	@since 7.10.2009
	 */
	 
	public class MenuManager extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const MENU_BUTTON_EVENT:String = "MenuhasButtonEvent";
		public const MENU_EVENT:String = "MenuManagerhasEvent";
		public const MENU_NAVIGATION_EVENT:String = "MenuSpecialEvent";
		
		public static const MENU_INTRO_SCR:String = "mIntroScreen";
		public static const MENU_GAMEOVER_SCR:String = "mGameOverScreen";
		public static const MENU_GAME_SCR:String = "mGameScreen";
		public static const MENU_INSTRUCT_SCR:String = "mInstructionScreen";
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		protected var mMenuArray:Array;
		protected var mDocumentClass:MovieClip;
		protected var mTranslationInfo:TranslationData;
		
		protected var mMenuHolder:Sprite;
		protected var mActiveMenuID:String;
		
		private static const mInstance:MenuManager = new MenuManager( SingletonEnforcer ); 
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
	public function MenuManager(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
			}
			
			setupVars();
		}
		
		/** 
		 * @Note: Starts the Menu Init Process.
		 * 
		 * @Param		pRoot		The Document Class of your Project as a MovieClip as it can not be typed and still be A unversal used Class
		 */
		 
		public function init(pRoot:MovieClip, pTranslationInfo:TranslationData = null):void
		{
			mDocumentClass = pRoot;
			mTranslationInfo = pTranslationInfo;
		}	
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():MenuManager
		{ 
			return mInstance;	
		} 
		
		public function get menusDisplayObj ():Sprite
		{
			return mMenuHolder;
		}
		
		public function getMenuScreen(pMenu:String):*
		{
			var tCount:int = 	mMenuArray.length;

			for (var t:int = 0; t < tCount; t++)
			{
				if (mMenuArray[t].mID == pMenu)
				{
					return mMenuArray[t];
				}
			}
			return false;
		}
		
		public function isMenuActive(pMenuID:String):Boolean
		{
			if (mActiveMenuID == pMenuID)
			{
				return true;	
			}
			else
			{
				return false;	
			}
		}
		
		public function currentActiveMenuID():String
		{
			return mActiveMenuID;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @NOTE: This Navigates the Menus
		 * @param		pMenu		String		The Name of the Menu to Turn On
		 */
		 
		public function menuNavigation(pMenu:String):void
		{
			var tCount:int = 	mMenuArray.length;
			
			for (var t:int = 0; t < tCount; t++)
			{
				mMenuArray[t].visible = false;	
				mMenuArray[t].menuButtonLock = false;	
				
				if (mMenuArray[t].mID == pMenu)
				{
					if (AbsMenu(mMenuArray[t]).parentMenuID)
					{
						activateMenuWithParent(mMenuArray[t]);
					}
					else
					{
						mMenuArray[t].visible = true;
						dispatchEvent(new CustomEvent({MENU:pMenu}, MENU_NAVIGATION_EVENT));		
					}
						
				}
	
			}
			
			
		}
		
		public function addScreen(pDisplayObject:DisplayObject, pID:String):void
		{
			var tScreenHolder:AbsMenu = new AbsMenu();
			
			tScreenHolder.visible = false;
			
			tScreenHolder.addChild(pDisplayObject);
			tScreenHolder.mID = pID;
			
			mMenuArray.push(tScreenHolder);
			
			mMenuHolder.addChild(tScreenHolder);	
		}
		
		/**
		 * @NOTE: This Creates Menus and Stores them in the mMenuArray. 
		 * @RETURN: It Returns the Parent Class of All Menus. You will need to Type the Returned Object if you wish to type the returned Object.
		 * @param		pLibName					String		The Name of the Object you linked in your Library FLA
		 * @param		pID							String		The Reference Name used in the mMenuArray for Access.
		 * @param		pEmbeded				Boolean		Only True if you are Emdeding a SWF (Flex) and need to get access to a Menu from 
		 * @param		pEmdedMenuClass	Class			If Embeding a SWF, you will need to pass the Reference to The SWF Class Holding The Menu.
		 * @param		pParentMenuID			String		If this Menu has a parent Menu that it needs to be in front and to Lock when it is acitve
		 *  */
		 
		public function createMenu(pLibName:String,pID:String,pEmbeded:Boolean = false, pEmbedObjData:EmbedObjectData = null, pParentMenuID:String = undefined, pStartLocation:Point = null):AbsMenu
		{
			var tIntroMenuClass:Class;
			
			if (pEmbeded)
			{
				var tEmbedObjData:EmbedObjectData = pEmbedObjData;
				tIntroMenuClass = tEmbedObjData.mApplicationDomain.getDefinition(pLibName) as Class;	
			}
			else
			{
				tIntroMenuClass = ApplicationDomain.currentDomain.getDefinition(pLibName) as Class;	
			}
				
				var tScreen:AbsMenu = new tIntroMenuClass();
				tScreen.mID = pID;
				tScreen.addEventListener(tScreen.BUTTON_PRESSED,onInterfaceButtonPressed,false,0,true);
				mMenuArray.push(tScreen);
				tScreen.visible = false;
				mMenuHolder.addChild(tScreen);	
				
				
				if (pParentMenuID)
				{
					tScreen.parentMenuID = 	pParentMenuID;
				}
				
				if (pStartLocation != null)
				{
					tScreen.x = pStartLocation.x;
					tScreen.y = pStartLocation.y;
				}
				
				return tScreen;
				
				
				//return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @NOTE: This is for the Buttons on a MENU. The Buttons Needed to have different names inorder for it to know what scene its from.
		 * @Note: Just in Case it will broadcast the Button Clicked if you want more Code to be processed in your game or add a new Button.
		 * @Note from the MENU_BUTTON_EVENT in VendorGameExtension add Button Cmds for new Buttons.
		 * @param			evt.oData.TARGETID			String			The Name of the Button Being Pressed
		 */
		 
		protected function onInterfaceButtonPressed(evt:CustomEvent):void
		{
			switch (evt.oData.TARGETID)
			{
				case "startGameButton":  // INTRO Scene
					mDocumentClass.neopets_GS.sendTag (mDocumentClass.START_GAME_MSG);
				break;
				case "instructionsButton":  // INTRO Scene
					menuNavigation(MenuManager.MENU_INSTRUCT_SCR);
				break;
				case "quitGameButton": // GAME SCENE
					menuNavigation(MenuManager.MENU_GAMEOVER_SCR);
				break;
				case "playAgainBtn": // Game Over SCENE
					mDocumentClass.sendScoringMeterToBack();
				break;
				case "reportScoreBtn": // Game Over SCENE
					getMenuScreen(MenuManager.MENU_GAMEOVER_SCR).toggleInterfaceButtons(false);
					mDocumentClass.sendScoringMeterToFront();
					mDocumentClass.neopets_GS.addEventListener(mDocumentClass.neopets_GS.RESTART_CLICKED,restartBtnPressed);
				break;
				case "returnBtn": // Instruction SCENE
					menuNavigation(MenuManager.MENU_INTRO_SCR);
				break;
				case "soundToggleBtn":
					// Handled in the VenderGameExtension through the bottom dispatchedEvent
				break;
				case "musicToggleBtn":
					// Handled in the VenderGameExtension through the bottom dispatchedEvent
				break;
			}	
			

			dispatchEvent(new CustomEvent({EVENT:evt.oData.TARGETID}, MENU_BUTTON_EVENT));	
			
		}
		
		/**
		 * @Note Called from the Game System when the Restart Game button is pressed on the Score Report Window
		 */
		 
		 protected function restartBtnPressed(evt:Event = null):void
		 {
		 	if (mDocumentClass.neopets_GS.hasEventListener(mDocumentClass.neopets_GS.RESTART_CLICKED))
		 	{
		 		mDocumentClass.neopets_GS.removeEventListener(mDocumentClass.neopets_GS.RESTART_CLICKED,restartBtnPressed); 		
		 	}
			
			mDocumentClass.sendScoringMeterToBack();
			
			dispatchEvent(new CustomEvent({EVENT:"restartGame"}, MENU_EVENT));
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{	
			mMenuArray = [];
			mMenuHolder = new Sprite();
			mTranslationInfo = new TranslationInfo();
			
		}

		/**
		 * Activates the Tasked Menu with its Parent (EX: A popup Menu with its Parent still in the Background)
		 * @param		pPopUpMenu	AbsMenu 		The Popup Menu That is ontop of the Parent Menu
		 */
		 
		private function activateMenuWithParent(pPopMenu:AbsMenu):void
		{
			var tPopUpMenu:AbsMenu = pPopMenu;
			var tBackgroundMenu:AbsMenu;
			var tBackgroundMenuID = tPopUpMenu.parentMenuID;
			
			var tCount:int = 	mMenuArray.length;
			
			for (var t:int = 0; t < tCount; t++)
			{
				if (mMenuArray[t].mID == tBackgroundMenuID)
				{
					tBackgroundMenu = mMenuArray[t];
					break;
				}
			}
			
			if (!tBackgroundMenu)
			{
				trace ("Error activateMenuWithParent: Popup Menu: " + tPopUpMenu.mID + " Has no Parent in MenuManager called: " + tPopUpMenu.parentMenuID);
				return;
			}
			
			//Make Sure the Child is on Top of the Parent in the Display Index
			if (mMenuHolder.getChildIndex(tPopUpMenu) < mMenuHolder.getChildIndex(tBackgroundMenu))
			{
				mMenuHolder.setChildIndex(tPopUpMenu,	mMenuHolder.getChildIndex(tBackgroundMenu));
			}
			
			tPopUpMenu.visible = true;
			tBackgroundMenu.visible = true;
			tBackgroundMenu.menuButtonLock = true;
			dispatchEvent(new CustomEvent({MENU:tPopUpMenu.mID}, MENU_NAVIGATION_EVENT));	
			
		}
	
	}
}
/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}