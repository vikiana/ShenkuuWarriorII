/* AS3
	Copyright 2008
*/
package com.neopets.util.collision
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 *	The Collision Manager handles all collision spaces created by the project.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author David Cary
	 *	@since  8.24.2009
	 */
	public class CollisionManager
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected static var _spaces:Array = new Array();
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function CollisionManager():void{
			throw new Error( "Invalid Singleton access." );
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @This function returns a list of all known coordinate spaces.
		 */
		 
		public static function get spaces():Array { return _spaces; }
		
		/**
		 * @This function tries to find the coordinate space with the target name.
		 */
		 
		public static function getSpace(id:String):CollisionSpace {
			var space:CollisionSpace;
			for(var i:int = 0; i <  _spaces.length; i++) {
				space = _spaces[i];
				if(space.name == id) return space;
			}
			return null;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to create a new collision space with a unique identifier.
		 * @param		id			String 						Name of the new collision space.
		 * @param		container	DisplayObjectContainer 		Base container for the new space. 
		 */
		 
		public static function addSpace(id:String,container:DisplayObjectContainer=null):CollisionSpace {
			var space:CollisionSpace;
			space = getSpace(id);
			if(space == null) {
				space = new CollisionSpace(id,container);
				_spaces.push(space);
			}
			return space;
		}
		
		/**
		 * @This function tries to add a canvas to the target coordinate space.
		 * @param		id			String 						Name of the new collision space.
		 * @param		container	DisplayObjectContainer 		Base container for the new drawing layer.
		 * @param		tag			String				 		Optional name for the drawing layer.
		 */
		 
		public static function addCanvas(id:String,container:DisplayObjectContainer=null,tag:String=null):Sprite {
			var space:CollisionSpace;
			space = getSpace(id);
			if(space != null) return space.addCanvas(container,tag);
			else return null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
