package com.neopets.games.inhouse.shootergame.overlays
{
	import com.neopets.games.inhouse.shootergame.abstract.AbstractOverlay;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 *	Warning Overlay Class.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.20.2009
	 */
	public class WarningOverlay extends AbstractOverlay
	{
		
		public var message_txt:TextField;
		
		public function WarningOverlay(gs:MovieClip)
		{
			super(gs);
			cacheAsBitmap = true;
		}
		
	}
}