
/* AS3
	Copyright 2008
*/
package com.neopets.projects.mvc.view
{
	import com.neopets.util.button.INeopetButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.util.loading.LoadingEngineXML;
	import com.neopets.util.sound.SoundManagerOld;
	import com.neopets.util.text.TextObject;
	import com.neopets.util.xml.ObjectXMLParser;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	
	/**
	 *	This is for creation of an Scene
	 * 	A Scene is made up of the Following Elemenets
	 * 		^ A Background Image or SWF
	 * 		^ Buttons or Display Elements
	 * 		^ A ViewContainer to HoldDisplayElements
	 * 		^ Button Commands are not in a Scene, They are in the parent
	 * 		
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.14.2008
	 */
	 
	public class NeopetsScene extends EventDispatcher //implements INeopetsScene
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const BUTTON_ACTION:String = "ButtonhasBeenClicked";
		public const SCENE_READY:String = "SceneIsReady";
		public const EXTERNAL_CMD:String = "ProcessExternalCommand";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mViewContainer:ViewContainer;
		private var mID:String;
		private var mButtonArray:Array;
		private var mVisibility:Boolean;
		
		private var mApplicationDomain:ApplicationDomain;
		private var mLockButtons:Boolean;
		private var mLocalSoundManager:SoundManagerOld;
		private var mBackgroundSound:String;
		private var mConstructionXML:XML;
		
		private var mParentLoadingEngine:LoadingEngineXML;
		private var mDisplayObjectsArray:Array;
		private var mTextObjectsArray:Array;
		private var mBackgroundArray:Array;
		private var mTotalLoadCount:int;
		private var mCurrentLoadedCount:int;
		protected var mDefaultSceneEffect:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function NeopetsScene(target:IEventDispatcher=null)
		{
			setupVars();
			super(target);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get viewContainer():ViewContainer
		{
			return mViewContainer;
		}
		
		public function get ID():String
		{
			return mID;
		}
		
		public function get constructionXML():XML
		{
			return mConstructionXML;
		}
		
		public function get buttonArray():Array
		{
			return mButtonArray;
		}
		
		public function get displayFlag():Boolean
		{
			return mVisibility;
		}
		
		public function set displayFlag(pFlag:Boolean):void
		{
			mVisibility = pFlag;
			
			if (pFlag)
			{
				mViewContainer.visible = true;	
			} 
			else
			{
				mViewContainer.visible = false;	
			}

		}
		
		public function get backgroundArray():Array
		{
			return mBackgroundArray;
		}
		
		public function getButton(pName:String):INeopetButton
		{
			var tCount:int = mButtonArray.length;
			
			if (tCount >= 1)
			{
				for (var t:int = 0; t < tCount; t++)
				{
					if (mButtonArray[t].ID == pName)
					{
						return mButtonArray[t];
						break;
					}
				}
			}
			
			return null;
		}
		
		public function get lockButtons():Boolean
		{
			return mLockButtons;
		}
		
		public function set lockButtons(pFlag:Boolean):void
		{
			mLockButtons = pFlag;
			
			var tCount:int = mButtonArray.length;
			
			for (var t:int = 0; t < tCount; t++)
			{
				mButtonArray[t].lockOut = mLockButtons;	
			}
			
		}
		
		public function get backgroundSound():String
		{
			return mBackgroundSound;
		}
		
		public function get sceneSoundManager():SoundManagerOld
		{
			return mLocalSoundManager;
		}
		
		public function get localLoadingEngine():LoadingEngineXML
		{
			return mParentLoadingEngine;
		}
		
		public function get displayObjectsArray():Array
		{
			return mDisplayObjectsArray;
		}
		
		public function get textObjectsArray():Array
		{
			return mTextObjectsArray;
		}
		
		public function getTextObject(pID:String):TextObject
		{
			var tCount:int = mTextObjectsArray.length;
			for (var t:int = 0; t < tCount; t++)
			{
				if (pID == mTextObjectsArray[t].ID)
				{
					return mTextObjectsArray[t];
					break;
				}
			}
			return null;
		}
		
		public function getDisplayObject(pID:String):DisplayObject
		{
			var tReturnDisplayObj:DisplayObject;
			
			if (mDisplayObjectsArray.hasOwnProperty(pID))
			{
				tReturnDisplayObj = mDisplayObjectsArray[pID];
			}
			
			return tReturnDisplayObj;
		}
		
		public function get defaultSceneEffect():String
		{
		 return mDefaultSceneEffect;	
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function init(sceneXML:XML,pApplicationDomain:ApplicationDomain= null,pLocalSoundManager:SoundManagerOld = null,pLoadingEngine:LoadingEngineXML = null):void
		{
			
			mConstructionXML = sceneXML;
			mBackgroundSound = (mConstructionXML.hasOwnProperty("background_sound")) ? mConstructionXML.background_sound[0] : null;
			mID = mConstructionXML.id;
			mViewContainer = new ViewContainer(mID + "VC");
			mApplicationDomain = pApplicationDomain;
			mParentLoadingEngine = pLoadingEngine;
			displayFlag = GeneralFunctions.convertBoolean(mConstructionXML.visible);
			mLocalSoundManager = pLocalSoundManager;
			mDefaultSceneEffect = (sceneXML.hasOwnProperty("effect")) ? mConstructionXML.effect : null;
			setupDisplayElements();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Sends the Button Event to the Parent
		 */
		 
		private function onBroadcastEvent(evt:Event):void
		{
			if (!mLockButtons)
			{
				this.dispatchEvent(new CustomEvent({SCENE:this,BUTTON:evt.currentTarget},BUTTON_ACTION));
			}
		}
		
		/**
		 * @Note: When the Scene needed to Load an Item
		 * @param		evt.oData.LOADEDITEM		LoadedItem		The Item that was loaded
		 */
		 
		private function onObjectLoaded(evt:CustomEvent):void
		{	
			var tLoadedItem:LoadedItem = evt.oData.LOADEDITEM;
			var tDisplayObject:DisplayObject = tLoadedItem.objItem as DisplayObject;
			
			switch (tLoadedItem.objData.section)
			{
				case "DISOBJ":
					mDisplayObjectsArray[tLoadedItem.objID] = tDisplayObject;
				break;
				case "BACKGROUND":
					mBackgroundArray[tLoadedItem.objID] = tLoadedItem;
				break;
			}
			mCurrentLoadedCount++;
			
			mViewContainer.addDisplayObjectUI(tDisplayObject,tLoadedItem.objData.displayorder,tLoadedItem.objID,new Point(tLoadedItem.objData.x,tLoadedItem.objData.y));		
			
			checkForFunctions(tLoadedItem.objXML,tDisplayObject);
			
			mViewContainer.reOrderDisplayList();
			
			if (mCurrentLoadedCount == mTotalLoadCount)
			{
				dispatchEvent(new CustomEvent({ID:mID,SCENE:this},SCENE_READY));
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mVisibility = true;	
			mButtonArray = [];
			mLockButtons = false;
			mDisplayObjectsArray = [];
			mBackgroundArray = [];
			mTotalLoadCount = 0;
			mCurrentLoadedCount = 0;;
			mTextObjectsArray = [];
		
		}
		

		
		
		/**
		 * @note: This will setup all the Buttons used in a scene
		 */
		 
		private function setupDisplayElements():void
		{
			var tItemsToLoad:XMLList = mConstructionXML.*.*.(hasOwnProperty("url"));
			
			mTotalLoadCount = tItemsToLoad.length();
			
			if (mConstructionXML.hasOwnProperty("BACKGROUND"))
			{
				setupBackground();
			}
			
			setupDisplayObjects();
			
			if (mConstructionXML.hasOwnProperty("TEXTFIELDS"))
			{
				for each (var textXML:XML in mConstructionXML.TEXTFIELDS.*)
				{
					var tTextObject:TextObject = new TextObject();
					tTextObject.init(textXML);
					mTextObjectsArray.push(tTextObject);
					mViewContainer.addDisplayObjectUI(tTextObject,textXML.displayorder.toString(),tTextObject.ID,new Point(textXML.x,textXML.y),GeneralFunctions.convertBoolean(textXML.visible.toString()));	
				
					checkForFunctions(textXML,tTextObject);
				}
			}
			
			
			if (mConstructionXML.hasOwnProperty("BUTTONS"))
			{
				
				for each (var buttonXML:XML in mConstructionXML.BUTTONS.*)
				{
					mButtonArray.push(createBtn(buttonXML));		
				}
				
			}
			
			mViewContainer.reOrderDisplayList();
			
			/* There is no Files to Load */
			if (mTotalLoadCount == 0)
			{
				dispatchEvent(new CustomEvent({ID:mID,SCENE:this},SCENE_READY));
			}
			
		}
		
		/**
		 * @Note: For Setting up the DisplayObjects
		 */
		 
		private function setupDisplayObjects():void
		{
			if (mConstructionXML.hasOwnProperty("DISPLAYOBJECT")) 
			{
				var tLoadListXML:XML = <LIST></LIST>;
				var tLoadFlag:Boolean = false;
				
				for each (var displayObjXML:XML in mConstructionXML.DISPLAYOBJECT.*)
				{
					if (displayObjXML.hasOwnProperty("url"))
					{
						 tLoadListXML.appendChild(displayObjXML);
						 tLoadFlag = true; 
					}
					else
					{
						getDisplayObjects(displayObjXML);	
					}
				}
				
				if (tLoadFlag)
				{ 
					if (mParentLoadingEngine == null)
					{
						mParentLoadingEngine = new LoadingEngineXML();
						mParentLoadingEngine.addEventListener(mParentLoadingEngine.LOADING_OBJLOADED,onObjectLoaded,false,0,true);
						mParentLoadingEngine.init(tLoadListXML,"LE_Scene_" + mID);
					}
					else
					{
						mParentLoadingEngine.addEventListener(mParentLoadingEngine.LOADING_OBJLOADED,onObjectLoaded,false,0,true);
						mParentLoadingEngine.addListToLoad(tLoadListXML);
					}
				}
			}
		}
		
		/**
		 * @NOTE: This is for making a Instance of a DisplayObject from the Library
		 * @Param		pObjectXML		XML		The Object to be created
		 */
		 
		private function getDisplayObjects(pObjectXML:XML = null):void
		{
			
			if (mApplicationDomain.hasDefinition(pObjectXML.assetname))
			{
				var tDisplayItem:Class;
				
				tDisplayItem = mApplicationDomain.getDefinition(pObjectXML.assetname) as Class;
				
				var tDisplayObject:DisplayObject = new tDisplayItem();
				
				if (mParentLoadingEngine == null)
				{ 
					mParentLoadingEngine = new LoadingEngineXML();
				}
				
				var tData:Object = ObjectXMLParser.xmlToObject(pObjectXML.data[0]);
				//mDisplayObjectsArray.push(tDisplayObject);
				mDisplayObjectsArray[pObjectXML.id.toString()] = tDisplayObject;
				
				mViewContainer.addDisplayObjectUI(tDisplayObject,tData.displayorder,pObjectXML.id.toString(),new Point(tData.x,tData.y),GeneralFunctions.convertBoolean(tData.visible));	
				
				checkForFunctions(pObjectXML,tDisplayObject);
			}
			else
			{
				trace( pObjectXML.assetname + " is not in the Application Domain");
			}
		}
		
		/**
		 * @Note: For Setting up the Background Object
		 */
		 
		private function setupBackground():void
		{
			
			var tClassBackGround:Class;
			var tItemXML:XML = mConstructionXML.BACKGROUND.ITEM[0];
		
			if (mConstructionXML.BACKGROUND.ITEM.hasOwnProperty("url"))
			{
				var tLoadingData:XML = mConstructionXML.BACKGROUND[0];
				
				if (mParentLoadingEngine == null)
				{ 
					mParentLoadingEngine = new LoadingEngineXML();
					mParentLoadingEngine.addEventListener(mParentLoadingEngine.LOADING_OBJLOADED,onObjectLoaded,false,0,true);
					mParentLoadingEngine.init(tLoadingData,"LE_Scene_" + mID);
				}
				else
				{
					mParentLoadingEngine.addEventListener(mParentLoadingEngine.LOADING_OBJLOADED,onObjectLoaded,false,0,true);
					mParentLoadingEngine.addItemToLoad(tLoadingData);	
				}
					
			}
			else
			{
				if (mApplicationDomain.hasDefinition(tItemXML.assetname))
				{
					tClassBackGround = mApplicationDomain.getDefinition(tItemXML.assetname) as Class;
					var tDisplayObj:DisplayObject = new tClassBackGround();
					
					if (mParentLoadingEngine == null)
					{ 
						mParentLoadingEngine = new LoadingEngineXML();
					}
					var tData:Object = ObjectXMLParser.xmlToObject(tItemXML.data[0]);
	
					mBackgroundArray[tItemXML.id.toString()] = tDisplayObj;
					mViewContainer.addDisplayObjectUI(tDisplayObj,tData.displayorder,tItemXML.id.toString(),new Point(tData.x,tData.y),GeneralFunctions.convertBoolean(tData.visible));	
				
					checkForFunctions(tItemXML,tDisplayObj);
				
				}
				else
				{
					trace( mConstructionXML.BACKGROUND.ITEM.assetname + " is not in the Application Domain");
				}
			}
				
				
		}
		
		
		/**
		 * @Note: Creates the Buttons
		 * @param		tButtonElement		XML		The Button Setup Info	
		*/
		 
		private function createBtn(tButtonElement:XML):INeopetButton 
		{ 
			if (mApplicationDomain.hasDefinition(tButtonElement.type))
			{
				var tClassButton:Class = mApplicationDomain.getDefinition(tButtonElement.type) as Class;
				var tNewBtn:NeopetsButton = new tClassButton() as NeopetsButton;
				var tSManager:SoundManagerOld = tButtonElement.hasOwnProperty("SOUNDS") ? mLocalSoundManager:null;
				
				tNewBtn.init(tButtonElement,tButtonElement.id,tSManager);
			
				mViewContainer.addDisplayObjectUI(tNewBtn,Number(tButtonElement.displayorder),tButtonElement.id,new Point(tButtonElement.x,tButtonElement.y),GeneralFunctions.convertBoolean(tButtonElement.visible.toString()));
				tNewBtn.addEventListener(MouseEvent.MOUSE_DOWN,onBroadcastEvent,false,0,true);
				return tNewBtn;
			}
			else
			{
				trace ("Button ",tButtonElement.id.toString(), " is not in the Library");
				return null;
			}
		}
		
		/**
		 * @Note:Checks for Functions to be called
		 * @param	pXMLList	XMLList		The Item to Check
		 * @param	pObject		Object	 	The Object to Have the Command executed on
		 */
		 
		 protected function checkForFunctions(pXMLList:XML,pObject:Object = null):void
		 {
		 	if (pXMLList.hasOwnProperty("FUNCTIONS"))
		 	{
		 		for each (var tFunctionXML:XML in pXMLList.FUNCTIONS.*)
		 		{
		 			localCommand(tFunctionXML,pObject);	
		 		}
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
				var tInfoObj:Object = {CMD:tXML.cmd.toString()};
				
				if (tXML.hasOwnProperty("params"))
				{
					tInfoObj["PARAMS"] = tXML.params.toString();	
				}
				
				if (tXML.hasOwnProperty("targeted"))
				{
					if (GeneralFunctions.convertBoolean(tXML.targeted.toString()))
					{
						tInfoObj["OBJECT"] = pObject;
					}	
				}
				
				this.dispatchEvent(new CustomEvent(tInfoObj,this.EXTERNAL_CMD));	
			}
			else
			{
				var tObjectForFunctionCall:Object = this;
				
				if (tXML.hasOwnProperty("targeted"))
				{
					if (GeneralFunctions.convertBoolean(tXML.targeted.toString()))
					{
						tObjectForFunctionCall = pObject;
					}	
				}
				
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
	}
	
}
