package com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.pages
{
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class WallpapersPage extends AbsPageWithBtnState
	{
		
		
		public var close_btn:MovieClip;
		
		public var w1_800_btn:MovieClip;
		public var w1_1024_btn:MovieClip;
		public var w2_800_btn:MovieClip;
		public var w2_1024_btn:MovieClip;
		
		public function WallpapersPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
		}
		
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndStop("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFF00, 1, 16, 16, 2, 3)]
			}
		}
	}
}