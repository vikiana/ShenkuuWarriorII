/**
 *	View Manager
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

 /**
  *	TODOs
  *	cleanup method
  *	make sure the number of buttons are bigger than mshownimages to show teh arrows
  **/
 
package com.neopets.users.abelee.utils
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;

	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	import com.neopets.users.abelee.resource.mask.EasyMask;
	import com.neopets.users.abelee.utils.SupportFunctions //no need to import but for others to know
	import caurina.transitions.Tweener;
	import com.neopets.util.events.CustomEvent;
	
	public class ViewManager_v3 extends MovieClip
	{
		//----------------------------------------
		//	Constatnts
		//----------------------------------------
		public static const VERTICAL_VIEW:String = "vertical_layout";
		public static const HORIZONTAL_VIEW:String = "horizontal_layout";
		public const CURRENT_INDEX:String = "current_index"
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var xPos:Number;
		protected var yPos:Number;
		protected var mNumShownImages:int;
		protected var mCurrentIndex:int;
		protected var mCurrentDirection:String;
		protected var mBufferDistance:Number;
		protected var mFullImagesWindow:Boolean;
		protected var mButtonResize:Boolean
		protected var mScrollEnabled:Boolean = false
		protected var mItemsArray:Array = []  //array that contains all the items 
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		
		/**
		 *
		 * @PARAM	pContentImageArray		Array		Array of images to be shown
		 **/
		public function ViewManager_v3 (
									 pContentImageArray:Array = null, 
									 pControlArray:Array = null, 
									 pShowingNumber:int = 4, 
									 pImageBuffer:Number = 25, 
									 pDirection:String = HORIZONTAL_VIEW, 
									 pFullWindow:Boolean = false, 
									 pButtonResize:Boolean = false
									):void
		{
			xPos = 0;
			yPos = 0;
			mFullImagesWindow = pFullWindow
			mButtonResize = pButtonResize
			if (pContentImageArray != null)
			{
				defaultSetup(pContentImageArray, pControlArray, pShowingNumber, pImageBuffer, pDirection)			
			}
			else 
			{
				trace ("\nPlease make sure content image array is not empty\n")
			}
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get images():Sprite
		{
			return Sprite(getChildByName("image holder"))
		}
		

		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function cleanup():void
		{
			
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------		
		
		//----------------------------------------
		//	protected METHODS
		//----------------------------------------
		
		
		
		
		protected function defaultSetup(pContentImageArray:Array = null, pControlArray:Array = null, pShowingNumber:int = 5, pImageBuffer:Number = 10, pDirection:String = HORIZONTAL_VIEW):void
		{
			mScrollEnabled = pContentImageArray.length >= pShowingNumber? true: false;
			mNumShownImages = pShowingNumber
			mCurrentIndex = 0
			mCurrentDirection = pDirection
			mBufferDistance = pImageBuffer
			
			//setup first button
			var firstButton:MovieClip = pControlArray[0] as MovieClip
			firstButton.name = "first button"
			
			//create empty MC and place all images there
			var images:Sprite = new Sprite ()
			images.name = "image holder"
			for (var i:String in pContentImageArray)
				{
					var image:MovieClip = pContentImageArray[i] as MovieClip
					image.x = xPos
					image.y = yPos
					images.addChild(image)
					mItemsArray.push(image)
					pDirection == HORIZONTAL_VIEW? xPos += image.width + pImageBuffer:yPos += image.height + pImageBuffer;
				}
			
			//setup second button
			var secondButton:MovieClip = pControlArray[1] as MovieClip
			secondButton.name = "second button"
			
			//add Imgages in order
			addChild(images)
			if (mScrollEnabled)
			{
				addChild(firstButton)
				addChild(secondButton)
			
				if (pDirection == HORIZONTAL_VIEW)
				{
					firstButton.y = images.height/2 - firstButton.height/2
					secondButton.y = images.height/2 - secondButton.height/2
				}
				else 
				{
				}
				//place the images accordingly and place second arrow as well
				var endPoint:Point = findDistance(mItemsArray[mCurrentIndex], mItemsArray[mCurrentIndex + mNumShownImages -1])
				var imagesMask:EasyMask
				var lastShownImage:MovieClip = mItemsArray[mNumShownImages - 1]				
				if (pDirection == HORIZONTAL_VIEW) 
				{
					firstButton.x = 0 - (firstButton.width + mBufferDistance);
					secondButton.x = endPoint.x + lastShownImage.width  + mBufferDistance
					imagesMask = new EasyMask (this, images, 0, 0,endPoint.x + lastShownImage.width, images.height)
														
														
				}
				else
				{
					firstButton.y = 0 - (firstButton.height + mBufferDistance)
					secondButton.y =  endPoint.y + lastShownImage.height + mBufferDistance
					imagesMask = new EasyMask (this, images, 0, 0,images.width, endPoint.y + lastShownImage.height)
				}
				
				firstButton.addEventListener(MouseEvent.MOUSE_DOWN, handleScroll, false, 0, true)
				secondButton.addEventListener(MouseEvent.MOUSE_DOWN, handleScroll, false, 0, true)
				firstButton.alpha = .3
			}
			
			//ADDED BY VIV : set all private to protected and added some custom functions such as customSetup to facilitate class extension
			customSetup(imagesMask);
		}
		
		
		protected function customSetup(refmc:Sprite=null, ...args):void {
				trace ("ViewManager3: Override this function in a custom subclass if you need to change the layout");
		}
		
		
		//returns distance in Point where second button should be placed at.
		protected function findDistance(pStartImage:MovieClip,pEndImage:MovieClip):Point
		{
			
			var startImage:MovieClip = pStartImage
			var endImage:MovieClip = pEndImage
			return new Point (
							  endImage.x - startImage.x, 
							  endImage.y - startImage.y
							  )
		}
		
		//returns the last item that's showing on the screen
		protected function returnLastImageInWindow():MovieClip
		{
			var images:Sprite = Sprite (getChildByName ("image holder"))
			var nextSet:int = mCurrentIndex + mNumShownImages -1
			var lastShownImageNum:int = nextSet > images.numChildren - 1 ? images.numChildren -1 : nextSet
			return returnImage(lastShownImageNum)
			
		}
		
		protected function returnImage(pIndexA:int):MovieClip
		{
			var endImage:MovieClip = mItemsArray[pIndexA]
			return endImage
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function handleScroll(evt:MouseEvent):void
		{
			trace ("handle scroll called")
			var images:Sprite = Sprite (getChildByName ("image holder"))
			var moveDistance:Number;
			var indexTobe:int;
			var distancePoint:Point;
			var travelDistance:Number;
			var tobe:int
			
			switch (evt.currentTarget.name)
			{
				case "first button":
					if (mCurrentIndex != 0) // if current index is not 0 then find new index
					{
						tobe = mCurrentIndex - mNumShownImages
						indexTobe =  tobe <= 0 ? 0 : tobe
						getChildByName("second button").alpha = 1
					}
					else 	//if current index is 0 then indexTobe should be 0 
					{
						indexTobe = 0
					};
					if (indexTobe ==0)evt.currentTarget.alpha = .3;
					break;
				
				case "second button":	//if there is more set to show, move the current index
					tobe = mCurrentIndex + mNumShownImages
					var lastShowing:int = tobe -1
					{
						if (lastShowing + mNumShownImages < images.numChildren)
						{
							indexTobe =  tobe
						}
						else 
						{
							indexTobe = mItemsArray.length - mNumShownImages;
							
						}
						getChildByName("first button").alpha = 1
					}
					if (indexTobe == mItemsArray.length - mNumShownImages)evt.currentTarget.alpha = .3;
					//trace ("what is my index to be", indexTobe)
					break;
			}
			
			mCurrentIndex = indexTobe
			var lastImage:MovieClip = returnLastImageInWindow()
			var indexImage:MovieClip = returnImage(indexTobe)
			distancePoint = findDistance (mItemsArray[indexTobe], lastImage)
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
		}
		
	}
	
}