/* AS3
	Copyright 2008
*/
package com.neopets.util.collision
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.neopets.util.collision.objects.CollisionSensor;
	import com.neopets.util.collision.geometry.BoundedArea;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class CollisionSpace
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _name:String;
		protected var _contents:Array;
		protected var _root:DisplayObjectContainer;
		protected var _canvas:Sprite;
		protected var redrawNeeded:Boolean;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var lineColor:uint;
		public var showMotion:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		id			String			 		Space's name.
		 *  @param		base		DisplayObjectContainer 	Used in "getBounds" calls of contents.
		 */
		public function CollisionSpace(id:String=null,base:DisplayObjectContainer=null):void{
			_name = id;
			_contents = new Array();
			_root = base;
			lineColor = 0x000000;
			showMotion = true;
			redrawNeeded = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function returns the space's unique identifier.
		 */
		 
		public function get name():String { return _name; }
		
		/**
		 * @This function returns a list of the space's contents.
		 */
		 
		public function get contents():Array { return _contents; }
		
		/**
		 * @This function returns what this space uses as it's "root" layer.
		 */
		 
		public function get root():DisplayObjectContainer { return _root; }
		
		/**
		 * @This function returns a list of the drawing areas used by this space.
		 */
		
		public function get canvas():Sprite { return _canvas; }
		
		/**
		 * @This function tries to add a canvas to the target coordinate space.
		 * @param		container	DisplayObjectContainer 		Base container for the new drawing layer.
		 * @param		tag			String				 		Optional name for the drawing layer.
		 */
		 
		public function set canvas(sprite:Sprite):void {
			// clear previous canvas
			if(_canvas != null) {
				_canvas.removeEventListener(Event.REMOVED_FROM_STAGE,onCanvasRemoval);
				_canvas = null;
			}
			// set up new canvas
			_canvas = sprite;
			if(_canvas != null) {
				redrawNeeded = true;
				_canvas.addEventListener(Event.ENTER_FRAME,onCanvasFrame);
				_canvas.addEventListener(Event.REMOVED_FROM_STAGE,onCanvasRemoval);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to add a new object to this collision space.
		 * @param		itm		CollisionSensor 		The object to be added.
		 */
		 
		public function addItem(itm:CollisionSensor):void{
			if(itm == null) return;
			// check if we already have this object
			var entry:CollisionSensor;
			for(var i:int = 0; i < _contents.length; i++) {
				entry = _contents[i];
				if(entry == itm) return;
			}
			// do the intiail collision test against our other contents
			for(i = 0; i < _contents.length; i++) {
				entry = _contents[i];
				itm.checkForCollision(entry);
			}
			// add it to our content list
			itm.addEventListener(BoundedArea.AREA_CHANGED,onAreaChange);
			_contents.push(itm);
			redrawNeeded = true;
		}
		
		/**
		 * @This function tries to take an object out of this collision space.
		 * @param		itm		CollisionSensor 		The object to be added.
		 */
		 
		public function removeItem(itm:CollisionSensor):void{
			if(itm == null) return;
			// clear the item's collision list
			itm.clearColliders();
			// take the item off our list
			var entry:CollisionSensor;
			for(var i:int = _contents.length - 1; i >= 0; i--) {
				entry = _contents[i];
				if(entry == itm) {
					itm.removeEventListener(BoundedArea.AREA_CHANGED,onAreaChange);
					_contents.splice(i,1);
				} else {
					entry.removeCollider(itm);
				}
			}
			redrawNeeded = true;
		}
		
		/**
		 * @This function tries to add a canvas to the target coordinate space.
		 * @param		container	DisplayObjectContainer 		Base container for the new drawing layer.
		 * @param		tag			String				 		Optional name for the drawing layer.
		 */
		 
		public function addCanvas(container:DisplayObjectContainer=null,tag:String=null):Sprite {
			var spr:Sprite = new Sprite();
			spr.mouseEnabled = false;
			if(tag != null) spr.name = tag;
			if(container != null) container.addChild(spr);
			canvas = spr;
			return _canvas;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function checks each frame to see if the canvas needs to be updated.
		 */
		 
		public function onCanvasFrame(ev:Event):void {
			if(redrawNeeded) {
				if (_canvas){
				_canvas.graphics.clear();
				}
				var entry:CollisionSensor;
				for(var i:int = 0; i < _contents.length; i++) {
					_canvas.graphics.lineStyle(1,lineColor,1);
					entry = _contents[i];
					entry.drawOn(_canvas);
				}
				redrawNeeded = false;
			}
		}
		
		/**
		 * @Automatically clear the canvas when it's removed from the stage.
		 */
		 
		public function onCanvasRemoval(ev:Event):void {
			canvas = null;
		}
		
		/**
		 * @This function tries to add a canvas to the target coordinate space.
		 */
		 
		public function onAreaChange(ev:Event):void {
			var itm:CollisionSensor = ev.target as CollisionSensor;
			// check for collisions
			var entry:CollisionSensor;
			for(var i:int = _contents.length - 1; i >= 0; i--) {
				entry = _contents[i];
				itm.checkForCollision(entry);
			}
			redrawNeeded = true;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
