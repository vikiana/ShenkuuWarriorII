package com.neopets.games.inhouse.shootergame.utils {
	
	/**
	*	This Math utilities class. Static.
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*	
	*	@author Viviana Baldarelli
	* 	@since  05.22.2009
	*/
	public class Mathematic {

		/* Radians to degrees */
		public static function toDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}

		/* Degrees to radians */
		public static function fromDegrees(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		//-------------------------------------------------------------------------
		public static function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random()*(max-min+1))+min;
			return randomNum;
		}
		
		
		//-------------------------------------------------------------------------
		public static function magicTrigFunctionX(pointRatio:Number):Number {
			return Math.sin(pointRatio * 2 * Math.PI);
		}
		public static function magicTrigFunctionY(pointRatio:Number):Number {
			return Math.cos(pointRatio * 2 * Math.PI);
		}
		
		//------------------------------------------------------------------------
		public static function isDivisible(numA:Number, numB:Number):Boolean {
			var isIt:Boolean;
			if (numA/numB == Math.floor (numA/numB)) {
				isIt = true;
			} else {
				isIt = false;
			}
			return isIt;
		}
	}
}