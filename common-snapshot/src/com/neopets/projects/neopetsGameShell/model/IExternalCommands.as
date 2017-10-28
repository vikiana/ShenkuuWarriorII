package com.neopets.projects.neopetsGameShell.model
{
	public interface IExternalCommands
	{
		function doExternalCommand(pCmd:String,pParam:String = null,pObject:Object = null):void;	
	}
}