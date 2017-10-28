// This class handles objects that collide with any pinballs that aren't above or below them.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{
	
	import com.neopets.games.inhouse.pinball.objects.Ball;
	
	public class BallBlocker extends CabinetPart {
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		public override function checkInteractionsFor(other:CabinetPart):void {
			// we can collide with any other balls in the same zLayer
			if(other is Ball) {
				if(_group != null && other.group != null) {
					if(other.zLayer == _zLayer) addCollidable(_group,other.group);
					else _group.removeCollidable(other.group);
				}
			}
		}
		
	}
}