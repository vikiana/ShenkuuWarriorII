/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.materials
{
	
	/**
	 *	This class tracks physics properties for a given substance.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.6.2009
	 */
	public class MaterialData
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _name:String;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var density:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MaterialData(tag:String):void{
			_name = tag;
			density = 1;
			// make sure there's no other instances that use our name
			if(!MaterialRegistry.register(this)) {
				throw new Error("Error: Material(" + _name + ") could not be registered!");
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get name():String { return _name; }
		
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
