// A "BarbellPart" consists of two polygons jointed at their starting points by a line.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import com.neopets.games.inhouse.pinball.objects.abstract.MultiWalled;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class BarbellPart extends MultiWalled {
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				addWall("a",true);
				addWall("b",true);
				connectPoints("a",0,"b",0);
			}
		}
		
	}
}