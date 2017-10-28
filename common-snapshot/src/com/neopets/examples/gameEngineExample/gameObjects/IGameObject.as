package com.neopets.examples.gameEngineExample.gameObjects
{
	
	import flash.geom.Rectangle;
	
	
	public interface IGameObject 
	{
		function init(pID:String,pBoundingBox:Rectangle,pBaseScale:Number = 1):void;
		function doCleanUp():void;
		function setStartLocation():void;
		function doEffect():void;
	}
}