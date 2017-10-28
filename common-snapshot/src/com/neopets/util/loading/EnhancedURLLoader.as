package com.neopets.util.loading
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class EnhancedURLLoader extends URLLoader
	{
		
		public var mID:String;
		
		public function EnhancedURLLoader(pID:String = "",request:URLRequest=null)
		{
			//TODO: implement function
			mID = pID;
			super(request);
		}
		
	}
}