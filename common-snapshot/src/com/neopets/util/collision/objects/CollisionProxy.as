/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.objects
{
	import com.neopets.util.collision.geometry.*;
	import com.neopets.util.collision.*;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.neopets.util.collision.geometry.tracking.*;
	import com.neopets.util.collision.physics.MovementEvent;
	import com.neopets.util.collision.physics.RotationPoint;
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.general.MathUtils;
	
	/**
	 *	Collision Proxies act as representatives for a display object within
	 *  a collision space.  They essentially act as collision sensors that
	 *  try to automatically update their position to keep up with changes in the
	 *  the target display object.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.9.2009
	 */
	public class CollisionProxy extends CollisionSensor
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const NO_SYNCH:int = 0;
		public static const POSITION_SYNCH:int = 1;
		public static const BOUNDS_SYNCH:int = 2;
		public static const ALWAYS_SYNCH:int = 3;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _owner:DisplayObject;
		protected var _offset:Point;
		protected var _previousState:Object;
		protected var _synchLevel:int;
		protected var synchTest:Function;
		protected var movementConverter:CoordinateConverter;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollisionProxy(dobj:DisplayObject=null):void{
			synchLevel = 0;
			_offset = new Point();
			super();
			if(dobj != null) owner = dobj;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns the display object this proxy represents.
		 */
		 
		public function get owner():DisplayObject { return _owner; }
		 
		 /**
		 * @Sets the display object this proxy represents.
		 */
		 
		public function set owner(dobj:DisplayObject):void {
			// clear listeners
			if(_owner != null) _owner.removeEventListener(Event.REMOVED_FROM_STAGE,onOwnerRemoved);
			// check if synching is enabled
			if(synchTest != null) {
				if(_owner != null) stopSynching();
				_owner = dobj;
				if(_owner != null) startSynching();
			} else _owner = dobj;
			// add listeners to new owner
			if(_owner != null) _owner.addEventListener(Event.REMOVED_FROM_STAGE,onOwnerRemoved);
			// Make sure our movement values are up to date
			initMovement();
		}
		
		/**
		 * @Sets the area used for collision tests.
		 */
		 
		override public function set area(shape:BoundedArea):void {
			if(_areaTracker != null) _areaTracker.area = shape;
			else {
				_areaTracker = new BasicAreaTracker(shape);
				_areaTracker.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			}
			clearColliders();
			// Make sure our movement values are up to date
			initMovement();
		}
		
		/**
		 * @Returns the proxy's state record.
		 */
		 
		public function get previousState():Object { return _previousState; }
		
		/**
		 * @Sets the collision space that contains this object.
		 */
		 
		override public function set space(cs:CollisionSpace):void {
			// clear previous space
			if(_space != null) _space.removeItem(this);
			// move into our new space
			_space = cs;
			if(cs != null) cs.addItem(this);
			// Make sure our movement values are up to date
			initMovement();
		}
		
		/**
		 * @Returns how much effort the proxy puts into matching it's owner's position.
		 */
		 
		public function get synchLevel():int { return _synchLevel; }
		 
		 /**
		 * @Sets how much effort the proxy puts into matching it's owner's position.
		 */
		 
		public function set synchLevel(val:int):void {
			if(_synchLevel != val) {
				// set up the synch testing function
				switch(val) {
					case NO_SYNCH:
						if(synchTest != null && _owner != null) stopSynching();
						synchTest = null;
						_synchLevel = val;
						break;
					case POSITION_SYNCH:
						if(synchTest == null && _owner != null) startSynching();
						synchTest = checkPosition;
						_synchLevel = val;
						break;
					case BOUNDS_SYNCH:
						if(synchTest == null && _owner != null) startSynching();
						synchTest = checkBounds;
						_synchLevel = val;
						break;
					case ALWAYS_SYNCH:
						if(synchTest == null && _owner != null) startSynching();
						synchTest = autoPass;
						_synchLevel = val;
						break;
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to push the proxy away from it's colliders
		 * @The returned value is the object's escape vector.
		 * @param		filter		Function 	Lets the user specify which colliders to use.
		 */
		
		public function escapeCollisions(filter:Function=null):Point {
			var exit_vec:Point = getExitVector(filter);
			// if we didn't get an exit vector, abort.
			if(exit_vec == null || exit_vec.length <= 0) return null;
			// check if we have a bounded area
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) {
				// shift area to test position
				cur_area.moveBy(exit_vec.x,exit_vec.y);
				// check if we collide with anything at the new position
				var rebound_vec:Point = getExitVector(filter);
				if(rebound_vec != null && rebound_vec.length > 0) {
					// use half sized rebound to prevent collision toggle bug
					rebound_vec.normalize(rebound_vec.length * 0.5);
					cur_area.moveBy(rebound_vec.x,rebound_vec.y);
					// combine exit and rebound vectors
					var merged_vec:Point = rebound_vec.add(exit_vec);
					finishMovement(merged_vec.x,merged_vec.y);
					return merged_vec;
				} else {
					// no secondary collision, so just apply movement to owner
					finishMovement(exit_vec.x,exit_vec.y);
					return exit_vec;
				}
			} else return null;
		}
		
		/**
		 * @This function yields the combined exit vector for the current area's colliders.
		 * @The returned value is the object's escape vector.
		 * @param		filter		Function 	Lets the user specify which colliders to use.
		 */
		
		public function getExitVector(filter:Function=null):Point {
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area == null) return null;
			// initialize displacement values
			var left_shift:Number = 0;
			var right_shift:Number = 0;
			var up_shift:Number = 0;
			var down_shift:Number = 0;
			// check everything we're colliding with
			var sensor:CollisionSensor;
			var other_area:BoundedArea;
			var path:Point;
			for(var i:int = 0; i < _colliderList.length; i++) {
				sensor = _colliderList[i];
				if(filter == null || filter(sensor)) {
					other_area = sensor.area;
					if(other_area != null) {
						path = cur_area.getExitVectorFor(other_area);
						// break path down into components
						if(path != null) {
							if(path.x > 0) right_shift = Math.max(path.x,right_shift);
							else left_shift = Math.min(path.x,left_shift);
							if(path.y > 0) down_shift = Math.max(path.y,down_shift);
							else up_shift = Math.min(path.y,up_shift);
						}
					}
				} // end of filter check
			} // end of collider loop
			// convert shift components into a movement vector
			var dx:Number = mergeShifts(left_shift,right_shift);
			var dy:Number = mergeShifts(up_shift,down_shift);
			return new Point(dx,dy);
		}
		
		/**
		 * @Attaches event listeners to owner.
		 */
		 
		public function startSynching():void {
			_owner.addEventListener(Event.ENTER_FRAME,onOwnerFrame);
		}
		
		/**
		 * @Removes event listeners from owner.
		 */
		 
		public function stopSynching():void {
			_owner.removeEventListener(Event.ENTER_FRAME,onOwnerFrame);
		}
		
		/**
		 * @This function makes the proxy update it's area to match it's owner's current state.
		 */
		
		public function synch():void {
			_areaTracker.rebuildArea();
		}
		
		/**
		 * @Provides string summary of this proxy.
		 */
		
		override public function toString():String {
			return "[CollisionProxy for "+_owner+"]";
		}
		
		/**
		 * @Initializes coordinate converters.
		 */
		 
		public function initMovement():void {
			// check if we have an owner
			var p_space:DisplayObject;
			if(_owner != null) p_space = _owner.parent;
			// build coordinate converter for linear motion
			if(movementConverter != null) movementConverter.setSpaces(root,p_space);
			else movementConverter = new CoordinateConverter(root,p_space);
			// use the converter to set up our offset
			if(_owner != null) {
				// check if we have an area
				var cur_area:BoundedArea = _areaTracker.area;
				if(cur_area != null) {
					// get our owner's position relative to the area
					var axis:Point = movementConverter.convertPosition(cur_area.center);
					_offset.x = _owner.x - axis.x;
					_offset.y = _owner.y - axis.y;
				}
			}
		}
		
		// Synch Checking Functions
		
		/**
		 * @This function simply returns true.  It's used to ensure synching is always used every frame.
		 */
		 
		public function checkPosition():Boolean {
			// make sure we have an initial record
			if(_previousState == null) {
				_previousState = {x:_owner.x,y:_owner.y,rotation:_owner.rotation};
				return false;
			}
			// check if the state has changed
			if(_previousState.x != _owner.x || _previousState.y != _owner.y || _previousState.rotation != _owner.rotation) {
				_previousState.x = _owner.x;
				_previousState.y = _owner.y;
				_previousState.rotation = _owner.rotation;
				return true;
			} else return false;
		}
		
		/**
		 * @This function simply returns true.  It's used to ensure synching is always used every frame.
		 */
		 
		public function checkBounds():Boolean {
			// make sure we have an initial record
			if(_previousState == null) {
				_previousState = _owner.getBounds(root);
				return false;
			}
			// check if the state has changed
			var bb:Rectangle = _owner.getBounds(root);
			if(_previousState.equals(bb)) {
				_previousState = bb;
				return true;
			} else return false;
		}
		
		/**
		 * @This function simply returns true.  It's used to ensure synching is always used every frame.
		 */
		 
		public function autoPass():Boolean { return true; }
		
		// Inheritted Functions
		
		/**
		 * @This function moves the area by the given values
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		dr		Number 		Change in rotation
		 */
		 
		override public function moveBy(dx:Number,dy:Number,dr:Number=0):void{
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) {
				cur_area.moveBy(dx,dy,dr);
				finishMovement(dx,dy,dr);
			}
		}
		
		/**
		 * @This function moves the area toward a given location while stopping if any barriers are hit.
		 * @param		dx			Number 		Target x shift
		 * @param		dy			Number 		Target y shift
		 * @param		sticky		Boolean		Turn this off to try sliding around barriers
		 * @param		filter		Function 	This function control which colliders are treated as barriers.
		 */
		 
		public function slideBy(dx:Number,dy:Number,sticky:Boolean=false,filter:Function=null):void {
			if(dx == 0 && dy == 0) return; // no movement
			// check if we have a bounded area
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) {
				// shift area to test position
				cur_area.moveBy(dx,dy);
				// Find the furthest back we have to go to escape all barriers
				var motion_area:BoundedArea = _areaTracker.motionArea;
				var sensor:CollisionSensor;
				var other_area:BoundedArea;
				var path:Point;
				var path_length:Number;
				var longest_path:Point;
				var longest_length:Number;
				var max_length:Number = Math.sqrt(dx*dx + dy*dy);
				var exit_dir:Number = Math.atan2(-dy,-dx);
				// cycle through all colliders
				for(var i:int = 0; i < _colliderList.length; i++) {
					sensor = _colliderList[i];
					if(filter == null || filter(sensor)) {
						other_area = sensor.area;
						if(other_area != null) {
							path = motion_area.getExitVectorFor(other_area,exit_dir,sticky);
							// check if the path goes back past our origin point
							path_length = path.length;
							if(path_length >= max_length) {
								// barrier prevents movement, so undo slide
								cur_area.moveBy(-dx,-dy);
								return;
							} else {
								// check if this is the largest push back so far
								if(longest_path == null || path_length > longest_length) {
									longest_path = path;
									longest_length = path_length;
								}
							}
						}
					} // end of filter check
				} // end of collider loop
				// apply the largest barrier push back
				if(longest_path != null) {
					cur_area.moveBy(longest_path.x,longest_path.y);
					dx += longest_path.x;
					dy += longest_path.y;
				}
				// apply movement to owner
				finishMovement(dx,dy);
			} else moveBy(dx,dy);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is called each frame tracking is enabled.  It's main purpose is
		 * @keeping the proxy's area sycnhed with it's owner's position and scaling.
		 */
		 
		public function onOwnerFrame(ev:Event):void {
			if(synchTest()) synch();
		}
		
		/**
		 * @If the owner is removed from the stage, drop it.
		 */
		 
		public function onOwnerRemoved(ev:Event):void {
			stopSynching();
			_owner = null;
			space = null;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This class handles the common code for finalizing a move or slide action.
		 * @This mainly involves updating our owner's position, postponing auto-synching, and
		 * @dispatching a movement event.
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		dr		Number 		Change in rotation
		 */
		 
		protected function finishMovement(dx:Number,dy:Number,dr:Number=0):void{
			var cur_area:BoundedArea = _areaTracker.area;
			// try to move our owner to keep it synched with the area
			if(_owner != null) {
				// check if we've got a defined area
				if(cur_area != null) {
					var axis:Point = movementConverter.convertPosition(cur_area.center);
					// apply rotation
					if(dr != 0) {
						// rotate our owner
						_owner.rotation += dr;
						// Check if the owner's origin is not on the area's center point
						if(_offset.length > 0) {
							// calculate the rotated values of the offset
							var rad:Number = dr * AreaTransformation.RADIANS_PER_DEGREE;
							var sine:Number = Math.sin(rad);
							var cosine:Number = Math.cos(rad);
							var rx:Number = _offset.x  * cosine - _offset.y * sine;
							var ry:Number = _offset.x  * sine + _offset.y * cosine;
							// store the rotated offset
							_offset.x = rx;
							_offset.y = ry;
							// reposition the owner
							_owner.x = axis.x + _offset.x;
							_owner.y = axis.y + _offset.y;
						} else {
							// reposition the owner
							_owner.x = axis.x;
							_owner.y = axis.y;
						}
					} else {
						// apply linear motion
						if(dx != 0 || dy != 0) {
							// reposition the owner
							_owner.x = axis.x + _offset.x;
							_owner.y = axis.y + _offset.y;
						}
					}
				} else {
					// apply the movement directly to the owner
					_owner.x += dx;
					_owner.y += dy;
					_owner.rotation += dr;
				}
				// Make sure this movement doesn't trigger a synch
				if(_synchLevel == POSITION_SYNCH) {
					_previousState.x = _owner.x;
					_previousState.y = _owner.y;
					_previousState.rotation = _owner.rotation;
				} else {
					if(_synchLevel == BOUNDS_SYNCH) {
						_previousState = _owner.getBounds(root);
					}
				} // end of _previousState update
			}
			// dispatch movement event
			var movement:RotationPoint = new RotationPoint(dx,dy,dr);
			var move_event:Event = new MovementEvent(movement,POSITION_CHANGED);
			dispatchEvent(move_event);
		}
		
		/**
		 * @This function combines collision shift values so that opposing shifts centers the 
		 * @collision area between them.
		 */
		 
		protected function mergeShifts(s1:Number,s2:Number):Number{
			if(s1 != 0) {
				if(s1 > 0) {
					// s1 is positive
					if(s2 >= 0) return Math.max(s1,s2);
					else return (s1 + s2) / 2;
				} else {
					// s1 is negative
					if(s2 > 0) return (s1 + s2) / 2;
					else return Math.min(s1,s2);
				}
			} else return s2;
		}
		
	}
	
}
