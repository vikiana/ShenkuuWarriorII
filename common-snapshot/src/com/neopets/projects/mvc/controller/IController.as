package com.neopets.projects.mvc.controller
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	
	public interface IController
	{
		function activateCMD(pCMD:String,pObject:Object = null):void;
		function init(pSharedListener:ISharedListener,pProjectLogic:iLogic):void;		
	}
}