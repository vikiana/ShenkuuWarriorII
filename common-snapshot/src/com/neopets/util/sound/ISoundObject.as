package com.neopets.util.sound
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 *	This is the Basic Interface for Sound Objects
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Interface
	 * 
	 *	@author Clive Henrick
	 *	@since  1.04.2009
	 */
	 
	public interface ISoundObject
	{
		function set currentSoundChannel(pSNDC:SoundChannel):void;
		function get currentSoundChannel():SoundChannel;
		function get name():String;
		function set name(pName:String):void
		function get type():String;
		function set volume(pVolume:Number):void;
		function get volume():Number;
		function set isPlaying(pIsPlaying:Boolean):void;
		function get isPlaying():Boolean;
		function get randomPool():String;
		function set randomPool(pPool:String):void;
		function get playInfo():Array;
		function set playInfo(pArray:Array):void;
		function get infiniteLoop():Boolean;
		function get constructionInfo():Array
		function playSound(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null,pInfiniteLoop:Boolean = false):void;
		function togglePlayback():void;
		function fastFwd():void;
		function toggleMute():void;
		function stopSound():void;
		function seek(pLocation:Number):void;
		function fadeDown(pDuration:Number=1000):void
		 	
	}
}