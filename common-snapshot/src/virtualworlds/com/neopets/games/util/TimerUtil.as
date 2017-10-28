
		/**
		 * @author Nate Altschul
		 * Convenience wrapper for Timer class
		 * 
		 */
		 
package virtualworlds.com.neopets.games.util
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	 
	
	public class TimerUtil
	{
		
		/**
		 * @author Nate Altschul
		 * Convenience wrapper for Timer class
		 * 
		 * 
		 * For normal use this should do
		 * @pararm delay uint Required		
		 * @pararm callbackMethod Function Required 
		 * @pararm repeatNum uint Optional 		
		 * @return String	FullyQualifiedUri	
		 * 
		 * TODO: allow parameter to be passed to callback method
		 * 
		 */
		public static function startTimer(delay:Number, callbackMethod:Function, repeatCount:int = 0):Timer
		{
			var timer:Timer = new Timer(delay, repeatCount);
			timer.addEventListener(TimerEvent.TIMER, callbackMethod);
			timer.start();
			return timer;
		}

		//public static function setInterval(delay:Number, callbackMethod:Function, repeatCount:int = 1):Timer
		//public static function setTimeout(delay:Number, callbackMethod:Function, repeatCount:int = 1):Timer


		/*
		* protected constructor
		*/ 
		public function TimerUtil()
		{
		}
	
	}
	
}