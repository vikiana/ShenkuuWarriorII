/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry.trails
{
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.PolygonStrip;
	import com.neopets.util.collision.geometry.CompositeArea;
	import flash.events.Event;
	
	/**
	 *	This class tries to create a motion trail for given point area.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern AbstractClass
	 * 
	 *	@author David Cary
	 *	@since  10.05.2009
	 */
	public class ChainAreaTrail extends LineAreaTrail
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ChainAreaTrail(shape:BoundedArea=null):void{
			super(shape);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function checks for changes in the area an creates a new trail from those changes.
		 */
		 
		override public function update():void {
			if(_area == null) return;
			// check area's current state
			var pts:Array = _area.clonePoints();
			// create the trail
			var comp:CompositeArea;
			comp  = new CompositeArea();
			comp.addArea(_area);
			var strip:PolygonStrip = new PolygonStrip(prevPoints,pts);
			comp.addArea(strip);
			_trail = comp;
			// record the new state
			prevPoints = pts;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
