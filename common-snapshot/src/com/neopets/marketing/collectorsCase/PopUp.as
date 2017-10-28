/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	/**
	 *	This class is a simple movie clip shell with special handling for pop up events.
	 *  The class is similiar to a singleton in that there should generally only be one
	 *  in existance at a time.  You can have more that one of these layers, but only
	 *  the currently active layer will pick up new pop up requests.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class PopUp extends MovieClip 
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
		public function PopUp():void{
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isInStageBounds():Boolean {
			if(stage == null) return false; // if we're off stage, the check fails
			// test bounds
			var my_bounds:Rectangle = getBounds(stage);
			if(my_bounds.left < 0) return false;
			if(my_bounds.right > stage.stageWidth) return false;
			if(my_bounds.top < 0) return false;
			if(my_bounds.bottom > stage.stageHeight) return false;
			// if we got this far we must be in bounds
			return true;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Initialization Functions
		
		/**
		 * @This function tries to set up the pop up using the given information.
		 * @param		info		Object 		Initialization values for the pop up
		 */
		 
		public function loadData(info:Object):void {}
		
		// Alignment Functions
		
		/**
		 * @This function ensures the clip stays fully on stage.
		 */
		 
		public function alignWithStage():void {
			if(stage != null) {
				// get bounds
				var my_bounds:Rectangle = getBounds(stage);
				if(my_bounds.left < 0) x -= my_bounds.left;
				else {
					if(my_bounds.right > stage.stageWidth) {
						x += stage.stageWidth - my_bounds.right;
					}
				}
				if(my_bounds.top < 0) y -= my_bounds.top;
				else {
					if(my_bounds.bottom > stage.stageHeight) {
						y += stage.stageHeight - my_bounds.bottom;
					}
				}
			}
		}
		
		/**
		 * @This function tries to set up the pop up using the given information.
		 * @param		target		DisplayObject		Object to center the pop up over
		 * @param		x_align		Boolean				Align x midpoints (vertical column)
		 * @param		y_align		Boolean				Align y midpoints (horizontal row)
		 */
		 
		public function centerOver(target:DisplayObject,x_align:Boolean=true,y_align:Boolean=true):void {
			if(target != null) {
				// get bounds
				var my_bounds:Rectangle = getBounds(parent);
				var target_bounds:Rectangle = target.getBounds(parent);
				// shift x values
				var my_middle:Number;
				var target_middle:Number;
				if(x_align) {
					my_middle = (my_bounds.left + my_bounds.right) / 2;
					target_middle = (target_bounds.left + target_bounds.right) / 2;
					x += target_middle - my_middle;
				}
				// shift y values
				if(y_align) {
					my_middle = (my_bounds.top + my_bounds.bottom) / 2;
					target_middle = (target_bounds.top + target_bounds.bottom) / 2;
					y += target_middle - my_middle;
				}
				// keep all the pop up on stage
				alignWithStage();
			}
		}
		
		/**
		 * @This function tries move this pop up so it's right edge touches the target's left edge.
		 * @param		target		DisplayObject		Object to center the pop up over
		 */
		 
		public function moveLeftOf(target:DisplayObject):void {
			if(target != null) {
				// get bounds
				var my_bounds:Rectangle = getBounds(parent);
				var target_bounds:Rectangle = target.getBounds(parent);
				// shift x value
				x += target_bounds.left - my_bounds.right;
			}
		}
		
		/**
		 * @This function tries move this pop up so it's left edge touches the target's right edge.
		 * @param		target		DisplayObject		Object to center the pop up over
		 */
		 
		public function moveRightOf(target:DisplayObject):void {
			if(target != null) {
				// get bounds
				var my_bounds:Rectangle = getBounds(parent);
				var target_bounds:Rectangle = target.getBounds(parent);
				// shift x value
				x += target_bounds.right - my_bounds.left;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Attach this function to event listeners to close the pop-up
		 */
		 
		public function onCloseRequest(ev:Event=null):void {
			if(parent != null) parent.removeChild(this);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}