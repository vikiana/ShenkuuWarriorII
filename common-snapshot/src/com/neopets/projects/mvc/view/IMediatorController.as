package com.neopets.projects.mvc.view
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	
	public interface IMediatorController
	{
		function init(pSharedListener:ISharedListener,pSiteLogic:iLogic):void;
		function addDisplayMediator(pViewMediator:IMediator):void;
		function get viewContainer():ViewContainerold;
		function set projectMediatorsTotal(pNum:uint):void;
			
	}
}