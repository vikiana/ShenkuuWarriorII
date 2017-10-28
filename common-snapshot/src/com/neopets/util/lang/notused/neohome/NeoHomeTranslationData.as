//Marks the right margin of code *******************************************************************
package com.neopets.util.lang.neohome
{
	//--------------------------------------
	//  Imports
	//--------------------------------------
	import com.neopets.util.lang.TranslationData;	
		
	//--------------------------------------
	//  Class
	//--------------------------------------
	/**
	 * Extends <code>TranslationData</code> to populate with name/values expected from TranslationManager call.  
	 * This hardcode assists the intellisense.
	 * 
	 * This is to be kept up to date with dev.neopets.com/transcontent/flash/content_1136.txt.  
	 * As a phrase is added, add it here with a "^" and online without the "^"
	 * 
     * <listing version="3.0" >
	 * 	//Code example goes here.
	 * </listing>
	 *
     * <span class="hide">Any hidden comments go here.</span>
     *
	*/
	dynamic public class NeoHomeTranslationData extends TranslationData
	{		
		
		//--------------------------------------
		//  Properties
		//--------------------------------------

		//**************************************************************************************************
		//GENERAL
		//**************************************************************************************************
		public var GENERAL_NEOPOINTS : String = "^(Neopoints)";
		public var GENERAL_NEOCASH : String = "^(Neocash)";
		
		//**************************************************************************************************
		//PROMPTS
		//**************************************************************************************************
		
		public var PROMPT_PLEASE_WAIT_TITLE : String = "^Please Wait...";
		public var PROMPT_LOADING_STYLES_BODY : String = "^Loading Styles...";		
		public var PROMPT_LOADING_APPLICATION_DATA_BODY : String = "^Loading Menus...";		
		public var PROMPT_SAVING_APPLICATION_DATA_BODY : String = "^Saving Neohome...";		
		public var PROMPT_LOADING_MODAL_APPLICATION_DATA_BODY : String = "^Loading Neohome...";		
		public var PROMPT_REVERTING_TITLE : String = "^Reverting...";		
		public var PROMPT_ATTEMPT_REVERTING_BODY : String = "^When reverting, you lose all changes made since your last save. Would you like to revert your Neohome?";		
		public var PROMPT_REVERTING_BODY : String = "^Reverting Neohome...";
		
		
		//
		public var PROMPT_SAVING_TITLE : String = "^Saving...";		
		public var PROMPT_ATTEMPT_SAVING_BODY : String = "^When saving, you replace your last save with your current Neohome. Your Construction Costs of %CONSTRUCTION_COSTS NP will be deducted from your available NP balance of %AVAILABLE_NEOPOINTS. Would you like to save your Neohome?";
		public var PROMPT_SAVING_BODY : String = "^Saving Neohome...";
		//
		public var PROMPT_ERROR_TITLE : String = "^Error";
		//
		public var PROMPT_CONFIRM_TITLE : String = "^Confirm";		
		public var PROMPT_CONFIRM_BUTTON_LABEL : String = "^Confirm";		
		public var PROMPT_CONFIRM_BUTTON_TOOLTIP : String = "^Proceed with the current operation.";		
		public var PROMPT_CANCEL_BUTTON_LABEL : String = "^Cancel";		
		public var PROMPT_CANCEL_BUTTON_TOOLTIP : String = "^Stop the current operation.";		
		//
		public var PROMPT_CONFIRM_SAVING_ENTER_PIN : String = "^Please enter your pin number.";		
		public var PROMPT_CONFIRM_SAVING_CONSEQUENCE_BODY : String = "^Saving your Neohome will overwrite your previous save with the current configuration. Are you sure you want to save?";		
		public var PROMPT_CONFIRM_REVERTING_CONSEQUENCE_BODY : String = "^Reverting your Neohome will load your last save. You will lose any progress since then. Are you sure you want to revert?";
		
		//
		public var PROMPT_RENDERING_WORLD_BODY : String = "^Rendering Neohome...";
		
		// TRANSCONTENT TO HERE 7/9/08
			
		//**************************************************************************************************
		//COMPONENTS
		//**************************************************************************************************
		
		//applicationControlBarView -------------------------------
		//tooltips		
		public var APPLICATION_CONTROL_BAR_VIEW_SAVE_BUTTON_TOOLTIP : String = "^Save your Neohome.";		
		public var APPLICATION_CONTROL_BAR_VIEW_REVERT_BUTTON_TOOLTIP : String = "^Undo all changes to your Neohome since your last save.";		
		public var APPLICATION_CONTROL_BAR_VIEW_PRINT_BUTTON_TOOLTIP : String = "^Print your Neohome.";		
		public var APPLICATION_CONTROL_BAR_VIEW_HELP_BUTTON_TOOLTIP : String = "^View help for this application.";		
		public var APPLICATION_CONTROL_BAR_VIEW_SHOP_BUTTON_TOOLTIP : String = "^Click here to visit the Shopping Hub and shop for Neohome items." 		
		public var APPLICATION_CONTROL_BAR_VIEW_HUB_BUTTON_TOOLTIP : String = "^Leave the application and go back to the Neohome hub page."; 		
		public var APPLICATION_CONTROL_BAR_VIEW_OPTIONS_BUTTON_TOOLTIP : String = "^Change your Neohome options."; 		
		public var APPLICATION_CONTROL_BAR_VIEW_UNDO_BUTTON_TOOLTIP : String = "^Undo your last change."; 		
		public var APPLICATION_CONTROL_BAR_VIEW_REDO_BUTTON_TOOLTIP : String = "^Redo your last undo."; 		
		public var APPLICATION_CONTROL_BAR_VIEW_MINIMIZE_BUTTON_TOOLTIP : String = "^Minimise the control panel."; 		
		public var APPLICATION_CONTROL_BAR_VIEW_MAXIMIZE_BUTTON_TOOLTIP : String = "^Maximise the control panel."; 
		// compass		
		public var ZOOM_IN_TOOLTIP : String = "^Zoom in.";		
		public var ZOOM_OUT_TOOLTIP : String = "^Zoom out.";		
		public var GO_INTERIOR_TOOLTIP : String = "^View the inside of your Neohome.";		
		public var GO_EXTERIOR_TOOLTIP : String = "^View the outside of your property.";		
		//allItemsView --------------------------------------------		
		//titlebar		
		public var ALL_ITEMS_VIEW_LABEL : String = "^Neohome Inventory";		
		//allItemsSort		
		public var ALL_ITEMS_VIEW_SORT_SEARCH_TOOLTIP : String = "^Enter search string to filter items by title.";		
		public var ALL_ITEMS_VIEW_SORT_SEARCH_VALUE : String = "^Enter Search String...";		
		//propertyView --------------------------------------------		
		public var PROPERTY_VIEW_LABEL : String = "^My Neohome";		
		public var PROPERTY_VIEW_PREVIEW_BUTTON_LABEL : String = "^Preview";		
		public var PROPERTY_VIEW_PREVIEW_BUTTON_TOOLTIP : String = "^Preview your current Neohome as a guest would see it.";		
		public var PROPERTY_VIEW_EDIT_BUTTON_TOOLTIP : String = "^Go back to editing your Neohome.";		
		public var PROPERTY_VIEW_MUTE_BUTTON_TOOLTIP : String = "^Turn off all sounds in your Neohome.";		
		public var PROPERTY_VIEW_UNMUTE_BUTTON_TOOLTIP : String = "^Turn on all sounds in your Neohome.";		
		// show floor (future release)
		
		public var PROPERTY_VIEW_UI_BAR_SHOW_FLOORS_TOOLTIP : String = "^Select which floor to show."; 		
		//compass navigation		
		public var PROPERTY_VIEW_UI_ROTATE_CLOCKWISE_BUTTON_TOOLTIP : String = "^Spin the property counter-clockwise.";		
		public var PROPERTY_VIEW_UI_ROTATE_COUNTERCLOCKWISE_BUTTON_TOOLTIP : String = "^Spin the property clockwise.";		
		//		
		public var PROPERTY_VIEW_UI_TRANSLATE_UP_BUTTON_TOOLTIP : String = "^Move the property up.";		
		public var PROPERTY_VIEW_UI_TRANSLATE_DOWN_BUTTON_TOOLTIP : String = "^Move the property down.";		
		public var PROPERTY_VIEW_UI_TRANSLATE_LEFT_BUTTON_TOOLTIP : String = "^Move the property left.";		
		public var PROPERTY_VIEW_UI_TRANSLATE_RIGHT_BUTTON_TOOLTIP : String = "^Move the property right.";		
		public var PROPERTY_VIEW_UI_CENTER_BUTTON_TOOLTIP : String = "^Centre the property.";		
		
		//selectedItemControlBarView --------------------------------------------		
		
		public var SELECTED_ITEM_CONTROL_BAR_VIEW_RAISE_BUTTON_TOOLTIP : String = "^Raise the selected item.";		
		public var SELECTED_ITEM_CONTROL_BAR_VIEW_LOWER_BUTTON_TOOLTIP : String = "^Lower the selected item.";		
		//		
		public var SELECTED_ITEM_CONTROL_BAR_VIEW_ROTATE_CLOCKWISE_BUTTON_TOOLTIP : String = "^Rotate the selected item counter-clockwise.";		
		public var SELECTED_ITEM_CONTROL_BAR_VIEW_ROTATE_COUNTERCLOCKWISE_BUTTON_TOOLTIP : String = "^Rotate the selected item clockwise.";		
		
		//metersView ----------------------------------------------		
		
		//**************************************************************************************************		
		//ERRORS		
		//**************************************************************************************************		
		public var ERROR_AMFPHP_GENERIC : String = "^An error has occurred.";		
		public var ERROR_SUFFIX_FATAL : String = " ^Please refresh your browser and try again later.";		
		public var ERROR_SUFFIX_NON_FATAL : String = " ^Please close this prompt and continue. If errors continue, try to refresh your browser and try again later.";		
		public var ERROR_STARTUP_FULLNESS_EXCEEDED : String = " ^Your Neohome is too full.";		
		public var ERROR_ADD_FULLNESS_EXCEEDED : String = " ^Cannot complete transaction: Your Neohome is too full.";		
		public var ERROR_SAVE_FULLNESS_EXCEEDED : String = " ^Cannot save Neohome: Your Neohome is too full.";		
		public var HOME_TOO_FULL : String = "Yikes! The Neohome you are about to visit is very full and it may take a long time to load. If you have a slow computer you might not want to visit this Neohome."
		//**************************************************************************************************		
		//OPTIONS		
		//**************************************************************************************************		
		public var OPTIONS_VIEW_TITLE : String = "OPTIONS";		
		public var OPTIONS_VIEW_DISPLAY_TITLE : String = "Display";		
		public var OPTIONS_VIEW_DISPLAY_ON : String = "on";		
		public var OPTIONS_VIEW_DISPLAY_OFF : String = "off";		
		public var OPTIONS_VIEW_DISPLAY_WALLS : String = "Walls";		
		public var OPTIONS_VIEW_DISPLAY_ANIMATION : String = "Animation";		
		public var OPTIONS_VIEW_DISPLAY_SHADOW : String = "Shadow";		
		public var OPTIONS_VIEW_DISPLAY_ITEMS : String = "Items";		
		public var OPTIONS_VIEW_PRIVACY_TITLE : String = "Privacy";		
		public var OPTIONS_VIEW_PRIVACY_VIEWABLE : String = "Neohome viewable to:";		
		public var OPTIONS_VIEW_PRIVACY_EVERYONE : String = "Everyone";		
		public var OPTIONS_VIEW_PRIVACY_ONLY_FRIENDS : String = "Only Neo Friends";		
		public var OPTIONS_VIEW_PRIVACY_ONLY_VIP : String = "Only VIP Neo Friends";		
		public var OPTIONS_VIEW_PRIVACY_NONE : String = "None";		
		public var OPTIONS_VIEW_NOTE : String = "Note: If you are having performance issues, please try turning off some of the display options";
		
		public var PROMPT_CHGVIEW_NOSAVE_TITLE : String = "^Change View";		
		public var PROMPT_CHGVIEW_NOSAVE_BODY : String = "^You have unsaved changes. Do you want to continue without saving?";
		public var MESSAGE_ILLEGAL_DRAG_DROP : String = "^You can't place an item there!";
		public var MESSAGE_SAVE_CANCELLED : String = "^Save canceled.";
		public var MESSAGE_EXIT_APP : String = "^Warning: You are about to exit this application. You should save your NeoHome before you leave!";
		
			
		public var PROMPT_YES_BUTTON_LABEL : String = "^Yes";		
		public var PROMPT_NO_BUTTON_LABEL : String = "^No";	
		
		// storage shed
		public var STORAGE_SHED : String = "^Storage Shed";
		public var TOOLTIP_SEARCH : String = "Enter some keywords, then press the magnifying glass to search.";
		public var SEARCHBOX_SEARCH : String = "^Search";
		public var SHOW_ALL : String = "^Show All";
		public var MESSAGE_SAVE_SUCCESS : String = "^Save was succsesful.";
		public var MESSAGE_ITEM_ADDED_TO_INVENTORY : String = "%1  has been added to inventory";
		public var TOOLTIPS_NEOPET : String = "Neopets";
		public var TOOLTIP_MATERIALS : String = "Materials";
		public var TOOLTIP_ITEMS : String = "Furniture";
		public var GENERAL_NEOPET : String = "^(Neopet)";
		public var GENERAL_RARITY_INDEX : String = "^Rarity Index: %1";
		public var GENERAL_SPECIES : String = "Species: %1";
		
		//added 10/07/08
		public var PROMPT_SAVE_SNAP_TITLE: String = "^Save Snapshot";
		public var MESSAGE_SAVE_SNAP : String = "^Do you want to save this picture as the default view of your Neohome?";
		public var TOOLTIP_SNAPSHOT : String = "^Click here to take a snapshot"
		public var TOOLTIP_EXIT_SNAPSHOT : String = "^Exit snapshot mode"
		public var TOOLTIP_SNAPSHOT_MODE : String = "^Take a picture of your Neohome."
		
	}
}
