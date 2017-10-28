/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine
{
	import com.neopets.projects.comicEngine.gui.StoryBookLogo;
	import com.neopets.projects.comicEngine.gui.StoryBookLogoSymbol;
	import com.neopets.projects.comicEngine.objects.StoryBookCallObject;
	import com.neopets.projects.comicEngine.objects.StoryBookChapterObject;
	import com.neopets.projects.comicEngine.objects.StoryBookClickObject;
	import com.neopets.projects.comicEngine.objects.StoryBookData;
	import com.neopets.projects.comicEngine.objects.StoryBookPanelObject;
	import com.neopets.projects.comicEngine.translation.StoryBookTranslation;
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarsFinder;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.util.loading.LoadingManager;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.system.ApplicationDomain;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	
	/**
	 *	
	 *	This is the Support for the StoryEngine
	 * 		>> Communicate with AMFPHP
	 * 		>> Load the External Assets
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  3.04.2009
	 */
	 
	public class StoryEngineSupport extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const GET_DATA:String = "getAmfPhpData";
		public const STORYENGINE_SETUP_READY:String = "StoryEngineSetupReady";
		
		public const NAV_ID:String = "NavigationID";
		public const LOGO_ID:String = "LoadingLogoID";
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		
		protected var mAmfPHPBridge:Amfphp;

		protected var mStoryBookData:StoryBookData;
		protected var mLoadingManager:LoadingManager;

		protected var mTranslationManager:TranslationManager;
		protected var mTranslationData:StoryBookTranslation;
		protected var mOffline:Boolean;
		protected var mCurNumberOfPages:int;
		
		//protected var mLoadingLogo:StoryBookLogoSymbol;
		protected var mLoadingLogo:MovieClip;
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryEngineSupport():void
		{
			super();
			
			setupVars();
		}
		
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		/**
		 * @Note Start the Process of setting up the StoryEngine
		 */
		 
		public function init():void
		{
			//FLASH VARS
			var tBaseUrl:String = FlashVarsFinder.findVar(this,"baseurl");
			var tBaseLanguage:String = FlashVarsFinder.findVar(this,"lang");
			var tBaseChapter:int  = int(FlashVarsFinder.findVar(this,"chapter"));
			var tBaseImageHost:String = FlashVarsFinder.findVar(this,"image_host");
			var tBasePlotCode:String = FlashVarsFinder.findVar(this,"plot_code");
			
			trace("FlashVars: > tBaseUrl:", tBaseUrl, " >tBaseLanguage:", tBaseLanguage, " >tBaseChapter:", tBaseChapter, " > tBaseImageHost:",tBaseImageHost, " >tBasePlotCode:",tBasePlotCode);
			
			mStoryBookData.mLanguage  = tBaseLanguage != null ? tBaseLanguage : mStoryBookData.mLanguage;
			mStoryBookData.mChapter  = (tBaseChapter == 0) ? mStoryBookData.mChapter : tBaseChapter;
			mStoryBookData.mImageServerURL  = tBaseImageHost != null ? tBaseImageHost : mStoryBookData.mImageServerURL;
			mStoryBookData.mPlot_code  = tBasePlotCode != null ? tBasePlotCode : mStoryBookData.mPlot_code;
			
			StoryBookCallObject;
			
			if (tBaseUrl != null)
			{
				//TESTING ONLY
				//if (tBaseUrl == null){ tBaseUrl = mStoryBookData.mBaseUrl}
				
				mStoryBookData.mBaseUrl = tBaseUrl;
				
				mAmfPHPBridge.init("http://" + tBaseUrl);
				var responder = new Responder(handleData, returnError);
			
				Amfphp.instance.connection.call("ComicService.loadChapter", responder,mStoryBookData.mPlot_code, Number(mStoryBookData.mChapter));
			}
			else
			{
				mOffline = true;
				continueSetup();
			}	
		
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	if amfphp call has failed
		 **/
		 
		private function returnError(obj:Object):void
		{
			trace ("Error occured in receiving amfphp data:")
			
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i])
			}
			
			continueSetup();
		}
		
		/**
		 *	if amfphp call is sucessfull
		 **/
		 
		private function handleData(obj:Object):void
		{
			trace ("AMFPHP obj of handleData received:")
			
			for (var i:String in obj)
			{
				trace ("	",i,":",  obj[i])
			}
			
			
			mStoryBookData.mChapterData = StoryBookChapterObject( GeneralFunctions.syncParamters(mStoryBookData.mChapterData,obj) );
			
			continueSetup();
		}
		
		/** 
		 * @Note When TranslationManager has contected to PHP and Translation is Complete.
		 * @Note: If you Have In game Items Needed for Translation, You should have them in them translated after this event
		 */
		 
		private function translationComplete(evt:Event):void
		{
			var tTranslationManager : TranslationManager = TranslationManager.instance;
		 	mTranslationData = StoryBookTranslation(tTranslationManager.translationData);
		 	
		 	supportReady();
		}
		
		/**
		 * @Note: All Loading Files are completed
		 */
		 
		private function onExternalFilesLoaded(evt:Event):void
		{
			mTranslationManager.init(mStoryBookData.mLanguage.toUpperCase(), mStoryBookData.mChapterData.content_id, 14, mTranslationData, mStoryBookData.mBaseUrl, mStoryBookData.mChapterData.hash);
		}
		
		/**
		 * @Note: For Each Chapter that loads, It will Update the Counter on the Loader Icon
		 * @param		evt.oData.LOADEDITEM			LoadedItem			The Loaded Item from the LoadingManager
		 */
		 
		private function onCountObjectsLoaded(evt:CustomEvent):void
		{
			var tLoadedItem:LoadedItem = LoadedItem(evt.oData.LOADEDITEM);	
			
			if (tLoadedItem.objID == LOGO_ID)
			{
				if ( ApplicationDomain.currentDomain.hasDefinition("LogoSymbol"))
				{
					var tLogoClass:Class = ApplicationDomain.currentDomain.getDefinition("LogoSymbol") as Class;	
				}
				else if (tLoadedItem.localApplicationDomain.hasDefinition("LogoSymbol"))
				{
					var tLogoClass:Class = tLoadedItem.localApplicationDomain.getDefinition("LogoSymbol") as Class;	
				}
				
				mLoadingLogo = new tLogoClass();
				mLoadingLogo.x = 325;
				mLoadingLogo.y = 175;
				mLoadingLogo.dispatchEvent(new CustomEvent({lang:mStoryBookData.mLanguage},StoryBookLogoSymbol.UPDATE_LOGO_LANG));
				addChild(mLoadingLogo);
				
			}
			else
			{
				if (mLoadingLogo != null)
				{
					mCurNumberOfPages++;
					var tCount:int = mStoryBookData.mChapterData.pages.length;
					mLoadingLogo.dispatchEvent(new CustomEvent({chapter:mCurNumberOfPages, numChapters:tCount}, StoryBookLogoSymbol.UPDATE_LOADING_SCREEN));	
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Setup Starting Values
		 */
		 
		private function setupVars():void
		{
			mAmfPHPBridge = Amfphp.instance;
			
			mLoadingManager = LoadingManager.instance;
			
			mLoadingManager.addEventListener(mLoadingManager.LOADING_COMPLETE, onExternalFilesLoaded, false, 0, true);
			mLoadingManager.addEventListener(mLoadingManager.LOADING_OBJLOADED, onCountObjectsLoaded, false, 0, true);
			
			mTranslationManager = TranslationManager.instance;
			mTranslationManager.addEventListener(Event.COMPLETE, translationComplete, false, 0, true);
			mTranslationData = new StoryBookTranslation();
			
			mStoryBookData = new StoryBookData();
			mOffline = false;
			
			mCurNumberOfPages = 0;

		}
		
		
		
		/**
		 *	The Data has been Processed, Now its time to get the files to Load. A Large part of this is recasting the AMF Objects
		 *  Back to Flash Classes. In this future these should be binded so this will not be needed.
		 **/
		 
		private function continueSetup():void
		{
			var tLocalPathway:String = "";
			var tDefaultPathway:String = "";
			
			if (!mOffline)
			{
				tDefaultPathway = mStoryBookData.mImageServerURL + "/";
			}
			
			mLoadingManager.init(tDefaultPathway,true);
			
			
			mLoadingManager.addItemToLoad(mStoryBookData.mChapterData.nav_asset_url, NAV_ID,LoadingManager.ADD_CHILD,null,null,false);
			mLoadingManager.addItemToLoad(mStoryBookData.mChapterData.logo_asset_url, LOGO_ID,LoadingManager.ADD_CHILD,null,null,true);
			
			//LOAD ALL PAGES for a Chapter
			var tCount:int = mStoryBookData.mChapterData.pages.length;
			var tNewTypedArray:Array = [];
			
			for (var z:int = 0; z < tCount; z++)
			{
				var tStoryBookPanelObj:StoryBookPanelObject = new StoryBookPanelObject();
				tStoryBookPanelObj = StoryBookPanelObject( GeneralFunctions.syncParamters(tStoryBookPanelObj, mStoryBookData.mChapterData.pages[z]) );
			
				
				
				if (tStoryBookPanelObj.clickable_objects.length > 0)
				{
					var tCount2:int = tStoryBookPanelObj.clickable_objects.length;
					var tTypedclickable_objectsArray:Array = [];
					
					for (var x:int = 0; x < tCount2; x++)
					{
						
						
						var tObj:Object = tStoryBookPanelObj.clickable_objects[x];
						
						for (var i:String in tObj)
						{
							trace ("	",i,":",  tObj[i])
						}
						
						if (tStoryBookPanelObj.clickable_objects[x].hasOwnProperty("call_function"))
						{
							var tStoryBookCallObject:StoryBookCallObject = new StoryBookCallObject();
							tStoryBookCallObject = StoryBookCallObject( GeneralFunctions.syncParamters(tStoryBookCallObject, tStoryBookPanelObj.clickable_objects[x]) );
							tTypedclickable_objectsArray.push(tStoryBookCallObject);
							
							trace ("AMFPHP obj tStoryBookPanelObj.clickable_objects[",x,"] is a tStoryBookCallObject:", tStoryBookCallObject);
						
							var tObj2:Object = tStoryBookCallObject;
						
							for (var i2:String in tObj2)
							{
								trace ("	",i2,":",  tObj2[i2])
							}
						
						} 
						else
						{
							var tStoryBookClickObject:StoryBookClickObject = new StoryBookClickObject();
							tStoryBookClickObject = StoryBookClickObject( GeneralFunctions.syncParamters(tStoryBookClickObject, tStoryBookPanelObj.clickable_objects[x]) );
							tTypedclickable_objectsArray.push(tStoryBookClickObject);
							
							trace ("AMFPHP obj tStoryBookPanelObj.clickable_objects[",x,"] is a StoryBookClickObject:", tStoryBookClickObject);
							
							var tObj3:Object = tStoryBookClickObject;
						
							for (var i3:String in tObj3)
							{
								trace ("	",i3,":",  tObj3[i3])
							}
							
						}
						
					}
						
					tStoryBookPanelObj.clickable_objects = 	tTypedclickable_objectsArray;
				}
				
				tNewTypedArray.push(tStoryBookPanelObj);
			}
			
			mStoryBookData.mChapterData.pages = tNewTypedArray;
			
			var tCount3:int = mStoryBookData.mChapterData.pages.length;
			
			for (var q:int = 0; q< tCount3; q++)
			{
				var tStoryBookPanelObj2:StoryBookPanelObject =  StoryBookPanelObject(mStoryBookData.mChapterData.pages[q]);
				
				tStoryBookPanelObj2.name = "Chapter" + mStoryBookData.mChapter + "_Panel" + q;
				
				var tLoadingURL:String = tStoryBookPanelObj2.asset_url;
				mLoadingManager.addItemToLoad(tLoadingURL, tStoryBookPanelObj2.name,LoadingManager.ADD_CHILD,null,null,true);
				//trace("LoadingPanel: ",tStoryBookPanelObj2.name, " at URL: ", tLoadingURL);
			}
			
			mLoadingManager.startLoadingList();
		}
		
		/**
		 * @Note: Everything has been loaded and ready for Navigation and Setup
		 */
		 
		protected function supportReady():void
		{
			mLoadingLogo.txt_Fld.htmlText = "";
			mLoadingLogo.visible = false;
			
			dispatchEvent(new Event(STORYENGINE_SETUP_READY));
		}
		
		
		
		 
		
	}
	
}
