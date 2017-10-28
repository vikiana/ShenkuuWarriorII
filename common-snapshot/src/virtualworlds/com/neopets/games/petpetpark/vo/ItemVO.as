package virtualworlds.com.neopets.games.petpetpark.vo
{
	
	public class ItemVO
	{
	
		public var accountToItemID:int;
		public var instanceID:int;
		
		public var itemID:int;
		public var itemName:String;
		public var expirationtype:int;
		public var itemType:String;
		public var itemTypeID:int;
		
		public var inUse:int;
		public var location:String;
		
		public var perishable:Boolean;
		public var description:String;
		public var cost:int;
		public var quantity:int;
		
		public var numberPerInventorySlot:int;
		
		public var charm:int;
		public var agility:int;
		public var memory:int;
		
		public var swfURL:String;
		public var thumbURL:String;
		public var imgLoaded:Boolean;
		public var isNCMallItem : Boolean;
		
		public var petpetID:int;
		
		public var conceals:String; // ~conceals 09/09
		//public var zones:String; // ~conceals 09/09
		
		public var isInVault : Boolean;
		
		public function ItemVO()
		{
		}

		
	}
}