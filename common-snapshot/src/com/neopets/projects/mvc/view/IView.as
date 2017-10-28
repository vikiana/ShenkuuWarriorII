package com.neopets.projects.mvc.view
{
	
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.iLogic;
	
	public interface IView
	{
		function get projectMediator():IMediatorController;	
		function get projectLogic():iLogic;
		function get projectViewContainer():ViewContainerold;
		function init(pSiteLogic:iLogic):void
	}
}