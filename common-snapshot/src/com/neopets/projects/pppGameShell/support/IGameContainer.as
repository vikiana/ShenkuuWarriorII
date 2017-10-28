package com.neopets.projects.pppGameShell.support
{
	import com.neopets.projects.mvc.view.ViewContainerold;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	
	import flash.display.MovieClip;
	
	public interface IGameContainer
	{
		function get gameShell_Events():GameShell_Events;
		function get inShell():Boolean;
		function  get configXML():XML;
		function  get viewContainer():ViewContainerold;
		function init(pShellRoot:MovieClip = null,pGameShell_Events:GameShell_Events = null, pConfigXML:XML = null):void
	}
}