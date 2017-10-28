package virtualworlds.helper.Fu.Helpers
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import virtualworlds.helper.Fu.BaseClasses.BasicClass;
	import virtualworlds.helper.Fu.BaseClasses.IUpdateable;
	
	public class StackExecutor extends BasicClass implements IExecutingController
	{
		// time in ms that the handle of a IUpdateable is called
		private var _updateSpeed:uint
		// the stack of updateables
		private var _stack:Array 
		// items ready to have their exit() called and then removed from the stack
		private var _deleteQue:Array
		// the timer which holds the listener for the update loop
		private var _timer:Timer
		// the number of gameSteps that have happened since the first start of this stack executor
		private var _gameSteps:uint
		// the about of time it took for the last execution
		private var _lastExecutionTime:uint
		// a booleaon to trace whether or not this will trace updae time
		private var _outputExecutionTime:Boolean
		
		public function StackExecutor(aSpeedInMs:uint = 42) // 24fps
		{
			output("New StackController")
			_updateSpeed = aSpeedInMs
			_stack = new Array()
			_deleteQue = new Array()
			_timer = new Timer(_updateSpeed,0)
			_timer.addEventListener(TimerEvent.TIMER,handle,false,0,true)
		}
		
		// adds a IUpdateable to the stack - aka a message, a statemachine, anything
		public function addToStack(aUpdateable:IUpdateable, aPriority:uint = 1):void{
			output("Adding aUpdateable to stack: " + aUpdateable)
			_stack.push(aUpdateable)
			
		}
		
		// does exactly that - removes brother
		public function removeFromStack(aUpdateable:IUpdateable, forceRemoval:Boolean = false):void{
			var u:uint = _stack.indexOf(aUpdateable)
			if(u > -1)
			{
				if(!forceRemoval){
					_deleteQue.push(_stack[u])
				}else{
					IUpdateable(_stack[u]).exit()
					_stack.splice(u,1)
				}
			}
		}
		
		// use this to intialize all items in the stack and start the timer
		public function start():void
		{
			output("Starting")
			var p:int = _stack.length - 1
			for(p; p>=0; p--){
				IUpdateable(_stack[p]).enter()
			}
			output("Start Successful")
			
			//Arvind - 05/27/09
			//To fasten the time within which the
			//avatar gets displayed when entering a zone. 
			handle();
			
			_timer.reset()
			_timer.start()
		}
		
		// use this to exit all items in the stack and stop the timer
		public function stop():void
		{
			output("Stopping")
			var p:int = _stack.length - 1
			
			for(p; p>=0; p--){
				IUpdateable(_stack[p]).exit()
			}
			
			_timer.stop()
			
			output("Stop Successful")
		}
		
		public function handle(e:TimerEvent = null):void{
			if(e != null) {
				var _timeTaken:uint = getTimer();
			}
			var p:int = _stack.length - 1;
			
			for(p; p>=0; p--){
				IUpdateable(_stack[p]).execute(_gameSteps);
			}
			
			flushDeleteQue();
			
			_gameSteps++;
			
			if(e != null) {
				_lastExecutionTime = getTimer() - _timeTaken;
				
				if(_outputExecutionTime){
					output("? Time: " + _lastExecutionTime);
				}
			}
		}
		
		// moves a updateable in the stack incase of priority
		public function moveUpdateableInStack(aUpdateable:IUpdateable, index:uint):void
		{
			output("Moving a IUpdateable")
			_stack.splice(_stack.indexOf(aUpdateable),1)
			_stack[index] = aUpdateable
		}
		
		// gets rid of all the things in the delete que
		public function flushDeleteQue():void{
			var p:int = _deleteQue ? (_deleteQue.length - 1) : 0;
			var y:int;
			
			var tmpUpdateable:IUpdateable;
			
			for(p; p>=0; p--){
				tmpUpdateable = _deleteQue[p] as IUpdateable;
				if (!tmpUpdateable)
				{
					continue;
				}
				tmpUpdateable.exit();
				_deleteQue.splice(p,1)
				y = _stack ? _stack.indexOf(tmpUpdateable) : -1;
				if(y > -1){
					_stack.splice(y,1)
				}
			}
		}
		
		// pauses/unpauses the timer without calling the exit of the state
		public function pause(aBool:Boolean):void
		{
			output("pausing: " + aBool)
			if(aBool){
				_timer.start()
			}else{
				_timer.stop()
			}
		}
		
		// IExecutingTimer functions
		public function get lastExecutionTime():uint{
			return _lastExecutionTime
		}
		
		public function set outputExecutionTime(aBool:Boolean):void{
			_outputExecutionTime = aBool
		}
		
	}
}