/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc {
	
	/**
	 *	Provides a library of useful functions and utilities for game development
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 08 Sept 2009
	*/	
	
	import flash.display.DisplayObjectContainer;
	import flash.net.SharedObject;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		
	 
	 public class GameUtilities {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const VERSION:String = "1.0";
		
		private static const _instance:GameUtilities = new GameUtilities(SingletonEnforcer);
		
		private const rad_const:Number = 180 / Math.PI;
		private const deg_const:Number = Math.PI / 180;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _shareddata:SharedObject;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function GameUtilities(singletonEnforcer:Class = null):void {
			if(singletonEnforcer != SingletonEnforcer) {
				throw new Error( "[GameUtilities] Invalid Singleton access. Use GameUtilities.instance." ); 
			}

			trace("\n[GameUtilities] v" + VERSION + " started\n");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		* @Note: Returns the singleton instance for this object
		* @return		GameUtilities			myself
		*/  
		public static function get instance():GameUtilities {
			return _instance;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Checks all displayobjects under a particular displayobject for initialization. Returns True if all displayobjects are ready. 
		 * @param		p_obj			DisplayObject		The displayobject to check
		 * @return		Boolean		True if all displayobjects are accessible and ready for usage, False if at least one is not ready
		 */
		public function initOK(p_obj:DisplayObjectContainer):Boolean {
			for (var i:int = 0; i < p_obj.numChildren; i ++) {
				if (!p_obj.getChildAt(i)) return false;
			}
			return true;
		}
		
		/**
		 * @Note: Creates a random number between p_start and p_end (inclusive)
		 * @param		p_start			int		Starting number
		 * @param		p_end			int		Ending number
		 * @param		int							the returned random number
		 */
		public function randRange(p_start: int, p_end: int):int {
			return Math.floor(p_start + int(Math.random() * ((p_end + 1) - p_start)));
		}
		
		public function deg2rad(p_deg:Number):Number {
			return p_deg * deg_const;
		}
		
		public function rad2deg(p_rad:Number):Number {
			return p_rad * rad_const;
		}
		
		/**
		 * @Note: Saves a piece of data into a cookie; data is only saved onto the disk when the swf is closed
		 * @param		p_ident				String		The name to identify the cookie
		 * @param		p_dataident		String		The name to identify the data
		 * @param		p_data				*				The data to be saved
		 */
		public function setSharedData(p_ident:String, p_dataident:String, p_data:*):void {
			_shareddata = SharedObject.getLocal(p_ident);
			_shareddata.data[p_dataident] = p_data;
		}
		
		/**
		 * @Note: Retrieves a piece of data from a loaded cookie
		 * @param		p_ident				String		The name to identify the cookie
		 * @param		p_dataident		String		The name to identify the data
		 * @return		*										The data identified by p_ident.p_dataident; null if no data exists
		 */
		public function getSharedData(p_ident:String, p_dataident:String):* {
			_shareddata = SharedObject.getLocal(p_ident);
			if ((_shareddata) && (_shareddata.data[p_dataident])) {
				return _shareddata.data[p_dataident];
			}
			return null;
		}
		
		/**
		 * @Note: Replaces a particular text in a string
		 * @param		poriginal			String 		The text to be worked on
		 * @param		preplace				String 		The text to be replaced on poriginal
		 * @param		ptext					String 		The replacing text
		 * @return		String								The final text with the replaced string
		 */ 				
		public function replaceToken(poriginal:String, preplace:String, ptext:String):String {
			return poriginal.split(preplace).join(ptext);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			_shareddata = null;
		}
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}


