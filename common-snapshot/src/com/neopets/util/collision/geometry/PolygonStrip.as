/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.geometry
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 *	Polygon strips are specialized composite area that consist of a series
	 *  of polygons where each can share an edge with up to two siblings.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.28.2009
	 */
	public class PolygonStrip extends CompositeArea
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
		public function PolygonStrip(list_1:Array=null,list_2:Array=null,close_loop:Boolean=false):void{
			super();
			buildFromPoints(list_1,list_2,close_loop);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		// Construction Functions
		
		/**
		 * @This tries to build a series of panels from lists of points or segments.
		 * @param		list_1		Array		 List of points for first strip edge.
		 * @param		list_2		Array		 List of points for second strip edge.
		 * @param		close_loop	Boolean		 Attach the last points to the first ones.
		 */
		 
		public function buildFromPoints(list_1:Array,list_2:Array,close_loop:Boolean=false):void{
			if(list_1 == null || list_2 == null) return;
			// connect both lines
			var cur_area:LineArea;
			var min_size:int = Math.min(list_1.length,list_2.length);
			var recalc:Boolean = false;
			var i:int;
			if(min_size > 0) {
				// get intitial point pair
				var prev_pt_1:Point = list_1[0];
				var prev_pt_2:Point = list_2[0];
				// make sure we have at least 4 points to work with
				if(min_size > 1) {
					// create first edge
					var reversed:Boolean = false; // controls order points are added
					var back_edge:LineSegment;
					if(!prev_pt_1.equals(prev_pt_2)) {
						back_edge = new LineSegment(prev_pt_1,prev_pt_2);
					}
					// declare panel construction variables
					var cur_pt_1:Point;
					var cur_pt_2:Point;
					var front_edge:LineSegment;
					var adj_edge:LineSegment;
					var opp_edge:LineSegment;
					// if this is a closed loop, make one more pass at the end
					var limit:int;
					if(close_loop) limit = min_size + 1;
					else limit = min_size;
					// cycle through remaining point pairs
					for(i = 0; i < limit; i++) {
						// check if we're trying to close the loop
						if(i < min_size) {
							cur_pt_1 = list_1[i];
							cur_pt_2 = list_2[i];
						} else {
							cur_pt_1 = list_1[0];
							cur_pt_2 = list_2[0];
						}
						// check if there's a front edge
						if(cur_pt_1.equals(cur_pt_2)) {
							// points match so no front edge
							if(back_edge != null) {
								// we've got a closing triangle
								cur_area = new PolygonArea();
								adj_edge = new LineSegment(back_edge.point2,cur_pt_1);
								opp_edge = new LineSegment(cur_pt_1,back_edge.point1);
								cur_area.segments = [back_edge,adj_edge,opp_edge];
								addArea(cur_area);
								back_edge = null; // move new null edge into storage
							} else {
								// both pairs match so this is a straight line
								if(cur_area == null || cur_area is PolygonArea) {
									// create a new line
									cur_area = new LineArea();
									cur_area.points = [prev_pt_1,cur_pt_1];
									addArea(cur_area);
								} else {
									// assume the last area created was a line, so we can add points here
									cur_area.pushPoint(cur_pt_1);
									recalc = true; // the new point could adjust bounds, so enable rechecking
								}
							}
							prev_pt_1 = cur_pt_2; // store point 2 as point 1 since they're equal
						} else {
							// build the new edges
							if(reversed) {
								adj_edge = new LineSegment(prev_pt_1,cur_pt_1);
								front_edge = new LineSegment(cur_pt_1,cur_pt_2);
								opp_edge = new LineSegment(cur_pt_2,prev_pt_2);
							} else {
								adj_edge = new LineSegment(prev_pt_2,cur_pt_2);
								front_edge = new LineSegment(cur_pt_2,cur_pt_1);
								opp_edge = new LineSegment(cur_pt_1,prev_pt_1);
							}
							reversed = !reversed; // each new shared edge flips the point linking direction
							// create the new polygon
							cur_area = new PolygonArea();
							// check if we also have a back edge
							if(back_edge != null) {
								cur_area.segments = [back_edge,adj_edge,front_edge,opp_edge];
							} else {
								// we've got an opening triangle
								cur_area.segments = [adj_edge,front_edge,opp_edge];
							}
							addArea(cur_area);
							back_edge = front_edge; // store the new leading edge
							prev_pt_1 = cur_pt_1; // store point 1
						}
						prev_pt_2 = cur_pt_2; // store point 2
						
					}
				} else {
					// if we've only got one point pair, connect them with a single line.
					cur_area = new LineArea();
					cur_area.points = [prev_pt_1,prev_pt_2];
					addArea(cur_area);
				}
			} // end of min_size test
			// make a line of the remaining segments
			if(list_1.length != list_2.length) {
				// get larger of the two lists
				var big_list:Array;
				if(list_1.length > list_2.length) big_list = list_1;
				else big_list = list_2;
				// build a line from the remaining points
				cur_area = new LineArea();
				for(i = min_size; i < big_list.length; i++) {
					cur_area.pushPoint(big_list[i]);
				}
				addArea(cur_area);
			}
			// check if the bounds need to be recalculated
			if(recalc) resetBounds();
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
