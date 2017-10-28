// This class handles all the game data and functions not specific to a single game level.
// Author: David Cary
// Last Updated: June 2008

package com.neopets.games.inhouse.pinball.gui{
	
	import com.neopets.games.inhouse.pinball.ShellControl;
	
	import flash.display.MovieClip;
	
	public class GameScene extends MovieClip {
		protected var _controller:ShellControl;
		
		public const BUTTON_EVENT:String = "ButtonhasbeenPressed";
		
		// Accessor Functions
		
		/**
		 * @Note: Gives access ti Shell Control that extends GameEngine
		 */
		 
		public function get controller():ShellControl { return _controller; }
		
		public function set controller(shell:ShellControl) {
			// clear the old controller
			if(_controller != null) {
				removeEventListener(ShellControl.CHANGE_SCENE,_controller.onSceneChangeRequest);
			}
			// set up the new controller
			_controller = shell;
			if(_controller != null) {
				addEventListener(ShellControl.CHANGE_SCENE,_controller.onSceneChangeRequest);
			}
		}
		
	}
	
}