package com.neopets.games.inhouse.shootergame.abstract
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 *	Base Class for all overlays.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.25.2009
	 */
	public class AbstractOverlay extends MovieClip
	{
		
		protected var _GAMINGSYSTEM:MovieClip;
		

		/**
		 * 
		 * Constructor
		 * 
		 * @param       gs    Gaming System: to access translations and sounds
		 * 
		 */
		public function AbstractOverlay(gs:MovieClip)
		{
			super();
			_GAMINGSYSTEM = gs;
			tabIndex =  getChildIndex(getChildByName("message_txt"));
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		public function setText(tf:TextField, message:String, fontName:String):void {
			var translated:String = _GAMINGSYSTEM.getTranslation (message);
			_GAMINGSYSTEM.setFont( fontName );
			_GAMINGSYSTEM.setTextField(tf, translated );
		}
		
		public function cleanUp ():void {
			_GAMINGSYSTEM = null;
		}
	}
}