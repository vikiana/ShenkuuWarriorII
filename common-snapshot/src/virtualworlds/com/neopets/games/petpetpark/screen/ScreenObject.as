package virtualworlds.com.neopets.games.petpetpark.screen
{	
	import mx.utils.NameUtil;
	
	import virtualworlds.helper.Fu.BaseClasses.UIDisplayObject;

	public class ScreenObject extends UIDisplayObject
	{
		public var id:String
		
		public function ScreenObject()
		{
			super();
			
			id = NameUtil.createUniqueName(this);
		}
		
		override public function activated():void 
		{
			super.activated();
		}
	}
}