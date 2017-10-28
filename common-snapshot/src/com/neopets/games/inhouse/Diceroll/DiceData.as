package com.neopets.games.inhouse.Diceroll
{
	
	
	 
	public class DiceData extends Object {
		
		private static const _instance:Object = new DiceData( SingletonEnforcer ); 
		
		public var diceRemaining: Number = 99;
		public var tier: Number = 99;
		public var prize1name: String = "none";
		public var prize2name: String = "none";
		public var prizeBname: String = "none";
		public var prize1oii: Number = 99;
		public var prize2oii: Number = 99;
		public var prizeBoii: Number = 99;
		public var prize1url: String = "none";
		public var prize2url: String = "none";
		public var prizeBurl: String = "none";
		
		public var rollID: Number = 1;
		
		public var lang: String = "EN";
		
		public static function get instance():Object
		{ 
			return _instance;
			
		} 
		
		
	
		public function DiceData(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use DiceData.instance." ); 
			}			
		}
	
	}
	
	
}
internal class SingletonEnforcer{}