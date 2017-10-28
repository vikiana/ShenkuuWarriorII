package com.neopets.projects.mvc
{
	import com.neopets.projects.mvc.controller.IController;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.view.IView;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	public interface iLogic
	{
		
		function get projectView():IView;
		function get projectController():IController;
		function get rootApplication():Object;
		function get gameShell_Events():ISharedListener;
		function get sharedListener():ISharedListener;
		function set configXML(pXML:XML):void;
		function get configXML():XML;
		
		function init(pRootApplication:Stage):void;

		//function onSiteCoreReady(evt:Event):void;		
	}
}