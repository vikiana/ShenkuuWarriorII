/**
 *	DESCRIPTION HERE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.users.abelee.resource.bmd
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	public class BMDFollow extends Sprite
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var variable
		private var mWidth:Number;
		private var mHeight:Number;
		private var mSourceSprite:Sprite;
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function BMDFollow(pWidth:Number, pHeight:Number, pSource:Sprite):void
		{
			mWidth = pWidth;
			mHeight = pHeight;
			mSourceSprite = pSource;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		public function startEmitter():void
		{	
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			filters = [new GlowFilter(0x0000FF, 8, 8, 8, 3), new BlurFilter(8, 8, 3) ]
		}
		
		public function reset():void
		{	
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		private function manageChild(num:Number):void
		{
			while (this.numChildren > num)
			{
				this.removeChildAt(0)
			}
		
		}
		
		private function manageChild2():void
		{	
			var inc:Number = 1/this.numChildren
			for (var i:int = 0; i < this.numChildren; i++)
			{				
				var bm:Bitmap = Bitmap(this.getChildAt(i))
				bm.alpha = inc * i
			}
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		private function handleEnterFrame(event : Event) : void
		{
			var buffer1:BitmapData = new BitmapData(mWidth, mHeight, true, 0);
			buffer1.draw(mSourceSprite)
			var bm:Bitmap = new Bitmap(buffer1, "auto", true);
			addChild(bm)
			manageChild(20)
			manageChild2()
		}

	}
	
}







