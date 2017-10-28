// This class wraps walls around the four sides of the pinball cabinet to keep the ball in bounds.
// Author: David Cary
// Last Updated: May 2008

package com.neopets.games.inhouse.pinball.objects
{
	
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import flash.geom.Rectangle;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class CabinetWalls extends CabinetPart {
		protected var _bounds:Rectangle;
		protected var topWall:RectangleParticle;
		protected var leftWall:RectangleParticle;
		protected var rightWall:RectangleParticle;
		protected var bottomWall:RectangleParticle;
		// constants
		public static const WALL_THICKNESS:Number = 32;
		public static const STORAGE_HEIGHT:Number = 64;
		
		// Initialization Functions
		
		// Put any initialization code that depends on the game shell here.
		protected override function onAddedToGame():void  {
			if(_group == null) {
				// calculate bounds
				var half:Number = WALL_THICKNESS/2;
				_bounds = new Rectangle();
				_bounds.left =  -half;
				_bounds.right = GameShell.SCREEN_WIDTH + half;
				_bounds.top = -half;
				_bounds.bottom = GameShell.SCREEN_HEIGHT + half + STORAGE_HEIGHT;
				// add APEngine elements
				if(_bounds != null) {
					_group = new Group(false);
					// add top wall
					var cx:Number = (_bounds.left + _bounds.right) / 2;
					topWall = new RectangleParticle(cx,_bounds.top,_bounds.width,WALL_THICKNESS,0,true);
					topWall.sprite.visible = _cabinet.game.showWires;
					_group.addParticle(topWall);
					// add left wall
					var cy:Number = (_bounds.top + _bounds.bottom) / 2;
					leftWall = new RectangleParticle(_bounds.left,cy,WALL_THICKNESS,_bounds.height,0,true);
					leftWall.sprite.visible = _cabinet.game.showWires;
					_group.addParticle(leftWall);
					// add right wall
					rightWall = new RectangleParticle(_bounds.right,cy,WALL_THICKNESS,_bounds.height,0,true);
					rightWall.sprite.visible = _cabinet.game.showWires;
					_group.addParticle(rightWall);
					// add bottom wall
					bottomWall = new RectangleParticle(cx,_bounds.bottom,_bounds.width,WALL_THICKNESS,0,true,1,0);
					bottomWall.sprite.visible = _cabinet.game.showWires;
					_group.addParticle(bottomWall);
				}
			} // end of group check
		}
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		public override function checkInteractionsFor(other:CabinetPart):void {
			// cabinet walls collide with balls regardless of their zLayer.
			if(other is Ball) {
				if(_group != null && other.group != null) addCollidable(_group,other.group);
			}
		}
		
	}
}