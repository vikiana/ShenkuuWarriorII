/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase.loadedData
{
	import com.neopets.marketing.collectorsCase.NameGenerator;
	import com.neopets.util.general.GeneralFunctions;
	import virtualworlds.lang.TranslationManager;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	//import com.neopets.marketing.collectorsCase.DebugTracer;
	
	/**
	 *	This class holds the info for a single collector's case item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class ItemData extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const IMAGE_DIRECTORY:String = "/ncmall/collectibles/";
		public static const TOTAL_CHANGED:String = "total_changed";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _itemName:String;
		protected var _IDNumber:int;
		protected var _iconURL:String;
		protected var _imprintURL:String;
		protected var _itemTotal:int;
		protected var _releaseDate:Date;
		protected var _monthName:String;
		protected var _imageURL:String;
		protected var _description:String;
		protected var _isForSale:Boolean;
		protected var _teaserShown:Boolean;
		protected var _isBonusItem:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ItemData():void{
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isBonusItem():Boolean { return _isBonusItem; }
		
		public function get description():String { return _description; }
		
		public function get iconURL():String { return _iconURL; }
		
		public function get IDNumber():int { return _IDNumber; }
		
		public function get imprintURL():String { return _imprintURL; }
		
		public function get imageURL():String { return _imageURL; }
		
		public function get isForSale():Boolean { return _isForSale; }
		
		public function get itemName():String { return _itemName; }
		
		public function get itemTotal():int { return _itemTotal; }
		
		public function set itemTotal(val:int) {
			_itemTotal = val;
			dispatchEvent(new Event(TOTAL_CHANGED));
		}
		
		public function get monthName():String { return _monthName; }
		
		public function get releaseDate():Date { return _releaseDate; }
		
		public function get teaserShown():Boolean { return _teaserShown; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function creates a random icon url for testing purposes.
		 */
		 
		public function getRandomIcon() {
			var index:int = Math.ceil(Math.random() * 4);
			return "/items/cardboard_petpet_"+index+".gif";
		}
		
		/**
		 * @This function provides default values for offline testing.
		 */
		 
		public function useTestValues():void {
			// name item
			var namer:NameGenerator = new NameGenerator();
			_itemName = namer.createName();
			// add description text
			_description = namer.createParagraph(180);
			// set item release date
			var month:int = Math.floor(Math.random()*12);
			var year:int = 2008 + Math.floor(Math.random() * 3);
			var day:int = Math.ceil(Math.random()*28);
			_releaseDate = new Date(year,month,day);
			_monthName = "Month_" + month;
			// check if the item has already been released
			var cur_date:Date = new Date();
			if(_releaseDate.time <= cur_date.time) {
				// item released
				_itemTotal = Math.round(Math.random() * 3);
				_isForSale = true;
				_teaserShown = true;
			} else {
				// item hasn't been released yet
				_itemTotal = 0;
				_isForSale = false;
				_teaserShown = (Math.random() < 0.5);
				_iconURL = null;
			}
			_iconURL = getRandomIcon();
			_imprintURL = "/items/gar_snowangel.gif";
			_imageURL = "/ncmall/hubrid-nox_herosvillians.gif";
			_isBonusItem = false;
		}
		
		/**
		 * @This function initializes our values from those of an unspecified data object.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function initFrom(info:Object, collectionName:String):void {
			if(info == null) return;
			_itemName = info.name;
			_IDNumber = int(Number(info.objInfoId));
			_isForSale = info.buyable;
			_teaserShown = Boolean(info.active);
			if("isBonus" in info) _isBonusItem = Boolean(Number(info.isBonus));
			if (_isBonusItem){
				setDate(info.month,info.year, collectionName);
			} else {
				setDate(info.month,info.year);
			}
			if(info.monthWord != null) _monthName = info.monthWord;
			_description = info.objDescription;
			if(info.totalCount !=  null) _itemTotal = int(Number(info.totalCount));
			else _itemTotal = 0;
		}
		
		/**
		 * @This function updates our values for a given user.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function initUser(info:Object):void {
			if(info == null) return;
			if(info.totalCount !=  null) _itemTotal = int(Number(info.totalCount));
		}
		
		/**
		 * @This function initializes our values from those of an unspecified data object.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function setDate(month:String,year:String, collectionName:String=""):void {
			// set up our image directory
			var dir:String;
			if (collectionName!=""){
				dir = IMAGE_DIRECTORY + "case/collections/"+collectionName;
			} else {
				dir = IMAGE_DIRECTORY + year + "_" + month;
			}
			// set our release date
			_releaseDate = new Date(month+"/01/20"+year);
			var trans:TranslationManager = TranslationManager.instance;
			_monthName = trans.getTranslationOf("IDS_MONTH_"+String(Number(month)));
			// set up asset urls
			_iconURL = dir + "/item.png";
			_imprintURL = dir + "/imprint.png";
			_imageURL = dir + "/nc-collectible.jpg";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}