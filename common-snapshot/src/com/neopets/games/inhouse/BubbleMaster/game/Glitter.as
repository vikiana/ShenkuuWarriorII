/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Glitter extends Sprite {
		private var scope:Object;
		private var target:Object;
		
		private var vector:Number;
		private var velocity:Number;
		
		private var lifetime:int = 0;
		private var lifecount:int = 0;
		
		public function Glitter(_target:Object, _scope:Object, _xp:Number, _yp:Number, _vector:Number, _velocity:Number, _color:uint):void {
			scope = _scope;
			target = _target;
			
			x = _xp;
			y = _yp;
			
			vector = _vector;
			velocity = _velocity / 10;
			
			lifetime = 3 + Math.ceil(Math.random() * 3);
			
			graphics.beginFill(_color);
			graphics.drawCircle(0,0,1);
			graphics.endFill();
			
			target.addChild(this);
			
		}
		
		public function process():void {
			velocity -= velocity / 10;
			x += velocity * Math.cos(vector);
			y += velocity * Math.sin(vector);
			
			alpha = 1 - ( lifecount / lifetime );
			
			(lifecount < lifetime) ? lifecount++ : remove();
		}
		
		private function setRemoval():void {
			scope.removal.push(this);
		}
		
		public function remove():void {
			var id = scope.particles.indexOf(this);
			scope.particles.splice(id, 1);
			parent.removeChild(this);
			delete this;
		}
		
	}	
}