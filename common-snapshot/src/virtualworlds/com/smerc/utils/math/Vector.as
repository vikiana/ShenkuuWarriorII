/*
Copyright (c) 2006, 2007 Alec Cove

Permission is hereby granted, free of charge, to any person obtaining a copy of this 
software and associated documentation files (the "Software"), to deal in the Software 
without restriction, including without limitation the rights to use, copy, modify, 
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to the following 
conditions:

The above copyright notice and this permission notice shall be included in all copies 
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/* 
	TODO:
	- provide passible vectors for results. too much object creation happening here
	- review the division by zero checks/corrections. why are they needed?
*/
package virtualworlds.com.smerc.utils.math
{
	import flash.errors.IllegalOperationError;
	
	public class Vector
	{
		
		public var x:Number;
		public var y:Number;
	
	
		public function Vector(px:Number = 0, py:Number = 0) {
			x = px;
			y = py;
		}
				
		public function SetZero() : void { x = 0.0; y = 0.0; }
		public function Set(x_:Number=0, y_:Number=0) : void {x=x_; y=y_;};
		public function SetV(v:virtualworlds.com.smerc.utils.math.Vector) : void {x=v.x; y=v.y;};

		public function Negative():virtualworlds.com.smerc.utils.math.Vector { return new virtualworlds.com.smerc.utils.math.Vector(-x, -y); }
		
		static public function Make(x_:Number, y_:Number):virtualworlds.com.smerc.utils.math.Vector
		{
			return new virtualworlds.com.smerc.utils.math.Vector(x_, y_);
		}
		
		public function setTo(px:Number, py:Number):void {
			x = px;
			y = py;
		}
		
		
		public function copy(v:virtualworlds.com.smerc.utils.math.Vector):void {
			x = v.x;
			y = v.y;
		}
		
		public function Copy():virtualworlds.com.smerc.utils.math.Vector{
			return new virtualworlds.com.smerc.utils.math.Vector(x,y);
		}
		
		public function clone():virtualworlds.com.smerc.utils.math.Vector{
			return new virtualworlds.com.smerc.utils.math.Vector(x, y);
		}
		
		public function dot(v:virtualworlds.com.smerc.utils.math.Vector):Number {
			return x * v.x + y * v.y;
		}
		
		
		public function cross(v:virtualworlds.com.smerc.utils.math.Vector):Number {
			return x * v.y - y * v.x;
		}
		
		public function Add(v:virtualworlds.com.smerc.utils.math.Vector) : void
		{
			x += v.x; y += v.y;
		}
		
		public function plus(v:virtualworlds.com.smerc.utils.math.Vector):virtualworlds.com.smerc.utils.math.Vector {
			return new virtualworlds.com.smerc.utils.math.Vector(x + v.x, y + v.y); 
		}
	
		
		public function plusEquals(v:virtualworlds.com.smerc.utils.math.Vector):virtualworlds.com.smerc.utils.math.Vector {
			x += v.x;
			y += v.y;
			return this;
		}
		
		
		public function minus(v:virtualworlds.com.smerc.utils.math.Vector):virtualworlds.com.smerc.utils.math.Vector {
			return new virtualworlds.com.smerc.utils.math.Vector(x - v.x, y - v.y);    
		}
	
	
		public function minusEquals(v:virtualworlds.com.smerc.utils.math.Vector):virtualworlds.com.smerc.utils.math.Vector {
			x -= v.x;
			y -= v.y;
			return this;
		}
	
	
		public function mult(s:Number):virtualworlds.com.smerc.utils.math.Vector {
			return new virtualworlds.com.smerc.utils.math.Vector(x * s, y * s);
		}
		
		public function Subtract(v:virtualworlds.com.smerc.utils.math.Vector) : void
		{
			x -= v.x; y -= v.y;
		}
	
		public function multEquals(s:Number):virtualworlds.com.smerc.utils.math.Vector {
			x *= s;
			y *= s;
			return this;
		}
	
	
		public function times(v:virtualworlds.com.smerc.utils.math.Vector):virtualworlds.com.smerc.utils.math.Vector {
			return new virtualworlds.com.smerc.utils.math.Vector(x * v.x, y * v.y);
		}
		
		
		public function divEquals(s:Number):virtualworlds.com.smerc.utils.math.Vector {
			if (s == 0) s = 0.0001;
			x /= s;
			y /= s;
			return this;
		}
		
		public function magnitude():Number {
			return Math.sqrt(x * x + y * y);
		}
		
		public function withMagnitude(newMag:Number):virtualworlds.com.smerc.utils.math.Vector
		{
			 var m:Number = magnitude();
			 if (m == 0)
			 {
				 m = 0.0001;
			 }
			 return mult(newMag / m);
		}
		
		public function magnitudeSquared():Number {
			return (x * x + y * y);
		}
		
		public function distance(v:virtualworlds.com.smerc.utils.math.Vector):Number {
			var delta:virtualworlds.com.smerc.utils.math.Vector = this.minus(v);
			return delta.magnitude();
		}
		
		public function distSquared(v:virtualworlds.com.smerc.utils.math.Vector):Number {
			var delta:virtualworlds.com.smerc.utils.math.Vector = this.minus(v);
			return ((delta.x * delta.x) + (delta.y * delta.y));
		}
		
		public function normalize():virtualworlds.com.smerc.utils.math.Vector {
			 var m:Number = magnitude();
			 if (m == 0) m = 0.0001;
			 return mult(1 / m);
		}
		
		public function Multiply(a:Number) : void
		{
			x *= a; y *= a;
		}
		
		public function CrossVF(s:Number) : void
		{
			var tX:Number = x;
			x = s * y;
			y = -s * tX;
		}
		
		public function CrossFV(s:Number) : void
		{
			var tX:Number = x;
			x = -s * y;
			y = s * tX;
		}
		
		public function MinV(b:virtualworlds.com.smerc.utils.math.Vector) : void
		{
			x = x < b.x ? x : b.x;
			y = y < b.y ? y : b.y;
		}
		
		public function MaxV(b:virtualworlds.com.smerc.utils.math.Vector) : void
		{
			x = x > b.x ? x : b.x;
			y = y > b.y ? y : b.y;
		}
		
		public function Abs() : void
		{
			x = Math.abs(x);
			y = Math.abs(y);
		}

		public function Length():Number
		{
			return Math.sqrt(x * x + y * y);
		}

		public function Normalize():Number
		{
			var length:Number = Length();
			if (length < Number.MIN_VALUE)
			{
				return 0.0;
			}
			var invLength:Number = 1.0 / length;
			x *= invLength;
			y *= invLength;
			
			return length;
		}
		
		
		
		/**
		* 	Okay, kids, let's review our first week of Trigenometry!!!
		* 
		* @return	An int representing what Quadrant the Vector lies in, I, II, III, or IV.
		*/
		public function get quadrant():int
		{
			// To reduce one check, assume that we're in Quadrant 1, unless specified otherwise.
			var quadrant:int = 1;
			
			if(x >= 0)
			{
				// x is positive, determine if we're in Quadrant IV
				
				if(y < 0)
				{
					// Quadrant IV
					quadrant = 4;
				}
			}
			else
			{
				// x is negative, determine if we're in Quadrant II or III.
				
				if(y > 0)
				{
					// Quadrant II
					quadrant = 2;
				}
				else
				{
					// Quadrant III
					quadrant = 3;
				}
			}
			
			return quadrant;
			
		}//end quadrantOf()
		
		public function toString():String
		{
			return "(" + x + ", " + y + ")";
		}
		
	}//end class Vector
	
}//end package Math
