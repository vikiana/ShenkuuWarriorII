package com.neopets.games.marketing.destination.altadorbooth2011.pages
{
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ErrorPopup extends AbsPageWithBtnState
	{
		
		public var message_txt:TextField;
		public var close_btn:MovieClip;
		
		public function ErrorPopup(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
		}
	}
}