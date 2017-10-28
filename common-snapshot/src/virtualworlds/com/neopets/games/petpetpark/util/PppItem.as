package virtualworlds.com.neopets.games.petpetpark.util
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.Security;
	
	import virtualworlds.com.neopets.games.petpetpark.vo.ItemVO;
	import virtualworlds.helper.Fu.Helpers.ComplexLoader;
	
	
	/**
	 * Visible reprentation of an item in Petpet Park
	 * @author Smerc
	 */
	public class PppItem extends MovieClip
	{
		
		//ResourceManagerProxy should set this
		public static var itemAssetBaseURL:String; 
		
		/**
		 * Item Type: hairstyle.
		 * 
		 * @default ink
		*/
		public static var ITEM_TYPE_HAIRSTYLE : String = "hairstyle";
		/**
		 * Item Type: ink bottle.
		 * 
		 * @default ink
		*/
		public static var ITEM_TYPE_INK : String = "ink";
		
		/**
		 * Item Type: grooming.
		 * 
		 * @default grooming
		*/
		public static var ITEM_TYPE_GROOMING : String = "grooming";
		
		/**
		 * Item Type: shampoo.
		 * 
		 * @default shampoo
		*/
		public static var ITEM_TYPE_SHAMPOO : String = "shampoo";
	
		/**
		 * Item Type: Clothing.
		 * 
		 * @default clothes
		*/
		public static var ITEM_TYPE_CLOTHES : String = "clothes";
	
		/**
		 * Item Type: General Spa item.
		 * 
		 * @default spa
		*/
		public static var ITEM_TYPE_SPA : String = "spa";
		
		/**
		 * Item Type: General quest item.
		 * 
		 * @default quest
		*/
		public static var ITEM_TYPE_QUEST : String = "quest";
	
		/**
		 * Item Type: Food item.
		 * 
		 * @default food
		*/
		public static var ITEM_TYPE_FOOD : String = "food"; 
		
		/**
		 * Item Type: beard.
		 * 
		 * @default beard
		*/
		public static var ITEM_TYPE_BEARD : String = "beard"; 

		/**
		 * Item Type: Petpetpet.
		 * 
		 * @default petpetpet
		*/
		public static var ITEM_TYPE_PETPETPET : String = "petpetpet"; 

		/**
		 * Item Type: book.
		 * 
		 * @default book
		*/
		public static var ITEM_TYPE_BOOK : String = "book"; 


		public var itemVO:ItemVO = new ItemVO();
	
		//private members
	/*	private var _accounttoitem_id:int;
		private var _item_id:int;
		private var _itemName:String;
		private var _itemtype_id:int;
		private var _in_use:int;
		private var _itemtype:String;
		private var _description:String;
		private var _cost:int;
		private var _number_per_inventory_slot:int;
		private var _charm:int;
		private var _agility:int;
		private var _memory:int;
		private var _swf_url:String;
		private var _thumb_url:String;
		private var _instance_id:int;
		private var _perishable:Boolean;
		private var _location:String;
		
		private var _imgLoaded:Boolean;*/
		
		
		/**
		 * Constructor
		 * @param	a_obj Object Contains all the data on the item
		 */
		public function PppItem(a_obj:Object) 
		{
			if(a_obj is PppItem)
			{
				itemVO = ItemVO(a_obj.itemVO);
			}
			else if(a_obj is ItemVO)
			{
				itemVO = ItemVO(a_obj);
			}
			else
			{
				itemVO.accountToItemID = a_obj.accounttoitem_id;
				itemVO.itemID = a_obj.item_id;
				itemVO.itemName = a_obj.name;
				itemVO.numberPerInventorySlot = a_obj.number_per_inventory_slot;
				itemVO.charm = a_obj.charm;
				itemVO.agility = a_obj.agility;
				itemVO.memory = a_obj.memory;
				itemVO.description = a_obj.description;
				itemVO.itemType = a_obj.itemtype; 
				itemVO.inUse = a_obj.in_use;
				itemVO.itemTypeID = parseInt(a_obj.itemtype_id);
				itemVO.instanceID = a_obj.instance_id;
				itemVO.cost = a_obj.cost;
				itemVO.perishable = a_obj.perishable == 1;
				itemVO.location = a_obj.location_name;
				itemVO.quantity = a_obj.quantity;
				itemVO.swfURL = itemAssetBaseURL +  a_obj.swf_url;
				itemVO.petpetID = a_obj.pp_id;
				
				itemVO.isNCMallItem = a_obj.isNCMallItem;

				itemVO.conceals = a_obj.conceals; // ~conceals 09/09
				//itemVO.zones = a_obj.zones; // ~conceals 09/09 zones is location

				if(a_obj.swf_url && a_obj.swf_url.indexOf("assets/") == -1 ){
				itemVO.swfURL = itemAssetBaseURL + "assets/" +  a_obj.swf_url; 
				}
				
				if(a_obj.thumb_url != null)
				{
					itemVO.thumbURL = itemAssetBaseURL + a_obj.thumb_url;
				
					if(a_obj.thumb_url && a_obj.thumb_url.indexOf("assets/") == -1 ){
						itemVO.thumbURL = itemAssetBaseURL + "assets/" +  a_obj.thumb_url; 
					}
				}
				else
				{
					itemVO.thumbURL = null
				}
				
				itemVO.imgLoaded = false;
			}
			
			Security.allowDomain("*"); //Arvind - 05/21/09
			
			var loader:ComplexLoader;
			
			if (itemVO.thumbURL != null && itemVO.thumbURL != "")
				loader = new ComplexLoader(itemVO.thumbURL);
			else
				loader = new ComplexLoader(itemVO.swfURL);
				
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
				
			loader.load();
		}
		
		
		
		
		/**
		 * Event Handler for the item swf is loaded
		 * @private
		 * @param	evt
		 */
		private function swfLoaded(evt:Event):void 
		{
			var bitmap:Bitmap = Bitmap(evt.currentTarget.content);
			bitmap.smoothing = true;
			addChild(bitmap);
			itemVO.imgLoaded = true;
			dispatchEvent(evt);
		}
		
	}//end class PppItem
	
}//end package ppp.core
