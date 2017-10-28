package com.neopets.games.marketing.destination.altadorbooths.common
{
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class NotLoggedinPopup extends AbsPageWithBtnState
	{
		
		public var message_txt:TextField;
		public var close_btn:MovieClip;
		
		public function NotLoggedinPopup(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			message_txt.htmlText = "<p>You must be logged in to participate in this activity!  Why not <a href='http://www.neopets.com/reg/'>login</a> or <a href='http://www.neopets.com/reg/index.phtml?destination=/index.phtml'>sign up</a>?</p>";
		}
	}
}