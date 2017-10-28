// Tunnels are just a paired set of walls.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import com.neopets.games.inhouse.pinball.objects.abstract.MultiWalled;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class Tunnel extends MultiWalled {
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group();
				addWall("l");
				addWall("r");
			}
		}
		
	}
}