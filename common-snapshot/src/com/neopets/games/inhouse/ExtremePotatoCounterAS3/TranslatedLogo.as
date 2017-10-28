/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.ExtremePotatoCounterAS3
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	/**
	 *	This is a List of All the Text that needs to be Translated by the System
	 *	You can see this File Online http://www.neopets.com/transcontent/flash/game_13000.txt
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Translation System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	dynamic public class TranslatedLogo extends MovieClip 
	{
		
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TranslatedLogo():void{
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to push our main clip to the target frame.
		 */
		 
		public function startChildAnimation(tag:String):void {
			var child:DisplayObject;
			var clip:MovieClip;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is MovieClip) {
					clip = child as MovieClip;
					clip.gotoAndPlay(tag);
				}
			}
		}
		
	}
	
}
