package com.neopets.util.video
{
	
	import flash.display.MovieClip;
	
	/**
	 *  This TrailerPlayer doesn't need an instance of MenuManager to work. It's particulary useful to plug in old or tthird party sponsored games.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Viviana Baldarelli
	 *	@since 8 Oct 2009
	*/	
	public class NPTrailerPlayer_standalone extends NPTrailerPlayer
	{
		
		private var _objRoot:MovieClip;
		
		
		public function NPTrailerPlayer_standalone(objRoot:MovieClip)
		{
			super();
			_objRoot = objRoot;
		}
		
		
		/**
		* @Note: True if the game is on live server
		*/  
		override public function get isOnLive():Boolean {
			var sVars:Array = _objRoot.loaderInfo.loaderURL.split("/");
			for (var i:int = 0; i < sVars.length; i ++) {
				trace ("getting flashvars: "+sVars[i]);
				switch (sVars[i]) {
					case "images.neopets.com": return true;
					case "www.neopets.com": return true;
					case "file:": return true;
				}
			}
			return false;
		}
	}
}