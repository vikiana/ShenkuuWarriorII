/**
 *	SlotRoller
 *	Handles movement of slot reel
 *	If slot items are stacked up, the reel move down and vice versa
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
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class SlotRoller extends MovieClip
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mMainGame:Object		//MainGame class
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SlotRoller(pMainGame:Object = null):void
		{
			mMainGame = pMainGame
			//this is from tweener to use the filter effect on tweener
			FilterShortcuts.init();		
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		////
		//	It "rolls" the slot reel (it simply moves the slot "up" (or down) to the end of the reel)
		//
		//	@PARAM		slot		Slot that nees to be moved
		//	@PARAM		duration	Times (secs) it'll take for reel to come to completion
		////
		public function rollReel(slot:Slot = null, duration:Number = 3):void
		{
			var tAssetInfo:Object = {};
			
			// line below returns array of item names
			tAssetInfo.slotItems = mMainGame.configXML.GAME.ArtAssetItems.@slotItems.split("||");	
			tAssetInfo.itemHeight = Number(mMainGame.configXML.GAME.ArtAssetSize.@itemHeight);
			tAssetInfo.itemWidth = Number(mMainGame.configXML.GAME.ArtAssetSize.@itemWidth);
			
			if (Slot != null && mMainGame != null)
			{
				
				
				var itemHeight:Number = tAssetInfo.itemHeight;
				
				if (slot.stacked == Slot.UP) 
				{
					Tweener.addTween(
									 slot, 
									 {
										 y:slot.height-itemHeight * 3 + 30, 
										 time:duration, 
										 transition:"easeInCubic", 
										 onComplete:slotSound
									 }
									);
					
					Tweener.addTween(
									 slot, 
									 {
										 y:slot.height-itemHeight * 3, 
										 time:.4, 
										 delay:duration, 
										 transition:"easeOutBounce", 
										 onComplete:slotStopped
									 }
									);
				} 
				else
				{
					Tweener.addTween(
									 slot, 
									 {
										 y:-slot.height + itemHeight * 3 + 30, 
										 time:duration, 
										 transition:"easeInCubic", 
										 onComplete:slotSound
									 }
									);
					
					Tweener.addTween(
									 slot, 
									 {
										 y:- slot.height + itemHeight * 3, 
										 time:.4, 
										 delay:duration, 
										 transition:"easeOutBounce", 
										 onComplete:slotStopped
									 }
									);
				}
				Tweener.addTween(slot, {_Blur_blurY:40, time:duration * .9, transition:"easeInCubic"});
				Tweener.addTween(slot, {_Blur_blurY:0, time:.1,  delay:duration})
				
			}
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		////
		//	play a slot rolling sound if the sound is on
		////
		private function slotSound():void
		{
			mMainGame.playThisSound(mMainGame.soundBank.machineClick, mMainGame.soundOn);
		}
		
		////
		//	dispatch an event when slot has come to completion (SlotmachineCore will listen for this)
		////
		private function slotStopped():void
		{
			dispatchEvent(new Event ("rollCompleted"));
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}