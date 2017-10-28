// This class handles all the game data and functions not specific to a single game level.
// Author: David Cary
// Last Updated: June 2008

package com.neopets.games.inhouse.pinball.gui{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.inhouse.pinball.ShellControl;
	
	public class SceneControlButton extends TextButtonMC {
		protected var _scene:GameScene;
		public var destination:String;
		
		public function SceneControlButton() {
			addEventListener(Event.ADDED_TO_STAGE,findScene);
		}
		
		// Initialization Functions
		
		// This function searches to see if this object has a GameShell ancestor.
		protected function findScene(ev:Event):void {
			if(ev.target == this) {
				var p:Object = parent as Object;
				while(p != null && p != stage) {
					if(p is GameScene) {
						_scene = p as GameScene;
						onAddedToScene();
						break;
					} else p = p.parent; // keep searching
				}
				removeEventListener(Event.ADDED_TO_STAGE,findScene);
			}
		}
		
		// This function handles the button's initial set up once it's been added to the scene.
		// This function is usually overriden by subclasses.
		protected function onAddedToScene():void {
		}
		
		// When a scene control button is clicked it should try to change the scene.
		protected override function onMouseClick(ev:MouseEvent) {
			// broadcast a scene change event
			if(_scene != null) {
				var cev:CustomEvent = new CustomEvent({scene:destination},ShellControl.CHANGE_SCENE);
				_scene.dispatchEvent(cev);
			}
		}
		
	}
	
}