// This class handles bumpers which use open walls.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.neopets.games.inhouse.pinball.objects.abstract.WalledBumper;
	import com.neopets.games.inhouse.pinball.objects.components.Wall;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class LineBumper extends WalledBumper {
		// constants
		public static const BASE_VALUE:Number = 50;
		
		// Initialization functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				_group = new Group(false);
				addWall("p");
				var rwall:Wall = addWall("r");
				if(rwall != null) {
					rwall.addEventListener(CollisionEvent.COLLIDE,onCollision);
					hitValue = BASE_VALUE / rwall.length;
				} else hitValue = 1;
				if("img_mc" in this) {
					mainClip = this["img_mc"];
					hitValue *= mainClip.totalFrames;
				}
				hitValue = Math.ceil(hitValue);
				enableUpdates();
			}
			if(mainClip != null) mainClip.gotoAndStop(1);
		}
		
	}
}