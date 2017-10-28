package com.neopets.games.inhouse.shootergame.overlays
{
	import com.neopets.games.inhouse.shootergame.abstract.AbstractOverlay;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 *	MidLevel Overlay Class.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.20.2009
	 */
	public class MidLevelOverlay extends AbstractOverlay
	{
		public var message_txt:TextField;	
	
		public function MidLevelOverlay(gs:MovieClip)
		{
			super(gs);
			cacheAsBitmap = true;
		}
	
	}
}