// This class holds useful math functions such as conversions.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.util.general
{
	
	public class MathUtils {
		protected static const _degreesPerRadian:Number = 180/Math.PI;
		protected static const _radiansPerDegree:Number = Math.PI/180;
		
		// Angle conversion functions
		
		public static function degreesToRadians(deg:Number):Number {
			return _radiansPerDegree * deg;
		}
		
		public static function radiansToDegrees(rad:Number):Number {
			return _degreesPerRadian * rad;
		}
		
		// Number selection functions
		
		// limits a value to within a given range.
		
		public static function constrain(min:Number,val:Number,max:Number):Number {
			if(val < min) return min;
			if(val > max) return max;
			return val;
		}
		
		// returns value furthers from 0.
		
		public static function mostExtreme(n1:Number,n2:Number):Number {
			if(Math.abs(n1) > Math.abs(n2)) return n1;
			else return n2;
		}
		
		// returns value closest to 0.
		
		public static function leastExtreme(n1:Number,n2:Number):Number {
			if(Math.abs(n1) < Math.abs(n2)) return n1;
			else return n2;
		}
		
	}
}