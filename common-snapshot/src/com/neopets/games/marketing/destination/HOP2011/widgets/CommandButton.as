/**
 *	This class lets us program commands into clickable clips easily.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.BoundedIconRow;
	
	import com.neopets.games.marketing.destination.HOP2011.commands.AbsCommand;
	
	public class CommandButton extends MovieClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _clickCommand:AbsCommand;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CommandButton():void {
			super();
			// set up mouse behaviour
			// set up mouse behaviour
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			buttonMode = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get clickCommand():AbsCommand { return _clickCommand; }
		
		public function set clickCommand(cmd:AbsCommand) {
			// remove old listener
			if(_clickCommand != null) {
				removeEventListener(MouseEvent.CLICK,_clickCommand.execute);
			}
			// add new listener
			_clickCommand = cmd;
			if(_clickCommand != null) {
				addEventListener(MouseEvent.CLICK,_clickCommand.execute);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onMouseOver(ev:MouseEvent) {
			gotoAndPlay("on");
		}
		
		protected function onMouseOut(ev:MouseEvent) {
			gotoAndPlay("off");
		}
		
		protected function onMouseDown(ev:MouseEvent) {
			gotoAndPlay("down");
		}

	}
	
}