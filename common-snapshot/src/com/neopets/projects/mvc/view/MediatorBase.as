/* AS3
	Copyright 2008
*/

package com.neopets.projects.mvc.view
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadingEngineXML;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.MovieClipLoaderAsset;
	
	
	/**
	 *	This is a Mediator Basic Class for the Site
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.08.2008
	 */
	
	 
	public class MediatorBase extends EventDispatcher implements IMediator
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const MEDIATOR_READY:String = "MediatorReady";
		public const VIEWSTATE_CHANGE:String = "onViewStateChange";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var mSharedListener:SharedListener;
		protected var mViewContainer:ViewContainerold;
		protected var mSetupInfo:Object;
		protected var mSiteLogic:iLogic;
		protected var mMediatorLoadingEngine:LoadingEngineXML;
		protected var mActiveViewFlag:Boolean = true;
		protected var mID:String;
		protected var mDataXML:XML;
		protected var mSetupDataInfo:Object;
		
		protected var mXMLLoadList:XML;
		protected var mViewContainersLayer:uint;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MediatorBase()
		{
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get viewContainer():ViewContainerold
		{
			return mViewContainer;
		}
		 
		public function get ID():String
		{
			return mID;
		}
		
		public function get ActiveViewFlag():Boolean
		{
			return mActiveViewFlag;
		}
		
		public function set ActiveViewFlag(pSwitch:Boolean):void
		{
			mActiveViewFlag = pSwitch;
			onDisplayViewChange();
		}
		
		public function get viewContainersLayer():uint
		{
			return mViewContainersLayer;
		}
		
		public function set viewContainersLayer(pDefaultLayer:uint):void
		{
			mViewContainersLayer = pDefaultLayer;
		}
		
		public function get setupInfo():Object
		{
			return mSetupInfo;
		}
		
		public function get mediatorLoadListXML():XML
		{
			return mXMLLoadList;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @NOTE: This is the basic init for a Mediator
		 * @param		pSharedListener		ISharedListener		The Project Shared Listener
		 * @param		pInfoObject			Object				The Proxy Info that will be used for this Mediator
		 * @param		pSiteLogic			ILogic				The Link to the Project Logic (Facade)
		 * @param		pDefaultLayer		uint				The Mediator View Container will default be at this layer for the overall project
		 * @param		pLoadingSection		String				For the Loading XML, If will strip only items that have this attribute
		 * @param		pID					String				The ID of the Mediator
		 * @param		pInfoDataObject		Object				IF needed, the Data to call a Mediator for more required info
		 */
		 
		public function init(pSharedListener:ISharedListener,pInfoObject:Object,pSiteLogic:iLogic,pDefaultLayer:uint = 0,pLoadingSection:String = null,pID:String = "Mediator",pInfoDataObject:Object = null):void
		{
			
			mID = pID;
			mSharedListener = pSharedListener as SharedListener;
			mSiteLogic = pSiteLogic;
			mViewContainersLayer = pDefaultLayer;
			mSetupInfo = pInfoObject;
			pInfoObject = null;
			mSetupInfo.ID = mID;
			mSetupInfo.LEngineID = "LE_" + mID; 
			mSetupInfo.LEFLAG = true;
			mSetupInfo.SECTION = pLoadingSection;
			if (pInfoDataObject != null) 
			{
				mSetupDataInfo = pInfoDataObject;
				mSetupDataInfo.ID = mID;
				mSetupDataInfo.LEFLAG = false;
			}
			else
			{
				mSetupDataInfo = null;
			}

			mSharedListener.addEventListener(mSharedListener.PROXY_SENDOBJ,onIncommingData,false,0,true);
			mSharedListener.addEventListener(mSharedListener.CONTROLLER_SENDOBJ,onIncommingObject,false,0,true);
			
			setUpViewContainers();
			localInit();
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * All the DataRequest Come Back Here
		 * 	@param		evt.oData.ID		String		Object IDs requesting the DataObject (This Class)
		 *  @param		evt.oData.XML		XML			TThe XML List needed
		 *  @param		evt.oData.ITEM		String		The Object Being Requested (What was requested)
		 *  @param		evt.oData.LEFLAG	Boolean		True if an LoadingXML for a LoadingEngine
		 */
		 
		protected function onIncommingData (evt:CustomEvent):void
		{
			if (mID == evt.oData.ID) 
		 	{
		 		switch (evt.oData.ITEM)
		 		{
		 			case mSetupInfo.ITEM:
		 				if (mSetupInfo.SECTION != null || mSetupInfo.SECTION != undefined)
		 				{
		 					consolidateLoadingXML(evt);	
		 				}
		 				else
		 				{
		 					mSiteLogic.projectController.activateCMD("LoadThisViewItems",{XML:evt.oData.XML,NAME:mSetupInfo.LEngineID});	
		 					if (mSetupDataInfo) 
		 					{
								mSharedListener.dispatchEvent(new CustomEvent(mSetupDataInfo,mSharedListener.PROXY_GETOBJ));	
							}
		 				}
		 				
		 				
		 				
		 				
					break;
					case mSetupDataInfo.ITEM:
						mDataXML = XML(evt.oData.XML);
						onDataReady();	
					break;
		 		}
		 	
		 	}
		}
		
		
		/**
		 * All the Objects that are Requested Come Back Here
		 *  @param		evt.oData.LENGINE	LoadingEngineXML	The LoadingEngine with all the LoadingItems
		 *  @param		evt.oData.ITEM		String				The Object Being Requested (What was requested)
		 */
		 
		protected function onIncommingObject (evt:CustomEvent):void
		{
			if (evt.oData.ITEM == mSetupInfo.LEngineID) 
			{
				mMediatorLoadingEngine = evt.oData.LENGINE;
				loadViewContainer();
				evt.stopImmediatePropagation();
				
			}
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		/**
		 * @Note: This is for stripping out only the needed info for a section to make a loadList
		 * 	@param		evt.oData.ID		String		Object IDs requesting the DataObject (This Class)
		 *  @param		evt.oData.XML		XML			TThe XML List needed
		 *  @param		evt.oData.ITEM		String		The Object Being Requested (What was requested)
		 *  @param		evt.oData.LEFLAG	Boolean		True if an LoadingXML for a LoadingEngine
		 */
		 
		 protected function consolidateLoadingXML(evt:CustomEvent):void
		 {
		 	var tXMLtoSend:XMLList = new XMLList();
		 	var tFullXML:XML = evt.oData.XML;
		 	
		 	//Generates an XMLLIST of just the LoadList Nodes
		 	var tFullXML_LoadList:XMLList = tFullXML.LOADLIST.*; 
		 	
		 	tXMLtoSend = tFullXML_LoadList.(@ID == mSetupInfo.SECTION);
		 	
		 	//Convert the XMLLIST to a XML File
		 	var tXMLString:String = tXMLtoSend.toXMLString();
			
			tXMLString = "<LOADLIST>"+tXMLString+"</LOADLIST>";

			mXMLLoadList = new XML(tXMLString);
		 	
		 	//Request a XMLLoadingEngine to get the Files and Load them
		 	mSiteLogic.projectController.activateCMD("LoadThisViewItems",{XML:mXMLLoadList,NAME:mSetupInfo.LEngineID});	
		 	
		 	//If there is Data Needed for the Mediator, Request it
		 	if (mSetupDataInfo != null) 
		 	{
				mSharedListener.dispatchEvent(new CustomEvent(mSetupDataInfo,mSharedListener.PROXY_GETOBJ));	
			}
		 		
		 }
		 
		 
		/**
		 * @Note: This Asks for the Data Needed to create a Loading Engine
		 * 
		 */
		 
		protected function setUpViewContainers():void
		{
			mViewContainer = new ViewContainerold(mID +"VC");
			mSharedListener.dispatchEvent(new CustomEvent(mSetupInfo,mSharedListener.PROXY_GETOBJ));
		}
		
		protected function setupVars():void
		{
			mSetupInfo = {};
			mXMLLoadList = new XML();
		}
		
		/**
		 * @Note: Once the LoadingEngine has been returned then go through it and Have the setupDisplayItem run for each item
		 */
		  
		protected function loadViewContainer():void
		{
			var tLoadList:Array = mMediatorLoadingEngine.loadedItems;
			
			var tCount:uint = tLoadList.length;
			
			for (var t:uint = 0; t < tCount; t++)
			{
				setupDisplayItem(tLoadList[t]);	
			}
			
			mViewContainer.reOrderDisplayList();
			
			loadingComplete();
			
			
		}
		
		/** 
		 * This goes through each LoadedItem Object that the Loading Engine Returns
		 */
		 
		protected function setupDisplayItem(pLoadingItem:LoadedItem):void
		{
		}
		
		protected function localInit():void
		{	
		}
		
		protected function onDataReady():void
		{
			
		}
		
		protected function onResetView():void
		{
			
		}
		
		protected function loadingComplete():void
		{
			
		}
		
		protected function onDisplayViewChange():void
		{
		
					if (mActiveViewFlag)
					{
						mViewContainer.visible = true;
						onResetView();
					} 
					else
					{
						mViewContainer.visible = false;	
					}
		}
		
		/**
		 * @NOTE: This is for Creating Objects based on the Embeded SWFS
		 * Will Finish this with More Time
		 */
		 
		protected function setupEmbedObjects():void
		{
			
		}
		
		/**
		 * @NOTE: This is for Creating Objects based on the Embeded SWFS
		 * Will Finish this with More Time
		 */
		 
		protected function createObjects(evt:Event):void
		{
			
		}
	}
	
}
