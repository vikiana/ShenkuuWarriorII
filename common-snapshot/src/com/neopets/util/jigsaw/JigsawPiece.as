/* AS3
	Copyright 2010
*/

package com.neopets.util.jigsaw {
	
	/**
	 *	This is a single piece of jigsaw. Also functions as a doubly linked list node
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 25 Feb 2010
	 */	
	 
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		
	 
	 internal class JigsawPiece extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _clickx:Number;
		private var _clicky:Number;
		private var _oldhome:DisplayObjectContainer;
		private var _active:Boolean;
				
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var JIGSAW:Jigsaw;
		public var _func:Function;
		
		public var _mousex:int;
		public var _mousey:int;
				
		public var id:int;
		public var cx:int;
		public var cy:int;
		public var bm:Bitmap;
		public var mymask:Jig;
		public var mapper:JigsawMapper;
		public var nextlink:JigsawPiece;
		public var prevlink:JigsawPiece;
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function JigsawPiece():void {
			_func = idleFunction;
			nextlink = prevlink = null;
			bm = new Bitmap();
			//_oldhome = JIGSAW._bottomlayer;
			_active = true;
			addChild(bm);
			cacheAsBitmap = true;
			addEventListener(MouseEvent.MOUSE_DOWN, pickMeUp);
			//addEventListener(Event.ENTER_FRAME, efFunction);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get vx():int {
			return (x + cx);
		}
		
		public function get vy():int {
			return (y + cy);
		}
		
		public function set vx(p_x:int):void {
			x = p_x - cx;
		}
		
		public function set vy(p_y:int):void {
			y = p_y - cy;
		}
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Sets the mask for the picture (to form the jigsaw shape)
		*/ 		
		public function setMaskAs(p_mask:Jig):void {
			mymask = p_mask;
			addChild(mymask);
			bm.mask = mymask;
		}
		
		/**
		 * @Note: Sets the bitmapdata (this is the image being shown behind the mask)
		*/ 		
		public function setBitmapAs(p_bmd:BitmapData, p_rect:Rectangle = null):void {
			if (!p_rect) {
				bm.bitmapData = p_bmd;
			} else {
				bm.bitmapData = p_bmd;
				bm.x = p_rect.x;
				bm.y = p_rect.y;
			}
		}
		
		/**
		 * @Note: Snaps this piece to the designated coordinates. (The coordinates of another piece of jigsaw)
		 * @param		p_x		int 		X coordinate
		 * @param		p_y		int 		Y coordinate
		*/ 		
		public function snapTo(p_x:int, p_y:int):void {
			x = p_x;
			y = p_y;
		}
		
		/**
		 * @Note: Floats this piece above all other pieces not picked up
		*/ 		
		public function floatMe():void {
			_clickx = mouseX;
			_clicky = mouseY;
			_oldhome = JIGSAW._bottomlayer;
			JIGSAW.floatJigsawPiece(this);
			_func = followTheMouse;
		}
		
		/**
		 * @Note: Disables this jigsaw piece. Places it down and inactive
		 * @param		p_success		Boolean 		True if player completes the stage
		*/ 		
		public function disabled(p_success:Boolean = true):void {
			putMeDown();
			_active = false;
			if (p_success) _func = fadeOut;
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: When mouse picks up this piece of jigsaw
		*/ 		
		public function pickMeUp(e:MouseEvent = null):void {
			_mousex = parent.mouseX;
			_mousey = parent.mouseY;
			if ((_mousex <= JIGSAW.left_bound) || (_mousex >= JIGSAW.right_bound)) {
				return;
			}
			
			if ((_mousey <= JIGSAW.up_bound) || (_mousey >= JIGSAW.down_bound)) {
				return;
			}
			
			if (_active) mapper.pickUpJigsaw(this);
		}

		/**
		 * @Note: Puts this piece of jigsaw down
		*/ 		
		public function putMeDown():void {
			if (_func == followTheMouse) {
				_func = idleFunction;
				_oldhome.addChild(this);
				mapper.checkNeighbourIsNear(this);
			}
		}
		
		/**
		 * @Note: Enterframe function
		*/ 		
		private function efFunction(e:Event):void {
			_func();
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Do nothing
		*/ 		
		private function idleFunction():void {}
		
		/**
		 * @Note: Follows where the mouse goes
		*/ 		
		private function followTheMouse():void {
			_mousex = parent.mouseX;
			_mousey = parent.mouseY;
			
			if ((_mousex <= JIGSAW.left_bound) || (_mousex >= JIGSAW.right_bound)) {
				mapper.putJigsawDown(this);
				return;
			}
			
			if ((_mousey <= JIGSAW.up_bound) || (_mousey >= JIGSAW.down_bound)) {
				mapper.putJigsawDown(this);
				return;
			}
			
			x += ((_mousex - _clickx) - x) >> 1;
			y += ((_mousey - _clicky) - y) >> 1;
			x = int(x);
			y = int(y);
		}
		
		/**
		 * @Note: Moves the jigsaw to the center
		*/ 		
		private function fadeOut():void {
			if (alpha > 0) {
				alpha -= 0.1;
			} else {
				_func = idleFunction;
			}
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			//removeEventListener(Event.ENTER_FRAME, efFunction);
			cacheAsBitmap = false;
			removeEventListener(MouseEvent.MOUSE_DOWN, pickMeUp);
			bm.bitmapData.dispose();
			bm.bitmapData = null;
			bm.mask = null;
			removeChild(bm);
			removeChild(mymask);
			bm = null;
			mymask = null;
			nextlink = prevlink = null;
			JIGSAW = null;
		}
	}
}