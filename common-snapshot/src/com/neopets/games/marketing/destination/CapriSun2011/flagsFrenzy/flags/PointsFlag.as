
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.flags
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.neopets.util.text.BitmapText;
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.marketing.destination.CapriSun2011.flagsFrenzy.flags.PrizeFlag;
	
	/**
	 *	This class handles assigning random point values and synching a flag's bitmap text with it's point value.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  05.06.2010
	 */
	 
	public class PointsFlag extends PrizeFlag
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _pointField:BitmapText;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function PointsFlag():void{
			super();
			// search for bitmap text
			var child:DisplayObject;
			for(var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if(child is BitmapText) {
					_pointField = child as BitmapText;
					break;
				}
			}
			// set points to random value
			//_pointValue = int(GeneralFunctions.getRandom(10,90,1,5));
			if(_pointField != null) _pointField.translatedText = String(_pointValue);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function setPointField(pScore:int):void
		{
			_pointValue = pScore;
			if(_pointField != null) _pointField.translatedText = String(_pointValue);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
