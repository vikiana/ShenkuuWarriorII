/**
 *	Static class that shows the winning line by playing the animation on items on the winning line
 * 	For example, if line 1 wins a bet with because of first three matching items, the first three items on 
 * 	line one will play the animation
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
	import flash.display.MovieClip;
	
	
	public class WinIndicator
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		//@NOTE: the items on the screen is calculated as 3 by 5 table (arrays)
		/*
		[
		[1,1,1,1,1],
		[2,2,2,2,2],
		[3,3,3,3,3]
		]
		*/
		
		//based on betting lines, winning item position is as follos:"
		public static const LINE_ONE:Array = [2,2,2,2,2];
		public static const LINE_TWO:Array = [1,1,1,1,1];
		public static const LINE_THREE:Array = [3,3,3,3,3];
		public static const LINE_FOUR:Array = [1,2,3,2,1];
		public static const LINE_FIVE:Array = [3,2,1,2,3];
		public static const LINE_SIX:Array = [1,1,2,3,3];
		public static const LINE_SEVEN:Array = [3,3,2,1,1];
		public static const LINE_EIGHT:Array = [2,1,2,3,2];
		public static const LINE_NINE:Array = [2,3,2,1,2];
				
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function WinIndicator():void
		{
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		////
		//	play winning items in winning line
		//
		//	@PARAM		pLine			winning line
		//	@PARAM		pItemNums		num of items that should play starting from left end
		//	@PARAM		pSlotArray		array containing all the slots from the slot machine		
		////
		public static function showWins( pLine:int, pItemNums:int, pSlotArray:Array):void
		{
			//trace ("showWins", pLine, pItemNums)
			//trace (returnItemsInLine(pLine))
			var lineWon:Array = returnItemsInLine(pLine, pSlotArray)
			for ( var i:int = 0; i < pItemNums; i++)
			{
				if(lineWon[i].item)
				{
					lineWon[i].item.play();
					
					if (lineWon[i].item.item != null) 
					{
						lineWon[i].item.item.play();
					}
					if (lineWon[i].item.item2 != null) 
					{
						lineWon[i].item.item2.play();
					}
				}
				else
				{
					trace("lineWon["+i+"] does not have 'item' define as a property");
				}				
			}
		}
		
		
		////
		//	stops animation from the winning items in winning line
		//
		//	@PARAM		pLine			winning line
		//	@PARAM		pItemNums		num of items that should play starting from left end
		//	@PARAM		pSlotArray		array containing all the slots from the slot machine	
		////
		public static function stopWins( pLine:int, pItemNums:int, pSlotArray:Array):void
		{
			trace ("stop wins called", pLine, pItemNums)
			var lineWon:Array = returnItemsInLine(pLine, pSlotArray)
			for ( var i:int = 0; i < pItemNums; i++)
			{
				if(lineWon[i].item)
				{
					lineWon[i].item.gotoAndStop(1);
					if (lineWon[i].item.item != null) 
					{
						lineWon[i].item.item.gotoAndStop(1);
					}
					if (lineWon[i].item.item2 != null) 
					{
						lineWon[i].item.item2.gotoAndStop(1);
					}
				}
				else
				{
					trace("lineWon["+i+"] does not have 'item' define as a property");
				}			
			}
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		////
		//	it retuns items from slots based on (winning) line
		//
		//	@PARAM		pLine			line
		//	@PARAM		pSlotArray		array containing all the slots from the slot machine
		////
		private static function returnItemsInLine(pLine:int, pSlotArray:Array):Array
		{
			var itemArray:Array = new Array ()
			var itemIndicatorArray:Array
			switch (pLine)
			{
				case 1:
					itemIndicatorArray = LINE_ONE;
					break;

				case 2:
					itemIndicatorArray = LINE_TWO;
					break;
					
				case 3:
					itemIndicatorArray = LINE_THREE;
					break;
					
				case 4:
					itemIndicatorArray = LINE_FOUR;
					break;
					
				case 5:
					itemIndicatorArray = LINE_FIVE;
					break;
					
				case 6:
					itemIndicatorArray = LINE_SIX;
					break;
					
				case 7:
					itemIndicatorArray = LINE_SEVEN;
					break;
					
				case 8:
					itemIndicatorArray = LINE_EIGHT;
					break;
					
				case 9:
					itemIndicatorArray = LINE_NINE;
					break;
					
			}
			for (var i in pSlotArray)
			{
				itemArray.push (itemOnLine(pSlotArray[i], itemIndicatorArray[i]))
			}
			return itemArray
		}	
		
		
		////
		//	returns an item from a slot reel
		//
		//	@PARAM		pSlot			slot reel
		//	@PARAM		pSpoition		position of the item you want to retreive
		////
		private static function itemOnLine (pSlot:Slot, pPosition:int):MovieClip
		{
			var slot:Slot = pSlot
			var pos:int
			if (slot.stacked == Slot.UP)
			{
				pos =  slot.numOfItems - pPosition
			}
			else 
			{
				pos =  slot.numOfItems - 4 + pPosition
			}
			var item:MovieClip = slot.retrieveItem(pos)
			return item;
		}
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}