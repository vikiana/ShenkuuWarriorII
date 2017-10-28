package virtualworlds.net.vo
{
	import flash.net.registerClassAlias;

	public class ExampleVO
	{
		
		/**
		 * Registers this VO as a remote class.
		*/
		public static function register( ):void
		{		
			registerClassAlias("ExampleService.ExampleVO", virtualworlds.net.vo.ExampleVO);		
		}

	}
}