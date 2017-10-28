package com.neopets.projects.mvc.view
{
	import com.neopets.util.button.INeopetButton;
	import com.neopets.util.sound.SoundManagerOld;
	
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	public interface INeopetsScene
	{
		function get viewContainer():ViewContainerold;
		function get ID():String;
		function get constructionXML():XML;
		function get buttonArray():Array;
		function get displayFlag():Boolean;
		function set displayFlag(pFlag:Boolean):void;
		function get background():DisplayObject;
		function get lockButtons():Boolean;
		function set lockButtons(pFlag:Boolean):void;
		function get backgroundSound():String;
		function get sceneSoundManager():SoundManagerOld;
		function getButton(pName:String):INeopetButton;
		function init(sceneXML:XML,pApplicationDomain:ApplicationDomain= null,pBackground:DisplayObject = null,pLocalSoundManager:SoundManagerOld = null):void;
		
	}
}