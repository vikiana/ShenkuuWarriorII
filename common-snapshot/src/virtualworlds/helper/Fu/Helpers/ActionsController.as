package virtualworlds.helper.Fu.Helpers
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import virtualworlds.helper.Fu.BaseClasses.Action;
	import virtualworlds.helper.Fu.BaseClasses.UpdateableClass;
	
	
	public class ActionsController extends UpdateableClass implements IExecutingController
	{
		
		private var _actionsDictionary:Dictionary = new Dictionary()
		
		// the about of time it took for the last execution
		private var _lastExecutionTime:uint
		// a booleaon to trace whether or not this will trace updae time
		private var _outputExecutionTime:Boolean
		
		public function ActionsController()
		{
			output("New ActionsController")
		}
		
		public function add(aAction:Action, removeInGroup:Boolean = false):void{
			output("Adding: " + aAction)
			
			if(removeInGroup){
				removeAllSimilar(aAction)
			}
			
			_actionsDictionary[aAction] = aAction
			aAction.controller = this
			aAction.enter()
		}
		
		public function remove(aAction:Action):void{
			output("Removing: " + aAction)
			if(_actionsDictionary[aAction]){
				Action(_actionsDictionary[aAction]).exit()
				delete _actionsDictionary[aAction]
			}
		}
		
		public function removeAllActions():void{
			output("Removing all actions")
			for each(var prop:Action in _actionsDictionary) {	
				remove(_actionsDictionary[prop])
			}
			
		}
		
		public function removeAllSimilar(aAction:Action):void {
			for each(var prop:Action in _actionsDictionary) {	
				if(Action(_actionsDictionary[aAction]).removeActionCopies(_actionsDictionary[prop])) {
					output("Removing similar action: " + prop);
					remove(_actionsDictionary[prop]);
				}
			}
		}
		
		public function removeAllOfType(actionCls:Class):void {
			for each(var prop:Action in _actionsDictionary) {
				if ( Action(_actionsDictionary[prop]) is actionCls ) {
					output("Removing actions of type: " + actionCls);
					remove(_actionsDictionary[prop]);
				}
			}
		}
		
		public override function execute(aStep:uint=0):void{
			var _timeTaken:uint = getTimer()
			for each(var prop:Action in _actionsDictionary){
				Action(_actionsDictionary[prop]).execute(aStep)
			}
			_lastExecutionTime = getTimer() - _timeTaken
			if(_outputExecutionTime){
				output("∆ Time: " + _lastExecutionTime)
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