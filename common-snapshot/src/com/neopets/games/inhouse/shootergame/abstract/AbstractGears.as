package com.neopets.games.inhouse.shootergame.abstract
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 *	This the class that rules the movement of Gears. In uses init() to calculate rotaton times for all dependent gears of a gear system.
	 *  Every gear system (such as Slit) will subclass this and add Tweens for every gear.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.01.2009
	 */
	public class AbstractGears extends MovieClip
	{
				
		
	 	/**
	 	*	Constructor
	 	*/
		public function AbstractGears()
		{
			super();
			addEventListener (Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		protected function init(e:Event=null):void {
			trace ("using abstract class");
		}
		
		
		protected function getDependentGearTime (g1Time:Number, gear1:MovieClip, gear2:MovieClip):Number{
			var g2Time:Number;
			g2Time = (g1Time * (gear2.width/2))/(gear1.width/2);
			return g2Time;
		}
	}
}