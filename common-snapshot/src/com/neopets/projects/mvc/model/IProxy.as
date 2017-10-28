package com.neopets.projects.mvc.model
{
	
	import flash.events.Event;
	
	public interface IProxy
	{
		function loadData(pURLARRAY:Array):void;
		function get ID():String;
		function get loadedDataArray():Array;
		function getXML(pName:String):XML;
		function reorderByAtribute(pName:String, pAttribute:String, pOptions:Object = null, pCopy:Boolean=false):XML;
	}
}