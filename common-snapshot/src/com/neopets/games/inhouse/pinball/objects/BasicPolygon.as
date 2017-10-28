// Use this class to handle parts with simple polygonal boundaries.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	import com.neopets.games.inhouse.pinball.objects.abstract.BallBlocker;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class BasicPolygon extends BallBlocker {
		protected var wall:Wall;
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group();
				wall = new Wall("p",this,true);
			}
		}
		
	}
}