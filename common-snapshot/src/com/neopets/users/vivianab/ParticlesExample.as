//Marks the right margin of code *******************************************************************
package com.neopets.users.vivianab
{
	import com.neopets.games.inhouse.shenkuuwarrior2.effects.BonusPickupFX;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	/**
	 * public class ParticlesExample extends MovieClip
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ParticlesExample extends MovieClip
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
		private var _VFX:BonusPickupFX;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ParticlesExample extends MovieClip instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ParticlesExample()
		{
			super();
			stage.addEventListener(MouseEvent.CLICK, starteffect);
			addEventListener(Event.ENTER_FRAME, update);
			trace (this, hasEventListener(MouseEvent.CLICK));
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		private function puEffect(pClasses:Array, timeLapse:int, callBack:Function):void {
			startPowerupTimer (callBack, timeLapse);
			_VFX = new BonusPickupFX ();
			_VFX.init(pClasses, mouseX, mouseY);
			addChild (_VFX);
			trace ("_VFX created");
		}
	
		
		private function startPowerupTimer (callBack:Function, secs:int):void {
			trace ("Timer started");
			var t:Timer = new Timer (1000, secs);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, callBack, false, 0, true);
			t.start();
		}
		
		private function endFlyingPowerup (e:TimerEvent):void {
			trace ("timer ended");
			Timer(e.target).stop();
			Timer (e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, endFlyingPowerup);
			/*if (_VFX){
				if (contains(_VFX)){
					removeChild(_VFX);
				}
				_VFX = null;
			}*/
			_VFX.active = false;
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		
		private function starteffect (e:MouseEvent):void {
			trace ("clicked");
			puEffect(["p2"], 1, endFlyingPowerup);
		}
		
		private function update (e:Event):void {
			if (_VFX){
				_VFX.update();
			}
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}