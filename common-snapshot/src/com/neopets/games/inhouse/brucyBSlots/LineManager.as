/**
 *	This class shows teh betting lines.  
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.inhouse.brucyBSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	
	
	import com.neopets.users.abelee.resource.easyCall.QuickFunctions;
	
	
	public class LineManager extends Sprite
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var mSlotMachine:SlotMachineCore;
		private var itemWidth:Number
		private var itemHeight:Number
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function LineManager(pWidth:Number = 120, pHeight:Number = 120):void
		{
			itemWidth = pWidth;
			itemHeight = pHeight;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		////
		// 	It can handle 1-9 betting lines This class will only draw one line at a time so, 
		//	if user is betting on 3 lines, this function has to be called 3 times:
		//	makeLine(1), makeLine(2), makeLine(3)
		//
		//	NOTE: colorArray determines the color of each line
		////
		
		public function makeLine(line:int):void
		{
			var colorArray:Array = [0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFDFBAA,0xE7D221,0xA6C0DB,0xD397D9, 0xCEE6AE,0x93BFAA]
			var pointsArray:Array 			
			var yOffset:Number
			var sx:Number = itemWidth * 0
			var sy:Number;
			switch(line)
			{
				case 1:
					yOffset = 0
					sy= itemHeight * 2 + yOffset
					pointsArray = [[sx,sy],[sx + itemWidth * 4, sy]]
					drawLine(pointsArray, colorArray[0], line)
					break;
				
				case 2:
					yOffset = 0
					sy= itemHeight * 1 + yOffset
					pointsArray = [[sx,sy],[sx + itemWidth * 4, sy]]
					drawLine(pointsArray, colorArray[1], line)
					break;
				
				case 3:
					yOffset = 0
					sy= itemHeight * 3 + yOffset
					pointsArray = [[sx,sy],[sx + itemWidth * 4, sy]]
					drawLine(pointsArray, colorArray[2], line)
					break;
				
				case 4:
					yOffset = 10
					sy= itemHeight * 1 + yOffset
					pointsArray = 
						[
						 [sx,sy],
						 [sx + itemWidth * 2, sy + itemHeight * 2],
						 [sx + itemWidth * 4, sy]
						]
					drawLine(pointsArray, colorArray[3], line)
					break;
				
				case 5:
					yOffset = 10
					sy= itemHeight * 3 + yOffset
					pointsArray = 
						[
						 [sx,sy],
						 [sx + itemWidth * 2, sy - itemHeight * 2],
						 [sx + itemWidth * 4, sy]
						]
					drawLine(pointsArray,  colorArray[4], line)
					break;
				
				case 6:
					yOffset = -10
					sy= itemHeight * 1 + yOffset
					pointsArray = 
						[
						 [sx,sy],
						 [sx + itemWidth * 1, sy],
						 [sx + itemWidth * 3, sy + itemHeight * 2],
						 [sx + itemWidth * 4, sy + itemHeight * 2],
						]
					drawLine(pointsArray, colorArray[5], line)
					break;
				
				case 7:
					yOffset = -10
					sy= itemHeight * 3 + yOffset
					pointsArray = 
						[
						 [sx,sy],
						 [sx + itemWidth * 1, sy],
						 [sx + itemWidth * 3, sy - itemHeight * 2],
						 [sx = itemWidth * 4, sy - itemHeight * 2],
						]
					drawLine(pointsArray, colorArray[6], line)
					break;
					
				case 8:
					yOffset = 10
					sy= itemHeight * 2 + yOffset
					pointsArray = 
						[
						 [sx,sy],
						 [sx + itemWidth * 1, sy - itemHeight * 1],
						 [sx + itemWidth * 3, sy + itemHeight * 1],
						 [sx + itemWidth * 4, sy],
						]
					drawLine(pointsArray, colorArray[7], line)
					break;
					
				case 9:
					yOffset = 10
					sy= itemHeight * 2 + yOffset
					pointsArray = 
						[
						 [sx,sy],
						 [sx + itemWidth * 1, sy + itemHeight * 1],
						 [sx + itemWidth * 3, sy - itemHeight * 1],
						 [sx + itemWidth * 4, sy],
						]
					drawLine(pointsArray, colorArray[8], line)
					break;
				
			}
		}
		
		////
		// 	Assuming line have been created already, 
		//	this function will fade a line (alpha) to giving setting 
		//
		//	@PARAM		num		line number
		//	@PARAM		pValue	alpha value
		////
		public function fadeLine(num:int, pValue:Number = .3):void
		{
			var lineSprite:Sprite = getChildByName("line" + num) as Sprite
			lineSprite.alpha = pValue
		}
		
		
		////
		// clean up lines
		////
		public function cleanup():void
		{
			var util:QuickFunctions = new QuickFunctions();
			util.removeChildren(this)
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		////
		// 	draws line and applies a filter(s)
		//
		//	@PARAM		pointsArray		set of x,y points that line should be drawn to
		//	@PARAM		color			color of the line
		//	@PARAM		pType			line type (ie. line 1, or line 7, etc.)
		////
		private function drawLine(pointsArray:Array, color:Number, pType:int):void
		{
			var lineSprite:Sprite = new Sprite();
			
			lineSprite.name = "line"+pType.toString();
			lineSprite.graphics.clear();
			//lineSprite.graphics.lineStyle(2, 0xFFFFFF, 1, true)
			lineSprite.graphics.lineStyle(8, color, 1, true)
			lineSprite.graphics.moveTo(pointsArray[0][0], pointsArray[0][1])
			for (var i:int = 1; i < pointsArray.length; i++)
			{
				lineSprite.graphics.lineTo(pointsArray[i][0], pointsArray[i][1]);
			}
			lineSprite.filters = [new GlowFilter(0x000000, .5, 1.5, 1.5, 10, 3, true)]
			addChild(lineSprite);
			
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}