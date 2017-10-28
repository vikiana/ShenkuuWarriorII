/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.tracking
{
	import com.neopets.util.collision.geometry.*;
	import com.neopets.util.collision.geometry.trails.*;
	
	/**
	 *	This the abstract base class used in tracking the motion of bounded areas.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abstract Class
	 * 
	 *	@author David Cary
	 *	@since  9.29.2009
	 */
	public class FullAreaTracker extends BasicAreaTracker
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var prevState:Object;
		protected var _motionArea:AreaTrail;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function FullAreaTracker(shape:BoundedArea=null):void{
			super(shape);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function set area(shape:BoundedArea):void{
			if(_area != null) _area.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			// clear the previous motion area
			if(_motionArea != null) {
				_motionArea.area = null;
				_motionArea.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
				_motionArea = null;
			}
			// store the new area
			_area = shape;
			if(_area != null) {
				// set up the new motion area
				_motionArea = _area.getTrail();
				// attach listeners
				if(_motionArea != null) _motionArea.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
				else _area.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			}
		}
		
		override public function get motionArea():BoundedArea {
			if(_motionArea != null) return _motionArea.trail;
			else return _area;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
