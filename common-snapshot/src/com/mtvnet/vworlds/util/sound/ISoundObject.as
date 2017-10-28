package com.mtvnet.vworlds.util.sound
{
	import flash.events.IEventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	
	/**
	 *	This is the Basic Interface for Sound Objects
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Interface
	 * 
	 *	@author Clive Henrick
	 *	@since  12.04.2009
	 */
	 
	public interface ISoundObject extends IEventDispatcher
	{
		function set currentSoundChannel(pSNDC:SoundChannel):void;
		function get currentSoundChannel():SoundChannel;
		function get name():String;
		function set name(pName:String):void
		function get type():String;
		function set type(pType:String):void;
		function set volume(pVolume:Number):void;
		function get volume():Number;
		function set isPlaying(pIsPlaying:Boolean):void;
		function get isPlaying():Boolean;
		function get randomPool():String;
		function set randomPool(pPool:String):void;
		function get playInfo():Array;
		function set playInfo(pArray:Array):void;
		function get infiniteLoop():Boolean;
		function get constructionInfo():Array;
		function set constructionInfo(pArray:Array):void;
		function get soundApplicationDomain():ApplicationDomain;
		function set soundApplicationDomain(pApplicationDomain:ApplicationDomain):void;
		/**
		 * This is the Basic PlayBack of a Sound File
		 * @param	startTime		Number				The StartTime in a SoundFile
		 * @param	loops			int					Tells the Sound to Loop
		 * @param	sndTransform	SoundTransform		For Special Effects
		 * */
		 
		function playSound(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null,pInfiniteLoop:Boolean = false):void;
		
		/**
		 * Load a SoundFile from an External Location
		 */
		 
		function loadExternalSound ():void;
		 
		/**
		 * This turns on or off a sound file
		*/
		
		function togglePlayback():void;
		
		/**
		 * This is a Fake Fast Foward (There is no fast foward of Audio in Flash). It Skips every few seconds
		*/
		function fastFwd():void;
		
		/**
		 * This Turns off or On the Volume
		*/
		
		function toggleMute():void;
		
		/**
		 * This Stops Playback
		*/
		
		function stopSound():void;
		
		/**
		 * This Starts PlayBack at a lcoation for Playback
		 * @param		pLocation		Number				The StartTime in a SoundFile 
		*/
		
		function seek(pLocation:Number):void;
		
		/**
		 * This Will Fade the Sound File
		 * @param		pDuration		Number		The Amount of time to Fade the SoundFile
		*/
		
		function fadeDown(pDuration:Number=1):void
		
		/**
		 * This Will Fade the Sound File to a set volume
		 * @param		pDuration		Number		The Amount of time to Fade the SoundFile
		*/
		
		function fadeIn(pVolume:Number = 1, pDuration:Number=1):void
		
		/**
		 * @Note This is to Clear Memory for the Loaded Item
		*/
		 
		function clearLoadedItem():void	
	}
}