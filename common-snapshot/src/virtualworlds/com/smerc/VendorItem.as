package virtualworlds.com.smerc
{	
	import virtualworlds.com.neopets.games.petpetpark.util.PppObject;
	
	
	
	/**
	* A class representation of the database table that maps vendors to items *AND* it includes the actual item and vendor!
	* 
	* @author Bo
	*/
	public class VendorItem extends PppObject
	{
		public static const VENDORID:String = "vendorId";
		public static const ITEMID:String = "id";
		public static const MARKUP:String = "markup";
		public static const INITIALQUANTITY:String = "initialQuantity";
		public static const RESTOCKFREQUENCY:String = "restockFrequency";
		public static const RESTOCKQUANTITY:String = "restockQuantity";
		public static const MAXIMUMQUANTITY:String = "maximumQuantity";
		public static const ITEM:String = "item";
		
		public function VendorItem()
		{
			super();
			
			this.addAttributeName(VendorItem.VENDORID);
			this.addAttributeName(VendorItem.ITEMID);
			this.addAttributeName(VendorItem.MARKUP);
			this.addAttributeName(VendorItem.INITIALQUANTITY);
			this.addAttributeName(VendorItem.RESTOCKFREQUENCY);
			this.addAttributeName(VendorItem.RESTOCKQUANTITY);
			this.addAttributeName(VendorItem.MAXIMUMQUANTITY);
			this.addAttributeName(VendorItem.ITEM);
			
		}//end VendorItem()
		
		public function getItem():Item
		{
			return this.getAttribute(VendorItem.ITEM) as Item;
		}//end getItem()
		
		public function setVendorId(a_vendorId:int):void
		{
			this.setAttribute(VendorItem.VENDORID, a_vendorId);
		}//end setVendorId()
		
		/**
		 * @inheritDoc PppObject#deserializeFrom()
		 * 
		 * @param	a_serializedObj
		 */
		override public function deserializeFrom(a_serializedObj:Object):void
		{
			var item:Item;
			
			// Build our item
			item = new Item();
			item.deserializeFrom(a_serializedObj);
			_attribs[VendorItem.ITEM] = item;
			
			for (var i:int = 0; i < _attributeNames.length; i++)
			{
				var myAttrib:String = _attributeNames[i] as String;
			//for (var myAttrib:String in _attribs)
			//{
				if (undefined == a_serializedObj[myAttrib])
				{
					continue;
				}
				
				switch(myAttrib)
				{
					case VendorItem.VENDORID:
					case VendorItem.ITEMID:
					case VendorItem.INITIALQUANTITY:
					case VendorItem.RESTOCKFREQUENCY:
					case VendorItem.RESTOCKQUANTITY:
					case VendorItem.MAXIMUMQUANTITY:
						this.setAttribute(myAttrib, new int(a_serializedObj[myAttrib]));
						break;
					
					case VendorItem.MARKUP:
						this.setAttribute(myAttrib, new Number(a_serializedObj[myAttrib]));
						break;
					
					default:
						this.setAttribute(myAttrib, a_serializedObj[myAttrib]);
						break;
				}
			}
			
		}//end deserializeFrom()
		
	}//end class VendorItem
	
}//end package com.smerc.ppa.core.objects
