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
  *	make sure the number of buttons is bigger than mshownimages to show the arrows
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
	
	public class ViewManager_v2 extends MovieClip
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
		private var xPos:Number;
		private var yPos:Number;
		private var mNumShownImages:int;
		private var mCurrentIndex:int;
		private var mCurrentDirection:String;
		private var mBufferDistance:Number;
		private var mFullImagesWindow:Boolean;
		private var mButtonResize:Boolean
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		
		/**
		 *
		 * @PARAM	pContentImageArray		Array		Array of images to be shown
		 **/
		public function ViewManager_v2 (
									 pContentImageArray:Array = null, 
									 pControlArray:Array = null, 
									 pShowingNumber:int = 5, 
									 pImageBuffer:Number = 10, 
									 pDirection:String = HORIZONTAL_VIEW, 
									 pFullWindow:Boolean = true, 
									 pButtonResize:Boolean = false
									):void
		{
			xPos = 0;
			yPos = 0;
			mFullImagesWindow = pFullWindow
			mButtonResize = pButtonResize
			if (pContentImageArray != null)
			{
				pControlArray != null ?
				defaultSetup(pContentImageArray, pControlArray, pShowingNumber, pImageBuffer, pDirection): 
				layAllImagesSetup(pContentImageArray, pImageBuffer, pDirection);
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
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		
		
		private function layAllImagesSetup(pContentImageArray:Array, pImageBuffer:Number , pDirection:String):void
		{
			var images:Sprite = new Sprite ()
			images.name = "image holder"
			for (var i:String in pContentImageArray)
				{
					var image:MovieClip = pContentImageArray[i] as MovieClip
					image.x = xPos
					image.y = yPos
					images.addChild(image)
					pDirection == HORIZONTAL_VIEW? xPos += image.width + pImageBuffer:yPos += image.height + pImageBuffer;
				}
		}
		
		private function defaultSetup(pContentImageArray:Array = null, pControlArray:Array = null, pShowingNumber:int = 5, pImageBuffer:Number = 10, pDirection:String = HORIZONTAL_VIEW):void
		{
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
					image.name = i
					images.addChild(image)
					pDirection == HORIZONTAL_VIEW? xPos += image.width + pImageBuffer:yPos += image.height + pImageBuffer;
				}
			
			//setup second button
			var secondButton:MovieClip = pControlArray[1] as MovieClip
			secondButton.name = "second button"
			
			//add Imgages in order
			addChild(images)
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
			var endPoint:Point = findDistance(
											  mCurrentIndex.toString(), 
											  (mCurrentIndex + mNumShownImages -1).toString()
											  )
			var imagesMask:EasyMask;
			var lastShownImage:MovieClip = SupportFunctions.getChildAsMovieClip(
																			getChildByName("image holder"), 
																			(mNumShownImages - 1).toString()
																			)
			
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
		}
		
		//returns distance in Point where second button should be placed at.
		private function findDistance(pObjName:String,pObjName2:String):Point
		{
			
			var startImage:MovieClip = SupportFunctions.getChildAsMovieClip(
																			getChildByName("image holder"), 
																			pObjName
																			)
			var endImage:MovieClip = SupportFunctions.getChildAsMovieClip(
																		  getChildByName("image holder"), 
																		  pObjName2
																		  )
			return new Point (
							  endImage.x - startImage.x, 
							  endImage.y - startImage.y
							  )
		}
		
		//returns the last item that's showing on the screen
		private function returnLastImageInWindow():MovieClip
		{
			var images:Sprite = Sprite (getChildByName ("image holder"))
			var nextSet:int = mCurrentIndex + mNumShownImages -1
			var lastShownImageNum:int = nextSet > images.numChildren - 1 ? images.numChildren -1 : nextSet
			return returnImage(lastShownImageNum.toString())
			
		}
		
		private function returnImage(pName:String):MovieClip
		{
			var endImage:MovieClip = SupportFunctions.getChildAsMovieClip(
																		  getChildByName("image holder"), 
																		  pName
																		  )
			return endImage
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		private function handleScroll(evt:MouseEvent):void
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
					}
					else 	//if current index is 0 then indexTobe should be 0 
					{
						indexTobe = 0
					};
					break;
				
				case "second button":	//if there is more set to show, move the current index
					tobe = mCurrentIndex + mNumShownImages
					var doubleTobe = tobe + mNumShownImages
					if (mFullImagesWindow)
					{
						if (tobe < images.numChildren -1 && doubleTobe < images.numChildren -1)
						{
							indexTobe = tobe
						}
						else if (tobe <= images.numChildren -1 && doubleTobe >= images.numChildren -1)
						{
							indexTobe = images.numChildren  - mNumShownImages
						}
						else
						{
							indexTobe = mCurrentIndex
						}
						
					}else 
					{
						indexTobe =  tobe < images.numChildren -1 ? tobe : mCurrentIndex;
					}
					break;
			}
			
			mCurrentIndex = indexTobe
			var lastImage:MovieClip = returnLastImageInWindow()
			var indexImage = returnImage(indexTobe.toString())
			distancePoint = findDistance (indexImage.name, lastImage.name)
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