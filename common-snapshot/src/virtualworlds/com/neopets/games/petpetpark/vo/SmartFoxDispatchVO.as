package virtualworlds.com.neopets.games.petpetpark.vo
{
	public class SmartFoxDispatchVO
	{
		public var cmd:String;
		public var msg:Object = {};
		public var extensionName:String = "PPPExtension";
		//public var onResponse:Function;
		
		public function SmartFoxDispatchVO(p_cmd:String = null, p_msg:Object = null)
		{
			cmd = p_cmd;
			if(p_msg) 
			{
				msg = p_msg;
			}
			else 
			{
				msg = {};
			}
		}

	}
}