
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.ExtremePotatoCounterAS3.game
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.ExtremePotatoCounterAS3.game.ExtremePotatoCounterGameScreen;
	import com.neopets.util.display.DisplayUtils;
	
	/**
	 *	This class handles flying objectes in the game such as potatoes and other vegetables.
	 *  The name seems to come from the german word for potato and was imported from the flash 6 version of the game.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  1.05.2010
	 */
	 
	public class Kartoffel extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// flash 6 variables
		public var Xspeed:Number;
		public var Yspeed:Number;
		public var rotationSpeed:Number;
		// flash 9 variables
		protected var _gameScreen:ExtremePotatoCounterGameScreen;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function Kartoffel():void {
			addEventListener(Event.ENTER_FRAME,update);
			addEventListener(Event.ADDED,onAdded);
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
		 * @Note: called when this object is added to the stage
		 */
		
		public function onAdded(ev:Event=null):void {
			// check if we're the thing being added
			if(ev.target == this) {
				// seatch for a game screen ancestor
				var ancestor:DisplayObjectContainer = DisplayUtils.getAncestorInstance(this,ExtremePotatoCounterGameScreen);
				if(ancestor != null) _gameScreen = ancestor as ExtremePotatoCounterGameScreen;
				else _gameScreen = null;
				// stop listening
				removeEventListener(Event.ADDED,onAdded);
			}
		}
		
		/**
		 * @Note: called each frame
		 */
		
		public function update(ev:Event=null):void {
			x += Xspeed;
			y += Yspeed;
			rotation += rotationSpeed;
			
			var bRemove = false;
			
			if ( (x - width) > 700 )  bRemove = true;
			else if ( (x + width) < 0 )  bRemove = true;
			if ( (y - height) > 500 )  bRemove = true;
			else if ( (y + height) < 0 )  bRemove = true;
			
			if ( bRemove )
			{
				if(_gameScreen != null) {
					var list:Array = _gameScreen.aKartoffeln;
					for (var i:int = 0; i < list.length; i++) {
						if (list[i] == name) {
							list.splice(i, 1);
							break;
						}
					}
					var gs_vars:Array = _gameScreen.aEKZ;
					if ( (gs_vars[3]/gs_vars[0]) == (gs_vars[2]/gs_vars[0]) ) {
						if ( list.length == 0 ) {
							_gameScreen.roundActive = 0;
						} 
					}
				}
				if(parent != null) parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME,update);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
