/**
 *	Create a slot (reel)
 *	The slot is created like a film reel. (it doesn't actually spin as in real slot machine)
 *	Everytime when slot machien is called to play, it simply create a long reel of items and simply
 *	moves up or down to give the "rolling" effect and it stops once the reel comes to an end.
 *
 *	When Slot is called, it creates a reel and randomly feels in the spots.  Once the slot results are in,
 *	according to it, items are substituded then the reel will move up or down to show the result.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.inhouse.blackPawkeetSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import com.neopets.users.abelee.resource.easyCall.*;
	


	public class Slot extends MovieClip {
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public static  const UP:String = "stack_up";
		public static  const DOWN:String = "stack_down";

		private var mMainGame:Object;	//MainGame class
		private var mItemsArray:Array;	//array of items in teh reel
		private var mDirection:String;	// direction of the reel
		private var mTotalItems:int;	//total number of items in a reel
		private var mRolls:int	//total number of spins (in reel format)
		private var util:QuickFunctions;	//for cleaing up purposes

		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function Slot(pMainGame:Object, px:Number, py:Number, pDir:String = UP):void {
			util = new QuickFunctions ();
			mMainGame = pMainGame;
			mDirection = pDir;
			x = px;
			y = py;
			mRolls = 5 	// should this come from xml??  for now hardcoded. reel is 5 times length of items  when it "rolls" think of it as having 5 spins
			init();
		}
		
		
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		public function get stacked():String 
		{
			return mDirection;
		}
		
		public function get numOfItems():int
		{
			return numChildren 
		}
		
		
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------

		////
		//	Replaces an exsisting item from a reel with a new one
		//
		//	@PARAM		position		position of the item in reel
		//	@PARAM		itemNumber		item identifier from the asset library
		////		
		public function substitude(position:int, itemNumber:int):void
		{
			removeChildAt(position)
			var itemClass:Class = mMainGame.assetInfo.getDefinition(mItemsArray[itemNumber])
			var item:MovieClip = new itemClass ();
			var stackFactor:int;
			var offset:Number;
			if (mDirection == UP) 
			{
				stackFactor = -1;
				offset = 0;
			} 
			else 
			{
				stackFactor = 1;
				offset = item.height * -2;
			}
			item.y = position * item.height * stackFactor + offset;
			item.item.stop();
			if (item.item.item != null) 
			{
				item.item.item.stop();
			}
			if (item.item.item2 != null) 
			{
				item.item.item2.stop();
			}
			item.name = position.toString();
			addChild(item);
			setChildIndex(item, position);
		}
		
		
		////
		//	Replaces exsisting items from a reel with new ones (in array)
		//	This replacement happens from the last items and moves down.
		//	Basically replaces last items in the real to what resulting items should be
		//
		//	@PARAM		itemArray		contains array of itemNumbers
		////
		public function substitudeFromLast(itemArray:Array):void
		{
			if (mDirection == UP)
			{
				for (var i in itemArray)
				{
					substitude(mTotalItems-i, itemArray[i])
				}
			}
			else 
			{
				for (var j in itemArray)
				{
					substitude(mTotalItems-((itemArray.length -1 )-j), itemArray[j])
				}
			}
		}
		
		////
		//	Replaces exsisting items from a reel with new ones (in array)
		//	This replacement happens from the first item in the reel and moves up.
		//	Basically replaces fist items in the real to show previous result
		//
		//	@PARAM		itemArray		contains array of itemNumbers
		////
		public function substitudeFromFirst(itemArray:Array):void
		{
			if (mDirection == UP)
			{
				var startPos:int = itemArray.length -1
				for (var i in itemArray)
				{
					substitude(startPos - i , itemArray[i])
				}
			}
			else 
			{
				for (var j in itemArray)
				{
					substitude(j , itemArray[j])
				}
				
			}
		}
		
		
		////
		//	After each "roll" slots needs to be reset so it can be rolled again.
		//
		//	@PARAM		startArray		contains array of itemNumbers from previous result for consistancy
		////
		public function resetSlot(startArray:Array = null):void
		{
			y = 0	// this should be set to px but it works...
			cleanup();
			makeSlot();
			if (startArray != null) substitudeFromFirst(startArray);
		}
		
		////
		//	clean the slot
		////
		public function cleanup():void {
			util.removeChildren(this)
		}
		
		////
		//	returns the item in slot
		//
		//	@PARAM		num		position of the item in the reel
		////
		public function retrieveItem(num:int):MovieClip
		{
			var item:MovieClip = getChildByName(num.toString()) as MovieClip
			return item;
		}

		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------

		
		private function init():void {
			mItemsArray = mMainGame.configXML.GAME.ArtAssetItems.@slotItems.split("||");	
			makeSlot();
		}
		
		////
		//	makes the slot based on mItemsArray, which contains all the items used for this game
		//	@NOTE: if stack factor is set to "UP", then items will build up visually and the reel
		//	will move down.  When set to "DOWN" items will build down and the reel move up when
		//	The slot rolls.  And the movement of slot it done automatically based on stack factor
		////
		private function makeSlot():void {
			for (var i:int = 0; i < mItemsArray.length * mRolls; i++) {
				var num:int = Math.floor(Math.random() * mItemsArray.length);
				var itemClass:Class = mMainGame.assetInfo.getDefinition(mItemsArray[num])
				var item:MovieClip = new itemClass ();
				var stackFactor:int;
				var offset:Number;
				if (mDirection == UP) {
					stackFactor = -1;
					offset = 0;
				} else {
					stackFactor = 1;
					offset = item.height * -2;
				}
				item.y = i * item.height * stackFactor + offset;
				item.item.stop();
				if (item.item.item != null) 
				{
					item.item.item.stop();
				}
				if (item.item.item2 != null) 
				{
					item.item.item2.stop();
				}
				//item.item.coinText.text = num
				item.name = i.toString()
				mTotalItems = i
				addChild(item);
			}
		}
		
		
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

	}
}