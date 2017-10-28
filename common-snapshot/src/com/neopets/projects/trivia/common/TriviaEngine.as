/* AS3
	Copyright 2008
*/
package com.neopets.projects.trivia.common
{

	import com.neopets.projects.mvc.view.NeopetsScene;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.projects.neopetsGameShell.model.IExternalCommands;
	import com.neopets.util.button.*;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.sound.SoundManagerOld;
	import com.neopets.util.text.TextObject;
	import com.neopets.util.tranistion.TransitionObject;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	
	
	/**
	 *	This is the Basic AddBanner Class
	 * 	
	 * 	
	 * 	###### NOTE ######
	 * 	This Class Handles all the Transitions and Sound Loading Functions
	 * 	the ExternalCommands Class.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick
	 *	@since  01.21.2008
	 */
	 
	public class TriviaEngine extends TriviaEngineSupport
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const TRANSITION_TOP_CENTER:String = "TopToCenter";
		public const TRANSITION_BOT_CENTER:String = "BottomToCenter";
		public const TRANSITION_RIGHT_CENTER:String = "RightToCenter";
		public const TRANSITION_LEFT_CENTER:String = "LeftToCenter";
		public const TRANSITION_FADE:String = "XFadeStage";
		
		public const EFFECT_FADEUP:String = "FadeUponStage";
		public const EFFECT_FADEDOWN:String = "FadeUponStage";
		
		public const STARTING_SCENE:String = "BACKGROUND";
		public const DISPLAY_SCENE:String = "INTERFACE";
		public const DISPLAY_LOADINGBAR:String = "LOADERBAR";
		
		
		public const READY:String = "ShellisReady";
		public const TRANSITION_COMPLETE = "SceneTransitionIsDone";
		
		public static const UPDATE_PRELOADER:String = "UpdateThePreloaderTextField";
		public static const CMD_ACTIVATE:String = "ActivateAndJumpToAScene";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mScenesToLoad:int;
		protected var mRunningSceneCount:int;
	
		protected var mButtonLock:Boolean;
		protected var mCurrentScene:NeopetsScene;
		protected var mSoundManager:SoundManagerOld;
		
		protected var mSceneArray:Array;
		protected var mExternalCommand:IExternalCommands;
		protected var mTranslationDictionary:Dictionary;
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TriviaEngine():void
		{
			mID = "NeoPets_AddBanner";
			setupVars();
			super();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get soundManager():SoundManagerOld
		{
			return mSoundManager;
		}
		
		public function get buttonLock():Boolean
		{
			return mButtonLock;
		}
		
		public function set buttonLock(pFlag:Boolean):void
		{
			mButtonLock = pFlag;
		}
		
		public function set externalCommand(pExternalCmd:IExternalCommands):void
		{
			mExternalCommand = pExternalCmd;
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
		 }
		
		 /**
		 * @Note: This is for the Child to Have for Commands needed. This Should be OVERRIDED
		 */
		 
		  protected function initChild():void {}
		  
		 

		 //--------------------------------------
		//  PUBLIC INSTANCE METHODS
		//--------------------------------------
		/**
		 * This Effects One Scene
		 * 	@param		pActiveScene		NeopetsScene				The Scene you want the Effect On
		 * 	@param		pEffect				String			(null)		The Type of Translation for a Scene			
		 */
		 
		public function sceneEffect(pActiveScene:NeopetsScene,pEffect:String = null):void
		{
			if (pEffect == null)
			{
				pActiveScene.displayFlag = false;
				
				
				if (pActiveScene.backgroundSound) 
				{
					pActiveScene.sceneSoundManager.stopSound(pActiveScene.backgroundSound);	
				}
				
			}
			else
			{
				pActiveScene.displayFlag = true;
				pActiveScene.lockButtons = true;
				var newViewC:ViewContainer = pActiveScene.viewContainer;
				
				switch (pEffect)
				{
					case EFFECT_FADEUP:
						TransitionObject.startTransition(TransitionObject.FADE_UP,
							{
								ITEM:newViewC,TIME:3,FUNCTION:transitionComplete,PARAMTERS:[pActiveScene]
							}
						);
					break;
					case EFFECT_FADEDOWN:
						TransitionObject.startTransition(TransitionObject.FADE_DOWN,
							{
								ITEM:newViewC,TIME:3,FUNCTION:transitionComplete,PARAMTERS:[pActiveScene]
							}
						);
					break;
				}
			}
		}
		
		/**
		 * This Jumps Betweens Scences
		 * 	@param		pNewScene			NeopetsScene
		 * 	@param		pCurrentScene		NeopetsScene	
		 * 	@param		pTransition			String			(null)		The Type of Translation for a Scene			
		 * 	@param		c				Number			(null)		The Time for the Transition			
		 * */
		 
		public function sceneTransition(pNewScene:NeopetsScene,pCurrentScene:NeopetsScene = null,pTransition:String = null,pTime:Number = 2):void
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
					pCurrentScene.sceneSoundManager.fadeOutSound(pCurrentScene.backgroundSound,pTime);	
				}
				
				switch (pTransition)
				{
					case TRANSITION_FADE:
						TransitionObject.startTransition
						(
							TransitionObject.XFADE,
							{
								ITEM:newViewC,TIME:pTime,FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							{
								ITEM:oldViewC,TIME:1
							}
						);
					break;
					case TRANSITION_TOP_CENTER:
						TransitionObject.startTransition
						(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:pTime,STARTLOC:new Point(0,(newViewC.y - newViewC.height)),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(0,mRootMC.stage.stageHeight + 100)
							}
							
						);
					break;
					case TRANSITION_BOT_CENTER:
						TransitionObject.startTransition
						(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:pTime,STARTLOC:new Point(0,mRootMC.stage.stageHeight + 100),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(0,-(mRootMC.stage.stageHeight))
							}
							
						);
					break;
					case TRANSITION_RIGHT_CENTER:
						TransitionObject.startTransition
						(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:pTime,STARTLOC:new Point((newViewC.x - newViewC.width),0),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point((oldViewC.x + mRootMC.stage.stageWidth + 100),0)
							}
							
						);
					break;
					case TRANSITION_LEFT_CENTER:
						TransitionObject.startTransition
						(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:pTime,STARTLOC:new Point((newViewC.x + newViewC.width),0),ENDLOC:new Point(0,0),
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
		 	
		 	var tCount:int = mSceneArray.length;
			
			for (var t:int = 0; t < tCount; t++)
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
			
			var tCount:int = tWorkArray.length;
			
			for (var t:int = 0; t < tCount; t++)
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
			mScenesToLoad = 0;
			mRunningSceneCount = 0;
			mViewContainer = new ViewContainer(ID + "_VC");
			mButtonLock = false;
			mSoundManager = new SoundManagerOld(null,"SM_" + ID);
			mSceneArray = [];
		}
		
		
		
		
		/**
		 * @Note: This will look through the Config File looking for fonts and getting them
		 * out of the Application Domain and Register them
		 */
		 
		 private function setupFonts():void
		 {
		 	var tFontList:XMLList = mConfigXML.SETUP.INTERFACE..*.(hasOwnProperty("font"));
			var tAddedFontArray:Array = [];
			
		 	for each (var data:XML in tFontList)
		 	{
		 		var tFontName:String = data.font.toString();
		 		if (!tAddedFontArray[tFontName])
		 		{
		 			if (ApplicationDomain.currentDomain.hasDefinition(tFontName))
		 			{
		 				var tFontClass:Class = ApplicationDomain.currentDomain.getDefinition(tFontName) as Class;
		 				Font.registerFont(tFontClass);	
		 				tAddedFontArray[tFontName] = tFontClass;	
		 			}
		 			else
		 			{
		 				trace( tFontName + " is not in the Application Domain");
		 			}
		 			
		 		}
		 		
		 	}
		 	
			var tFontArray:Array = Font.enumerateFonts(false);	
		 }
		 
		 
		 
		 
		/**
		 * @Note: This is used to setup the Sound Files. These files are set in the config.xml.
		 * @Note: The SoundFiles are assumed to be embeded in the Library of the soundObj Class
		 */
		 
		private function setupSounds():void
		{
			var tWaitForSounds:Boolean = false;
			
			if (mConfigXML.SETUP.hasOwnProperty("SOUNDS"))
			{
				for each (var sndXML:XML in mConfigXML.SETUP.SOUNDS.*)
				{
					if (sndXML.hasOwnProperty("url"))
					{
						mSoundManager.addEventListener(mSoundManager.SOUNDMANAGER_ALLLOADED, continueSetup);
						mSoundManager.loadSound(sndXML.id,sndXML.type,0,sndXML.url);
						tWaitForSounds = true;		
					}
					else
					{
						mSoundManager.loadSound(sndXML.id,sndXML.type);	
					}				
				}
				
				if (!tWaitForSounds)
				{
					continueSetup();	
				}
			}
			else
			{
				continueSetup();
			}
		}
		
		/**
		 * @Note: After the Sounds are Ready, continue the setup
		 */
		 
		  protected function continueSetup(evt:Event = null):void
		  {
		  	mSoundManager.removeEventListener(mSoundManager.SOUNDMANAGER_ALLLOADED, continueSetup);
		  	setupFonts();
		 	setupDisplayElements(STARTING_SCENE);
		  }
		  
		/**
		 * This is used to setup the display Elements in the Scenes
		 */
		 
		protected function setupDisplayElements(pSceneName:String):void
		{
			var tButtonArray:Array = [];
			var tApplicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			
			mScenesToLoad = mConfigXML.SETUP.INTERFACE.SCENES.SCENE.length();
			
			mSceneArray = [];
			
			for each (var sceneXML:XML in mConfigXML.SETUP.INTERFACE.SCENES.*)
			{
				var tNeopetsScene:NeopetsScene = new NeopetsScene();
				tNeopetsScene.addEventListener(tNeopetsScene.SCENE_READY,onSceneReady,false,0,true);
				tNeopetsScene.addEventListener(tNeopetsScene.BUTTON_ACTION,onButtonAction,false,0,true);
				tNeopetsScene.addEventListener(tNeopetsScene.EXTERNAL_CMD,doExternalCommand,false,0,true);
				mSceneArray.push(tNeopetsScene);
				
				tNeopetsScene.init(sceneXML,tApplicationDomain,mSoundManager);
				mViewContainer.addUIViewContainer(tNeopetsScene.viewContainer,sceneXML.displayorder,tNeopetsScene.viewContainer.ID,new Point(tNeopetsScene.constructionXML.x,tNeopetsScene.constructionXML.y),tNeopetsScene.viewContainer.visible);
				
				
				if (tNeopetsScene.ID == STARTING_SCENE)
				{
					mCurrentScene = getNeopetsScene(STARTING_SCENE);
				}
			}

		}
		
		/**
		 * @Note: Sets the Interface to a "OFF" State
		 */
		 
		protected function deactivateInterface():void
		{
			mSoundManager.stopAllCurrentSounds();
			visible = false;	
		}
		
		/**
		 * @Note: Sets the Interface to a "ON" State
		 * @param		pActiveScene		String		The Scene that you want on Stage (active)
		 */
		 
		protected function activateInterface(pActiveScene:String):void
		{
			
			var tReturnedScene:NeopetsScene = getNeopetsScene(pActiveScene);
			var tNewScene:NeopetsScene = (tReturnedScene != null) ?  tReturnedScene:mSceneArray[0];

			if (mCurrentScene != tNewScene)
			{
				sceneTransition(tNewScene,mCurrentScene);
			}
			
			//mRootMC.visible = true;
			
			visible = true;
				
		}
		
		
		
		
	
		
		/**
		 * @NOTE: This is called after an SceneTransition is complete
		 * @param	OldDisplayObj 		NeopetsScene		The Old Scene
		 * @param	newDisplayObj 		NeopetsScene		The New Scene
		 * */
		 
		protected function transitionComplete(OldDisplayObj:NeopetsScene,newDisplayObj:NeopetsScene = null):void
		{
		
			OldDisplayObj.lockButtons = false;
			mButtonLock = false;
			
			if (newDisplayObj != null)
			{
				OldDisplayObj.displayFlag = false;
				OldDisplayObj.viewContainer.alpha = 1;
				OldDisplayObj.viewContainer.x = 0;
				OldDisplayObj.viewContainer.y = 0;
				newDisplayObj.lockButtons = false;
				
				if (newDisplayObj.backgroundSound) 
				{
					newDisplayObj.sceneSoundManager.soundPlay(newDisplayObj.backgroundSound,true);	
				}	
			}
			else
			{
				if (OldDisplayObj.viewContainer.alpha == 0)
				{
					OldDisplayObj.displayFlag = false;
					OldDisplayObj.viewContainer.alpha = 1;	
				}	
			}
			
			dispatchEvent(new Event(TRANSITION_COMPLETE));
			
		}
		
		 /**
		 * @Note: This goes through all the Objects and Translates the Text
		 */
		 
		protected function translateObjects():void
		{
			
			if (GeneralFunctions.convertBoolean(mConfigXML.SETUP.SETUP_INFO.translation))
			{
				setDictionary();
				mTranslateItems.addEventListener(Event.COMPLETE,finishedTranslation,false,0,true);
				mTranslateItems.externalURLforTranslation = mConfigXML.SETUP.SETUP_INFO.translationURL;
				mTranslateItems.init(mConfigXML.SETUP.SETUP_INFO.game_lang.toString(),mConfigXML.SETUP.SETUP_INFO.game_id.toString(),mTranslationDictionary,mConfigXML.SETUP.SETUP_INFO.application_id.toString());
			}
			else
			{
				completedSetup();	
			}
			
		}
		
		/**
		 * @NOTE: This will setup the pairs of TextFlds with the Translation 
		 * information needed to translate at the start of the Game. You can always translate items
		 * later with the mTranslateItems.translateOneItem() function.
		 * 
		 * You can always OVERRIDE this function to add more Translations.
		 * 
		 * NOTE: That the TranslationObject wants the following format:
		 * TranslationObject(a_resName:String, a_fontName:String, a_TF:TextField)
		 * 		@param		a_resName		String		The resname in the Neopets returned XML
		 * 		@param		a_fontName		String		The Name of the Font you want the TextField Mapped to.
		 * 												This Font Should be in your FLA Library with Export 
		 * 												for ActionScript and the Same name as in a_fontName.
		 *		@param		a_TF			TextField	The TextField That you want to be Translated 	
		*/
		 
		protected function setDictionary():void
		{
			
			var tDictionary:Dictionary = new Dictionary(true);
			
			
			//PULL ITEMS FROM THE SCENES
			
			var tCount:int = mSceneArray.length;
			
			for (var t:int = 0; t < tCount; t++)
			{
				var tScene:NeopetsScene = 	mSceneArray[t];
				
				for each (var tButton:NeopetsButton in tScene.buttonArray)
				{
					if (tButton.translationObject != null)
					{
						tDictionary[tButton.translationObject.resourceName] = tButton.translationObject;
						
					}
				}
				
				for each (var tTextObj:TextObject in tScene.textObjectsArray)
				{
					if (tTextObj.translationObject != null)
					{
						tDictionary[tTextObj.translationObject.resourceName] = tTextObj.translationObject;	
					}
				}	
			}
			
			
			//Example of what it would look like if you wanted to manuelly set a translation Object
			/*
			// TEXT FIELDS
			tDictionary[TranslationList.Title_Instructions] = new TranslationObject("Title_Instructions", ALGERIAN, mInterface.Title_Instructions);
			tDictionary[TranslationList.Title_Results] = new TranslationObject("Title_Results", ALGERIAN, mInterface.Title_Score);
			*/
	
			mTranslationDictionary = tDictionary;	
		}
		
		/** 
		 * @Note: When the project is ready to be displayed
		 */
		 
		protected function completedSetup():void
		{
				
			mViewContainer.reOrderDisplayList();
			
			//mRootMC.addChild(mViewContainer);
			initChild();
			mGameShell_Events.dispatchEvent(new CustomEvent({CMD:mGameShell_Events.CMD_PRELOADER_DONE},mGameShell_Events.ACTION_SEND_CMD_SHELL));
		 	dispatchEvent(new CustomEvent({CMD:mGameShell_Events.CMD_PRELOADER_DONE},SEND_THROUGH_CMD));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @NOTE: This is after the translation is finished, can be OVERRIDED as needed.
		 */
		 
		 protected function finishedTranslation(evt:Event):void
		 {
			completedSetup();
		 }
		 
		/**
		 * @Note: As each scene is loaded and Ready this event occures
		 * @Param		evt.oData.ID		String 			The ID of the Loaded Scene
		 * @Param		evt.oData.SCENE		NeopetsScene 	The Scene
		 */
		 
		protected function onSceneReady(evt:CustomEvent):void
		{
			var tNeopetsScene:NeopetsScene = evt.oData.SCENE;
			
			mRunningSceneCount++;
			
			if (tNeopetsScene.displayFlag)
			{
				if (tNeopetsScene.backgroundSound != null)
				{
					tNeopetsScene.sceneSoundManager.soundPlay(tNeopetsScene.backgroundSound,true);	
				}
			}
			
			if (mScenesToLoad == mRunningSceneCount)
			{	
				translateObjects();
				
				//Need to Cycle the Scene's looking for Scene Effects
				for each (var Scene:NeopetsScene in mSceneArray)
				{
					 if (Scene.defaultSceneEffect != null)
					 {
					 	sceneEffect(Scene,Scene.defaultSceneEffect);	
					 }
				}
			}	
		}
		
		/**
		 * @Note:Checks for Functions to be called
		 * @param	pXMLList	XMLList		The Item to Check
		 * @param	pObject		Object	 	The Object to Have the Command executed on
		 */
		 
		 protected function checkForFunctions(pXMLList:XML,pObject:Object = null):Boolean
		 {
		 	if (pXMLList.hasOwnProperty("FUNCTIONS"))
		 	{
		 		for each (var tFunctionXML:XML in pXMLList.FUNCTIONS.*)
		 		{
		 			localCommand(tFunctionXML,pObject);	
		 		}
		 		return true;
		 	}
		 	else
		 	{
		 		return false;
		 	}
		 }
		
		/**
		 * @Note: Process internal Commands on Loaded Objects or Pass the Command to the External Cmd Class
		 * @param		tXML		XMLList	 	The Function Info from the Info about the Object
		 * @param		pObject		Object	 	The Object to Have the Command executed on
		*/
		 
		protected function localCommand(tXML:XML, pObject:Object = null):void
		{ 
			if (GeneralFunctions.convertBoolean(tXML.override.toString() ))
			{
				var tCmd:String = tXML.cmd.toString();
				var tParam:String;
				var tObject:Object;
				
				if (tXML.hasOwnProperty("params"))
				{
					tParam = tXML.params.toString();	
				}
				
				if (tXML.hasOwnProperty("targeted"))
				{
					if (GeneralFunctions.convertBoolean(tXML.targeted.toString()))
					{
						tObject = pObject;
					}	
				}
				
				doExternalCommand(null,tCmd,tParam,tObject);
			}
			else
			{
				var tObjectForFunctionCall:Object = pObject;
				
				if (tXML.hasOwnProperty("params"))
				{
					try 
					{
						tObjectForFunctionCall[tXML.cmd.toString()](tXML.params.toString());
					}
					catch (e:ArgumentError)
					{
   					 trace(e);
   					}
			
				}
				else
				{
					try 
					{
						tObjectForFunctionCall[tXML.cmd.toString()]();
					}
					catch (e:ArgumentError)
					{
   					 trace(e);
   					}	
				}
			}		
		}
		
		/**
		 * @Note:Commands that are to complex, so for now we must manuelly write a case state to Handle
		 * @Note: This Function can change from application to application.
		 * @param		pCmd		String		The Function as a String
		 * @param		pParam		String		The List of Params for the Function
		 * @param		pObject		Object		An Object to have the command act on
		 */
		
		protected function doExternalCommand(evt:CustomEvent = null,pCmd:String = null,pParam:String = null,pObject:Object = null):void
		{
			if (evt == null)
			{
				mExternalCommand.doExternalCommand(pCmd,pParam,pObject);
			}
			else
			{
				mExternalCommand.doExternalCommand(evt.oData.CMD,evt.oData.PARAM,evt.oData.OBJECT);	
			}
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
						if (GeneralFunctions.convertBoolean(functionXML.override))
						{
							doExternalCommand(null,functionXML.cmd,functionXML.params);
						}
						else
						{
							if (functionXML.hasOwnProperty("params"))
							{
								this[functionXML.cmd.toString()](functionXML.params.toString());
							}
							else
							{
								this[functionXML.cmd.toString()]();
							}
						}
					}
				}
			}
		} //End Function
		
		/**
		 * @Note: A Message has been sent to the Preloader
		 * @param	PassedObject.CMD		String		The Desired Command
		 * @param	PassedObject.PARAM		Object		The Desired Paramaters		
		 */
		 
		
		 protected override function returnedCmdPreloader(PassedObject:Object):void
		 {
		 	switch (PassedObject.CMD)
		 	{
		 		case UPDATE_PRELOADER:
		 			if (GeneralFunctions.convertBoolean(mConfigXML.SETUP.SETUP_INFO.useloadingbar))
		 			{
		 				var tInterfaceSc:NeopetsScene = getNeopetsScene(DISPLAY_LOADINGBAR);		
		 			}
		 			else
		 			{
		 				var tInterfaceSc:NeopetsScene = getNeopetsScene(DISPLAY_LOADINGBAR);
		 				var tStatusTextObj:TextObject = tInterfaceSc.getTextObject("txtProgress");
		 				tStatusTextObj.txt_Fld = PassedObject.AMOUNT;	
		 			}
		 			
		 			
		 			
		 		break;
		 		case mGameShell_Events.CMD_ALLLOADED:
		 			//CHANGE SCENES?
		 		break;
		 	}	
		 }
		
		
	}
	
}
