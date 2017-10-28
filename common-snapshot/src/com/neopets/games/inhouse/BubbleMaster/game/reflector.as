/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class reflector {
		private var target:MovieClip;
		private var reflection:Bitmap;
		private var reflectionMap:BitmapData;
		private var reflectionMask:Sprite;
		
		public function reflector(clip:MovieClip):void {
			target = clip;
			buildReflection();
			buildMask();
			setReflection();
		}
		 
		private function buildReflection():void {
			reflectionMap = new BitmapData(target.width, target.height, true, 0);
			reflectionMap.draw(target);
			
			reflection = new Bitmap();
			reflection.cacheAsBitmap = true;
			reflection.bitmapData = reflectionMap;
			reflection.transform.matrix = new Matrix(1,0,0,-1, 0, 0);
		}
		 
		private function buildMask():void {
			reflectionMask = new Sprite();
			reflectionMask.cacheAsBitmap = true;
			 
			var mtx = new Matrix();
			mtx.createGradientBox(target.width, target.height, Math.PI/2); 
			 
			reflectionMask.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [0.2, 0.4, 0.0], [0, 20, 200], mtx);
			reflectionMask.graphics.drawRect(0, 0, target.width, target.height);
			reflectionMask.graphics.endFill();
		}
		 
		private function setReflection():void {
			reflection.mask = reflectionMask;
			reflection.y = target.height * 2 + 2;
			reflectionMask.y = target.height + 2;
			target.addChild(reflection);
			target.addChild(reflectionMask);
		}
		 
	}
}