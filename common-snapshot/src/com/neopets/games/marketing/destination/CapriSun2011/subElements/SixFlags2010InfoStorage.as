package com.neopets.games.marketing.destination.sixFlags2010.subElements
{
	public class SixFlags2010InfoStorage
	{
		public var id:String
		public var webURL:String
		public var imageURL:String
		public var topText:String;
		public var bottomText:String;
		
		public function SixFlags2010InfoStorage(pID:string, pWeb:String,pImage:String,pTopT:String,pBotT:String)
		{
			id = pID;
			webURL = pWeb;
			imageURL = pImage;
			topText = pTopT;
			bottomText = pBotT;
		}
	}
}