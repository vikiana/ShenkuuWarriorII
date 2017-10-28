
/* AS3
	Copyright 2008
*/
package  com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	
	/**
	 *	A class to quickly integrate external art (that's already loaded via game engine) with the game
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Abraham Lee
	 *	@since  10.09.2009
	 */
	 
	public class AssetTool
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function AssetTool()
		{
			
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/**
		 *	return a class, assuming the ext. asset is loaded
		 **/
		public static function getClass (pValue:String):Class
		{
			return getDefinitionByName(pValue) as Class
		}
		
		/**
		 *	return instantiated class asset
		 **/
		public static function getAsset (pValue:String):Object
		{
			var tempClass:Class = AssetTool.getClass(pValue)
			return new tempClass ()
		}
		
		/**
		 *	return instantiated class as MovieClip
		 **/
		public static function getMC (pValue:String):MovieClip
		{
			var tempClass:Class = AssetTool.getClass(pValue)
			return MovieClip(new tempClass ())
		}
		
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

