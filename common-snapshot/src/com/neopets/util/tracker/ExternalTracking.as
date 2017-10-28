package com.neopets.util.tracker
{
	import flash.external.ExternalInterface;

	public class ExternalTracking
	{
		public function ExternalTracking()
		{
		}
		
		public static function track (trackingFunction:String, ...rest):void{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(trackingFunction, rest);	
			}
			else
			{
				trace("ExternalInterfaceCall Not Available");
			}
		}
	}
}