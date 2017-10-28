/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.tracking
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.CompositeArea;
	import com.neopets.util.collision.geometry.LineArea;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 *	This class adds a pathing line to the area's motion tracking.  These pathing lines are good 
	 *  for catching collisions on small, high speed areas where there's a chance the object may move
	 *  quickly enough to pass straight though another with no recorded moments of intersection.
	 *  It's faster, but less precise than a full area tracker.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.29.2009
	 */
	public class CentralAreaTracker extends BasicAreaTracker
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var prevCenter:Point;
		protected var _motionArea:CompositeArea;
		protected var motionTrail:LineArea;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CentralAreaTracker(shape:BoundedArea=null):void{
			// create the motion area
			_motionArea = new CompositeArea();
			motionTrail = new LineArea();
			_motionArea.addArea(motionTrail);
			// set up our main area
			super(shape);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function set area(shape:BoundedArea):void {
			if(_area != null) {
				_motionArea.removeArea(_area);
				_area.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			}
			_area = shape;
			if(_area != null) {
				_motionArea.addArea(_area);
				prevCenter = _area.center.clone();
				_area.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			}
		}
		
		override public function get motionArea():BoundedArea { return _motionArea; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is trigger when the tracked area changes.
		 */
		 
		override public function onAreaChanged(ev:Event):void {
			var center:Point = _area.center.clone();
			motionTrail.points = [prevCenter,center];
			prevCenter = center;
			dispatchEvent(new Event(BoundedArea.AREA_CHANGED));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
