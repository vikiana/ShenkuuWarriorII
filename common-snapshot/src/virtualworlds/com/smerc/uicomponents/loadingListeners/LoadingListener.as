package virtualworlds.com.smerc.uicomponents.loadingListeners
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	/**
	 * Listens to an object that dispatches ProgressEvents and an Event.COMPLETE event.
	 * @author Bo Landsman
	 */
	public class LoadingListener extends Sprite
	{
		protected var _loadingObj:IEventDispatcher;
		
		protected var _loadingImg:DisplayObject;
		
		protected var _loadingTxt:TextField;
		
		protected var _bAddContents:Boolean;
		
		public function LoadingListener(a_loadingObj:IEventDispatcher = null, a_loadingImg:DisplayObject = null, 
											a_bAddContents:Boolean = true)
		{
			_bAddContents = a_bAddContents;
			
			this.init(a_loadingImg);
			
			if(a_loadingObj)
			{
				this.loadingObj = a_loadingObj;
			}
			
		}//end LoadingListener() constructor.
		
		public function set loadingObj(a_loadingObj:IEventDispatcher):void
		{
			//
			
			if (_loadingObj)
			{
				_loadingObj.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_loadingObj.removeEventListener(Event.COMPLETE, onLoadingComplete);
			}
			
			_loadingObj = a_loadingObj;
			
			if (_loadingObj)
			{
				_loadingObj.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
				_loadingObj.addEventListener(Event.COMPLETE, onLoadingComplete, false, 0, true);
			}
			
		}//end set loadingObj()
		public function get loadingObj():IEventDispatcher
		{
			return _loadingObj;
			
		}//end get loadingObj()
		
		protected function init(a_loadingImg:DisplayObject):void
		{
			if (a_loadingImg)
			{
				_loadingImg = a_loadingImg;
			}
			else
			{
				var spriteLoadingImg:Sprite = new Sprite();
				_loadingImg = spriteLoadingImg;
				_loadingTxt = new TextField();
				_loadingTxt.text = "Loading...";
				_loadingTxt.selectable = false;
				_loadingTxt.width = _loadingTxt.textWidth + 2;
				_loadingTxt.height = _loadingTxt.textHeight + 2;
				
				spriteLoadingImg.addChild(_loadingTxt);
			}
			
			if(_bAddContents)
			{
				this.addChild(_loadingImg);
			}
			
		}//end init()
		
		protected function conclude(...args):void
		{
			if (_loadingImg && _loadingImg.parent)
			{
				_loadingImg.parent.removeChild(_loadingImg);
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}//end conclude()
		
		protected function onProgressHandler(a_progressEvt:ProgressEvent):void
		{
			// Let more complex handling of the progressEvents rest with subclasses.
			
		}//end onProgressHandler()
		
		protected function onLoadingComplete(a_evt:Event):void
		{
			if(_loadingObj)
			{
				_loadingObj.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_loadingObj.removeEventListener(Event.COMPLETE, onLoadingComplete);
			}
			
			this.conclude();
			
		}//end onLoadingComplete()
		
		public function destroy(...args):void
		{
			if (_loadingObj)
			{
				_loadingObj.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_loadingObj.removeEventListener(Event.COMPLETE, onLoadingComplete);
				_loadingObj = null;
			}
			
			if (_loadingTxt)
			{
				if (_loadingTxt.parent)
				{
					_loadingTxt.parent.removeChild(_loadingTxt);
				}
				_loadingTxt = null;
			}
			
			if (_loadingImg)
			{
				if (_loadingImg.parent)
				{
					_loadingImg.parent.removeChild(_loadingImg);
				}
				_loadingImg = null;
			}
			
		}//end destroy()
		
	}//end class LoadingListener
	
}//end package com.smerc.uicomponents.loadingListeners
