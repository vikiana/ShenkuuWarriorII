/* AS3
	Copyright 2008
*/
package com.neopets.util.collision
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 *	This class can be used to convert a coordinate point in one display object to the
	 *  corresponding coordinates in another display object.  The class uses "localToGlobal"
	 *  and "globalToLocal" calls to handle this.  As such, it's slower than calling these
	 *  functions directly the first time it's used.  However, the class stores conversion
	 *  values when it's linked to those two display objects.  That means later conversions 
	 *  can be significantly faster provided the two target remain the same and their containers
	 *  aren't scaled or rotated.
	 *  If the containers are transformed, the conversion values will need to be recalculated.
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singelton
	 * 
	 *	@author David Cary
	 *	@since  10.20.2009
	 */
	public class CoordinateConverter
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _firstSpace:DisplayObject;
		protected var _secondSpace:DisplayObject;
		// conversion values
		protected var _origin:Point;
		protected var _xVector:Point;
		protected var _yVector:Point;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CoordinateConverter(space_1:DisplayObject=null,space_2:DisplayObject=null):void{
			setSpaces(space_1,space_2);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Initialization Functions
		
		/**
		 * @This function sets our coordinate spaces and intializes our conversion values.
		 * @param		space_1		DisplayObject 		First coordinate space
		 * @param		space_2		DisplayObject 		Second coordinate space
		 */
		 
		public function setSpaces(space_1:DisplayObject,space_2:DisplayObject):void{
			_firstSpace = space_1;
			_secondSpace = space_2;
			recalculate();
		}
		
		/**
		 * @This function initializes our conversion values.
		 */
		 
		public function recalculate():void{
			// initialize points
			_origin = new Point(0,0);
			_xVector = new Point(1,0);
			_yVector = new Point(0,1);
			// check our coordinate spaces
			if(_firstSpace != null) {
				_origin = _firstSpace.localToGlobal(_origin);
				_xVector = _firstSpace.localToGlobal(_xVector);
				_yVector = _firstSpace.localToGlobal(_yVector);
			}
			if(_secondSpace != null) {
				_origin = _secondSpace.globalToLocal(_origin);
				_xVector = _secondSpace.globalToLocal(_xVector);
				_yVector = _secondSpace.globalToLocal(_yVector);
			}
			// set our vector relative to our origin
			_xVector = _xVector.subtract(_origin);
			_yVector = _yVector.subtract(_origin);
		}
		
		// Conversion Functions
		
		/**
		 * @This function converts the coordinates of a given target object.
		 * @param		target		Object 		Object that holds the target position.
		 */
		 
		public function convertPosition(target:Object):Point{
			var pt:Point = new Point();
			if(target == null) return null;
			// get x coordinate
			var tx:Number;
			if("x" in target) tx = target.x;
			else return null;
			// get x coordinate
			var ty:Number;
			if("y" in target) ty = target.y;
			else return null;
			// calculate new coordinates
			pt.x = _origin.x + _xVector.x * tx + _yVector.x * ty;
			pt.y = _origin.y + _xVector.y * tx + _yVector.y * ty;
			return pt;
		}
		
		/**
		 * @This function converts a change in coordinate values.  As such, origin is not used.
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 */
		 
		public function convertShift(dx:Number,dy:Number):Point{
			var pt:Point = new Point();
			pt.x = _xVector.x * dx + _yVector.x * dy;
			pt.y = _xVector.y * dx + _yVector.y * dy;
			return pt;
		}
		
		// This function just converts this object a string for easier tracing.
		
		public function toString():String {
			return "[converter for "+_firstSpace+" to "+_secondSpace+"]";
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
