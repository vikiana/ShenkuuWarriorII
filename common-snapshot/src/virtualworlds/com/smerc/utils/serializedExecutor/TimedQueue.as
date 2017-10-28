package virtualworlds.com.smerc.utils.serializedExecutor
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import virtualworlds.com.smerc.utils.events.ObjectEvent;
	
	/**
	 * This is a data structure useful in that the queue is not externally corruptable.
	 * A Timer of the developer's choosing is used to pop the elements in the queue, upon its TimerEvent.TIMER events.
	 * 
	 * @author Bo Landsman
	 */
	public class TimedQueue extends EventDispatcher
	{
		/**
		 * @eventType TimedQueue.POP_OBJECT_EVT
		 * This is dispatched upon each *pop* of the queue, that is, 
		 * each time the Timer fires, this dispatches the element in the queue
		 * inside of an ObjectEvent, removing that object from the queue.
		 * 
		 * @see com.smerc.utils.events.ObjectEvent
		 */
		public static const POP_OBJECT_EVT:String = "PopObjectEvent";
		
		/**
		 * The internal timer used to pop our queue.
		 */
		protected var _queueTimer:Timer;
		
		/**
		 * The internal queue, itself.
		 */
		protected var _queue:Array;
		
		public static const DEFAULT_POP_DELAY:Number = 1;
		
		/**
		 * Deterimines if we've been paused or not.  Our internal timer is paused and we do not pop our queue.
		 */
		protected var _paused:Boolean = false;
		
		/**
		 * Constructs a new TimedQueue.
		 * 
		 * @param	a_popDelay:	<Number @default NaN> used for the construction call to getNewTimerInstance(a_popDelay).
		 * 
		 * @see #getNewTimerInstance()
		 */
		public function TimedQueue(a_popDelay:Number = NaN)
		{
			_queue = new Array();
			_queueTimer = this.getNewTimerInstance(a_popDelay);
			
			if(_queueTimer)
			{
				_queueTimer.addEventListener(TimerEvent.TIMER, popQueue, false, 0, true);
			}
			
		}//end TimedQueue() constructor.
		
		/**
		 * 
		 * @param	a_popDelay:	<Number @default NaN> used for the delay value of our internal pop-Timer.
		 * 
		 * @return				<Timer> instance to be used internally as our Pop-Timer.
		 */
		protected function getNewTimerInstance(a_popDelay:Number = NaN):Timer
		{
			var timer:Timer;
			
			if (!_queueTimer)
			{
				if (isNaN(a_popDelay) || a_popDelay < 1)
				{
					a_popDelay = TimedQueue.DEFAULT_POP_DELAY;
				}
				
				timer = new Timer(a_popDelay, 0);
			}
			
			return timer;
			
		}//end get timerClass()
		
		/**
		 * Adds an object to the queue to be popped on the pop-timer.  If we're not paused, this will start the timer.
		 * 
		 * @param	a_obj:	<Object> Add an object to the queue to be popped in the 
		 * 					@eventType TimedQueue.POP_OBJECT_EVT.
		 * 
		 * @see #TimedQueue.POP_OBJECT_EVT
		 */
		public function add(a_obj:Object):void
		{
			_queue.push(a_obj);
			
			if(!_paused)
			{
				_queueTimer.start();
			}
			
		}//end add()
		
		/**
		 * Remove an item from the internal queue.
		 * 
		 * @param	a_obj:	<Object> Item to be removed from the queue, should it exist.
		 * 
		 * @return			<int> The index of a_obj that was removed from the internal queue.
		 */
		public function remove(a_obj:Object):int
		{
			var indexOf:int = _queue.indexOf(a_obj);
			if (indexOf >= 0)
			{
				_queue.splice(indexOf, 1);
			}
			
			return indexOf;
			
		}//end remove()
		
		/**
		 * Empty the internal queue.
		 */
		public function empty():void
		{
			_queue = new Array();
		}//end empty()
		
		/**
		 * This is the pop-timer event that calls doPop(), removing an item from this queue.
		 * If the queue is empty, or we are paused, the timer is stopped and the item is not popped.
		 * 
		 * @param	a_timerEvt:	<TimerEvent> The pop-timer event that pops items off this queue.
		 */
		private function popQueue(a_timerEvt:TimerEvent):void
		{
			if (!_queue.length || _paused)
			{
				_queueTimer.stop();
				return;
			}
			
			// Get the first element.
			var obj:Object = _queue[0];
			
			// Remove this first element from the front of the queue
			_queue.splice(0, 1);
			
			// do the popping.  In this case, dispatch the object in an ObjectEvent.
			this.doPop(obj);
			
		}//end popQueue()
		
		/**
		 * This does the actual popping of the queue, dispatching an ObjectEvent with the popped item inside of it.
		 * Should one want a circular queue, one could override this function and re-add the popped item, 
		 * or one could listen to the POP_OBJECT_EVT and re-add it in the listening function.
		 * 
		 * @param	a_obj:	<Object> The item to pop, that is, dispatch in an ObjectEvent.
		 * 
		 * @see com.smerc.utils.events.ObjectEvent
		 */
		protected function doPop(a_obj:Object):void
		{
			this.dispatchEvent(new ObjectEvent(TimedQueue.POP_OBJECT_EVT, a_obj));
			
		}//end doPop()
		
		/**
		 * 
		 * 
		 * @param	a_bool:	<Boolean> pause this queue from popping.
		 */
		public function pause(a_bool:Boolean):void
		{
			_paused = a_bool;
			
			if (_paused && _queueTimer && _queueTimer.running)
			{
				_queueTimer.stop();
			}
			else if (!_paused && _queueTimer)
			{
				_queueTimer.start();
			}
			
		}//end pause()
		
		/**
		 * Cleanup for this class.
		 * 
		 * @param	...args
		 */
		public function destroy(...args):void
		{
			if(_queueTimer)
			{
				_queueTimer.removeEventListener(TimerEvent.TIMER, popQueue);
				_queueTimer.stop();
				_queueTimer = null;
			}
			
			_queue = null;
			
			_paused = false;
		
		}//end destroy()
		
	}//end class TimedQueue
	
}//end package com.smerc.utils.serializedExecutor
