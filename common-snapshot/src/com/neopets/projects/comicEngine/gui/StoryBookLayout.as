
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.gui
{
	import com.neopets.projects.comicEngine.StoryEngineSupport;
	import com.neopets.projects.comicEngine.objects.StoryBookPanelObject;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	
	
	/**
	 *	This is for the Main StoryBook FLA that Holds the Panels, Navigation, Logo
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryBook Engine
	 * 
	 *	@author Clive Henrick
	 *	@since  08.24.2009
	 */
	 
	public class StoryBookLayout extends StoryEngineSupport
	{
		

		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		protected var mNavigation:StoryBookNavigation;
		protected var mCurrentPanel:MovieClip;
		protected var mCurrentPanelIndex:int;
		protected var mPageStorage:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookLayout():void
		{
			super();
			setupDocVars();
			init();
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/** 
		 * @Note Navigation SWF sending an Event
		 *	@param		evt.oData.direction			String			The Direction of the Arrow Pressed
		 */
		 
		protected function onNavigationEvent (evt:CustomEvent):void
		{
			var tOldCurrentIndex:int = mCurrentPanelIndex;
			
			switch (evt.oData.direction)
			{
				case StoryBookNavigation.NEXT_BTN:
					mCurrentPanelIndex++;
				break;
				case StoryBookNavigation.PREVIOUS_BTN:
					mCurrentPanelIndex--;
				break;
			}	
			
			var tCount:int = mStoryBookData.mChapterData.panels.length;
			
			if (mCurrentPanelIndex >= tCount || mCurrentPanelIndex == 0)
			{
				mCurrentPanelIndex = 0;	
				mNavigation.dispatchEvent(new CustomEvent({cmd:StoryBookNavigation.BUTTON_DISPLAY_EVENT, button:"left"},StoryBookNavigation.NAVIGATION_EVENT_UPDATE)); 
			}
			else if (mCurrentPanelIndex < 0 || mCurrentPanelIndex ==( tCount - 1))
			{
				mCurrentPanelIndex = 	tCount - 1;
				mNavigation.dispatchEvent(new CustomEvent({cmd:StoryBookNavigation.BUTTON_DISPLAY_EVENT, button:"right"},StoryBookNavigation.NAVIGATION_EVENT_UPDATE)); 
			}
			else
			{
				mNavigation.dispatchEvent(new CustomEvent({cmd:StoryBookNavigation.BUTTON_DISPLAY_EVENT, button:"none"},StoryBookNavigation.NAVIGATION_EVENT_UPDATE)); 	
			}
			
			MovieClip(mPageStorage[tOldCurrentIndex]).dispatchEvent(new Event(StoryBookPage.RESET_PAGE_EVENT));
			
			MovieClip(mPageStorage[tOldCurrentIndex]).visible = false;
			
			MovieClip(mPageStorage[mCurrentPanelIndex]).visible = true;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupDocVars():void
		{
			mCurrentPanelIndex = 0;		
			addEventListener(STORYENGINE_SETUP_READY, onFilesLoaded, false, 0, true);	
			mPageStorage = [];
		}
		
		/**
		 * @Note: The Files are Loaded and Ready to be displayed
		 */
		 
		protected  function onFilesLoaded(evt:Event):void
		{
			
			//Nvaigation Setup
			mNavigation = mLoadingManager.getLoadedObj(NAV_ID) as StoryBookNavigation;
			mNavigation.addEventListener(StoryBookNavigation.NAVIGATION_EVENT_BTN, onNavigationEvent, false, 0, true);
			
			var tLeftBtn:String = mTranslationManager.getTranslationOf("IDS_PREVIOUS_PAGE");
			var tRightBtn:String = mTranslationManager.getTranslationOf("IDS_NEXT_PAGE");
			
			mNavigation.dispatchEvent(new CustomEvent({cmd:StoryBookNavigation.UPDATE_TEXT, rightTxt:tRightBtn, leftTxt:tLeftBtn,lang:mStoryBookData.mLanguage},StoryBookNavigation.NAVIGATION_EVENT_UPDATE));
			mNavigation.dispatchEvent(new CustomEvent({cmd:StoryBookNavigation.BUTTON_DISPLAY_EVENT, button:"left"},StoryBookNavigation.NAVIGATION_EVENT_UPDATE)); 
			
			
			//Setup All the Panels
			setupPages();
			
			this.addChildAt(mNavigation,numChildren);
			
			MovieClip(mPageStorage[mCurrentPanelIndex]).visible = true;
			
		}
		
		protected function setupPages():void
		{
			var tCount:int = mStoryBookData.mChapterData.panels.length;
			var tID:String;
			var tFrontEndTransStr:String;
			var tDataObj:Object;
			var tMC:MovieClip;
			
			for (var z:int = 0; z < tCount; z++)
			{
				tID = mStoryBookData.mChapterData.panels[z].name;
				tMC = mLoadingManager.getLoadedObj(tID);
				tFrontEndTransStr = mStoryBookData.mChapterData.panels[z].content_prefix;
				tDataObj = {lang:mStoryBookData.mLanguage, projectId:mStoryBookData.mChapterData.content_id, transData:mTranslationData, transURL:mStoryBookData.mBaseUrl, transFrontID:tFrontEndTransStr, setUpTranslation:false, externalTransLoading:true, hash:mStoryBookData.mChapterData.hash, dataObject:mStoryBookData.mChapterData.panels[z]};
				tMC.dispatchEvent(new CustomEvent(tDataObj, StoryBookPage.LANG_UPDATE_EVENT));
				addChild(tMC);
				tMC.visible = false;
				mPageStorage.push(tMC);
			}
			
		}
		
		
	}
	
}

	