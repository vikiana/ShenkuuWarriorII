package com.neopets.util.lang.customneopet 
{
	import com.neopets.util.lang.TranslationData;

	[Bindable]
		
	/**
	* CLASS DESCRIPTION: ...
	*/	
	public dynamic class CustomNeopetTranslationData extends TranslationData 
	{	
		//PROBLEMS...TODO FIX.  WHY IS THIS referenced and causing an error  BUT WAS NOT DECLARED here or online UNTIL i THROW IT HERE
		public var TOOLTIP_BUTTONSORT : String 					= "^";
		public var ERROR_INVALID_PET_LOAD:String				= "^";

		//*****************
		//PROMPTS
		//*****************
		public var PROMPT_TITLE_TUTORIAL : String 					= "^Tutorial";
		public var PROMPT_TUTORIAL_SHOW_ALWAYS : String 			= "^Show always at startup:";
		public var PROMPT_SERVICE_TRANSLATION_LOADING : String 		= "^Loading";
		public var PROMPT_LOADING_APPLICATION_DATA : String 	 	= "^Loading application data."
		public var PROMPT_LOADING_USER_DATA_FOR : String 	  		= "^Loading user data for %USERNAME.";
		public var PROMPT_LOADING_EDITOR_DATA_FOR : String 	  		= "^Loading Neopet data for %USERNAME.";
		public var PROMPT_SAVING_EDITOR_DATA_FOR : String 	 		= "^Saving %USERNAME's %NEOPET_NAME.";
		public var PROMPT_SAVE_CONFIGURATION : String 	 			= "^Save configuration";
		public var PROMPT_LOAD_CONFIGURATION : String 	 			= "^Load configuration";
		public var PROMPT_CLOSE : String 	 						= "^Close";
		public var PROMPT_RETRY : String  							= "^Retry"; 
		public var PROMPT_TITLE_ERROR : String 						= "^Error";

		//
		public var PROMPT_REVERT_TO_LAST_SAVE : String  			= "^Revert to last save";
		public var PROMPT_ARE_YOU_SURE : String  					= "^Are you sure?";
		public var PROMPT_YES : String  							= "^Yes";
		public var PROMPT_YES_TOOLTIP : String  					= "^Click on ~Yes";
		public var PROMPT_NO : String 								= "^No";
		public var PROMPT_NO_TOOLTIP : String  						= "^Click on ~No";
		public var PROMPT_CANCEL : String 							= "^Cancel";
		public var PROMPT_CANCEL_TOOLTIP : String 					= "^Click on ~Cancel";

		//
		public var PROMPT_TITLE_PRESETS : String 					= "^Presets";
		public var PROMPT_PRESETS_PETNAME : String 					= "^Pet Name";
		public var PROMPT_PRESETS_CONFIG : String 					= "^Configuration";
		public var PROMPT_PRESETS_PREVIEW_NOT_AVAILABLE : String 	= "^Preview not available";
		public var PROMPT_PRESETS_APPLY : String 					= "^Save Changes";
		public var PROMPT_PRESETS_LOAD : String 					= "^Load and Customise";
		public var PROMPT_PRESETS_SAVE : String 					= "^Save Current Config to this Preset";


		public var PROMPT_CONFIRM_SAVE : String       						= "^You may not save with items applied to other pets."
		public var PROMPT_SAVE_WITHOUT : String       						= "^Save Without These Items"
		public var PROMPT_SAVE_CANCEL : String        						= "^Cancel"

		//*****************
		//ERROR
		//***************** 
		public var PROMPT_SERVICE_LOADING_MESSAGE : String = "^Loading Translation";
		public var ERROR_AMFPHP_GENERIC : String = "^There is a problem. Please try again later."
		public var ERROR_ITEMS_RESTRICTING : String = "^Zone Restricted!\nThe following item(s) are restricting this zone:\n%RESTRICTING\nRemove those item(s) to lift the restriction."

		public var ERROR_2124 : String = "^Error #2124: Loaded file is an unknown type. URL: ' %URL '." 
		public var ERROR_10000 : String = "^Error #10000: "
		public var ERROR_10001 : String = "^Error #10001: "
		public var ERROR_10002 : String = "^Error #10002: "
		public var ERROR_10003 : String = "^Error #10003: That's not one of your Neopets!"
		public var ERROR_10004 : String = "^Error #10004: ";
		public var ERROR_INCOMPATIBLE_ITEM : String	= "^%INCOMPATIBLE_ITEMS_NUM incompatible item has been removed and will be moved to your closet upon saving."
		public var ERROR_INCOMPATIBLE_ITEMS : String = "^%INCOMPATIBLE_ITEMS_NUM incompatible items have been removed and will be moved to your closet upon saving."
		public var ERROR_MOUSE_LEFT_APP_WITHOUT_SAVING : String = "^Your mouse has left the Customise application before your changes were saved.  Be sure to save your changes, if desired."
		
		
		//*****************
		//APPLICATION BAR VIEW
		//*****************
		public var TOP_NAV_CONFIGURATION : String  					= "^Configuration";
		public var TOP_NAV_CUSTOMISE_VERSION : String 				= "^Customise v";
		public var TOP_NAV_FRAMES_PER_SECOND_SHORT : String 		= "^FPS";
		public var TOP_NAV_SAVE_CHANGES : String  					= "^Save Changes";
		public var TOP_NAV_PRESETS : String  						= "^Presets";
		public var TOP_NAV_REVERT : String  						= "^Revert";
		public var TOP_NAV_PRINT : String  							= "^Print";
		public var TOP_NAV_HELP : String  							= "^Help";
		
		
		//*****************
		//SELECTED ITEM VIEW
		//*****************
		public var SELECTED_ITEM_VIEW_TITLE : String  			= "^Selected Item";
		public var SELECTED_ITEM_VIEW_USERNAME : String  		= "^Username";
		public var SELECTED_ITEM_VIEW_RARITY_INDEX : String  	= "^Rarity Index";
		public var SELECTED_ITEM_VIEW_NEOPET : String  			= "^Neopet"; 				
		public var SELECTED_ITEM_VIEW_ESTIMATED_VALUE : String  	= "^Estimated Value";
		
		//LABELS
		public var SELECTED_ITEM_VIEW_NAME : String  			= "^Name";
		public var SELECTED_ITEM_VIEW_CATEGORY : String 		= "^Category";
		public var SELECTED_ITEM_VIEW_WEIGHT : String  			= "^Weight";
		public var SELECTED_ITEM_VIEW_RARITY : String  			= "^Rarity";
		public var SELECTED_ITEM_VIEW_DESCRIPTION : String  		= "^Description";
		public var SELECTED_ITEM_ZONES_AFFECTED : String  		= "^Zones Affected";
		public var SELECTED_ITEM_ZONES_RESTRICTED : String  		= "^Zones Restricted";
		
		//BUTTONS
		public var SELECTED_ITEM_VIEW_APPLY : String  			= "^Apply";
		public var SELECTED_ITEM_VIEW_REMOVE : String  			= "^Remove";
		public var SEND_YOUR_NEOPET:String						= "^Send"; 
		//*****************
		//ALL ITEMS 
		//*****************
		public var ALL_ITEMS_VIEW_TITLE : String  				= "^Items View";
		public var ALL_ITEMS_VIEW_SORT : String  				= "^Sort";
		public var ALL_ITEMS_VIEW_BROWSE : String  				= "^Browse";
		public var ALL_ITEMS_VIEW_APPLIED : String  				= "^Applied";
		public var ALL_ITEMS_VIEW_INVENTORY : String  			= "^Closet";
		//SORTING
		public var ALL_ITEMS_VIEW_AVAILABLITITY : String  		= "^Availability";
		public var ALL_ITEMS_VIEW_SEARCH_NAME : String  		= "^Search Name";	
		public var ALL_ITEMS_VIEW_SPECIES : String  			= "^Species";
		public var ALL_ITEMS_VIEW_ZONE : String  				= "^Zones";
		public var ALL_ITEMS_VIEW_SOURCE : String  				= "^Source";
		public var ALL_ITEMS_VIEW_RARITY : String 				= "^Rarity";
		//BUTTONS
		public var ALL_ITEMS_VIEW_SUBMIT : String  				= "^Submit"; 
		public var ALL_ITEMS_VIEW_CLEAR : String  				= "^Clear"; 
		//TABS
		public var ALL_ITEMS_VIEW_ICON_VIEW : String  			= "^Icon View"; 
		public var ALL_ITEMS_VIEW_DETAIL_VIEW : String  		= "^Detail View";
		//MARQUEE, SAMR 8/20/07
		public var ALL_ITEMS_VIEW_MARQUEE : String  			= "^If you don't see your items here, remember to move them from your <A HREF='http://www.neopets.com/objects.phtml?type=inventory'><FONT COLOR='#2E72C0'><B>Inventory</B></FONT></A> to your <A HREF='http://www.neopets.com/closet.phtml'><FONT COLOR='#2E72C0'><B>Closet</B></FONT></A>.";
		public var ALL_ITEMS_VIEW_MARQUEE_NCMALL : String  		= "^<BR>You can also visit the <A HREF='http://ncmall.neopets.com/mall/shop.phtml'><FONT COLOR='#2E72C0'><B>NC Mall</B></FONT></A> for more items and new styles.";

		//*****************
		//TOOL TIPS
		//*****************
		public var TOOLTIP_CONFIGURATION_TITLE : String  			= "^Active Configuration~Your Neopet configuration is displayed below.";
		public var TOOLTIP_BUTTON_PRESETS : String  				= "^Load Presets~Click here to load a Neopet configuration.";

		public var TOOLTIP_BUTTON_SAVE : String    					= "^Save Changes~to %NEOPET_NAME's configuration.";
		public var TOOLTIP_BUTTON_REVERT : String    				= "^Revert~to %NEOPET_NAME's configuration originally loaded.";
		public var TOOLTIP_BUTTON_PRINT : String    				= "^Print~this pet configuration.";
		public var TOOLTIP_BUTTON_BROWSE : String  					= "^Browse~your items.";
		public var TOOLTIP_BUTTON_SORT : String  					= "^Sort~your items.";
		public var TOOLTIP_RADIOBUTTON_INVENTORY : String  			= "^Closet Items~Check this to display all your available items only.";
		public var TOOLTIP_RADIOBUTTON_APPLIED : String   			= "^Applied Items~Check this to display only the items your Neopet is using in this configuration.";
		public var TOOLTIP_COMBOBOX_AVAILABILITY : String 			= "^Items By Ownership~Select here if you want to search only the items you already own, or if you'd also like to search the items on your wish list.";
		public var TOOLTIP_COMBOBOX_SPECIES : String   				= "^Items By Species~Select here if you want to search items by the Neopet species they can be applied to."; 
		public var TOOLTIP_COMBOBOX_ZONES : String  				= "^Items By Zones~Select here if you want to search items by the zones they can be applied to (EX: HEAD, UPPER BODY, BACKGROUND, ETC.)."; 
		public var TOOLTIP_UNAVAILABLE_FEATURE  : String 			= "^Unavailable~This feature will be available soon.";
		
		//THIS ONE WILL CHANGE ONCE WE ADD 'WISHLIST' FUNCTIONALITY
		public var TOOLTIP_COMBOBOX_SOURCE : String 				= "^Items By Source~Select here to view items by source."
		
		//NEW
		public var TOOLTIP_BUTTON_SEND_NEOPET:String				= "Send~Send a picture of %NEOPET_NAME to a friend."
		public var TOOLTIP_MINIMISE_NEOPET_VIEW:String 				= "Minimise~Minimize the view of %NEOPET_NAME."
		public var TOOLTIP_MAXIMISE_NEOPET_VIEW:String 				= "Maximise~Maximise the view of %NEOPET_NAME."	
		public var TOOLTIP_MUTE_ON:String 			           		= "Enable sound effects and music for %NEOPET_NAME.";
		public var TOOLTIP_MUTE_OFF:String          		  		= "Disable sound effects and music for %NEOPET_NAME.";

		
		public var TOOLTIP_COMBOBOX_RARITY_INDEX : String  			= "^Rarity Index~Select the Rarity Index range of your search results.";
		public var TOOLTIP_CANVAS_ICON_VIEW : String  				= "^Icon Items View~Click here to see images of your items.";
		public var TOOLTIP_CANVAS_DETAIL_VIEW : String  			= "^Detailed Items View~Click here to see the details of your items.";
		//USES FORMATTED STRING
		public var TOOLTIP_BUTTON_HELP : String  					= "^Get Help~Display the tutorial in a pop-up window.";
		public var TOOLTIP_VIRTUAL_ITEM_LIST_ITEM : String 			= "^%ITEM_NAME~Click to display the item description in the 'Selected Item' window.<br>Drag and Drop in the Neopet window to apply this item.";
		public var TOOLTIP_SELECTED_ITEM_VIEW : String  			= "^%ITEM_NAME~Click on 'Apply' to apply the item to the Scene.";
		
		public var TOOLTIP_BUTTON_FEEDBACK : String  				= "^Feedback~Tell us what you think of the this new Neopets feature.";
		public var TOOLTIP_BUTTON_APPLY : String             		= "^Apply~Click to apply %ITEM_NAME to the scene. ";
		public var TOOLTIP_BUTTON_REMOVE : String             		= "^Remove~Click to remove %ITEM_NAME from the scene. It will go back to your closet.";
		public var TOOLTIP_NEOPETVIEW : String             			= "^%NEOPET_NAME~Click here to display only the items you applied to your Neopet (for easy removal).";
		public var TOOLTIP_SEARCHBOX : String           			= "^Search for Items~Typing in this box will display only the items that include the typed words.";
		public var TOOLTIP_CLEARSEARCH : String         			= "^Clear The Search~Click here to clear the search box.";
		
		//*****************
		//DATA GRID COLUMNS 
		//*****************                         
		public var ALL_ITEMS_VIEW_DATAGRID_NAME : String         	= "^Name"
		public var ALL_ITEMS_VIEW_DATAGRID_COMPATIBLE : String   	= "^Compatible"
		public var ALL_ITEMS_VIEW_DATAGRID_CATEGORY : String     	= "^Category"
		public var ALL_ITEMS_VIEW_DATAGRID_RARITY : String        	= "^Rarity"
	
		//*****************
		//SELECTED ITEM 
		//*****************  		
		public var SELECTED_ITEM_PRICE : String  					= "^Item Price"
		public var SELECTED_ITEM_EXPIRATION : String  				= "^Expiration Date"
		public var SELECTED_ITEM_IS_CASH_ITEM : String 		 		= "^Cash Item"
	}
}

