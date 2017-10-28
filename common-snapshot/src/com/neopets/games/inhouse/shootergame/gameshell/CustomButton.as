/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.shootergame.gameshell
{
	
	import com.neopets.games.inhouse.shootergame.Main;
	import com.neopets.util.sound.SoundManagerOld;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	/**
	 *	This is for Simple Control of a Button with a Little More Extras
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Clive Henrick/VB
	 *	@since  1.2.2009
	 */
	public class CustomButton extends MovieClip 
	{
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		protected var mID:String;
		protected var mSoundManager:SoundManagerOld;
		
		private var _MAIN:Main;
	
		
		/**
		 *	@Constructor
		 */
		public function CustomButton()
		{	
			buttonMode = true;
			gotoAndStop(1);
			addEventListener(MouseEvent.MOUSE_OVER,onRollOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,onRollOut,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get ID():String
		{
			return mID;
		}
		
		public function set ID(pString:String):void
		{
			mID = pString;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/** 
		 * @Note: This is the Init
		 * 
		 * @param       main							The Game Engnine, where the gaming system and the sounds manager are accessible.
		 * @param       textVar							The Button Title var (for translation);
		 * @param		pID 							String				The Name of the Button
		 */
		public function init(main:Main, textVar:String="none", pID:String = "button"):void	
		{
			mID = pID;
			_MAIN = main;	
			mSoundManager = _MAIN.soundManager;
		}
		
		
		/**
		 *@Note Resets the Button to the first frame 
		 */
		 
		public function reset():void
		{
			gotoAndStop(1);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onRollOver(evt:MouseEvent):void 
		{
			gotoAndStop("over");
		}
		
		protected function onRollOut(evt:MouseEvent):void 
		{
			gotoAndStop("up");	
		}
		
		protected function onDown(evt:MouseEvent):void 
		{
			gotoAndStop("down");
			playButtonSnd();
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//-----------------------------------
		protected function playButtonSnd():void
		{
			if (_MAIN){
				if (_MAIN.soundOn){
					mSoundManager.soundPlay("mouse_over");
				}
			}
		}
		
	}
	
}
