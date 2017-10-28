/**
 *	DESCRIPTION HERE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.users.abelee.resource.particles
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
 	import flash.display.Sprite
	import flash.display.Graphics
	
	
	public class ParticleGenerator extends Sprite
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var variable
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function ParticleGenerator():void
		{
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		public function generateCircle(pRadius:Number = 1, pColor:Number = undefined, lineThickness:Number = undefined, pLineColor:Number = undefined, pRandomSize:Number = undefined, px:Number = 0, py:Number = 0 ): Sprite
		{
			var circle:Sprite = new  Sprite();
			var color:Number = isNaN(pColor)? Math.random() * 0xFFFFFF: pColor;
			var lineColor:Number = isNaN(pLineColor)? Math.random() * 0xFFFFFF: pLineColor;
			var radius:Number = isNaN(pRandomSize)? pRadius: Math.random() * pRandomSize /2 ;
			circle.graphics.lineStyle(lineThickness, lineColor);
			circle.graphics.beginFill(color);
			circle.graphics.drawCircle(px, py, radius)
			circle.graphics.endFill()
			return circle
		}
		
		public function generateRectangle(pWidth:Number = 2, pHeight:Number = 2, pColor:Number = undefined, lineThickness:Number = undefined, pLineColor:Number = undefined, pRandomSize:Number = undefined, px:Number = 0, py:Number = 0 ): Sprite
		{
			var rect:Sprite = new  Sprite();
			var color:Number = isNaN(pColor)? Math.random() * 0xFFFFFF: pColor;
			var lineColor:Number = isNaN(pLineColor)? Math.random() * 0xFFFFFF: pLineColor;
			var rWidth:Number = isNaN(pRandomSize)? pWidth: Math.random() * pRandomSize;
			var rHeight:Number = isNaN(pRandomSize)? pHeight: Math.random() * pRandomSize;
			rect.graphics.lineStyle(lineThickness, lineColor);
			rect.graphics.beginFill(color);
			rect.graphics.drawRect(px-rWidth/2, py - rHeight/2, rWidth, rHeight)
			rect.graphics.endFill()
			return rect
		}
		
		public function generateTriangle(pWidth:Number = 2, pHeight:Number = 2, pColor:Number = undefined, lineThickness:Number = undefined, pLineColor:Number = undefined, pRandomSize:Number = undefined, px:Number = 0, py:Number = 0 ): Sprite
		{
			var tri:Sprite = new  Sprite();
			var color:Number = isNaN(pColor)? Math.random() * 0xFFFFFF: pColor;
			var lineColor:Number = isNaN(pLineColor)? Math.random() * 0xFFFFFF: pLineColor;
			var rWidth:Number = isNaN(pRandomSize)? pWidth: Math.random() * pRandomSize;
			var rHeight:Number = isNaN(pRandomSize)? pHeight: Math.random() * pRandomSize;
			tri.graphics.lineStyle(lineThickness, lineColor);
			tri.graphics.beginFill(color);
			tri.graphics.moveTo(px-rWidth/2, py - rHeight/2);
			tri.graphics.lineTo(px+rWidth/2, py - rHeight/2);
			tri.graphics.lineTo(px, py + rHeight/2);
			tri.graphics.lineTo(px-rWidth/2, py - rHeight/2);
			tri.graphics.endFill()
			return tri
		}
		
		public function generateRandom(pRadius:Number = 1, pWidth:Number = 2, pHeight:Number = 2, pColor:Number = undefined, lineThickness:Number = undefined, pLineColor:Number = undefined, pRandomSize:Number = undefined, px:Number = 0, py:Number = 0 ): Sprite
		{
			var num:int = Math.floor(Math.random()* 3)
			var particle:Sprite
			switch (num)
			{
				case 0:
					particle = generateCircle (pRadius, pColor, lineThickness, pLineColor, pRandomSize, px, py)
					break;
				case 1:
					particle = generateRectangle (pWidth, pHeight, pColor, lineThickness, pLineColor, pRandomSize, px, py)
					break;
				case 2:
					particle = generateTriangle (pWidth, pHeight, pColor, lineThickness, pLineColor, pRandomSize, px, py)
					break;
			}
			
			return particle
		}
		
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}