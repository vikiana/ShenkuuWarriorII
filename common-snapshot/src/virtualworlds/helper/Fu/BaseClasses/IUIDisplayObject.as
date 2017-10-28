package virtualworlds.helper.Fu.BaseClasses
{
	import flash.events.IEventDispatcher;
	
	public interface IUIDisplayObject extends IUpdateable, IEventDispatcher
	{
		function get active ():Boolean;
		function set active (value:Boolean):void;
		
		function get controller ():IUIController
		function set controller (value:IUIController):void;
		
		function get activeTweenArray ():Array;
		function set activeTweenArray (value:Array):void;
		
		function activated ():void;
		function deactivated ():void;
		
		function animatedIn ():void;
		function animatedOut ():void;
	}
}