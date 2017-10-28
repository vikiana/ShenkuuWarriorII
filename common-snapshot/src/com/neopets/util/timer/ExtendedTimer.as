package com.neopets.util.timer
{
	import flash.utils.Timer;

	public class ExtendedTimer extends Timer
	{
		private var mObject:Object;
		
		public function ExtendedTimer(delay:Number, repeatCount:int=0, pObject:Object = null)
		{
			mObject = pObject;
			
			super(delay, repeatCount);
		}
		
		public function get object():Object
		{
			return mObject;
		}
		
		public function set object(pObject:Object):void
		{
			mObject = pObject;	
		}
		
	}
}