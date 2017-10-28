// The basic wall is just a cabinet part with a single wall component.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.games.inhouse.pinball.GameShell;
	
	public class LevelDisplay extends CabinetPart 
	{
		
		public var val_txt:TextField; 			//On Stage Level TF
		public var level_txt:TextField;		//On Stage "LEVEL" TextField
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if("val_txt" in this) {
				//valueText = this["val_txt"];
				val_txt.htmlText = _cabinet.levelNumber + "." + _cabinet.boardNumber;
			}
		}
		
	}
}