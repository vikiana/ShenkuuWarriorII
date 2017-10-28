package virtualworlds.com.neopets.games.petpetpark.util
{
	import flash.utils.getQualifiedClassName;
	
	import virtualworlds.helper.Fu.BaseClasses.UpdateableObject;
	
	public class ProfileInformation extends UpdateableObject
	{	
		public var characterName:String;
		public var tickets:String;
		public var agility:int;
		public var memory:int;
		public var charm:int;
		
		public var mood:String;
		
		public var likeOne:String;
		public var likeTwo:String;
		public var dislikeOne:String;
		public var dislikeTwo:String;
		
		public var species:String;
		public var color:String;
		public var gender:String;
		public var species_url:String;
		public var creation_date:Number;
		public var accountName:String;		
		
		
		public function ProfileInformation() 
		{
			
		}
		
		override public function toString():String
		{
			var myQName:String = getQualifiedClassName(this);
			
			var myStringRep:String;
			
			var myAttribs:Array = 	[	{name:"characterName", value:characterName }, 
										{name:"tickets", value:tickets }, 
										{name:"agility", value:agility }, 
										{name:"memory", value:memory }, 
										{name:"charm", value:charm}, 
										{name:"mood", value:mood}, 
										{name:"likeOne", value:likeOne}, 
										{name:"likeTwo", value:likeTwo}, 
										{name:"dislikeOne", value:dislikeOne}, 
										{name:"dislikeTwo", value:dislikeTwo}, 
										{name:"species", value:species}, 
										{name:"color", value:color}, 
										{name:"gender", value:gender}, 
										{name:"species_url", value:species_url }, 
										{name:"creation_date", value:creation_date}, 
									];
			
			myStringRep = "[ " + myQName + " ("
			
			var assetList:String = "";
			
			var tmpAttribObj:Object;
			
			for (var i:int = 0; i < myAttribs.length; i++)
			{
				tmpAttribObj = myAttribs[i];
				assetList += (" " + tmpAttribObj.name + "=" + tmpAttribObj.value);
			}
			
			myStringRep += (assetList + " ) ]");
			
			return myStringRep;
			
		}//end toString()
	}
}


