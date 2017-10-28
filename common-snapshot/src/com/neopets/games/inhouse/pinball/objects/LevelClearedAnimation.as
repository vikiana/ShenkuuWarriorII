// Use this class for animations that should only play when the board has been cleared.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	public class LevelClearedAnimation extends CabinetPart {
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			_cabinet.addEventListener(GameShell.BOARD_FINISHED,resumeAnimation);
			gotoAndStop(1);
		}
		
		public function resumeAnimation(ev:Event=null) {
			_cabinet.game.controller.playSound(SoundIDs.BIG_DOOR_CLOSE);	
			gotoAndPlay(2);
		}
		
		// Removal Functions
		
		// Put the object's clean up code here.
		protected override function onRemoval():void  {
			_cabinet.removeEventListener(GameShell.BOARD_FINISHED,resumeAnimation);
		}
		
	}
	
}