//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Ledge;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.neopets.util.collision.geometry.CompositeArea;
	import com.neopets.util.collision.geometry.RectangleArea;
	
	/**
	 * public class LedgeBreaking extends ledge
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class LedgeBreaking extends Ledge
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var _timer:Timer;
		
		private var _broke:Boolean = false;
		//OLD change this to regulate the time it takes to the ledge to break
		//private var _millsecs:Number = 500;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class LedgeBreaking extends ledge instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function LedgeBreaking()
		{
			super();
			//OLD
			//createTimer();
			gotoAndStop(1);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init (value:Number):void {
			if (!_broke){
				createTimer(value);
			}
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		//OLD
		/*protected function createTimer():void {
			_timer = new Timer (_millsecs, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, lbreak, false, 0, true);
		}*/
		
		
		//NEW
		protected function createTimer(millsecs:Number):void {
			_timer = new Timer (Math.abs(millsecs), 1);//
			_timer.addEventListener(TimerEvent.TIMER, check, false, 0, true); 
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, lbreak, false, 0, true);
			trace (this, "TIMER START", Math.abs (millsecs));
			_timer.start();
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function check (e:TimerEvent):void {
			trace (this, "TIMER");
		
		}
		
		private function clearTimer ():void {
			trace (this, "CLEAR TIMER");
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, lbreak);
			_timer = null;
		}
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		protected function lbreak (e:TimerEvent):void {
			trace (this, "LEDGE BREAK");
			clearTimer();
			dispatchEvent(new CustomEvent ({etype:"break"}, GameInfo.LEDGE_EVENT));
			_broke = true;
			gotoAndPlay("break");
			addEventListener(Event.ENTER_FRAME,onLedgeCheck);
		}
		
		// Each frame check and see if the new ledge area has been set up.
		
		protected function onLedgeCheck(ev:Event):void {
			// check if the child regions have been defined
			var regions:Array = new Array();
			var region:DisplayObject = getChildByName("left");
			if(region != null) regions.push(region);
			region = getChildByName("right");
			if(region != null) regions.push(region);
			// if so, load them into a composite area
			if(regions.length > 0) {
				var composite:CompositeArea = new CompositeArea();
				var sub_area:RectangleArea;
				for(var i:int = 0; i < regions.length; i++) {
					region = regions[i];
					sub_area = new RectangleArea(region);
					composite.addArea(sub_area);
				}
				_proxy.area = composite;
				// stop listner
				removeEventListener(Event.ENTER_FRAME,onLedgeCheck);
			}
		}
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get broke():Boolean{
			return _broke;
		}
		//OLD
		/*override public function set hooked(value:Boolean):void {
			if (_timer){
				_timer.start();
			} 
			trace (this, "hooked");
		}*/
	}
}