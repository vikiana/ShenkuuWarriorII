// This class handles circular barriers.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class RoundBlocker extends BallBlocker {
		// APEngine Variables
		protected var myCircle:CircleParticle;
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				myCircle = getPointPart("bounds_mc",true,1,0.5,0);
				addHiddenParticle(myCircle);
			}
		}
		
	}
}