package virtualworlds.com.smerc.uicomponents.containers.scrollMenus
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import virtualworlds.com.smerc.uicomponents.buttons.ISmercButton;
	
	/**
	* ...
	* @author Bo
	*/
	public interface IScrollMenu 
	{
		function set buttonsHeldDownInterval(a_int:int):void;
		function destroy(...args):void;
		function set spacing(newSpacing:Number):void;
		function get spacing():Number;
		function set movementTweenTime(a_time:Number):void;
		function setSpeed(a_number:Number):void;
		function addItemToMenu(a_obj:DisplayObject):DisplayObject;
		function addItemAt(a_do :DisplayObject, a_index:int):DisplayObject;
		function getMenuItemAt(a_index:uint):DisplayObject;
		function removeMenuItem(a_do :DisplayObject, a_bDestroyItemsRemoved:Boolean = false):int;
		function indexOfMenuItem(a_do :DisplayObject):int;
		function hasMenuItem(a_do :DisplayObject):Boolean;
		function get numberOfItems():int;
		function clearMenu(a_bDestroyItemsRemoved:Boolean = false):void;
		function removeMenuItemAt(a_index:Number, a_bDestroyItemsRemoved:Boolean = false):void;
		function removeLastMenuItem(a_bDestroyItemRemoved:Boolean = false):void;
		function pause(a_bool:Boolean):void;
		function onScroll1Press(...args):void;
		function onScroll2Press(...args):void;
		function get scrollButton1():ISmercButton;
		function get scrollButton2():ISmercButton;
		function set tweenContainerMovement(a_bool:Boolean):void;
		function get entireMenuContents():MovieClip;
		
	}//end interface IScrollMenu
	
}//end package com.smerc.uicomponents.Containers.ScrollMenus
