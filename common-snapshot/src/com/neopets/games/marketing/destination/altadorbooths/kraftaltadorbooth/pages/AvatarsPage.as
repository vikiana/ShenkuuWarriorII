package com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.pages
{
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class AvatarsPage extends AbsPageWithBtnState
	{
		
		public var close_btn:MovieClip;
		
		public var a1_aol_btn:MovieClip;
		public var a1_msn_btn:MovieClip;
		public var a2_aol_btn:MovieClip;
		public var a2_msn_btn:MovieClip;
		public var a3_aol_btn:MovieClip;
		public var a3_msn_btn:MovieClip;
		public var a4_aol_btn:MovieClip;
		public var a4_msn_btn:MovieClip;
		public var a5_aol_btn:MovieClip;
		public var a5_msn_btn:MovieClip;

		
		public function AvatarsPage(pName:String=null, pView:Object=null)
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