package com.neopets.games.marketing.destination.sixFlags2010.pages
{
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class SixFlags2010QuestPage extends AbsPageWithBtnState
	{
		
		public var quest_meter:MovieClip;
		public var quest_board:MovieClip;
		public var popsicle_logo:MovieClip;
		public var quest_logo:MovieClip;
		//controls
		public var scroller_scrub:MovieClip;
		public var scrollUp_btn:MovieClip;
		public var scrollDown_btn:MovieClip;
		public var instructions_btn:MovieClip;
		public var next_btn:MovieClip;
		public var prev_btn:MovieClip;
		
		public var close_btn:MovieClip;

		public function SixFlags2010QuestPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
		}
	}
}