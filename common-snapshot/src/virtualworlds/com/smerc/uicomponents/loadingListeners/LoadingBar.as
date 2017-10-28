package virtualworlds.com.smerc.uicomponents.loadingListeners
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class LoadingBar extends LoadingListener
	{
		/**
		 * Either LoadingBar.FRAME_CONTROLLED or LoadingBar.MASK_PERCENTAGE
		 */
		protected var _type:int = -1;
		
		public static const FRAME_CONTROLLED:int = 0;
		
		
		public static const MASK_PERCENTAGE:int = 1;
		
		protected var _defaultLoader:Sprite;
		protected var _defaultLoaderBase:Sprite;
		protected var _defaultLoaderFill:Sprite;
		
		// For MovieClip Loaders
		protected var _totalFrames:int = 0;
		protected var _currentFrameToPlayTo:int = 0;
		
		public function LoadingBar(a_loadingObj:IEventDispatcher = null, a_loadingImg:DisplayObject = null, a_bAddContents:Boolean = true)
		{
			super(a_loadingObj, a_loadingImg, a_bAddContents);
			
			//
			
		}//end LoadingBar() constructor.
		
		override protected function init(a_loadingImg:DisplayObject):void
		{
			_loadingImg = a_loadingImg;
			var loadingImgMc:MovieClip = _loadingImg as MovieClip;
			
			
			// Three possible cases:
			// 1. a_loadingImg is null. Make a default Loading Bar.
			// 2. a_loadingImg is DisplayObject, yet has no frames. Use super.init() implementation.
			// 3. a_loadingImg is a MovieClip with frames.
			
			if (!loadingImgMc)
			{
				_loadingImg = defaultLoadingBar();
			}
			else if(loadingImgMc.totalFrames > 1)
			{
				initMcLoadingBar(loadingImgMc);
			}
			else if (loadingImgMc && loadingImgMc.totalFrames == 1)
			{
				
				_loadingImg = defaultLoadingBar();
			}
			
			if(_bAddContents)
			{
				this.addChild(_loadingImg);
			}
			
		}//end init()
		
		protected function initMcLoadingBar(a_mc:MovieClip):void
		{
			// Assume that the MovieClip's end-frame is 100% completion.
			// So, use when a progress event comes in, play the movieClip until
			// it's at the appropriate frame.
			
			this._type = LoadingBar.FRAME_CONTROLLED;
			
			// First, make sure that the MovieClip starts on the first frame.
			a_mc.gotoAndStop(1);
			
			// Get its total number of frames.
			_totalFrames = a_mc.totalFrames;
			_currentFrameToPlayTo = 1;
			
			a_mc.addEventListener(Event.ENTER_FRAME, onMcLoaderEnterFrame, false, 0, true);
			
			a_mc.play();
			
		}//end initMcLoadingBar()
		
		protected function onMcLoaderEnterFrame(a_evt:Event):void
		{
			var mc:MovieClip = a_evt.target as MovieClip;
			if (!mc)
			{
				
			}
			
			if (mc.currentFrame >= _currentFrameToPlayTo)
			{
				mc.stop();
			}
			
		}//end onMcLoaderEnterFrame()
		
		protected function defaultLoadingBar(...args):Sprite
		{
			_type = LoadingBar.MASK_PERCENTAGE;
			
			_defaultLoader = new Sprite();
			
			_defaultLoaderBase = new Sprite();
			//_defaultLoaderBase.graphics.beginFill(0xff0000, 1.0);
			_defaultLoaderBase.graphics.lineStyle(2, 0x000000);
			_defaultLoaderBase.graphics.drawRect(0, 0, 100, 10);
			//_defaultLoaderBase.graphics.endFill();
			
			_defaultLoaderFill = new Sprite();
			_defaultLoaderFill.graphics.beginFill(0xff0000, 1.0);
			_defaultLoaderFill.graphics.lineStyle(2, 0x000000);
			_defaultLoaderFill.graphics.drawRect(0, 0, 100, 10);
			_defaultLoaderFill.graphics.endFill();
			
			_defaultLoader.addChild(_defaultLoaderBase);
			_defaultLoader.addChild(_defaultLoaderFill);
			
			_defaultLoaderFill.scaleX = 0;
			
			return _defaultLoader;
			
		}//end defaultLoadingBar()
		
		override protected function onProgressHandler(a_progressEvt:ProgressEvent):void
		{
			var fractionLoaded:Number = (a_progressEvt.bytesLoaded / a_progressEvt.bytesTotal);
			
			//
			
			switch(this._type)
			{
				case LoadingBar.MASK_PERCENTAGE:
					// Set the scaleX of the mask to be the fractionLoaded
					_defaultLoaderFill.scaleX = fractionLoaded;
					break;
				case LoadingBar.FRAME_CONTROLLED:
					var loadingImgMC:MovieClip = _loadingImg as MovieClip;
					var currentFrame:int = loadingImgMC ? loadingImgMC.currentFrame : 1;
					_currentFrameToPlayTo = Math.round(fractionLoaded * (new Number(_totalFrames)));
					if (_currentFrameToPlayTo > currentFrame)
					{
						//loadingImgMC.play();
						loadingImgMC.gotoAndStop(_currentFrameToPlayTo);
					}
					break;
				default:
					
					break;
			}
			
		}//end override onProgressHandler()
		
		override protected function conclude(...args):void
		{
			if (this._type == LoadingBar.MASK_PERCENTAGE)
			{
				// Set the scaleX of the mask to be the fractionLoaded
				_defaultLoaderFill.scaleX = 1;
			}
			else if (this._type == LoadingBar.FRAME_CONTROLLED)
			{
				var loadingImgMc:MovieClip = _loadingImg as MovieClip;
				loadingImgMc ? loadingImgMc.removeEventListener(Event.ENTER_FRAME, onMcLoaderEnterFrame) : null;
			}
			
			super.conclude(args);
			
		}//end override conclude()
		
		override public function destroy(...args):void
		{
			_type = -1;
			
			_defaultLoader = _defaultLoaderBase = _defaultLoaderFill = null;
			
			var loadingImgMc:MovieClip = _loadingImg as MovieClip;
			
			if (loadingImgMc)
			{
				loadingImgMc.removeEventListener(Event.ENTER_FRAME, onMcLoaderEnterFrame);
			}
			
			super.destroy(args);
			
		}//end override destroy()
		
	}//end class LoadingBar
	
}//end package com.smerc.uicomponents.loadingListeners
