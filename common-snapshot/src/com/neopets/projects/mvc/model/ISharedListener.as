package com.neopets.projects.mvc.model
{
	
	import flash.events.IEventDispatcher;

	public interface ISharedListener extends IEventDispatcher
	{
		function sendCustomEvent(pEvent:String,pObject:Object, pBubbles:Boolean=false, pCancelable:Boolean=false):void;
	}
}