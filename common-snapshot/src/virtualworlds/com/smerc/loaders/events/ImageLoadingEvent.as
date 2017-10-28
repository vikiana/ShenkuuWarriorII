package virtualworlds.com.smerc.loaders.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	* ...
	* @author Bo
	*/
	public class ImageLoadingEvent extends Event
	{
		protected var _bSuccessful:Boolean;
		protected var _loadedImg:DisplayObject;
		protected var _errorStr:String;
		
		public function ImageLoadingEvent(type:String, a_bSuccess:Boolean = true, a_img:DisplayObject = null,
											a_error:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_bSuccessful = a_bSuccess;
			
			_loadedImg = a_img;
			
			_errorStr = a_error;
			
		}//end ImageLoadingEvent() constructor.
		
		public function getSuccessfullyLoaded():Boolean
		{
			return _bSuccessful;
		}//end getSuccessfullyLoaded()
		
		public function get loadedImg():DisplayObject
		{
			return _loadedImg;
		}//end get loadedImg()
		
		public function getErrorStr():String
		{
			return _errorStr;
		}//end getErrorStr()
		
		override public function clone():Event
		{
			return new ImageLoadingEvent(this.type, this._bSuccessful, this._loadedImg, this._errorStr, this.bubbles, this.cancelable);
		}//end override clone()
		
	}//end class ImageLoadingEvent
	
}//end package com.smerc.loaders.events
