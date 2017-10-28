// This class handles all the game data and functions not specific to a single game level.
// Author: David Cary
// Last Updated: June 2008

package com.neopets.games.inhouse.pinball.gui{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.ShellControl;
	
	public class StartButton extends SceneControlButton {
		protected var textClip:MovieClip;
		
		// This function handles the button's initial set up once it's been added to the scene.
		protected override function onAddedToScene():void {
			button = this;
			textClip = this["text_mc"];
			if(textClip != null) textfield = textClip.main_txt;
			setText("FGS_MAIN_MENU_START_GAME","Start Game");
			destination = ShellControl.PLAY_GAME_SCENE;
		}
		
	}
	
}