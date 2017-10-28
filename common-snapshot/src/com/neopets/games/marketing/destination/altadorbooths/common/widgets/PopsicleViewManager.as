package com.neopets.games.marketing.destination.altadorbooths.common.widgets
{
	import caurina.transitions.Tweener;
	
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PopsicleViewManager extends ViewManager_v3
	{
		
		private var _scrollmask:Sprite;
		
		public function PopsicleViewManager( pContentImageArray:Array = null, 
											 pControlArray:Array = null, 
											 pShowingNumber:int = 4, 
											 pImageBuffer:Number = 25, 
											 pDirection:String = HORIZONTAL_VIEW, 
											 pFullWindow:Boolean = false, 
											 pButtonResize:Boolean = false)
		{
			super( pContentImageArray, pControlArray, pShowingNumber, pImageBuffer, pDirection, pFullWindow, pButtonResize);
		}
		
		
		override protected function customSetup(refmc:Sprite=null, ...args):void{
			if (refmc){
				_scrollmask = refmc;
			}
			//if buttons are present, adjust the buttons position
			if (images.numChildren>=1){
				getChildByName ("first button").y = getChildByName ("second button").y = 220;
				getChildByName ("first button").x+= 80;
				getChildByName ("second button").x+= 30;
			}
		}
		
		public function scrollTo (idx:int):void {
			var images:Sprite = Sprite (getChildByName ("image holder"))
			var distancePoint:Point;
			mCurrentIndex = idx;
			var lastImage:MovieClip= returnLastImageInWindow()
			var indexImage:MovieClip = returnImage(mCurrentIndex)
			distancePoint = findDistance (mItemsArray[mCurrentIndex], lastImage)
			dispatchEvent (new CustomEvent ({DATA:mCurrentIndex}, CURRENT_INDEX))
			
			if (mCurrentDirection == HORIZONTAL_VIEW)
			{
				Tweener.addTween(images, {x:-indexImage.x, time:.5})
				if (!mFullImagesWindow &&  mButtonResize)Tweener.addTween(MovieClip(getChildByName("second button")), {x:distancePoint.x + lastImage.width  + mBufferDistance, time:.5});
			}
			else
			{
				Tweener.addTween(images, {y:-indexImage.y, time:.5})
				if (!mFullImagesWindow && mButtonResize)Tweener.addTween(MovieClip(getChildByName("second button")), {y:distancePoint.y + lastImage.height  + mBufferDistance, time:.5});
			}
			
			
			if (mCurrentIndex <= 0){
				MovieClip(getChildByName("first button")).alpha = .3;
			} else {
				MovieClip(getChildByName("first button")).alpha = 1;
			}
			if (mCurrentIndex >= mItemsArray.length-1){
				MovieClip(getChildByName("second button")).alpha = .3;
			} else{
				MovieClip(getChildByName("second button")).alpha = 1;
			}
			
			dispatchEvent (new CustomEvent ({DATA:mCurrentIndex}, CURRENT_INDEX))
		}
		
		public function get scrollmask ():Sprite {
			return _scrollmask;
		}
		
		public function set scrollmask (value:Sprite):void {
			_scrollmask = value;
		}
	}
}