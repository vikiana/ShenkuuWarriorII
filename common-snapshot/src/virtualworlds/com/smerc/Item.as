package virtualworlds.com.smerc
{
	import virtualworlds.com.neopets.games.petpetpark.util.PppObject;
	
	
	/**
	* Object used for Deserializing [vendor] Item objects from a PetPetPark SmartFoxServer.
	* Specifically, this is an attribute of a VendorItem.
	* 
	* @author Bo
	* 
	* @see VendorItem
	*/
	public class Item extends PppObject
	{
		
		public static const ID:String = "id";
		public static const NAME:String = "name";
		public static const DESCRIPTION:String = "description";
		public static const COST:String = "cost";
		public static const ITEMSWF:String = "swf_url";
		public static const THUMBNAIL:String = "thumb_url";
		public static const MOOD:String = "mood";
		public static const AGILITY:String = "agility";
		public static const CHARM:String = "charm";
		public static const MEMORY:String = "memory";
		public static const NUMBER_PER_INVENTORY_SLOT:String = "number_per_inventory_slot";
		public static const EXPIRATION_TYPE:String = "expirationtype";
		
		public function Item()
		{
			super();
			
			this.addAttributeName(Item.ID);
			this.addAttributeName(Item.NAME);
			this.addAttributeName(Item.DESCRIPTION);
			this.addAttributeName(Item.COST);
			this.addAttributeName(Item.ITEMSWF);
			this.addAttributeName(Item.THUMBNAIL);
			this.addAttributeName(Item.MOOD);
			this.addAttributeName(Item.AGILITY);
			this.addAttributeName(Item.CHARM);
			this.addAttributeName(Item.MEMORY);
			this.addAttributeName(Item.NUMBER_PER_INVENTORY_SLOT);
			this.addAttributeName(Item.EXPIRATION_TYPE);
			
        }//end Item() constructor.
		
		public function getName():String
		{
			return this.getAttribute(Item.NAME) as String;
		}//end getName()
		
		public function getItemSwf():String
		{
			return this.getAttribute(Item.ITEMSWF) as String;
		}
		public function getItemID():Number
		{
			return this.getAttribute(Item.ID) as Number;
		}
		
		/**
		 * @inheritDoc PppObject#deserializeFrom()
		 * 
		 * @param	a_serializedObj
		 */
		override public function deserializeFrom(a_serializedObj:Object):void
		{
			for (var i:int = 0; i < _attributeNames.length; i++)
			{
				var myAttrib:String = _attributeNames[i] as String;
			//for (var myAttrib:String in _attribs)
			//{
				if (undefined == a_serializedObj[myAttrib])
				{
					continue;
				}
				
				//
				
				switch(myAttrib)
				{
					case Item.NAME:
					case Item.DESCRIPTION:
					case Item.ITEMSWF:
					case Item.THUMBNAIL:
					case Item.MOOD:
					case Item.EXPIRATION_TYPE:
						this.setAttribute(myAttrib, new String(a_serializedObj[myAttrib]));
						break;
					
					case Item.ID:
					case Item.AGILITY:
					case Item.CHARM:
					case Item.MEMORY:
					case Item.NUMBER_PER_INVENTORY_SLOT:
						this.setAttribute(myAttrib, new int(a_serializedObj[myAttrib]));
						break;
					
					case Item.COST:
						this.setAttribute(myAttrib, new Number(a_serializedObj[myAttrib]));
						break;
					
					default:
						this.setAttribute(myAttrib, a_serializedObj[myAttrib]);
						break;
				}
			}
			
		}//end deserializeFrom()
		
	}//end class Item
	
}//end package com.smerc.ppa.core.objects
