
/* AS3
	Copyright 2008
*/
package com.neopets.projects.comicEngine.objects
{
	import com.neopets.projects.comicEngine.objects.StoryBookChapterObject;
	import com.neopets.projects.comicEngine.objects.StoryBookClickObject;
	import com.neopets.projects.comicEngine.objects.StoryBookPanelObject;
	

	
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  8.20.2009
	 */
	 
	public class StoryBookData
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public var mDefaultAssetPathway:String; 								//This will useally always be the same for a project
		public var mUseTranslation:Boolean;									// Simple Flag to use Translation System, Default = yes
		public var mImageServerURL:String;										//Images or images50	> AMFPHP
	
		public var mLanguage:String;												//Language Id, Standards (en,zh,pr,ect) > AMFPHP
		public var mPlot_code:String;
		public var mChapterData:StoryBookChapterObject;
		public var mChapter:int;
		public var mBaseUrl:String;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookData():void
		{
			setValues();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/** 
		 * @Note: These are the default testing values. PHP will overright some of these values when I get the AMFPHP Connection
		 */
		 
		private function setValues():void
		{
				mChapterData = new StoryBookChapterObject();
				mDefaultAssetPathway = "";
				mUseTranslation = true;

				//FlashVars
				mImageServerURL = "http://images50.neopets.com";
				mLanguage = "en";
				mChapter = 1;
				mPlot_code = "aota";
				mBaseUrl = "dev.neopets.com";
				
				//AMFPHP Replaced
				mChapterData.content_id = 910001;
				mChapterData.id = String(mChapter);
				mChapterData.nav_asset_url = "comics/aota_ab1280a284/nav_art_v1_ab1280a284.swf";
				mChapterData.logo_asset_url = "comics/aota_ab1280a284/logo_art_v1_ab1280a284.swf";
				mChapterData.panels = [];
				mChapterData.hash = "d7de749155";
		
				//TESTING ONLY
				var tTestPanelObject:StoryBookPanelObject = new StoryBookPanelObject();
				tTestPanelObject.asset_url = "comics/aota_ab1280a284/pages/aota_book2_page1_v1_eb0b34194e.swf";
				tTestPanelObject.content_prefix = "IDS_BOOK2_PAGE1_";
				tTestPanelObject.name = "Chapter1_Panel0";
				mChapterData.panels.push(tTestPanelObject);
				
				
				
				
				//OTHER PANEL TESTING
				var tTestPanelObject2:StoryBookPanelObject = new StoryBookPanelObject();
				tTestPanelObject2.asset_url = "comics/aota_ab1280a284/pages/aota_book2_page2_v1_eb0b34194e.swf";
				tTestPanelObject2.content_prefix = "IDS_BOOK2_PAGE2_";
				tTestPanelObject2.name = "Chapter1_Panel1";
				mChapterData.panels.push(tTestPanelObject2);
				
				
				var tTestPanelObject3:StoryBookPanelObject = new StoryBookPanelObject();
				tTestPanelObject3.asset_url = "comics/aota_ab1280a284/pages/aota_book1_page3_v1_d7de749155.swf";
				tTestPanelObject3.content_prefix = "IDS_BOOK1_PAGE3_";
				tTestPanelObject3.name = "Chapter1_Panel2";
				mChapterData.panels.push(tTestPanelObject3);
				
				var tTestClickThroughObj:StoryBookClickObject = new StoryBookClickObject();
				tTestClickThroughObj.attach_symbol = "LinkBoxPanel";
				tTestClickThroughObj.click_url = "http://dev.neopets.com";
				tTestClickThroughObj.rollover_effect = "glow";
				tTestPanelObject3.clickable_objects.push(tTestClickThroughObj);
			
				
		}
		
		
	}
	
}
