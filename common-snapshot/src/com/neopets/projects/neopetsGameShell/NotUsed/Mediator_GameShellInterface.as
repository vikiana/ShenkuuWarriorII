/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.NotUsed
{
	import com.neopets.projects.mvc.view.LoadedItem;
	import com.neopets.projects.mvc.view.NeopetsScene;
	import com.neopets.projects.mvc.view.ViewContainerold;
	import com.neopets.projects.neopetsGameShell.support.NeopetsGameSupport;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManagerOld;
	import com.neopets.util.tranistion.TransitionObject;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 *	This is the Basic Interface for the NeoPets Game Container
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.21.2008
	 */
	 
	public class Mediator_GameShellInterface extends NeopetsGameSupport 
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
		public static const SCENE_GAME_ENDSCREEN:String = "GAME_ENDSCREEN";
		public static const SCENE_GAME_INSTRUCTION:String = "GAME_INSTRUCTION";
		public static const SCENE_GAME_TRAILER:String = "GAME_TRAILER";
		public static const SCENE_GAME_ABOUT:String = "GAME_ABOUT";
		
		public static const CMD_ACTIVATE:String = "ActivateAndJumpToAScene";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
			
		private var mSceneCount:uint;
		private var mRunningSceneCount:uint;
		private var mIntroScene:NeopetsScene;
		private var mEndScene:NeopetsScene;
		private var mHelpScene:NeopetsScene;
		private var mAboutScene:NeopetsScene;
		private var mTrailerScene:NeopetsScene;
		private var mScore:int;
		private var mLoadingObjectData:LoadedItem;
		
		private var mButtonLock:Boolean;
		private var mCurrentScene:NeopetsScene;
		private var mSM_Interface:SoundManagerOld;
		private var mViewContainer:ViewContainerold;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function Mediator_GameShellInterface():void
		{
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function get loadedObjectData():LoadedItem
		{
			return mLoadingObjectData;
		}
		
		public function set loadedObjectData(pObject:LoadedItem):void
		{
			mLoadingObjectData = pObject;
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
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{	
			mSceneCount = 5;
			mRunningSceneCount = 0;
			mIntroScene = new NeopetsScene();
			mEndScene = new NeopetsScene();
			mHelpScene = new NeopetsScene();
			mAboutScene = new NeopetsScene();
			mTrailerScene = new NeopetsScene();
			mViewContainer = new ViewContainerold("GameShellVC");
			mButtonLock = false;
			mSM_Interface = new SoundManagerOld(null,"SM_Interface");
			
		}
		
		/**
		 * @Note: This is used to setup the Sound Files. 
		 * @Note: The SoundFiles are assumed to be embeded in the Library of the soundObj Class
		 */
		 
		private function setupSounds():void
		{
			mSM_Interface.loadSound("ClickButton",mSM_Interface.TYPE_SND_INTERNAL);
			mSM_Interface.loadSound("GameStart",mSM_Interface.TYPE_SND_INTERNAL);
			mSM_Interface.loadSound("IntroMusic",mSM_Interface.TYPE_SND_INTERNAL);
			mSM_Interface.loadSound("buttonSnd",mSM_Interface.TYPE_SND_INTERNAL);
		}
		
		/**
		 * This is used to setup the display Elements in the Scenes
		 */
		 
		private function setupDisplayElements(pSceneName:String):void
		{
			var tButtonArray:Array = [];
			var tBackgroundMC:MovieClip;
			var tNextScene:String;
			
			switch (pSceneName)
			{
				case SCENE_GAME_INTRO:
					//Will go into the Library and get the Item
					tBackgroundMC = mLoadingObjectData.getObjectOutofLibrary("IntroBackGround") as MovieClip;
					
					tButtonArray = 
					[
					{TYPE:"mcButStartGame",ID:"startBtn",LOCATION:new Point(330,200),DISPLAYORDER:1,DISPLAY:true,TEXT:'Start Game'},
					{TYPE:"NavButton",ID:"helpBtn",LOCATION:new Point(330,250),DISPLAYORDER:2,DISPLAY:true,TEXT:'Instructions',SOUNDMANAGER:mSM_Interface,SOUNDINFO:{OVER:"buttonSnd"}}, /* EXAMPLE OF A BUTTON WITH A SOUND */
					{TYPE:"NavButton",ID:"aboutBtn",LOCATION:new Point(330,300),DISPLAYORDER:3,DISPLAY:true,TEXT:'About',SOUNDMANAGER:mSM_Interface,SOUNDINFO:{DOWN:"ClickButton"}}, /* EXAMPLE OF A BUTTON WITH A SOUND */
					{TYPE:"NavButton",ID:"trailerBtn",LOCATION:new Point(330,350),DISPLAYORDER:4,DISPLAY:true,TEXT:'Trailer'},
					{TYPE:"NavButton",ID:"webBtn",LOCATION:new Point(330,400),DISPLAYORDER:5,DISPLAY:true,TEXT:'View Website'}
					];
					
					mIntroScene.init("GAME_INTRO",tButtonArray,mLoadingObjectData,tBackgroundMC,true);
					mIntroScene.addEventListener(mIntroScene.BUTTON_ACTION,onButtonAction,false,0,true);
					mViewContainer.addUIViewContainer(mIntroScene.viewContainer,0,mIntroScene.viewContainer.ID,new Point(0,0),true);
					mRunningSceneCount++;
					tNextScene = "GAME_ENDSCREEN";
				break;
				case SCENE_GAME_ENDSCREEN:
					//Will go into the Library and get the Item
					tBackgroundMC = mLoadingObjectData.getObjectOutofLibrary("EndScreenBackground") as MovieClip;
					
					tButtonArray = 
					[
						{TYPE:"NavButton",ID:"sendScoreBtn",LOCATION:new Point(330,375),DISPLAYORDER:1,DISPLAY:true,TEXT:'Send Score'},
						{TYPE:"NavButton",ID:"returnBtn",LOCATION:new Point(330,425),DISPLAYORDER:2,DISPLAY:true,TEXT:'Back to Menu'}
					];	
					
					mEndScene.init("GAME_ENDSCREEN",tButtonArray,mLoadingObjectData,tBackgroundMC,false);
					mEndScene.addEventListener(mEndScene.BUTTON_ACTION,onButtonAction,false,0,true);
					mViewContainer.addUIViewContainer(mEndScene.viewContainer,1,mEndScene.viewContainer.ID,new Point(0,0),false);
					mRunningSceneCount++;
					tNextScene = "GAME_INSTRUCTION";
				break;
				case SCENE_GAME_INSTRUCTION:
					tBackgroundMC = null;
					
					tButtonArray = 
					[
						{TYPE:"NavButton",ID:"returnBtn",LOCATION:new Point(330,225),DISPLAYORDER:1,DISPLAY:true,TEXT:'Back to Menu'}	
					];
					mHelpScene.init("ENDSCREEN",tButtonArray,mLoadingObjectData,tBackgroundMC,true);
					mHelpScene.addEventListener(mHelpScene.BUTTON_ACTION,onButtonAction,false,0,true);
					mViewContainer.addUIViewContainer(mHelpScene.viewContainer,2,mHelpScene.viewContainer.ID,new Point(0,0),false);
					mRunningSceneCount++;
					tNextScene = "GAME_TRAILER";
				break;
				case SCENE_GAME_TRAILER:
					tBackgroundMC = null;
					
					tButtonArray = 
					[
						{TYPE:"NavButton",ID:"highBWBtn",LOCATION:new Point(200,155),DISPLAYORDER:1,DISPLAY:true,TEXT:'High Bandwidth'},
						{TYPE:"NavButton",ID:"lowBWBtn",LOCATION:new Point(200,200),DISPLAYORDER:1,DISPLAY:true,TEXT:'Low Bandwidth'},
						{TYPE:"NavButton",ID:"returnBtn",LOCATION:new Point(330,425),DISPLAYORDER:1,DISPLAY:true,TEXT:'Back to Menu'}	
					];
					mTrailerScene.init("GAME_TRAILER",tButtonArray,mLoadingObjectData,tBackgroundMC,false);
					mTrailerScene.addEventListener(mTrailerScene.BUTTON_ACTION,onButtonAction,false,0,true);
					mViewContainer.addUIViewContainer(mTrailerScene.viewContainer,3,mTrailerScene.viewContainer.ID,new Point(0,0),false);
					mRunningSceneCount++;
					tNextScene = "GAME_ABOUT";
				break;
				case SCENE_GAME_ABOUT:
					tBackgroundMC = null;
					
					tButtonArray = 
					[
						{TYPE:"NavButton",ID:"returnBtn",LOCATION:new Point(330,425),DISPLAYORDER:1,DISPLAY:true,TEXT:'Back to Menu'}	
					];
					mAboutScene.init("GAME_ABOUT",tButtonArray,mLoadingObjectData,tBackgroundMC,false);
					mAboutScene.addEventListener(mAboutScene.BUTTON_ACTION,onButtonAction,false,0,true);
					mViewContainer.addUIViewContainer(mAboutScene.viewContainer,4,mAboutScene.viewContainer.ID,new Point(0,0),false);
					mRunningSceneCount++;
					tNextScene = "";
				break;
				
			}

			mViewContainer.reOrderDisplayList();
			
			if (mSceneCount == mRunningSceneCount)
			{
				mCurrentScene = mIntroScene;
				translateObjects();
			}
			else
			{
				setupDisplayElements(tNextScene);
			}
		}
		
		/**
		 * @Note: Sets the Interface to a "OFF" State
		 */
		 
		private function deactivateInterface():void
		{
			mSM_Interface.stopAllCurrentSounds();
			visible = false;	
		}
		
		/**
		 * @Note: Sets the Interface to a "ON" State
		 */
		 
		private function activateInterface(pActiveScene:String = "GAME_INTRO"):void
		{
			var tNewScene:NeopetsScene;
			
			switch (pActiveScene)
			{
				case SCENE_GAME_INTRO:  tNewScene = mIntroScene;		break;
				case SCENE_GAME_ENDSCREEN: tNewScene = mEndScene; 		break;
				case SCENE_GAME_INSTRUCTION:  tNewScene = mHelpScene;	break;
				case SCENE_GAME_TRAILER: tNewScene = mTrailerScene; 	break;
				case SCENE_GAME_ABOUT: tNewScene = mAboutScene; 		break;
			}
			
			if (mCurrentScene != tNewScene)
			{
				sceneTransition(tNewScene,mCurrentScene);
			}
			
			visible = true;		
		}
		
		/**
		 * @Note: This goes through all the Objects and Translates the Text
		 */
		 
		private function translateObjects():void
		{
			// ADD THE SCRIPT TO TRANSLATE OBJECTS
			completedSetup();	
		}
		
		private function completedSetup():void
		{
			this.addChild(mViewContainer);
			this.dispatchEvent(new Event(this.READY));
		}
		
		/**
		 * This Jumps Betweens Scences
		 * 	@param		pNewScene			NeopetsScene
		 * 	@param		pCurrentScene		NeopetsScene	
		 * 	@param		pTransition			String			(null)		The Type of Translation for a Scene			
		 */
		 
		private function sceneTransition(pNewScene:NeopetsScene,pCurrentScene:NeopetsScene = null,pTransition:String = null):void
		{
			mButtonLock = false ? pTransition = null:true;
			mCurrentScene = pNewScene;
			
			if (pTransition == null)
			{
				pNewScene.displayFlag = true;
				pCurrentScene.displayFlag = false;
			}
			else
			{
				pNewScene.displayFlag = true;
				pNewScene.lockButtons = true;
				pCurrentScene.lockButtons = true;
				var newViewC:ViewContainerold = pNewScene.viewContainer;
				var oldViewC:ViewContainerold = pCurrentScene.viewContainer;
				 
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
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(0,stage.stageHeight + 100)
							}
							
							);
					break;
					case TRANSITION_BOT_CENTER:
						TransitionObject.startTransition(
							TransitionObject.MOVEMENT,
							{
								ITEM:newViewC,TIME:2,STARTLOC:new Point(0,stage.stageHeight + 100),ENDLOC:new Point(0,0),
								FUNCTION:transitionComplete,PARAMTERS:[pCurrentScene,pNewScene]
							},
							
							{
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(0,-(stage.stageHeight))
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
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point((oldViewC.x + stage.stageWidth + 100),0)
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
								ITEM:oldViewC,TIME:1,STARTLOC:new Point(0,0),ENDLOC:new Point(-(stage.stageWidth),0)
							}
							
							);
					break;
				}
				
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: This is for Button Actions from the Scenes.
		 * All the Commands are in one location, as the functions effect other scenes, or the Interface in general.
		 * 
		 * @param	evt.oData.BUTTON	String		The ID of the Button Sending the MOUSE.DOWN Event
		 * @param	evt.oData.SCENEID	String		The ID of the SCENE Sending the MOUSE.DOWN Event
		 */
		 
		
		private function onButtonAction(evt:CustomEvent):void
		{
			if (!mButtonLock)
			{
				
				switch(evt.oData.SCENEID)
				{
					case mIntroScene.ID:
						switch (evt.oData.BUTTON)
						{
							case "startBtn":
								deactivateInterface();
								mGameShell_Events.dispatchEvent(new CustomEvent({CMD:"START",PARAM:{}},mGameShell_Events.ACTION_SEND_CMD_GAME));
							break;
							case "helpBtn":
								mSM_Interface.soundPlay("GameStart");	/*EXAMPLE TO PLAY A SOUND FILE WHEN NOT IN A BUTTON */
								sceneTransition(mHelpScene,mIntroScene,TRANSITION_FADE);
							break;
							case "aboutBtn":
								sceneTransition(mAboutScene,mIntroScene,TRANSITION_TOP_CENTER);
							break;
							case "trailerBtn":
								sceneTransition(mTrailerScene,mIntroScene,TRANSITION_RIGHT_CENTER);
							break;
							case "webBtn":
							
							break;
						}	
					break;
					case mEndScene.ID:
						switch (evt.oData.BUTTON)
						{
							case "sendScoreBtn":
							
							break;
							case "returnBtn":
							
							break;
						}	
					break;
					case mHelpScene.ID:
						switch (evt.oData.BUTTON)
						{
							case "returnBtn":
								sceneTransition(mIntroScene,mHelpScene,TRANSITION_FADE);
							break;
						}	
					break;
					case mAboutScene.ID:
						switch (evt.oData.BUTTON)
						{
							case "returnBtn":
								sceneTransition(mIntroScene,mAboutScene,TRANSITION_BOT_CENTER);
							break;
						}	
					break;
					case mTrailerScene.ID:
						switch (evt.oData.BUTTON)
						{
							case "highBWBtn":
							
							break;
							case "lowBWBtn":
							
							break;
							case "returnBtn":
								sceneTransition(mIntroScene,mTrailerScene,TRANSITION_LEFT_CENTER);
							break;
						}	
					break;		
					
				}
			}
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
		}
	
	}
	
}
