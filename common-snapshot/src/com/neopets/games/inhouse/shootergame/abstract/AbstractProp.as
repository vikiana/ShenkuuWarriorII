package com.neopets.games.inhouse.shootergame.abstract
{
	import flash.display.MovieClip;
	
	/**
	 *	This the abstract class for all props, elements that can get hit but don;t have any reaction.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.6.2009
	 */
	public class AbstractProp extends MovieClip
	{
		
		/**
	 	*	Constructor
	 	*/
		public function AbstractProp()
		{
			super();
			cacheAsBitmap = true;
		}
	}
}