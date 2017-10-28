/* AS3
	Copyright 2010
*/

package com.neopets.util.jigsaw {
	
	/**
	 *	This is used to form a single Jigsaw mask using 4 JigParts. Determines the edges of the piece.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 26 Feb 2010
	*/	
	
	import flash.display.Sprite;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 

	 
	 internal class Jig extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const FACE_UP:int = 0;
		public static const FACE_RIGHT:int = 1;
		public static const FACE_DOWN:int = 2;
		public static const FACE_LEFT:int = 3;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var JIGS:Array;		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Jig():void {
			JIGS = [];
			for (var j:int = 0; j < 4; j ++) {
				JIGS[j] = new JigPart();
				addChild(JIGS[j]);
				JIGS[j].x = 50;
				JIGS[j].y = 50;
				JIGS[j].rotation = 90 * j;
				JIGS[j].gotoAndStop(1);
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Finds a mating edge to a particular edge
		 * @param		p_type		int 		The type of edge to check for
		 * @return						int			The matching edge which fits
		*/ 
		public function getMate(p_type:int):int {
			if (p_type > 1) {
				if (p_type <= JIGS[0].totalFrames) {
					var mod:int = p_type % 2;
					if (mod == 1) {
						return p_type - 1;
					} else {
						return p_type + 1;
					}
				}
			}
			return 1;
		}
		
		/**
		 * @Note: Sets a particular side to an edge type
		 * @param		p_side		int 		The side to set
		 * @param		p_type		int 		The edge to use
		*/ 
		public function setSide(p_side:int, p_type:int):void {
			JIGS[p_side].gotoAndStop(p_type);
		}
		
		/**
		 * @Note: Returns the edge type used by a particular side
		 * @param		p_side		int 		The side to check
		 * @return						int 		The edge being use
		*/ 
		public function getSide(p_side:int):int {
			return JIGS[p_side].currentFrame;
		}
		
		/**
		 * @Note: Sets a random edge type for a side
		 * @param		p_side		int 		The side to set
		*/ 
		public function setSideRand(p_side:int):void {
			JIGS[p_side].gotoAndStop(randRange(2, JIGS[p_side].totalFrames));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Creates a random number between p_start and p_end (inclusive)
		 * @param		p_start			int		Starting number
		 * @param		p_end			int		Ending number
		 * @param		int							the returned random number
		 */
		private function randRange(p_start: int, p_end: int):int {
			return Math.floor(p_start + int(Math.random() * ((p_end + 1) - p_start)));
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			if (parent) parent.removeChild(this);
			for (var j:int = 0; j < JIGS.length; j ++) {
				removeChild(JIGS[j]);
			}
			JIGS.length = 0;
			JIGS = null;
		}
	}
}