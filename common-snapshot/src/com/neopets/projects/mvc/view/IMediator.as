package com.neopets.projects.mvc.view
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	
	public interface IMediator
	{
		function get viewContainer():ViewContainerold;
		function get ID():String;
		function get ActiveViewFlag():Boolean;
		function set ActiveViewFlag(pSwitch:Boolean):void;	
		function get viewContainersLayer():uint;
		function set viewContainersLayer(pDefaultLayer:uint):void;
		function get setupInfo():Object;
		function get mediatorLoadListXML():XML;
		
		//function init(pSharedListener:ISharedListener,pInfoObject:Object,pSiteLogic:iLogic,pDefaultLayer:uint = 0,pLoadingSection:String = null,pID:String = "Mediator",pInfoDataObject:Object = null):void;
		
	}
}