package com.neopets.util.sound
{
	import com.neopets.util.data.EmbedObjectData;
	import flash.events.*;	
	/**
	 *	This is the Basic Interface for Sound Objects
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	@Pattern Interface
	 * 
	 *	@author Clive Henrick
	 *	@since  1.04.2009
	 */
	 
	public interface ISoundManager
	{
		
		function set soundtobeLoadedCount(pNumber:uint):void;
		function get globalSoundLevel():uint;
		function set globalSoundLevel(pLevel:uint):void;
		function get soundOverRide():Boolean;
		function set soundOverRide(pFlag:Boolean):void;
		
		function checkSoundObj(pSoundname:String):Boolean;
		function removeSound(pSoundname:String):void;
		function fadeoutAllSounds(pFadeTime:int = 1):void;
		function fadeOutSound(pSoundName:String,pFadeTime:int = 1):void;
		function fadeInSound(pSoundName:String,pVolume:Number = 1, pFadeTime:int = 1):void;
		function stopAllCurrentSounds(evt:Event = null):void;
		function checkSoundState(pNameSound:String):Boolean;
		function stopSound(pNameSound:String):void;
		function loadSound(pSoundName:String,pType:String = "SoundFileIsLoaded",pAmountToBuffer:Number = 0,pLocation:String = null,pPool:String = null, pVolume:Number = 1, pID:String = null, pEmbedObjData:EmbedObjectData = null):void
		function addSound(pSoundObj:SoundObj):void;
		function soundPlay(pSoundName:String,pInfLoop:Boolean = false,pStart:uint = 0,pLoops:int = 0, pStartVolume:Number = -1):void;
		function changeSoundVolume(pNameSound:String,pVolume:Number):void;
		function getSoundObj(pSoundname:String):*;
		function cleanUpAllMemory():void;
	}
}