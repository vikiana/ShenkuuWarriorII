package virtualworlds.com.smerc.uicomponents.buttons
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import virtualworlds.com.smerc.loaders.SmercImgLoader;
	import virtualworlds.com.smerc.loaders.events.ImageLoadingEvent;
	import virtualworlds.com.smerc.uicomponents.buttons.Events.ButtonEvent;
	import virtualworlds.com.smerc.uicomponents.loadingListeners.LoadingListener;
	
	
	/**
	 * A button with functionality for playing a disappear animation and an appear animation.
	 * @author Bo
	 */
	public class ImageLoadingButton extends SmercButton
	{
		protected var _appearCompleteCallback:Function;
		protected var _disappearCompleteCallback:Function;
		
		protected var _swfLoader:SmercImgLoader;
		
		protected var _loaderHolder:Sprite;
		
		protected var _maxWidthAtRest:Number;
		
		protected var _maxHeightAtRest:Number;
		
		protected var _imgWidthHeightRatio:Number;
		
		protected var _widthAtRest:Number;
		protected var _heightAtRest:Number;
		
		protected var _onRolloverExpandBy:Number = NaN;
		
		protected var _url:String;
		
		protected var _loadedImg:DisplayObject;
		
		protected var _loadedImgBytes:ByteArray;
		
		public static const IMAGE_LOADING_COMPLETE_EVT:String = "ImageLoadingCompleteEvent";
		
		protected var _loadingListener:LoadingListener;
		
		protected var _loaderListenerClass:Class;
		protected var _loadingImg:DisplayObject;
		protected var _loadingListenerInstance:LoadingListener;
		
		public function ImageLoadingButton(a_mc:MovieClip, a_url:String, a_imgFileBytes:ByteArray = null, 
										   a_bAddContents:Boolean = true, a_bLoadImmediately:Boolean = true,
										   a_loaderListenerClass:Class = null, a_loadingImg:DisplayObject = null,
										   a_loadingListenerInstance:LoadingListener = null,
										   a_maxWidthAtRest:Number = NaN, a_maxHeightAtRest:Number = NaN)
		{
			super(a_mc, a_bAddContents);
			
			_loadingImg = a_loadingImg;
			
			_url = a_url;
			
			_loadedImgBytes = a_imgFileBytes;
			
			_maxWidthAtRest = a_maxWidthAtRest;
			_maxHeightAtRest = a_maxHeightAtRest;
			
			var thisBounds:Rectangle = this._buttonContents.getBounds(_buttonContents);
			
			if (isNaN(_maxWidthAtRest) || isNaN(_maxHeightAtRest))
			{
				_maxWidthAtRest = thisBounds.width;
				_maxHeightAtRest = thisBounds.height;
			}
			
			_loaderHolder = new Sprite();
			//_loaderHolder.name = "_loaderHolder";
			
			_swfLoader = new SmercImgLoader();
			//_swfLoader.name = "_swfLoader";
			_swfLoader.addEventListener(SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT, imageLoadingCompleteHandler, false, 0, true);
			_swfLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			_swfLoader.addEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingErrorHandler, false, 0, true);
			
			_loadingListenerInstance = a_loadingListenerInstance;
			_loaderListenerClass = a_loaderListenerClass;
			if (!_loaderListenerClass && !a_loadingListenerInstance)
			{
				// We weren't given an instance of a loadingListener to use, nor a class of one to use, so, use
				// the base class, LoadingListener.
				_loaderListenerClass = LoadingListener;
			}
			
			_loadingListener = a_loadingListenerInstance;
			
			if (!_loadingListener)
			{
				// We weren't given an instance of a LoadingListener, so here we create one from the class we know about.
				// (or the default)
				_loadingListener = new _loaderListenerClass(null, _loadingImg);
			}
			
			// We tell the loadingListner about the swf-loader that we're using to load our Image.
			_loadingListener.loadingObj = _swfLoader;
			
			// Make sure that our LoadingListener doesn't exceed our expected size.
			if (_loadingListener.width > _maxWidthAtRest)
			{
				_loadingListener.width = _maxWidthAtRest;
			}
			if (_loadingListener.height > _maxHeightAtRest)
			{
				_loadingListener.height = _maxHeightAtRest;
			}
			
			// Put the loaderHolder at middle of the button before anything loads into it
			_loaderHolder.x = thisBounds.x + (thisBounds.width * .5);
			_loaderHolder.y = thisBounds.y + (thisBounds.height * .5);
			
			_loaderHolder.addChild(_swfLoader);
			
			// Add our loader-holder.
			_loadingListener.x += (_loadingListener.width * -0.5);
			_loadingListener.y += (_loadingListener.height * -0.5);
			_loaderHolder.addChild(_loadingListener);
			
			// Put the imageHolder underneath the _hitArea
			if (_buttonContents == _hitArea.parent)
			{
				var hitAreaIndex:int = _buttonContents.getChildIndex(_hitArea);
				_buttonContents.addChildAt(_loaderHolder, hitAreaIndex);
			}
			else
			{
				//
				_buttonContents.addChild(_loaderHolder);
			}
			
			if(a_bLoadImmediately)
			{
				if(_loadedImgBytes)
				{
					_swfLoader.loadBytes(_loadedImgBytes);
				}
				else if(_url)
				{
					_swfLoader.load(_url, null);
				}
			}
			
		}//end ImageLoadingButton() constructor.
		
		public function reset():void
		{
			var thisBounds:Rectangle = this._buttonContents.getBounds(_buttonContents);
			
			if (_loaderHolder && _loaderHolder.parent)
			{
				//
				_loaderHolder.parent.removeChild(_loaderHolder);
			}
			
			if (_swfLoader)
			{
				if (_swfLoader.parent)
				{
					//
					_swfLoader.parent.removeChild(_swfLoader);
				}
				
				_swfLoader.removeEventListener(SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT, imageLoadingCompleteHandler);
				_swfLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_swfLoader.removeEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingErrorHandler);
				
				if (_swfLoader.loadedImg && _swfLoader.loadedImg.parent)
				{
					//
					_swfLoader.loadedImg.parent.removeChild(_swfLoader.loadedImg);
				}
				_swfLoader.destroy();
				
			}
			_loadedImgBytes = null;
			
			_loaderHolder = new Sprite();
			//_loaderHolder.name = "_loaderHolder";
			
			_swfLoader = new SmercImgLoader();
			//_swfLoader.name = "_swfLoader";
			_swfLoader.addEventListener(SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT, imageLoadingCompleteHandler, false, 0, true);
			_swfLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
			_swfLoader.addEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingErrorHandler, false, 0, true);
			
			if (_loadingListener && !_loadingListenerInstance)
			{
				_loadingListener.destroy();
			}
			
			///////////////////
			if (!_loadingListenerInstance)
			{
				_loadingListener = new _loaderListenerClass(null, _loadingImg);
			}
			_loadingListener.loadingObj = _swfLoader;
			///////////////////
			
			//_loadingListener = new _loaderListenerClass(_swfLoader, _loadingImg);
			if (_loadingListener.width > _maxWidthAtRest)
			{
				_loadingListener.width = _maxWidthAtRest;
			}
			if (_loadingListener.height > _maxHeightAtRest)
			{
				_loadingListener.height = _maxHeightAtRest;
			}
			
			// Put the loaderHolder at middle of the button before anything loads into it
			_loaderHolder.x = thisBounds.x + (thisBounds.width * .5);
			_loaderHolder.y = thisBounds.y + (thisBounds.height * .5);
			
			_loaderHolder.addChild(_swfLoader);
			
			// Add our loader-holder.
			_loadingListener.x += (_loadingListener.width * -0.5);
			_loadingListener.y += (_loadingListener.height * -0.5);
			_loaderHolder.addChild(_loadingListener);
			
			// Put the imageHolder underneath the _hitArea
			if (_buttonContents == _hitArea.parent)
			{
				var hitAreaIndex:int = _buttonContents.getChildIndex(_hitArea);
				_buttonContents.addChildAt(_loaderHolder, hitAreaIndex);
			}
			else
			{
				//
				_buttonContents.addChild(_loaderHolder);
			}
			
		}//end reset()
		
		protected function onProgressHandler(a_progressEvt:ProgressEvent):void
		{
			this.dispatchEvent(a_progressEvt);
		}//end onProgressHandler()
		
		public function loadImg(...args):void
		{
			if(!_swfLoader.isInUse)
			{
				if(_loadedImgBytes)
				{
					_swfLoader.loadBytes(_loadedImgBytes);
				}
				else
				{
					_swfLoader.load(_url);
				}
			}
			else
			{
				
			}
		}//end loadImg()
		
		public function get url():String
		{
			return _url;
		}//end get url()
		public function set url(a_url:String):void
		{
			_url = a_url;
		}//end set url()
		
		protected function imageLoadingCompleteHandler(a_loadedImgEvt:ImageLoadingEvent):void
		{
			//
			
			_loadedImgBytes = _swfLoader.loadedBytes;
			
			_swfLoader.removeEventListener(SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT, imageLoadingCompleteHandler);
			
			_loadedImg = a_loadedImgEvt.loadedImg;
			
			_imgWidthHeightRatio = _loadedImg.width / _loadedImg.height;
			
			if (_imgWidthHeightRatio > 1)
			{
				if(_maxWidthAtRest < _loadedImg.width)
				{
					// Wider than tall, so shrink to fit width, and use its scale on the y
					_loadedImg.width = _maxWidthAtRest;
					_loadedImg.scaleY = _loadedImg.scaleX;
				}
			}
			else if (_maxHeightAtRest < _loadedImg.height)
			{
				if (_maxHeightAtRest < _loadedImg.width)
				{
					// Wider than tall, so shrink to fit width, and use its scale on the y
					_loadedImg.height = _maxHeightAtRest;
					_loadedImg.scaleX = _loadedImg.scaleY;
				}
			}
			
			_widthAtRest = _loadedImg.width;
			_heightAtRest = _loadedImg.height;
			
			var imgBounds:Rectangle = _loadedImg.getBounds(_loadedImg);
			
			_swfLoader.x -= (imgBounds.x * _swfLoader.scaleX);
			_swfLoader.y -= (imgBounds.y * _swfLoader.scaleY);
			
			// Center register our image.
			_swfLoader.x -= .5 * _swfLoader.width;
			_swfLoader.y -= .5 * _swfLoader.height;
			
			if (readyToDispatchComplete())
			{
				this.dispatchEvent(new Event(ImageLoadingButton.IMAGE_LOADING_COMPLETE_EVT));
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			
		}//end imageLoadingCompleteHandler()
		
		public function get loadedImg():DisplayObject
		{
			return _loadedImg;
		}//end get loadedImg()
		
		public function get loadedImgBytes():ByteArray
		{
			return _loadedImgBytes;
			
		}//end get loadedImgBytes()
		
		public function set loadedImgBytes(a_byteArr:ByteArray):void
		{
			_loadedImgBytes = a_byteArr;
		}//end set loadedImgBytes()
		
		protected function readyToDispatchComplete():Boolean
		{
			return (_swfLoader && _swfLoader.loadedImg ? true : false);
		}//end readyToDispatchComplete()
		
		public function onRolloverExpandBy(a_fractionOfRest:Number):void
		{
			_onRolloverExpandBy = a_fractionOfRest;
			this.addEventListener(ButtonEvent.SMERCBUTTON_ROLL_OVER_EVT, expandOnRollover);
			this.addEventListener(ButtonEvent.SMERCBUTTON_ROLL_OUT_EVT, normalizeSize);
			
		}//end onRolloverExpandBy()
		
		protected function expandOnRollover(a_buttonEvt:ButtonEvent = null):void
		{
			if (!a_buttonEvt)
			{
				//
				return;
			}
			
			if (_swfLoader && _swfLoader.loadedImg && !isNaN(_onRolloverExpandBy))
			{
				if (Tweener.isTweening(_loaderHolder))
				{
					Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");
				}
				Tweener.addTween(_loaderHolder, { "scaleX":_onRolloverExpandBy, "scaleY":_onRolloverExpandBy, 
					time:0.5, transition:"easeInOutExpo"} );
				//_loaderHolder.scaleX = _onRolloverExpandBy;
				//_loaderHolder.scaleY = _onRolloverExpandBy;
			}
			
		}//end expandOnRollover()
		
		protected function normalizeSize(a_buttonEvt:ButtonEvent = null):void
		{
			if (!a_buttonEvt)
			{
				//
				return;
			}
			
			if (_swfLoader && _swfLoader.loadedImg && !isNaN(_onRolloverExpandBy))
			{
				if (Tweener.isTweening(_loaderHolder))
				{
					Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");
				}
				Tweener.addTween(_loaderHolder, {"scaleX":1, "scaleY":1, time:0.5, transition:"easeInOutExpo" } );
				//_loaderHolder.scaleX = 1;
				//_loaderHolder.scaleY = 1;
			}
			
		}//end normalizeSize()
		
		protected function imageLoadingErrorHandler(a_loadedImgEvt:ImageLoadingEvent):void
		{
			
			_swfLoader.removeEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingErrorHandler);
			
		}//end imageLoadingErrorHandler()
		
		override public function destroy(...args):void
		{
			super.destroy(args);
			
			if (_swfLoader)
			{
				_swfLoader.removeEventListener(SmercImgLoader.IMAGE_LOADING_COMPLETE_EVT, imageLoadingCompleteHandler);
				_swfLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_swfLoader.removeEventListener(SmercImgLoader.IMAGE_LOADING_ERROR_EVT, imageLoadingErrorHandler);
				_swfLoader.destroy();
				_swfLoader = null;
			}
			
			if (_buttonContents)
			{
				_buttonContents = null;
			}
			
			if (Tweener.isTweening(_loaderHolder))
			{
				Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");
			}
			
			_appearCompleteCallback = null;
			_disappearCompleteCallback = null;
			
			_loadedImgBytes = null;
			
			this.removeEventListener(ButtonEvent.SMERCBUTTON_ROLL_OVER_EVT, expandOnRollover);
			this.removeEventListener(ButtonEvent.SMERCBUTTON_ROLL_OUT_EVT, normalizeSize);
			
			if (_loadingListener)
			{
				_loadingListener.destroy();
				_loadingListener = null;
			}
			
		}//end override destroy()
		
		public function bounceInOut():void
		{
			this.appear(this.disappear);
		}//end bounceInOut()
		
		public function appear(a_onCompleteCallback:Function = null):void
		{
			//
			
			if (!_loaderHolder)
			{
				log.warn("ImageLoadingButton::appear(): _loaderHolder=" + _loaderHolder + ", returning.");
			}
			
			_appearCompleteCallback = a_onCompleteCallback;
			
			if (Tweener.isTweening(_loaderHolder))
			{
				Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");
				
				// 10/23/09 Nate Removed during Haircuts Branch Merge ... Tweener.removeTweensWithDelete not found
				/*
				if(Globals.newLoadingScheme)				
				Tweener.removeTweensWithDelete(_loaderHolder, "scaleX", "scaleY");
				else
				Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");
				*/
			}
			
			_loaderHolder.visible = true;
			_loaderHolder.scaleX = 0;
			_loaderHolder.scaleY = 0;
			
			Tweener.addTween(_loaderHolder, { scaleX:1, time:0.5, transition:"easeOutElastic", onComplete:appearComplete } );
			
			
			Tweener.addTween(_loaderHolder, { scaleY:1, time:0.5, transition:"easeOutElastic" } );
			
		}//end appear()
		
		public function disappear(a_onCompleteCallback:Function = null):void
		{
			//
			
			_disappearCompleteCallback = a_onCompleteCallback;
			
			if (Tweener.isTweening(_loaderHolder))
			{
				// 10/23/09 Nate Removed during Haircuts Branch Merge ... Tweener.removeTweensWithDelete not found
				Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");
				/*
				if(Globals.newLoadingScheme)
				Tweener.removeTweensWithDelete(_loaderHolder, "scaleX", "scaleY");
				else
				Tweener.removeTweens(_loaderHolder, "scaleX", "scaleY");	
				*/
			}
			
			_loaderHolder.scaleX = 1;
			Tweener.addTween(_loaderHolder, { scaleX:0, time:.25, transition:"easeOutQuad", onComplete:disappearComplete } );
			
			_loaderHolder.scaleY = 1;
			Tweener.addTween(_loaderHolder, { scaleY:0, time:.25, transition:"easeOutQuad" } );
			
		}//end disappear()
		
		protected function appearComplete(...args):void
		{
			//
			
			if(null != _appearCompleteCallback)
			{
				_appearCompleteCallback();
			}
			
		}//end appearComplete()
		
		protected function disappearComplete(...args):void
		{
			//
			
			_loaderHolder.visible = false;
			
			if(null != _disappearCompleteCallback)
			{
				_disappearCompleteCallback();
			}
			
		}//end disappearComplete()
		
	}//end class ItemContainerButton
	
}//end package com.smerc.uicomponents.Buttons
