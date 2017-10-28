/* AS3
	Copyright 2010
*/

package com.neopets.games.inhouse.advervideo.pc.tools {
	
	/**
	 *	A Key polling library. Works way faster than KEY_DOWN events and supports multiple keypresses
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 21 Apr 2010
	*/	
	
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;

	public class KeyPoll {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static const _instance:KeyPoll = new KeyPoll(SingletonEnforcer);
		
		public static const A:int = 65;
		public static const B:int = 66;
		public static const C:int = 67;
		public static const D:int = 68;
		public static const E:int = 69;
		public static const F:int = 70;
		public static const G:int = 71;
		public static const H:int = 72;
		public static const I:int = 73;
		public static const J:int = 74;
		public static const K:int = 75;
		public static const L:int = 76;
		public static const M:int = 77;
		public static const N:int = 78;
		public static const O:int = 79;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const R:int = 82;
		public static const S:int = 83;
		public static const T:int = 84;
		public static const U:int = 85;
		public static const V:int = 86;
		public static const W:int = 87;
		public static const X:int = 88;
		public static const Y:int = 89;
		public static const Z:int = 90;
		
		public static const SPACE:int = 32;
		public static const ENTER:int = 13;
		public static const ESC:int = 27;
		public static const CTRL:int = 17;
		public static const SHIFT:int = 16;
		public static const TAB:int = 9;
		public static const TIDDLE:int = 192;
		public static const CAPS_LOCK:int = 20;
		public static const NUM_LOCK:int = 144;
		public static const BACKSPACE:int = 8;
		
		public static const LEFT:int = 37;
		public static const UP:int = 38;
		public static const RIGHT:int = 39;
		public static const DOWN:int = 40;
		
		public static const F1:int = 112;
		public static const F2:int = 113;
		public static const F3:int = 114;
		public static const F4:int = 115;
		public static const F5:int = 116;
		public static const F6:int = 117;
		public static const F7:int = 118;
		public static const F8:int = 119;
		public static const F9:int = 120;
		
		public static const KEY0:int = 48;
		public static const KEY1:int = 49;
		public static const KEY2:int = 50;
		public static const KEY3:int = 51;
		public static const KEY4:int = 52;
		public static const KEY5:int = 53;
		public static const KEY6:int = 54;
		public static const KEY7:int = 55;
		public static const KEY8:int = 56;
		public static const KEY9:int = 57;
		
		public static const PLUS:int = 187;		
		public static const MINUS:int = 189;
		public static const LESS_THAN:int = 188; // <
		public static const GREATER_THAN:int = 190; // >
		public static const SLASH:int = 191; // /
		public static const OPEN_SQUARE_BRACKET:int = 219; // [
		public static const CLOSE_SQUARE_BRACKET:int = 221; // ]
		public static const BACKSLASH:int = 220; // \

		public static const NUM0:int = 96;
		public static const NUM1:int = 97;
		public static const NUM2:int = 98;
		public static const NUM3:int = 99;
		public static const NUM4:int = 100;
		public static const NUM5:int = 101;
		public static const NUM6:int = 102;
		public static const NUM7:int = 103;
		public static const NUM8:int = 104;
		public static const NUM9:int = 105;
		
		public static const NUM_STAR:int = 106;
		public static const NUM_PLUS:int = 107;
		public static const NUM_MINUS:int = 109;
		public static const NUM_DOT:int = 110;
		public static const NUM_SLASH:int = 111;

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _states:ByteArray;
		private var _dispObj:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function KeyPoll(singletonEnforcer:Class = null):void {
			if(singletonEnforcer != SingletonEnforcer) {
				throw new Error( "[GameUtilities] Invalid Singleton access. Use GameUtilities.instance." ); 
			} else {
				_states = new ByteArray();
				for (var i:int = 0; i < 7; i ++) {
					_states.writeUnsignedInt(0);
				}
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():KeyPoll {
			return _instance;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function init(p_displayObj:DisplayObject):void {
			if (_dispObj) {
				_dispObj.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				_dispObj.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				_dispObj.removeEventListener(Event.ACTIVATE, activateListener);
				_dispObj.removeEventListener(Event.DEACTIVATE, deactivateListener);
			}
			_dispObj = p_displayObj;
			
			if (_dispObj) {
				_dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				_dispObj.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				_dispObj.addEventListener(Event.ACTIVATE, activateListener);
				_dispObj.addEventListener(Event.DEACTIVATE, deactivateListener);
			}
		}

		public function isKeyDown(p_keyCode:int):Boolean {
			return (_states[p_keyCode >>> 3] & (1 << (p_keyCode & 7))) != 0;
		}
		
		public function isKeyUp(p_keyCode:int):Boolean {
			return (_states[p_keyCode >>> 3] & (1 << (p_keyCode & 7))) == 0;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		private function keyDownListener(e:KeyboardEvent):void {
			_states[e.keyCode >>> 3] |= 1 << (e.keyCode & 7);
		}
		
		private function keyUpListener(e:KeyboardEvent):void	{
			_states[e.keyCode >>> 3] &= ~(1 << (e.keyCode & 7));
		}
		
		private function activateListener(e:Event):void	 {
			for (var i:int = 0; i < 32; ++i) _states[i] = 0;
		}

		private function deactivateListener(e:Event):void {
			for( var i:int = 0; i < 32; ++i) _states[i] = 0;
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			init(null);
			_states = null;
		}
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}


