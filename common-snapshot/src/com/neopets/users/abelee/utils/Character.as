/**
 *	enemy Character
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.users.abelee.utils
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Character extends MovieClip
	{
		
		protected var fading:Boolean = false
		
		public function Character():void
		{
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function activate():void
		{
			alpha = .6
			if (!fading)
			{
				fading = true;
				addEventListener(Event.ENTER_FRAME, fadeMe, false, 0, true);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------

		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		protected function fadeMe(e:Event):void
		{
			alpha -= .02;
			if (alpha <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, fadeMe)
				fading = false;
			}
		}
		
	}
	
}





















