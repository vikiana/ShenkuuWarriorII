/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import virtualworlds.lang.TranslationData
	
	/**
	 *	This class is a simple movie clip shell with special handling for pop up events.
	 *  The class is similiar to a singleton in that there should generally only be one
	 *  in existance at a time.  You can have more that one of these layers, but only
	 *  the currently active layer will pick up new pop up requests.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	dynamic public class AppTranslationData extends TranslationData 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var IDS_DATE_OPEN_TAG:String = "<p align='center'><font size='16'>";
		
		// added in through amf-php call
		public var IDS_MONTH_1:String = "January";
		public var IDS_MONTH_2:String = "February";
		public var IDS_MONTH_3:String = "March";
		public var IDS_MONTH_4:String = "April";
		public var IDS_MONTH_5:String = "May";
		public var IDS_MONTH_6:String = "June";
		public var IDS_MONTH_7:String = "July";
		public var IDS_MONTH_8:String = "August";
		public var IDS_MONTH_9:String = "September";
		public var IDS_MONTH_10:String = "October";
		public var IDS_MONTH_11:String = "November";
		public var IDS_MONTH_12:String = "December";
		
		public var IDS_BONUS:String = "BONUS";
		
		public var IDS_NAME_OPEN_TAG:String = "<p align='center'><font size='16'>";
		
		public var IDS_DESC_OPEN_TAG:String = "<p align='center'><font size='16'>";
		
		public var IDS_BUTTON_OPEN_TAG:String = "<p align='center'><font size='16'>";
		
		public var IDS_ADD_BUTTON:String = "Add to Case";
		public var IDS_REMOVE_BUTTON:String = "Remove from Case";
		public var IDS_BUY_BUTTON:String = "Purchase at the NC Mall";
		
		public var IDS_CONFIRM_ADD:String = "Are you sure?  This will remove the item from your inventory.";
		public var IDS_CAN_NOT_ADD:String = "Oops. Looks like you don't have this item!";
		public var IDS_ITEM_REMOVED:String = "This item has been removed from your album and has been placed in your inventory.";
		
		public var IDS_YES:String = "Yes";
		public var IDS_NO:String = "No";
		public var IDS_CLOSE:String = "Okay";
		
		public var IDS_CLOSE_TAG:String = "</font></p>";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AppTranslationData():void{
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}