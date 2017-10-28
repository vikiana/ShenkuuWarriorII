package com.neopets.games.inhouse.shootergame.utils
{
	/**
	 *	Collection of static utilities for Arrays.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.20.2009
	 */
	public class ArrayUtils
	{
		
		//------------------------------------------------------------------------------------------------------
		public static function shuffle(array:Array, startIndex:int = 0, endIndex:int = 0):Array{
			if(endIndex == 0) endIndex = array.length-1;
			for (var i:int = endIndex; i>startIndex; i--) {
				var randomNumber:int = Math.floor(Math.random()*endIndex)+startIndex;
				var tmp:* = array[i];
				array[i] = array[randomNumber];
				array[randomNumber] = tmp;
			}
			return array;
		}
	}
}