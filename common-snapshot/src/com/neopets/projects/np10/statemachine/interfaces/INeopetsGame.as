package com.neopets.projects.np10.statemachine.interfaces
{
	import flash.events.IEventDispatcher;

	public interface INeopetsGame extends IEventDispatcher
	{
		function initGame():void;
		function restartGame():void;
		
	}
}