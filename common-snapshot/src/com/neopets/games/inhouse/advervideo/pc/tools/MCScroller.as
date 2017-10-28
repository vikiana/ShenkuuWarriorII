/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.tools {
	
	/**
	 *	An object for smooth scrolling panel used for About and Instructions text
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 22 Sept 2009
	*/	
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.text.TextField;
	
	public class MCScroller {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private const SCROLL_INCREMENT:int = 30;
		
		private const UpBtnClass:Class = MCScroller_UP;
		private const DownBtnClass:Class = MCScroller_DOWN;
		private const ScrollBarClass:Class = MCScroller_SCROLLBAR;
				
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _PARENT:DisplayObjectContainer;
		
		private var _container:Sprite;
		private var _mask:Sprite;
		private var _maskee:DisplayObjectContainer;
		private var _interface:Boolean;
		private var _mywidth:int;
		private var _myheight:int;
		
		private var _mcs_up:DisplayObjectContainer;
		private var _mcs_down:DisplayObjectContainer;
		private var _mcs_scrollbar:DisplayObjectContainer;
		
		private var _move_dir:int;
		private var _my:int;
		
		private var _clicktimer:Timer;
		private var _scrollbar_active:Boolean;
		
		private var _top_detect:int;
		private var _bottom_detect:int;
		private var _scrollbar_top:int;
		private var _scrollbar_bottom:int;
		private var _movable:int;
		
		private var _func:Function;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MCScroller(p_parent:DisplayObjectContainer, p_mc:DisplayObjectContainer, p_x:int = 0, p_y:int = 0, p_width:int = 0, p_height:int = 0):void {
			_PARENT = p_parent;
			_maskee = p_mc;
			_interface = false;
			
			//_upbtn = MCScroller_UP;
			//_downbtn = MCScroller_DOWN
			//_scrollbar = MCScroller_SCROLLBAR;
			
			// create the container
			_container = new Sprite();
			_PARENT.addChild(_container);
			_container.x = p_x;
			_container.y = p_y;
			
			(p_width == 0)? _mywidth = Math.ceil(_maskee.width): _mywidth = p_width;
			(p_height == 0)? _myheight = Math.ceil(_maskee.height): _myheight = p_height;

			// make a background for scrolling detection
			var backing:Sprite = makeBlock(_mywidth, _myheight);
			backing.alpha = 0;
			backing.cacheAsBitmap = true;
			backing.x = 0;
			backing.y = 0;
			_container.addChild(backing);
			
			//create the mask
			_mask = makeBlock(_mywidth, _myheight);
			_container.addChild(_mask);
			_mask.visible = false;
			_mask.x = 0;
			_mask.y = 0;
			_mask.mouseEnabled = false;
			
			_func = checkInit;
			_container.addEventListener(Event.ENTER_FRAME, efFunction);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Enterframe event
		*/ 		
		private function efFunction(e:Event):void {
			_func();
		}

		/**
		 * @Note: When the mouse button is released
		*/ 		
		protected function buttonUp(e:MouseEvent):void {
			if ((_move_dir != 0) || (_scrollbar_active)) {
				_move_dir = 0;
				_scrollbar_active = false;
				_clicktimer.stop();
			}
		}
		
		/**
		 * @Note: When mouse moves out of up/down button
		*/ 		
		protected function buttonRollOut(e:MouseEvent):void {
			if (_move_dir != 0) { // if only button in use
				_move_dir = 0;
				_clicktimer.stop();
			}
		}

		/**
		 * @Note: When mouse button is pressed on up button
		*/ 		
		protected function upButtonDown(e:MouseEvent):void {
			if (_move_dir <= 0) {
				_move_dir = 1;
				_clicktimer.reset();
				_clicktimer.start();
			}
		}
				
		/**
		 * @Note: When mouse button is pressed on down button
		*/ 		
		protected function downButtonDown(e:MouseEvent):void {
			if (_move_dir == 0) {
				_move_dir = -1;
				_clicktimer.reset();
				_clicktimer.start();
			}
		}
		
		/**
		 * @Note: When the scrollbar is being used. (mouse button is pressed down on the scrollbar)
		*/ 		
		protected function scrollBarActive(e:MouseEvent):void {
			if (!_scrollbar_active) {
				_scrollbar_active = true;
				_clicktimer.reset();
				_clicktimer.start();
			}
		}
		
		/**
		 * @Note: When mouse scrollwheel is moved
		*/ 		
		protected function mouseWheelHandler(e:MouseEvent):void {
			if ((_container.mouseY > 0) && (_container.mouseY < _container.height)) {
				if ((_container.mouseX > 0) && (_container.mouseX < _container.width)) {
					if (e.delta < 0) { // scroll up
						scrollDown();
						scrollDown();
						scrollDown();
					} else { // scroll down
						scrollUp();
						scrollUp();
						scrollUp();
					}
				}
			}
		}
		
		/**
		 * @Note: Periodically moves the panel when up/down button is pressed or scrollbar is being used.
		*/ 		
		protected function moveMaskee(e:TimerEvent):void {
			if (!_scrollbar_active) { // scrollbar not in use
				if (_move_dir > 0) { // using button click scroll
					scrollUp();
				} else if (_move_dir < 0) {
					scrollDown();
				}
			} else { // scrollbar in use
				// determine scroll position using mouse position
				if ((_container.mouseY > _top_detect) && (_container.mouseY < _bottom_detect)) {
					var ratio:Number = (_container.mouseY - _top_detect) / (_bottom_detect - _top_detect);
					_my = -int(ratio * _movable);
				} else if (_container.mouseY <= _top_detect) {
					_my = 0;
				} else if (_container.mouseY >= _bottom_detect) {
					_my = -(_maskee.height - _mask.height);
				}
				_func = anim;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Do nothing
		*/ 		
		private function idleFunction():void {}
		
		/**
		 * @Note: Creates a black block
		 * @param		p_width		int 		width of the block
		 * @param		p_height	int 		height of the block
		 * @return		Sprite					The created block
		*/ 		
		protected function makeBlock(p_width:int, p_height:int):Sprite {
			var res:Sprite = new Sprite();
			res.graphics.clear();
			res.graphics.beginFill(0x000000);
			res.graphics.drawRect(0, 0, p_width, p_height);
			return res;
		}
		
		/**
		 * @Note: Checks if all objects are initialized, and start adding objects
		*/ 		
		protected function checkInit():void {
			for (var i:int = 0; i < _PARENT.numChildren; i ++) {
				if (!_PARENT.getChildAt(i)) return;
			}
			_func = idleFunction;
			// move target displayobject into the container
			_container.addChild(_maskee);
			_maskee.x = 0;
			_maskee.y = 0;
			_maskee.mouseEnabled = false;
			// create the buttons and scrollbar
			if (_maskee.height > _mask.height) {
				createInterface();
				_maskee.mask = _mask;
			}
		}
		
		/**
		 * @Note: Creates the up and down buttons and scrollbar
		*/ 		
		protected function createInterface():void {
			_interface = true;
			_mcs_up = new UpBtnClass();
			_mcs_down = new DownBtnClass();
			_mcs_scrollbar = new ScrollBarClass();
					
			_container.addChild(_mcs_up);
			_container.addChild(_mcs_down);
			_container.addChild(_mcs_scrollbar);
			
			// up down buttons and scrollbar placements
			var x1:int = int(_mask.width + (_mcs_up.width / 2));
			var x2:int = int(_mask.width + (_mcs_down.width / 2));
			var final_x:int = x1;
			if (x2 > x1) {final_x = x2;}
			_mcs_up.x = final_x;
			_mcs_up.y = _mcs_up.height;
			_mcs_down.x = final_x;
			_mcs_down.y = _mask.height - _mcs_down.height;
			_scrollbar_top = int(_mcs_up.y + (_mcs_scrollbar.height / 2));
			_scrollbar_bottom = int(_mask.height - (_mcs_down.height + (_mcs_scrollbar.height / 2)));
			_mcs_scrollbar.x = final_x;
			_mcs_scrollbar.y = _scrollbar_top;
			_scrollbar_active = false;
			
			// mouse click detection parameters
			_top_detect = _mcs_up.height + (_mcs_scrollbar.height / 2);
			_bottom_detect = _mask.height - (_mcs_down.height + (_mcs_scrollbar.height / 2));
			_movable = Math.ceil(_maskee.height - _mask.height);
			_move_dir = 0;
			_my = 0;
			_clicktimer = new Timer(30, 0);
			_clicktimer.addEventListener(TimerEvent.TIMER, moveMaskee);
			
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, buttonUp);
			_container.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
			_mcs_up.addEventListener(MouseEvent.MOUSE_DOWN, upButtonDown);
			_mcs_up.addEventListener(MouseEvent.ROLL_OUT, buttonRollOut);
			
			_mcs_down.addEventListener(MouseEvent.MOUSE_DOWN, downButtonDown);
			_mcs_down.addEventListener(MouseEvent.ROLL_OUT, buttonRollOut);
			
			_mcs_scrollbar.addEventListener(MouseEvent.MOUSE_DOWN, scrollBarActive);
		}
		
		/**
		 * @Note: The scrolling animation. Called from enterframe event
		*/ 		
		protected function anim():void {
			if (_maskee.y != _my) {
				(Math.abs(_maskee.y - _my) > 1)? _maskee.y += (_my - _maskee.y) / 7 : _maskee.y = _my;
				
				var ratio:Number = Math.abs(_my) / _movable;
				var scrollbar_gap:int = _scrollbar_bottom - _scrollbar_top;
				_mcs_scrollbar.y =  _scrollbar_top + (ratio * scrollbar_gap);
			}
			if (!_PARENT.visible) { // reset position and go to idle mode when parent is not visible
				resetPosition();
				_func = idleFunction;
			}
		}
		
		/**
		 * @Note: Brings the panel back to the top
		*/ 		
		private function resetPosition():void {
			_maskee.y = 0;
			_mcs_scrollbar.y = _scrollbar_top;
			_move_dir = 0;
			_my = 0;
		}
		
		/**
		 * @Note: Scrolls the panel up
		*/ 		
		protected function scrollUp():void {
			(_my + SCROLL_INCREMENT < 0)? _my += SCROLL_INCREMENT: _my = 0;
			_func = anim;
		}
		
		/**
		 * @Note: Scrolls the panel down
		*/ 		
		protected function scrollDown():void {
			var diff:Number = _maskee.height - _mask.height;
			(_my - SCROLL_INCREMENT > -diff)? _my -= SCROLL_INCREMENT: _my = -Math.ceil(diff);
			_func = anim;
		}
		
		/**
		 *	@Destructor
		*/
		public function destructor():void {
			_container.removeEventListener(Event.ENTER_FRAME, efFunction);
			if (_interface) {
				_container.stage.removeEventListener(MouseEvent.MOUSE_UP, buttonUp);
				_container.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
				_mcs_up.removeEventListener(MouseEvent.MOUSE_DOWN, upButtonDown);
				_mcs_up.removeEventListener(MouseEvent.ROLL_OUT, buttonUp);
			
				_mcs_down.removeEventListener(MouseEvent.MOUSE_DOWN, downButtonDown);
				_mcs_down.removeEventListener(MouseEvent.ROLL_OUT, buttonUp);
			
				_mcs_scrollbar.removeEventListener(MouseEvent.MOUSE_DOWN, scrollBarActive);
				
				_clicktimer.removeEventListener(TimerEvent.TIMER_COMPLETE, moveMaskee);
				
				_container.removeChild(_mcs_up);
				_container.removeChild(_mcs_down);
				_container.removeChild(_mcs_scrollbar);
				_mcs_up = null;
				_mcs_down = null;
				_mcs_scrollbar = null;
			}
			_maskee.mask = null
			_maskee.parent.removeChild(_maskee);
			_maskee = null;
			_mask = null;
			_PARENT.removeChild(_container);
			_container = null;
			_PARENT = null;
			_func = null;
		}
	}
}