
/* AS3
	Copyright 2008
*/

package com.neopets.util.loading
{

	import com.neopets.util.events.CustomEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *	This is for the Loading of External Assets from an XML
	 * 
	 * 	It can also Store Loaded Assets for retrieval later using mLoadedItems.
	 * 
	 * ### As of now this can NOT handle Loading Sound Files
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@Clive henrick 
	 *	@since  12.03.08
	 */
	 
	public class LoadingManager extends EventDispatcher implements ILoadingManager
	{

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mLoadList:Vector.<LoadingData>;
		protected var mLoadedItems:Array;
		protected var mAllLoaded:Boolean;
		

		protected var mNumberToLoad:uint;

		protected var mLoader:Loader;
		protected var mLoadedItem:LoadedItem;
		protected var mActiveLoading:Boolean;
	
		protected var mDefaultURL:String;
		protected var mLoadListinProcess:Boolean;
		protected var mLocalTesting:Boolean;
		protected var mCurrentLoadingData:LoadingData;
		
		private static const mInstance:ILoadingManager = new LoadingManager( SingletonEnforcer ); 
		
		protected var mLoadOneItemFlag:Boolean;

		protected var mAllLoadDataList:Vector.<LoadingData>;
		
		//--------------------------------------
		//  CONST
		//--------------------------------------
		
		//MOVING ALL OF THESE TO LoadingManagerConstants
		
		public const LOADING_COMPLETE:String = "loadingEngine_Complete";
		public const LOADING_OBJINT:String = "loadingEngine_ObjectINT";
		public const LOADING_OBJLOADED:String = "loadingEngine_ObjectLoaded";
		public const LOADING_CLEANED:String = "AllMemoryShouldBeFree";
		public const LOADING_PROGRESS:String = "loadingEngine_On_Progress";
		
		public static const USE_PARENT:String = "use_parent";
		public static const KEEP_SEPERATE:String = "seperate";
		public static const ADD_CHILD:String = "add_child";
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		**/
		
		
		public function LoadingManager(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use LoadingManager.instance." ); 
			}
			setVars();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():ILoadingManager
		{ 
			return mInstance;	
		} 
		
		public function get defaultURL():String 
		{
			return mDefaultURL;
		}
		
		public function set defaultURL(pDefaultURL:String):void
		{
			mDefaultURL = pDefaultURL;
		}
		
		public function get loadedItems():Array 
		{
			return Array(mLoadedItems);
		}
		
		public function get activeLoading():Boolean
		{
			return mActiveLoading;
		}
		
		public function get allLoaded():Boolean
		{
			return mAllLoaded;
		}
		
		
		public function get localTestingFlag():Boolean
		{
			return mLocalTesting;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Init the Loading Manager
		 * @Param		pDefaultURL		String			What goes before all the additional Items to be loaded IE: All items start with a "http://images50.neopets.com" for the URL Address
		 * @Param		pLocalTesting	String			Sets the loaderContext for the loading of files
		 * */
		
		public function init (pDefaultURL:String = "http://images50.neopets.com", pLocalTesting:Boolean = true):void
		{
			setVars();
			mLocalTesting = pLocalTesting;
			mDefaultURL = pDefaultURL;
			mLoadOneItemFlag = false;
		}
		
		/**
		 *  @Note: For Adding Item to a LoadingEngine.
		 * 	@Setup List				

		 * 	@param		pUrl						String			Required		Default PathWay from the Document Class to the File
		 * 	@param		pId							String			Required		What you want the Loaded to be called for reference
		 * 	@param		pApplicationdomain			String			Required		The Default ApplocationDomain For the Item
		 * 	@param		pData						Object			Optional		An Object that You can Pass infomation that you want Tied to the Loaded Object. 
		 * 	@param		pOverrideURL				String			Optional		Will Over ride the defaultURL used for loading an Object.															
		 * 	@param		pSendEvent					Boolean			Optional		Will send an event when it is loaded or initialised
		 
		 * * **/

		 
		 public function addItemToLoad(pUrl:String, pId:String, pApplicationdomain:String = "add_child", pData:Object = null, pOverrideURL:String = null, pSendEvent:Boolean = false):void
		 {
		 	var tLoadingObj:LoadingData = new LoadingData(pUrl, pId, pApplicationdomain, pData, pOverrideURL, pSendEvent);
			
			mLoadList.push(tLoadingObj);
			
			mAllLoadDataList.push(tLoadingObj);
			
		 }
		 
		 /**
		 * @note	Starts to load all items in the loadList
		 */
		 
		 public function startLoadingList():void
		 {
		 		mLoadListinProcess = true;
				mLoadOneItemFlag = false;
		 		mNumberToLoad = 	mLoadList.length;
		 		startLoadingObject(	LoadingData(mLoadList[0]));	
		 }
		 
		 /**
		 * @note	 Loads One Item Only from the LoadList
		 * @param	pID		String		The Id of the Item you want to Load		
		 */
		 
		 public function loadOneItem(pID:String):void
		 {
			 
		 	mNumberToLoad = mAllLoadDataList.length;
		 	var tLoadingData:LoadingData;
		
			for (var i:int = 0; i < mNumberToLoad; i++)
			{
				if (pID == LoadingData(mAllLoadDataList[i]).id)
				{
					tLoadingData = LoadingData(mAllLoadDataList[i]);
					mLoadOneItemFlag = true;
					mLoadListinProcess = true;
					startLoadingObject(tLoadingData);
					break;
				}
			} 	
			
			
		 	
		 }
		 
		 
		 
		 /**
		 * @Note	 Unloads all the Objects for Memory CleanUp and resets the LoadingManager
		 */

		 public function cleanUpAllMemory():void
		 {
		 	var tCount:int = mLoadedItems.length;
		 	
			if (tCount == 0)
			{
				for (var t:int = 0; t < tCount; t++)
				{
					var tLoadedItem:LoadedItem = mLoadedItems[t];
					tLoadedItem.clearLoadedItem();
					tLoadedItem = null;
				}
				
				mLoadedItem = null;
				mLoadedItems = [];
				mLoader = null;
				mAllLoadDataList = new Vector.<LoadingData>;
					
			}
			
			resetVars();
			dispatchEvent(new Event(LoadingManagerConstants.LOADING_CLEANED));	
		 }
	
		 /**
		  * @Note: Unloads named Loader Object for Memory CleanUp.
		  * @param		pObjectID		String		The ID of an Object to be removed from the Loading Manager
		  */
		 
		 public function deleteLoaderObj(pObjectID:String):void
		 {
			 try {
				 var tCount:uint = mLoadedItems.length;
				 for (var t:uint = 0; t < tCount; t++)
				 {
					 
					 if (LoadedItem(mLoadedItems[t]).objID == pObjectID) 
					 {
						 var tLoadedItem:LoadedItem = LoadedItem(mLoadedItems[t]);
						 tLoadedItem.clearLoadedItem();
						 tLoadedItem = null;
						 mLoadedItems.splice(t,1);
						 return;
						 
					 }
				 }
				 throw new Error("deleteLoaderObj Not Found "  + pObjectID);
			 } catch (e:ArgumentError) {
				 trace(e);
			 }	
		 }
		 
		 
		 
		 
		 /**
		  * Returning an Object that has been Loaded by its ID
		  * @param			pObjectName			String			Name of the Object you want returned
		  **/
		 public function getLoadedObj(pObjectID:String):* 
		 {
			 try {
				 var tCount:uint = mLoadedItems.length;
				 for (var t:uint = 0; t < tCount; t++) {
					 if (LoadedItem(mLoadedItems[t]).objID == pObjectID) {
						 return mLoadedItems[t].objItem;
						 break;
					 }
				 }
				 throw new Error("getLoadedObj Not Found "  + pObjectID);
				 
			 } catch (e:ArgumentError) {
				 trace(e);
				 return false;
			 }
		 }
		 
		 /**
		  *  * Returning an LoadingEngine Storage Object by ObjectName
		  * @param			pObjectName			String			Name of the Object you want returned
		  **/
		 public function getLoaderObj(pObjectID:String):* {
			var tCount:uint = mLoadedItems.length;
			
			try 
			{
				for (var t:uint = 0; t < tCount; t++) {
					 if (LoadedItem(mLoadedItems[t]).objID == pObjectID) {
						 return mLoadedItems[t] as LoadedItem;
						 break;
					 }
				 }
				throw new Error("getLoaderObj Not Found "  + pObjectID);
			
			 } catch (e:ArgumentError) {
				 trace(e);
				 return false;
			 }
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@setVars sets up the variables used in this class
		**/
		 
		protected function setVars():void {
			mLoadedItems = [];
			mLoadList = new Vector.<LoadingData>;
			mAllLoaded = false;
			mNumberToLoad = 0;
			mActiveLoading = false;
			mLoadListinProcess = false;
			mLocalTesting = true;
			mAllLoadDataList = new Vector.<LoadingData>;
			
		}
		
		/**
		 * @Note		Reset Values after everything is dumped from the Loading Manager during a Cleanup Function
		 */
		
		protected function resetVars():void
		{
			mLoadedItems = [];
			mLoadList = new Vector.<LoadingData>;
			mAllLoaded = false;
			mNumberToLoad = 0;
			mActiveLoading = false;
			mLoadListinProcess = false;	
			mLoadOneItemFlag = false;
		}
		
		/**
		 *	@startLoadingObject starts the Load Process.
		 * 	@All addEventListeners use Weak References.
		 **/
		 
		protected function startLoadingObject(pDataLoadingObj:LoadingData):void
		{
				mCurrentLoadingData = pDataLoadingObj;
				
				mActiveLoading = true;

				mLoader = new Loader();
				mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemLoaded,false,0,true);
				mLoader.contentLoaderInfo.addEventListener(Event.INIT, onItemInit,false,0,true);
				mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
				mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
				
				var loaderContext:LoaderContext = new LoaderContext();
				
	
				switch(pDataLoadingObj.applicationdomain)
				{
				case LoadingManager.USE_PARENT:
					// child SWF uses parent domain definitions
					// if defined there, otherwise its own
					loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				break;
				case LoadingManager.KEEP_SEPERATE:
					// child SWF domain is completely separate and
					// each SWF uses its own definitions
					loaderContext.applicationDomain = new ApplicationDomain();
				break;
				default: //"add_child"
					// child SWF adds its unique definitions to
					// parent SWF; both SWFs share the same domain
					// child SWFs definitions do not overwrite parents
					loaderContext.applicationDomain = ApplicationDomain.currentDomain;				
				break;
				}
				
				
				loaderContext.checkPolicyFile = true;
				
				mLoadedItem = new LoadedItem();
				mLoadedItem.init(null,pDataLoadingObj.id,pDataLoadingObj.id,null,pDataLoadingObj.data,null,mLoader,pDataLoadingObj);
				
				var itemPath:String;
				
				if (pDataLoadingObj.overrideURL != null)
				{
					itemPath = pDataLoadingObj.overrideURL + pDataLoadingObj.url;
				}
				else
				{
					itemPath = mDefaultURL + pDataLoadingObj.url;	
				}
				
				if (! mLocalTesting) //TESTING ON A SERVER
				{
					loaderContext.checkPolicyFile = true;
					loaderContext.securityDomain = SecurityDomain.currentDomain;		
				}
				
				var tURLRequest:URLRequest = new URLRequest(itemPath);
				
				mLoader.load(tURLRequest, loaderContext);	
			
			
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@onItemInit starts the Load Process.
		 * 	@ When Object is Initalised. Many Objects then Load there own assets. In this Example There is no init called
		 *  @ as these are in game assets and as such do not have document classes that require external loading.
		 *  @param			evt			Event		From Event.INIT		
		 **/

		protected function onItemInit(evt:Event):void {
			try {
				var tID:String = mCurrentLoadingData.id;
				
				var LoadedClassName:String = getQualifiedClassName(evt.target.content);
				var appDomain:ApplicationDomain = evt.target.content.loaderInfo.applicationDomain;
				var LoadedClass:Class = appDomain.getDefinition(LoadedClassName) as Class;
				var downloadedObj:* = LoadedClass(evt.target.content);
				
				mLoadedItem.objItem = downloadedObj;
				mLoadedItem.objClass = LoadedClass;
				mLoadedItem.state = "initalised";
				mLoadedItem.localApplicationDomain = appDomain;
				
				if (downloadedObj == null) {
					throw new Error("ErrorLoaded Object>" + tID + " is TypeCasted Wrong thus Not Loaded");
				}
				
				if (mCurrentLoadingData.sendEvent)
				{
					dispatchEvent(new CustomEvent({LOADEDITEM:mLoadedItem},LoadingManagerConstants.LOADING_OBJINT));	
				}
				
							
			} catch (e:ArgumentError) {
   					 trace(e);
			} 
		}
		
		/**
		 *	@onItemLoaded handles when a Item are loaded Complete
		 *  @param			evt			Event		From Event.COMPLETE	
		**/
		 
		protected function onItemLoaded(evt:Event):void 
		{
			trace ("onItemLoaded", evt)
			//mLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			try {
				var tName:String = mCurrentLoadingData.id;
				var tID:String = mCurrentLoadingData.id;
				var tData:Object = {};
				
				mLoadedItem.state = "ready";
				mLoadedItem.loaded = true;
				
				mLoadedItems.push(mLoadedItem);
			
				mActiveLoading = false;
				
	
				
				if (mCurrentLoadingData.sendEvent)
				{
					dispatchEvent(new CustomEvent({LOADEDITEM:mLoadedItem, ID:tID },LoadingManagerConstants.LOADING_OBJLOADED));
				}
				
				if (mLoadOneItemFlag == true)
				{
					mLoadOneItemFlag = false;
					
					var tCount:int = mLoadList.length;
					
					if (tCount != 0)
					{
						for (var z:int = 0; z < tCount; z++)
						{
							if (mLoadedItem.objID == LoadingData(mLoadList[z]).id)
							{
								mLoadList.splice(z,1);		
							}
						}	
					}

					if ( mLoadList.length == 0) 
					{	
						if (!mAllLoaded)
						{
							mAllLoaded = true;
							dispatchEvent(new Event(LoadingManagerConstants.LOADING_COMPLETE));
						}	
					}
					
				}
				else
				{
					//Remove the Item from the LoadList as it is Loaded Now
					mLoadList.shift();

					if ( mLoadList.length > 0) 
					{	
						startLoadingObject(LoadingData(mLoadList[0]));
					} 
					else
					{
						if (!mAllLoaded)
						{
							mAllLoaded = true;
							dispatchEvent(new Event(LoadingManagerConstants.LOADING_COMPLETE));
						}
					}
				
				}
				
			} catch (e:ArgumentError) {
   					 trace("LoadingEngine  ErrorLoadeding at:" + e);
			} 
		}
		
		/**
		 *	@onError handles when a Loader has an Error
		 *  @param			evt			Event		From Event.ERROR	
		**/
		
		protected function onError(error:IOErrorEvent):void {
			trace("Error on LoadingArray >" + error);
			var tAsset:String = mCurrentLoadingData.id;
			
			var tIndexStart:uint = tAsset.lastIndexOf(".");
			var tIndexEnd:uint =  tAsset.length;
			var tType:String = tAsset.substring(tIndexStart+1, tIndexEnd);
			
			mLoadedItem.state = "errorOnLoading";
			
		}
		
		
		/**
		 *	@onProgress handles whild a loder is loading, meant to be overridden
		 *  @param			evt			Event		From Event.ERROR	
		**/
		protected function onProgress(e:ProgressEvent):void 
		{
			//trace("LoadingManager, onProgress: bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
			dispatchEvent(new CustomEvent({TOTAL_ITEMS:mNumberToLoad, BYTES_LOADED:e.bytesLoaded, BYTES_TOTAL:e.bytesTotal},LoadingManagerConstants.LOADING_PROGRESS));
		}
	

	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}