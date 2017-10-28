/* AS3
	Copyright 2008
*/
package com.neopets.util.collision.physics.materials
{
	
	/**
	 *	This class acts as a global list of all known materials.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  11.6.2009
	 */
	public class MaterialRegistry
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected static var _materials:Array = new Array();
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MaterialRegistry():void{
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to retrieve the info for the target material.
		 * @param		tag		String 		Name of the material
		 */
		 
		public static function getMaterial(tag:String):MaterialData{
			var mat:MaterialData;
			for(var i:int = 0; i < _materials.length; i++) {
				mat = _materials[i];
				if(mat.name == tag) return mat;
			}
			return null;
		}
		
		/**
		 * @This function removes all materials from the registry
		 */
		 
		public static function clearRegistry():void{
			while(_materials.length > 0) _materials.pop();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @This function tries to add a new material to the registry.
		 * @This is automatically called by new materials and shouldn't be called by anything else.
		 * @param		mat		MaterialData 		New material to be registered.
		 */
		 
		internal static function register(mat:MaterialData):Boolean{
			if(mat == null) return false;
			if(getMaterial(mat.name) != null) {
				// material will throw the error on registry failure
				trace("Error: Material(" + mat.name + ") is already in registry!");
				return false;
			} else {
				_materials.push(mat);
				return true;
			}
		}
		
	}
	
}
