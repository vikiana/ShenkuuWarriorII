/**
 *	Manages all the lines drawn on the stage.
 *	Each line is drawn on separate sprites and the sprites are kept in an array to be processed
 *	To invoke this class, there are serveral setups:
 *	1.	Init the canvas:  CanvasManager.init(stage)
 *	2.	Run following functions on enterFrame or on timer
 *			CanvasManager.canvasFade();
 *			CanvasManager.canvasUpdate();
 *			CanvasManager.drawLine();
 *	3.	use CanvasManager.reset() or other functions to reset the canvas
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.canvas
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	
	public class CanvasManager extends Sprite
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static const LINE_START:String = "start_drawing_line";
		public static const LINE_STOP:String = "stop_drawing_line";
		
		private static var mReturnedInstance:CanvasManager	//singleton instance
		private var mStage:Object;	//root stage
		private var mCurrCanvas:Sprite;	//current sprite the line is being drawn on	
		private var mCanvasArray:Array;	// array containing line sprites
		private var mLineOn:Boolean = false	//true when a ling is being drawn
		private var mGage:Number = 100	//gage the for the how much/long the line can be drawn
		private var mUsageRate:Number = 1;	//how fast the gage should run out
		private var mRecoverRate:Number = 2;	// how fast the gage should recover
		private var mMoveAmount:Number = 0	//amouont each line should move in x-axis
		private var mDecayRate:Number = .92	// fading rate for each line
		private var mTarget:DisplayObject;	// line won't start if mouse pos is within target range
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CanvasManager(pPrivCl : PrivateClass):void
		{
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public static function get instance():CanvasManager
		{
			if (mReturnedInstance == null)
			{
				mReturnedInstance = new CanvasManager(new PrivateClass ());
			}
			return mReturnedInstance;
			
		}
		
		public static function get lineOn():Boolean
		{
			return CanvasManager.instance.lineOn;
		}
		
		private function get lineOn():Boolean
		{
			return mLineOn;
		}
		
		public static function get gage():Number
		{
			return CanvasManager.instance.gage;
		}
		
		private function get gage():Number
		{
			return mGage;
		}
		
		public static function get usageRate():Number
		{
			return CanvasManager.instance.mUsageRate;
		}
		
		public static function set usageRate(pRate:Number):void
		{
			CanvasManager.instance.mUsageRate = pRate;
		}
		
		public static function get recoverRate():Number
		{
			return CanvasManager.instance.mRecoverRate;
		}
		
		public static function set gage(pn:Number):void
		{
			CanvasManager.instance.mGage = pn;
		}
		
		public static function set recoverRate(pRate:Number):void
		{
			CanvasManager.instance.mRecoverRate = pRate;
		}
		
		public static function get moveAmount():Number
		{
			return CanvasManager.instance.mMoveAmount;
		}
		
		public static function set moveAmount(pRate:Number):void
		{
			CanvasManager.instance.mMoveAmount = pRate;
		}
		
		public static function get decayRate():Number
		{
			return CanvasManager.instance.mDecayRate;
		}
		
		public static function set decayRate(pr:Number):void
		{
			CanvasManager.instance.mDecayRate = pr;
		}

		public static function get myTarget():DisplayObject
		{
			return CanvasManager.instance.mTarget;
		}
		
		public static function set myTarget(pd:DisplayObject):void
		{
			CanvasManager.instance.mTarget = pd;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/*
		 *	this needs to be called first so there is a stage reference
		 */
		public static function init(pStage:Object):void
		{
			CanvasManager.instance.init(pStage);
		}
		
		/*
		 *	stops the line that is currently being drawn (if there is one)
		 */
		public static function stopDrawing():void
		{
			CanvasManager.instance.stopDrawing();
		}
		
		/*
		 *	moves teh line by given amount and kills teh line spirte if alpha is 0
		 */
		public static function canvasUpdate():void
		{
			CanvasManager.instance.canvasUpdate();
		}
		
		/*
		 *	fades line sprites based on given decay rate
		 */
		public static function canvasFade():void
		{
			CanvasManager.instance.canvasFade();
		}		
		
		/*
		 *	remove all line sprites and reset the canvas
		 */
		public static function resetCanvas():void
		{
			CanvasManager.instance.resetCanvas();
		}
		
		//meant to be called on enter frame or timer
		public static function drawLine():void
		{
			CanvasManager.instance.drawLine();
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		/*
		 *	setup variables
		 */
		private function setvars():void 
		{
			mCanvasArray = [];
		}
		
		/*
		 *	this should be called first to use canvas manager
		 */
		private function init(pStage:Object):void
		{
			mStage = pStage;
			setvars();
			mStage.addEventListener(MouseEvent.MOUSE_DOWN, startLine, false, 0, true);
		}
		
		/*
		 *	remove all line sprites and reset the canvas
		 */
		private function resetCanvas():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			mCanvasArray = [];
			mStage.removeEventListener(MouseEvent.MOUSE_DOWN, startLine);
		}
		
		/*
		 *	removes given canvas from the array
		 */
		private function removeThisCanvas(canvas:Sprite):void
		{
			for (var i:String in mCanvasArray)
			{
				if (canvas == mCanvasArray[i])
				{
					mCanvasArray.splice(i,1);
				}
			}
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		
		/*
		 *	fades the lines
		 */
		private function canvasFade():void
		{
			for (var i:String in mCanvasArray)
			{
				var canvas:Sprite = mCanvasArray[i]
				canvas.alpha > .01 ? canvas.alpha *= mDecayRate : canvas.alpha = 0;
			}
		}
		
		
		/*
		 *	move teh canvas by given amount and laso removes the line if alpha is 0
		 */
		private function canvasUpdate():void
		{
			var numCanvas:int = this.numChildren;
			var count:int = 0;
			while (count < numCanvas)
			{
				if (getChildAt(count) != null)
				{
					var canvas:Sprite = getChildAt(count) as Sprite;
					canvas.x += mMoveAmount;
					count++;
					if (canvas.alpha <= 0)
					{
						removeThisCanvas(canvas);
						removeChild(canvas);
						count --;
						numCanvas --;
					}
				}
			}
			if (mGage <= 100 && !mLineOn)
			{
				mGage += mRecoverRate;
				if (mGage > 100) mGage = 100;
			}
		}
		
		
		/*
		 *	start drawing teh line
		 */
		private function startLine (e:MouseEvent):void
		{
			//put some condition to check if it's hitting the ship
			if (!touchingTarget())
			{
				var canvas:Sprite = new Sprite();
				canvas.graphics.lineStyle(30, 0xFFFFFF);
				canvas.cacheAsBitmap = true;
				addChild (canvas);
				mCurrCanvas = canvas;
				canvas.graphics.moveTo(stage.mouseX - mCurrCanvas.x, stage.mouseY);
				mStage.addEventListener(MouseEvent.MOUSE_UP, stopDrawing);
				mLineOn = true;
			}
		}
		
		/**
		 *	return true if mouse position is overlaping with the target, other wise false
		 **/
		private function touchingTarget():Boolean
		{
			return mTarget == null ? false : mTarget.hitTestPoint(stage.mouseX, stage.mouseY);
		}
		
		/*
		 *	draw the line to mouse position
		 */
		private function drawLine (e:MouseEvent = null):void
		{
			if (mLineOn)
			{
			if (!touchingTarget())
			{
				mGage -= mUsageRate
				mCurrCanvas.graphics.lineTo(stage.mouseX- mCurrCanvas.x, stage.mouseY);
				
				if (mGage <= 0) 
				{
					mGage = 0;
					stopDrawing();
				}
			}
			else
			{
				stopDrawing();
			}
			}
		}
		
		/*
		 *	stop drawing the current line.
		 */
		private function stopDrawing(e:MouseEvent = null):void
		{
			mCanvasArray[mCanvasArray.length] = mCurrCanvas;
			mCurrCanvas = null;
			mStage.removeEventListener(MouseEvent.MOUSE_UP, stopDrawing);
			mLineOn = false;
		}
		
	}
	
}


//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
		
	}

} 


























