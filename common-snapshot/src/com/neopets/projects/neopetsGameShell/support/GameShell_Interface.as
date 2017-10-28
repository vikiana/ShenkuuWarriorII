/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.support
{
	import com.neopets.mvc.view.NeopetsScene;
	import com.neopets.mvc.view.ViewContainer;
	import com.neopets.neopetsGameShell.model.ExternalCommands;
	import com.neopets.neopetsGameShell.support.NeopetsGameSupport;
	import com.neopets.util.button.INeopetButton;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManagerOld;
	import com.neopets.util.tranistion.TransitionObject;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	/**
	 *	This is the Basic Interface for the NeoPets Game Container
	 * 	This is more of an reader and translator of commands set in the config.xml.
	 * 	
	 * 	
	 * 	###### NOTE ######
	 * 	From Project to Project the only functions that will should be needed to be changed is
	 * 	the ExternalCommands Class.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.21.2008
	 */
	 
	public class GameShell_Interface extends NeopetsGameSupport
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const TRANSITION_TOP_CENTER:String = "TopToCenter";
		public const TRANSITION_BOT_CENTER:String = "BottomToCenter";
		public const TRANSITION_RIGHT_CENTER:String = "RightToCenter";
		public const TRANSITION_LEFT_CENTER:String = "LeftToCenter";
		public const TRANSITION_FADE:String = "XFadeStage";
		
		public static const SCENE_GAME_INTRO:String = "GAME_INTRO";
		
		public static const CMD_ACTIVATE:String = "ActivateAndJumpToAScene";
		public const READY:String = "ShellisReady";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
			
		private var mSceneCount:uint;
		private var mRunningSceneCount:uint;
		private var mScore:int;
	
		private var mViewContainer:ViewContainer;
		private var mButtonLock:Boolean;
		private var mCurrentScene:NeopetsScene;
		private var mSM_Interface:SoundManagerOld;
		private var mLocalTesting:Boolean;
		
		private var mSceneArray:Array;
		private var mExternalCommand:ExternalCommands;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameShell_Interface():void
		{
			setupVars();
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get soundManager():SoundManagerOld
		{
			return mSM_Interface;
		}
		
		public function get buttonLock():Boolean
		{
			return mButtonLock;
		}
		
		public function set buttonLock(pFlag:Boolean):void
		{
			mButtonLock = pFlag;
		}
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is here to be OVERRIDE if needed
		 */
		 
		 protected override function localInit():void 
		 {
		 	setupSounds();
		 	setupDisplayElements(SCENE_GAME_INTRO);
		 }
		 
		  /**
		 * @Note: This is called to recieve the incomming translations
		 * @param	PassedObject.OBJECT		DisplayObject		The Button /TextField which the String needs to go
		 * @param	PassedObject.STRING		String				The Translated Text
		 */
		 
		  protected override function translateObject(PassedObject:Object):void 
		  {
		  	
		  }

		/**
		 * @Note: This is only needed if the Game Container is Loading a seperate Intro Layer
		 * @param	PassedObject.CMD		String		The Desired Command
		 * @param	PassedObject.PARAM		Object		The Desired Paramaters		
		 */
		 
		 protected override function returnedCmdInterface(PassedObject:Object):void 
		 {
		 	switch (PassedObject.CMD)
		 	{
		 		case CMD_ACTIVATE:
		 			activateInterface(PassedObject.PARAM.MSG);
		 		break;
		 	}
		 	
		 }
		 
		 //--------------------------------------
		//  PUBLIC INSTANCE METHODS
		//--------------------------------------
		/**
		 * This Jumps Betweens Scences
		 * 	@param		pNewScene			NeopetsScene
		 * 	@param		pCurrentScene		NeopetsScene	
		 * 	@param		pTransition			String			(null)		The Type of Translation for a Scene			
		 */
		 
		public function sceneTransition(pNewScene:NeopetsScene,pCurrentScene:NeopetsScene = null,pTransition:String = null):void
		{
			mButtonLock = false ? pTransition = null:true;
			mCurrentScene = pNewScene;
			
			if (pTransition == null)
			{
				pNewScene.displayFlag = true;
				pCurrentScene.displayFlag = false;
				
				if (pCurrentScene.backgroundSound) 
				{
					pCurrentScene.sceneSoundManager.stopSound(pCurrentScene.backgroundSound);	
				}
				
				if (pNewScene.backgroundSound) 
				{
					pNewScene.sceneSoundManager.soundPlay(pNewScene.backgroundSound,true);		
				}
			}
			else
			{
				pNewScene.displayFlag = true;
				pNewScene.lockButtons = true;
				pCurrentScene.lockButtons = true;
				var newViewC:ViewContainer = pNewScene.viewContainer;
				var oldViewC:ViewContainer = pCurrentScene.viewContainer;
				
				if (pCurrentScene.backgroundSound) 
				{
					pCurrentScene.sceneSoundManager.fadeOutSound(pCurrentScene.backgroundSound,2);	
				}
				
				switch (pTransition)
				{
					case TRANSITION_FADE:
						TransitionObject.startTransition(TransitionObject.XFADE,
							{
								ITEM:newViewC,TIME:2,FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							{
								ITEM:oldViewC,TIME:1
							}
						);
					break;
					case TRANSITION_TOP_CENTER:
						TransitionObject.startTransition(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:2,STARTLOC:new Point(0,(newViewC.y - newViewC.height)),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(0,mRootMC.stage.stageHeight + 100)
							}
							
							);
					break;
					case TRANSITION_BOT_CENTER:
						TransitionObject.startTransition(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:2,STARTLOC:new Point(0,mRootMC.stage.stageHeight + 100),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(0,-(mRootMC.stage.stageHeight))
							}
							
							);
					break;
					case TRANSITION_RIGHT_CENTER:
						TransitionObject.startTransition(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:2,STARTLOC:new Point((newViewC.x - newViewC.width),0),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point((oldViewC.x + mRootMC.stage.stageWidth + 100),0)
							}
							
							);
					break;
					case TRANSITION_LEFT_CENTER:
						TransitionObject.startTransition(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:2,STARTLOC:new Point((newViewC.x + newViewC.width),0),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(-(mRootMC.stage.stageWidth),0)
							}
							
							);
					break;
				}
			}
		}
		
		/**
		 * Quick way to Find a Scene
		 * @param		pNeoPetsSceneID		String		The Name of the desired neopetsScene
		 */
		 
		 public function getNeopetsScene(pNeoPetsSceneID:String):NeopetsScene
		 {
		 	var tNewScene:NeopetsScene = null;
		 	
		 	var tCount:uint = mSceneArray.length;
			
			for (var t:uint = 0; t < tCount; t++)
			{
				if (mSceneArray[t].ID == pNeoPetsSceneID)
				{
					tNewScene = mSceneArray[t]
					break; 
				}	
			}
		 	
		 	return tNewScene;	
		 }	
		 
		 /**
		 * @Note: Strips the Params looking for a Common Stated Variable of that name to use its Value
		 */
		 
		 
		public function convertToArray(pInfo:String):Array
		{
			var tArray:Array = [];
			
			var tWorkArray:Array = pInfo.split(",");
			
			var tCount:uint = tWorkArray.length;
			
			for (var t:uint = 0; t < tCount; t++)
			{
				if (this.hasOwnProperty(tWorkArray[t]))
				{
					tArray.push(this[tWorkArray[t]]);
				}
				else
				{
					tArray.push(tWorkArray[t]);
				}
			}

			return tArray;
		} 
		
		
		 //--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{	
			mSceneCount = 5;
			mRunningSceneCount = 0;
			mViewContainer = new ViewContainer("GameShellVC");
			mButtonLock = false;
			mSM_Interface = new SoundManagerOld(null,"SM_Interface");
			mSceneArray = [];
			mExternalCommand = new ExternalCommands(this);
		}
		
		/**
		 * @Note: This is used to setup the Sound Files. These files are set in the config.xml.
		 * @Note: The SoundFiles are assumed to be embeded in the Library of the soundObj Class
		 */
		 
		private function setupSounds():void
		{
			for each (var sndXML:XML in mConfigXML.SETUP.INTERFACE.SOUNDS.*)
			{
				mSM_Interface.loadSound(sndXML.@ID,sndXML.@TYPE);			
			}
		}
		
		/**
		 * This is used to setup the display Elements in the Scenes
		 */
		 
		private function setupDisplayElements(pSceneName:String):void
		{
			var tButtonArray:Array = [];
			var tBackgroundMC:MovieClip = null;
			var tClassBackGround:Class;
			var tApplicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			mSceneArray = [];
			
			for each (var sceneXML:XML in mConfigXML.SETUP.INTERFACE.SCENES.*)
			{
				var tNeopetsScene:NeopetsScene = new NeopetsScene();
				/*
				if (sceneXML.hasOwnProperty("@BACKGROUND"))
				{
					tClassBackGround = tApplicationDomain.getDefinition(sceneXML.@BACKGROUND) as Class;
					tBackgroundMC = new tClassBackGround();
				}
				
				tNeopetsScene.init(sceneXML,tApplicationDomain,tBackgroundMC,mSM_Interface);
				tNeopetsScene.addEventListener(tNeopetsScene.BUTTON_ACTION,onButtonAction,false,0,true);
				mViewContainer.addUIViewContainer(tNeopetsScene.viewContainer,0,tNeopetsScene.viewContainer.ID,new Point(sceneXML.@X,sceneXML.@Y),Number(sceneXML.@VISIBLE));
					
				mSceneArray.push(tNeopetsScene);
				*/
			}

			mCurrentScene = getNeopetsScene(SCENE_GAME_INTRO);
			translateObjects();
			
		}
		
		/**
		 * @Note: Sets the Interface to a "OFF" State
		 */
		 
		private function deactivateInterface():void
		{
			mSM_Interface.stopAllCurrentSounds();
			mRootMC.visible = false;	
		}
		
		/**
		 * @Note: Sets the Interface to a "ON" State
		 * @param		pActiveScene		String		The Scene that you want on Stage (active)
		 */
		 
		private function activateInterface(pActiveScene:String):void
		{
			
			var tReturnedScene:NeopetsScene = getNeopetsScene(pActiveScene);
			var tNewScene:NeopetsScene = (tReturnedScene != null) ?  tReturnedScene:mSceneArray[0];

			if (mCurrentScene != tNewScene)
			{
				sceneTransition(tNewScene,mCurrentScene);
			}
			
			mRootMC.visible = true;	
				
		}
		
		/**
		 * @Note: This goes through all the Objects and Translates the Text
		 */
		 
		private function translateObjects():void
		{
			// ADD THE SCRIPT TO TRANSLATE OBJECTS
			completedSetup();	
		}
		
		/** 
		 * @Note: When the project is ready to be displayed
		 */
		 
		private function completedSetup():void
		{
			mRootMC.addChild(mViewContainer);
			dispatchEvent(new Event(this.READY));
		}
		
		/**
		 * @NOTE: This is called after an SceneTransition is complete
		 * @param	OldDisplayObj 		NeopetsScene		The Old Scene
		 * @param	newDisplayObj 		NeopetsScene		The New Scene
		 * */
		 
		private function transitionComplete(OldDisplayObj:NeopetsScene,newDisplayObj:NeopetsScene):void
		{
			OldDisplayObj.displayFlag = false;
			OldDisplayObj.viewContainer.alpha = 1;
			OldDisplayObj.viewContainer.x = 0;
			OldDisplayObj.viewContainer.y = 0;
			OldDisplayObj.lockButtons = false;
			newDisplayObj.lockButtons = false;
			mButtonLock = false;
			
			if (newDisplayObj.backgroundSound) 
			{
				newDisplayObj.sceneSoundManager.soundPlay(newDisplayObj.backgroundSound,true);	
			}
		}
		
		
		 /**
		 * TEST
		 */
		 
		 private function Test(pMSG:String):void
		 {
		 	trace(pMSG);
		 }
			
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/**
		 * @Note:Commands that are to complex, so for now we must manuelly write a case state to Handle
		 * @Note: This Function can change from application to application.
		 * @param		pCMD		String		The Function as a String
		 * @param		pPARAM		String		The List of Params for the Function
		 */
		
		private function doExternalCommand(pCmd:String,pParam:String):void
		{
			mExternalCommand.doExternalCommand(pCmd,pParam);
		}
		
		/**
		 * @Note: This is for Button Actions from the Scenes.
		 * All the Commands are in one location, as the functions effect other scenes, or the Interface in general.
		 * 
		 * @param	evt.oData.SCENE		NeopetsScene		The Scene that Contains the Button
		 * @param	evt.oData.BUTTON	NeopetsButton		The Button that Triggered the Event
		 */
		 
		private function onButtonAction(evt:CustomEvent):void
		{
			if (!mButtonLock)
			{
			
			var tButton:INeopetButton = evt.oData.BUTTON;
			
			
				if (tButton.dataObject.hasOwnProperty("FUNCTIONS"))
				{
					for each (var functionXML:XML in tButton.dataObject.FUNCTIONS.*)
					{
						if (Boolean(Number(functionXML.@OVERRIDE)))
						{
							doExternalCommand(functionXML.CMD,functionXML.PARAMS);
						}
						else
						{
							if (functionXML.hasOwnProperty("PARAMS"))
							{
								this[functionXML.CMD.toString()](functionXML.PARAMS.toString());
							}
							else
							{
								this[functionXML.CMD.toString()]();
							}
						}
					}
				}
			}
		} //End Function
		
	}
	
}
