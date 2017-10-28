/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.objects
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.neopets.util.collision.*;
	import com.neopets.util.collision.geometry.BoundedArea;
	import com.neopets.util.collision.geometry.CompositeArea;
	import com.neopets.util.collision.geometry.tracking.*;
	import com.neopets.util.collision.physics.MovementEvent;
	import com.neopets.util.collision.physics.RotationPoint;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	Collision Sensors are simply areas in a collision space with special rules
	 *  for detecting and handling collisions.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  9.9.2009
	 */
	public class CollisionSensor extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const COLLISION_CONFIRMED:String = "collision_confirmed";
		public static const COLLISION_FAILED:String = "collision_failed";
		public static const COLLISION_STARTS:String = "collision_starts";
		public static const COLLISION_ENDS:String = "collision_ends";
		public static const POSITION_CHANGED:String = "position_changed";
		public static const NO_TRAIL:int = 0;
		public static const LINE_TRAIL:int = 1;
		public static const AREA_TRAIL:int = 2;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _areaTracker:BasicAreaTracker;
		protected var _space:CollisionSpace;
		protected var _colliderList:Array;
		protected var _trailLevel:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var collisionFilter:Function;
		public var canCollideDefault:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollisionSensor():void{
			trailLevel = 0;
			canCollideDefault = true;
			_colliderList = new Array();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Returns the area used for collision tests.
		 */
		 
		public function get area():BoundedArea { return _areaTracker.area; }
		
		/**
		 * @Sets the area used for collision tests.
		 */
		 
		public function set area(shape:BoundedArea):void {
			if(_areaTracker != null) _areaTracker.area = shape;
			else {
				_areaTracker = new BasicAreaTracker(shape);
				_areaTracker.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			}
			clearColliders();
		}
		
		/**
		 * @Returns the collision space that contains this object.
		 */
		 
		public function get space():CollisionSpace { return _space; }
		
		/**
		 * @Sets the collision space that contains this object.
		 */
		 
		public function set space(cs:CollisionSpace):void {
			// clear previous space
			if(_space != null) _space.removeItem(this);
			// move into our new space
			_space = cs;
			if(cs != null) cs.addItem(this);
		}
		
		/**
		 * @Returns the "root" object of this sensor's space.
		 */
		 
		public function get root():DisplayObjectContainer {
			if(_space != null) return _space.root;
			else return null;
		}
		
		/**
		 * @Returns a list of other sensors we're colliding with.
		 */
		 
		public function get colliderList():Array { return _colliderList; }
		
		/**
		 * @Returns how much effort the proxy puts into matching it's owner's position.
		 */
		 
		public function get trailLevel():int { return _trailLevel; }
		 
		 /**
		 * @Sets how much effort the proxy puts into matching it's owner's position.
		 */
		 
		public function set trailLevel(val:int):void {
			if(_trailLevel != val) {
				_trailLevel = val;
				// unload the old tracker
				var shape:BoundedArea;
				if(_areaTracker != null) {
					shape = _areaTracker.area;
					_areaTracker.area = null;
					_areaTracker.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
				}
				// check if we need to update the motion area
				switch(_trailLevel) {
					case NO_TRAIL:
						_areaTracker = new BasicAreaTracker(shape);
						break;
					case LINE_TRAIL:
						_areaTracker = new CentralAreaTracker(shape);
						break;
					case AREA_TRAIL:
						_areaTracker = new FullAreaTracker(shape);
						break;
				}
				_areaTracker.addEventListener(BoundedArea.AREA_CHANGED,onAreaChanged);
			}
		}
		
		// Coordinate Accessors
		
		public function get x():Number {
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) return area.center.x;
			else return 0;
		}
		
		public function get y():Number {
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) return area.center.y;
			else return 0;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		 
		 /**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		BoundedArea 		The object we're using to draw this area.
		 */
		 
		public function addArea(shape:BoundedArea):void{
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) {
				var composite:CompositeArea
				if(cur_area is CompositeArea) {
					composite = cur_area as CompositeArea;
					composite.addArea(shape);
					clearColliders();
				} else {
					composite = new CompositeArea();
					composite.addArea(cur_area);
					composite.addArea(shape);
					_areaTracker.area = composite;
				}
			} else _areaTracker.area = shape;
		}
		
		/**
		 * @This function moves the sensor into a named collision space.
		 * @If the space doesn't exist, this function will create that space.
		 * @param		id		String 		Name of the target collision space.
		 */
		 
		public function addTo(id:String):void{
			var cs:CollisionSpace = CollisionManager.getSpace(id);
			if(cs == null) space = CollisionManager.addSpace(id);
			else space = cs;
		}
		 
		 /**
		 * @This function puts a drawing of the area in the target display object.
		 * @param		canvas		Sprite 		The object we're using to draw this area.
		 */
		 
		public function drawOn(canvas:Sprite):void{
			var drawn_area:BoundedArea;
			if(_space != null && _space.showMotion) {
				drawn_area = _areaTracker.motionArea;
			} else {
				drawn_area = _areaTracker.area;
			}
			if(drawn_area != null) drawn_area.drawOn(canvas);
		}
		
		/**
		 * @This function moves the area by the given values
		 * @param		dx		Number 		Target x shift
		 * @param		dy		Number 		Target y shift
		 * @param		dr		Number 		Change in rotation
		 */
		 
		public function moveBy(dx:Number,dy:Number,dr:Number=0):void{
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) {
				cur_area.moveBy(dx,dy,dr);
				// dispatch movement event
				var movement:RotationPoint = new RotationPoint(dx,dy,dr);
				var move_event:Event = new MovementEvent(movement,POSITION_CHANGED);
				dispatchEvent(move_event);
			}
		}
		
		/**
		 * @This function moves the area so it's centered over a given position.
		 * @param		tx		Number 		Target x coordinate
		 * @param		ty		Number 		Target y coordinate
		 * @param		tr		Number 		Target rotation
		 */
		 
		public function moveTo(tx:Number,ty:Number,tr:Number=0):void{
			var cur_area:BoundedArea = _areaTracker.area;
			if(cur_area != null) {
				var cp:Point = area.center;
				var dx:Number = tx - cp.x;
				var dy:Number = ty - cp.y;
				moveBy(dx,dy);
			}
		}
		
		// Collision Functions
		
		 /**
		 * @This function determines if this object can collide with the target.
		 * @param		other		CollisionSensor 		The other object being tested.
		 */
		 
		public function canCollideWith(other:CollisionSensor):Boolean{
			if(collisionFilter != null) return collisionFilter(other);
			else return canCollideDefault;
		}
		
		 /**
		 * @This function handles the object's collision testing and reactions.
		 * @param		other		CollisionSensor 		The other object being tested.
		 */
		 
		public function checkForCollision(other:CollisionSensor):void{
			// dispatch the results
			var entry:CollisionData;
			var cd:CollisionData;
			if(intersects(other)) {
				// broadcast the collision
				cd = new CollisionData(this,other);
				dispatchHit(other,cd);
				other.dispatchHit(this,cd);
			} else {
				if(other != null && other != this) {
					cd = new CollisionData(this,other);
					dispatchMiss(other,cd);
					other.dispatchMiss(this,cd);
				}
			}
		}
		
		/**
		 * @This function determines if this object intersects another one.
		 * @param		other		CollisionSensor 		The other object being tested.
		 */
		 
		public function intersects(other:CollisionSensor):Boolean{
			// check if this is a valid target
			if(other == null) return false;
			if(other == this) return false; // we can't collide with ourselves
			// we can't collision test without bounding areas
			var target_area:BoundedArea = other.area;
			if(target_area == null) return false;
			var cur_area:BoundedArea = _areaTracker.motionArea;
			if(cur_area == null) return false;
			// don't test if both areas ignore each other
			if(canCollideWith(other) || other.canCollideWith(this)) {
				return cur_area.intersects(target_area);
			} else return false;
		}
		
		/**
		 * @Resets the list of objects we've collided with.
		 */
		 
		public function clearColliders():void{
			while(_colliderList.length > 0) _colliderList.pop();
		}
		
		/**
		 * @This function determines if this object intersects another one.
		 * @param		other		CollisionSensor 		The other object being tested.
		 */
		 
		public function removeCollider(other:CollisionSensor):void{
			var entry:CollisionSensor;
			for(var i:int = _colliderList.length; i >= 0; i--) {
				entry = _colliderList[i];
				if(entry == other) {
					_colliderList.splice(i,1);
					break;
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is trigger when the tracked area changes.
		 */
		 
		public function onAreaChanged(ev:Event):void {
			dispatchEvent(new Event(BoundedArea.AREA_CHANGED));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function dispatches the collision event and updates our collision list.
		 * @param		other		CollisionSensor 		The other object being tested.
		 * @param		info		CollisionDara 		Details of the collision.
		 */
		 
		protected function dispatchHit(other:CollisionSensor,info:CollisionData):void{
			dispatchEvent(new CustomEvent(info,COLLISION_CONFIRMED));
			// check if we're already colliding with the target
			var entry:CollisionSensor;
			for(var i:int = 0; i <  _colliderList.length; i++) {
				entry = _colliderList[i];
				if(entry == other) return;
			}
			// if not, track the new collision
			_colliderList.push(other);
			dispatchEvent(new CustomEvent(info,COLLISION_STARTS));
		}
		
		/**
		 * @This function dispatches a failed collision event and updates our collision list.
		 * @param		other		CollisionSensor 		The other object being tested.
		 * @param		info		CollisionDara 		Details of the failed collision.
		 */
		 
		protected function dispatchMiss(other:CollisionSensor,info:CollisionData):void{
			dispatchEvent(new CustomEvent(info,COLLISION_FAILED));
			// check if we're already colliding with the target
			var entry:CollisionSensor;
			for(var i:int = _colliderList.length; i >= 0; i--) {
				entry = _colliderList[i];
				if(entry == other) {
					_colliderList.splice(i,1);
					dispatchEvent(new CustomEvent(info,COLLISION_ENDS));
					break;
				}
			}
		}
		
	}
	
}
