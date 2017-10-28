/* AS3
	Copyright 2010
*/

package com.neopets.util.jigsaw {
	
	/**
	 *	Serves as the main container and events handler for the Jigsaw object
	 *
	 * See confluence article
	 * http://confluence.mtvi.com/display/NEOPETS/AS+3.0+-+Jigsaw+Puzzle+Package+%28How+to+use+and+control%29 
	 * for usage guidelines
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 25 Feb 2010
	*/	
	
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class Jigsaw extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const JIGSAW_PICKED:String = "Jigsaw.JIGSAW_PICKED";
		public static const JIGSAW_RELEASED:String = "Jigsaw.JIGSAW_RELEASED";
		public static const JIGSAW_COMBINED:String = "Jigsaw.JIGSAW_COMBINED";
		public static const JIGSAW_COMPLETE:String = "Jigsaw.JIGSAW_COMPLETE";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _mapper:JigsawMapper;
		private var _stage:Object;
		
		private var _cols:int;
		private var _rows:int;
		
		private var _image:Sprite;
		
		private var _func:Function;
		
		private var _dispatcher:EventDispatcher;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var _topleft_x:int;
		public var _topleft_y:int;
		public var _scattered_width:int;
		public var _scattered_height:int;
		
		public var left_bound:int;
		public var right_bound:int;
		public var up_bound:int;
		public var down_bound:int;
		
		// on stage
		public var _toplayer:Sprite;			// when a jigsaw piece is grabbed, it comes here
		public var _bottomlayer:Sprite;		// jigsaw pieces will be here when they are idle
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Jigsaw():void {
			_toplayer = new Sprite();
			var dropshadow = new DropShadowFilter(2, 45, 0, 0.5, 7, 7, 1, BitmapFilterQuality.HIGH);
			var outline = new GlowFilter(0x000000, 1, 1, 1, 3, BitmapFilterQuality.HIGH);
			_toplayer.filters = [dropshadow, outline];

			_bottomlayer = new Sprite();
			_mapper = new JigsawMapper(this);
			_dispatcher = new EventDispatcher();
			
			addChild(_bottomlayer);
			addChild(_toplayer);
			
			_func = idleFunction;
			addEventListener(Event.ENTER_FRAME, efFunction);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get DISPATCHER():EventDispatcher {
			return _dispatcher;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Initializes the jigsaw
		 * @param		p_image					Sprite		The image to use
		 * @param		p_cols						int				Number of columns for the jigsaw
		 * @param		p_rows						int				Number of rows for the jigsaw
		 * @param		p_topleftx					int				X coord of the top left corner where the jigsaw will be (anchor)
		 * @param		p_toplefty					int				Y coord of the top left corner where the jigsaw will be (anchor)
		 * @param		p_scattered_width		int				Jigsaw pieces will be scatter within this width
		 * @param		p_scattered_height		int				Jigsaw pieces will be scatter within this height
		 */
		public function init(p_image:Sprite, p_cols:int = 5, p_rows:int = 5, p_topleftx:int = 0, p_toplefty:int = 0, p_scattered_width:int = 300, p_scattered_height = 300):void {
			if (parent) { // find out the stage object
				_stage = parent;
				while (_stage != _stage.stage) _stage = _stage.stage;
			}
			(p_cols < 2)? _cols = 2: _cols = p_cols;
			(p_rows < 2)? _rows = 2: _rows = p_rows;
			if (_cols > 20) _cols = 20;
			if (_rows > 20) _rows = 20;
			
			_topleft_x = p_topleftx;
			_topleft_y = p_toplefty;
			_scattered_width = p_scattered_width;
			_scattered_height = p_scattered_height;
			
			_image = p_image;
			if (!_image) {
				trace("Warning: image not defined");
				return;
			} else {
				_func = checkAllInit;
			}
		}
		
		public function setBounds(p_x1:int, p_x2:int, p_y1:int, p_y2:int):void {
			up_bound = p_y1;
			down_bound = p_y2;
			left_bound = p_x1;
			right_bound = p_x2;
		}
		
		/**
		 * @Note: Sets a particular jigsaw to float/picked up 
		 * @param		p_jigsawpiece		JigsawPiece		The piece that's picked up
		 */
		public function floatJigsawPiece(p_jigsawpiece:JigsawPiece):void {
			_toplayer.addChild(p_jigsawpiece);
			announceEvent(JIGSAW_PICKED);
		}
		
		/**
		 * @Note: Announces a jigsaw piece has been released
		 */
		public function releaseJigsawPiece():void {
			announceEvent(JIGSAW_RELEASED);
		}
		
		/**
		 * @Note: Signals that the jigsaw is completed
		 */
		public function jigsawIsComplete():void {
			//announceEvent(JIGSAW_COMPLETE);
			_image.alpha = 0;
			_toplayer.addChild(_image);
			//_image.x = (800 - _image.width) / 2;
			//_image.y = (550 - _image.height) /2;
			_image.x = _topleft_x;
			_image.y = _topleft_y;
			_mapper.fadeOut();
			_func = fadeToCompletedJigsaw;
		}
		
		/**
		 * @Note: Signals that 2 jigsaw pieces are combined
		 */
		public function jigsawIsCombined():void {
			announceEvent(JIGSAW_COMBINED);
		}
		
		/**
		 * @Note: Disables all jigsaw pieces
		 */
		public function stopJigsaw():void {
			_mapper.fail();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function efFunction(e:Event):void {
			_func();
		}
		
		private function mouseIsUp(e:MouseEvent):void {
			//trace("mouse up");
			_mapper.putJigsawDown();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		private function idleFunction():void {}
		
		/**
		 * @Note: Checks that all display objects are ready to be accessed
		 */
		private function checkAllInit():void {
			if (!initOK(this)) return;
			if (!initOK(_image)) return;
			_func = idleFunction;
			initDone();
		}
		
		/**
		 * @Note: Done initialization
		 */
		private function initDone():void {
			_mapper.setResource(_image, _cols, _rows);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseIsUp);
			_func = runMapper;
		}
		
		/**
		 * @Note: Checks all displayobjects under a particular displayobject for initialization. Returns True if all displayobjects are ready. 
		 * @param		p_obj			DisplayObject		The displayobject to check
		 * @return		Boolean		True if all displayobjects are accessible and ready for usage, False if at least one is not ready
		 */
		private function initOK(p_obj:DisplayObjectContainer):Boolean {
			for (var i:int = 0; i < p_obj.numChildren; i ++) {
				if (!p_obj.getChildAt(i)) return false;
			}
			return true;
		}
		
		/**
		 * @Note: Dispatches an event for all listeners
		 * @param		p_evt			String		The event to be dispatched
		 */
		private function announceEvent(p_evt:String):void {
			_dispatcher.dispatchEvent(new Event(p_evt));
			//trace(p_evt);
		}
		
		/**
		 * @Note: Runs all jigsaw pieces' enterframe functions
		 */
		private function runMapper():void {
			_mapper.run();
		}
		
		
		/**
		 * @Note: The jigsaw is completed. Fade out all pieces and show the completed image
		*/
		private function fadeToCompletedJigsaw():void {
			_mapper.run();
			if (_image.alpha < 1) {
				_image.alpha += 0.1;
			} else {
				_func = idleFunction;
				announceEvent(JIGSAW_COMPLETE);
				trace("jigsaw completed!");
			}
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			_func = idleFunction;
			removeEventListener(Event.ENTER_FRAME, efFunction);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseIsUp);
			if (parent) parent.removeChild(this);
			_mapper.destructor();
			_mapper = null;
			removeChild(_toplayer);
			removeChild(_bottomlayer);
			_toplayer.filters = null;
			_toplayer = null;
			_bottomlayer = null;
			_stage = null;
			if (_image.parent) {
				_image.parent.removeChild(_image);
			}
			_image = null;
			_dispatcher = null;
		}
	}
}