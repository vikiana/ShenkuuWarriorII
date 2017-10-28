// The Score Display simply keeps track of the current score and shows it to the player.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.games.inhouse.pinball.GameShell;
	
	public class ScoreDisplay extends CabinetPart {
		public var valueText:TextField;
		public var score_txt:TextField;
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if("val_txt" in this) valueText = this["val_txt"];
			updateDisplay();
			_cabinet.game.addEventListener(GameShell.SCORE_CHANGED,update);
		}
		
		// Removal Functions
		
		// Put the object's clean up code here.
		protected override function onRemoval():void  {
			_cabinet.game.removeEventListener(GameShell.SCORE_CHANGED,update);
		}
		
		// Update Functions
		
		// This function catches update events when the score changes.
		protected override function update(ev:Event):void  { updateDisplay(); }
		
		protected function updateDisplay():void {
			if(valueText != null) valueText.text = String(Math.round(_cabinet.game.score));
		}
		
	}
}