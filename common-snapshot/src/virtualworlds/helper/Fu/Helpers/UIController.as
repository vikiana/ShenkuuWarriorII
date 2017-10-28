package virtualworlds.helper.Fu.Helpers
{
	import fl.transitions.TweenEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	import virtualworlds.helper.Fu.BaseClasses.IUIController;
	import virtualworlds.helper.Fu.BaseClasses.IUIDisplayObject;
	import virtualworlds.helper.Fu.BaseClasses.UIDisplayObject;
	import virtualworlds.helper.Fu.BaseClasses.UpdateableClass;
	import virtualworlds.helper.Fu.BaseEvents.UIEvent;
	import virtualworlds.helper.Fu.Helpers.UIControllerTransitions.BasicTransition;

	public class UIController extends UpdateableClass implements IExecutingController, IUIController
	{
		
		// this is used for multiple items that need to be shown @ the same time, like messages
		public static const INDIVIDUAL:String = "SINGLE"
		// this is used for single items like screens
		public static const MULTIPLE:String = "MULTI"
		
		public static const CLOSE_DISPLAY_OBJECT:String = "close object";
		
		// the type of the controller
		private var _type:String
		// the default transition for this controller
		private var _defaultTransition:BasicTransition
		// the owner off all the UI Display objects
		private var _owner:Sprite
		// dictionary of the UIObjects
		private var _currentUIObjects:Dictionary = new Dictionary(true);
		// a boolean of whether or not this UI Controller recieves mouse events
		private var _mouseEvents:Boolean = true
		// filter used internally to fade out messages when you call disable
        private static var _genericFilter:ColorMatrixFilter
        
        private var _lastExecutionTime:uint
		private var _outputExecutionTime:Boolean
        
		// constructor. . . geeze
		public function UIController(aType:String, aDefaultTransition:BasicTransition)
		{
			output("New UIController")
			_type = aType
			_defaultTransition = aDefaultTransition
			setupDefaultFilter()
		}
		
		public static function disableDisplayObject(aIO:InteractiveObject):void
		{
			aIO.mouseEnabled = false
			aIO.tabEnabled = false 
			aIO.filters = new Array(_genericFilter)
		}
		
		public static function enableDisplayObject(aIO:InteractiveObject):void
		{
			aIO.mouseEnabled = true
			aIO.tabEnabled = true 
			aIO.filters = new Array()
		}
		
		// default filter to fade out messages when you call disable()
		private function setupDefaultFilter():void
		{
			var matrix:Array = new Array();
			 matrix = matrix.concat([.75, 0, 0, 0, 0]); // red
       		 matrix = matrix.concat([0, .75, 0, 0, 0]); // green
       		 matrix = matrix.concat([0, 0, .75, 0, 0]); // blue
       		 matrix = matrix.concat([0, 0, 0, 1, 0]);  // alpha
        	_genericFilter = new ColorMatrixFilter(matrix)
		}
		
		// you must call this function to give the UI controller a place to attach and remove UIDisplayObjects
		public function setup(aDisplayObject:Sprite):void
		{
			output("Setting Owner: " + aDisplayObject)
			_owner = aDisplayObject
		}
		
		// call this function to set mouse events on all attached UI Objects
		public function set mouseEvents(aBool:Boolean):void
		{
			_mouseEvents = aBool
			if(aBool){
				_owner.mouseEnabled = true
				_owner.mouseChildren = true
			}else{
				_owner.mouseEnabled = false
				_owner.mouseChildren = false
			}
		}
		
		// returns the current state of the mouse events
		public function get mouseEvents():Boolean
		{
			return _mouseEvents
		}
		
		// use this function to disable all UIOjbects owned by this controller - like a message telling a screen to SHUT ITS FACE
		public function disableAll(applyFilter:Boolean, filterArray:Array = null):void
		{
			disableAllButThis(null, applyFilter, filterArray)
		}
		
		// disable all but a specific UIObject, such as a warning message coming over all other messages
		public function disableAllButThis(aUIDisplayObject:UIDisplayObject = null, applyFilter:Boolean = false, filterArray:Array = null):void
		{
			var filters:Array = new Array()
			for each(var prop:UIDisplayObject in _currentUIObjects){
				if(_currentUIObjects[prop] != aUIDisplayObject){
					_currentUIObjects[prop].mouseEnabled = false
					_currentUIObjects[prop].mouseChildren = false
					if(applyFilter && filterArray != null){
			            _currentUIObjects[prop].filters = filterArray
					}else{
						
			            filters.push(_genericFilter)
			            _currentUIObjects[prop].filters = filters
					}
				}
			}
		}
		
		// enable all ui objects owned by this object
		public function enabledAll():void
		{
			var filters:Array = new Array()
			for each(var prop:UIDisplayObject in _currentUIObjects){
				_currentUIObjects[prop].mouseEnabled = true
				_currentUIObjects[prop].mouseChildren = true
				_currentUIObjects[prop].filters = filters
			}
		}
		
		// use this to show a UI Display object, if its a single type - it will autmoatically kill all other open UI objects, if its multi, it will open a new one
		public function show(aUIDisplayObject:IUIDisplayObject, aTransition:BasicTransition = null):void
		{
			output("Showing: " + aUIDisplayObject) 
			if(!_owner){
				error("You must give this UIController a owner by calling setup!  The owner is a sprite to place UIObjects in!")	
			}
			
			var transition:BasicTransition = decideTransition(aTransition)
			switch(_type){
				case INDIVIDUAL:
					hideAll(transition)
					showUIObject(aUIDisplayObject, transition)
				break;
				case MULTIPLE:
					showUIObject(aUIDisplayObject, transition)	
				break;
			}
		}
		// send a specified displayObject to the top of the display list.
		public function sendToFront(aUIDisplayObject:IUIDisplayObject):void
		{
			if( _currentUIObjects[aUIDisplayObject]){
				var mc : DisplayObject = _currentUIObjects[aUIDisplayObject] as DisplayObject;
				mc.parent.setChildIndex(mc, mc.parent.numChildren-1);
			}
		}
		// hide a specific UI Display object
		public function hide (target:IUIDisplayObject, transition:Object = null):void
		{
			output("Hiding: " + target)
			var trans:BasicTransition = decideTransition(BasicTransition(transition))
			if (target && _owner && _owner.contains(DisplayObject(target)))
			{
				if(target.controller == this){
					hideUIObject(target, trans)
				}else{
					output("Warning! You tried to hide a object which this UIController's owner does not have")
				}
			}else{
				output("Warning! You tried to hide a object which this UIController's owner does not have")
			}
		}
		
		// hide all open UI Display objects
		public function hideAll(aTransition:BasicTransition = null):void
		{
			var aUIDisplayObject:UIDisplayObject
			var transition:BasicTransition = decideTransition(aTransition)
			for each(var prop:UIDisplayObject in _currentUIObjects){
				aUIDisplayObject = _currentUIObjects[prop]
				hideUIObject(aUIDisplayObject,transition) 	
			}
		}
		
		// interal function that runs the hiding on a UI Display object
		private function hideUIObject(aUIDisplayObject:IUIDisplayObject, aTransition:BasicTransition):void
		{
			aUIDisplayObject.deactivated()
			aUIDisplayObject.exit()
			if(aUIDisplayObject.activeTweenArray.length){
				aUIDisplayObject.activeTweenArray[aUIDisplayObject.activeTweenArray.length-1].removeEventListener(TweenEvent.MOTION_FINISH, tweenOutFinished)
				aUIDisplayObject.activeTweenArray[aUIDisplayObject.activeTweenArray.length-1].removeEventListener(TweenEvent.MOTION_FINISH, tweenInFinished)
			}
			aUIDisplayObject.activeTweenArray = new Array()
			aTransition.applyTweenOut(aUIDisplayObject)
			aUIDisplayObject.activeTweenArray[aUIDisplayObject.activeTweenArray.length-1].addEventListener(TweenEvent.MOTION_FINISH, tweenOutFinished, false, 0, true);
			
			var event:UIEvent = new UIEvent(UIEvent.DEACTIVATED, aUIDisplayObject)
			this.dispatchEvent(event)
		}
		
		// interal function that runs the showin' on a UI Display object
		private function showUIObject(aUIDisplayObject:IUIDisplayObject, aTransition:BasicTransition):void
		{
			if(!_owner.contains(aUIDisplayObject as DisplayObject)){
				_owner.addChild(aUIDisplayObject as DisplayObject)
			}
			if(aUIDisplayObject.controller == this || !aUIDisplayObject.controller){
				
				aUIDisplayObject.controller = this
				
				DisplayObjectContainer(aUIDisplayObject).mouseEnabled = true
				DisplayObjectContainer(aUIDisplayObject).mouseChildren = true
				
				_currentUIObjects[aUIDisplayObject] = aUIDisplayObject
				aUIDisplayObject.activated()
				aUIDisplayObject.enter()
				if(aUIDisplayObject.activeTweenArray.length){
					aUIDisplayObject.activeTweenArray[aUIDisplayObject.activeTweenArray.length-1].removeEventListener(TweenEvent.MOTION_FINISH, tweenOutFinished)
					aUIDisplayObject.activeTweenArray[aUIDisplayObject.activeTweenArray.length-1].removeEventListener(TweenEvent.MOTION_FINISH, tweenInFinished)
				}
				aUIDisplayObject.activeTweenArray = new Array()
				
				
				aTransition.applyTweenIn(aUIDisplayObject)
				
				
				aUIDisplayObject.activeTweenArray[aUIDisplayObject.activeTweenArray.length-1].addEventListener(TweenEvent.MOTION_FINISH, tweenInFinished, false, 0, true);
				
				var event:UIEvent = new UIEvent(UIEvent.ACTIVATED, aUIDisplayObject)
				this.dispatchEvent(event)
			
			}
		}
		
		// function to determine whether or not to use a passed in transition
		private function decideTransition(aTransition:BasicTransition = null):BasicTransition
		{
			var transition:BasicTransition
			if(aTransition){
				transition = aTransition
			}else if(_defaultTransition){
				transition = _defaultTransition
			}else{
				error("You did not pass in a transition neither did you specify a transition to animate this ui object - basically you are a junky, junky human being")
			}
			return transition
		}
		
		// listener function and event dispatcher - used so you can tell when any UI Display object has stuff done to it
		private function tweenInFinished(e:TweenEvent):void
		{
			var aUIDisplayObject:IUIDisplayObject = IUIDisplayObject(e.currentTarget.obj)
			aUIDisplayObject.animatedIn()

			var event:UIEvent = new UIEvent(UIEvent.ANIMATEDIN, aUIDisplayObject)
			this.dispatchEvent(event)
		}
		
		// listener function and event dispatcher - used so you can tell when any UI Display object has stuff done to it
		private function tweenOutFinished(e:TweenEvent):void
		{
			var aUIDisplayObject:IUIDisplayObject = IUIDisplayObject(e.currentTarget.obj)
			
			if(DisplayObject(aUIDisplayObject).parent && _owner == DisplayObject(aUIDisplayObject).parent)
			{
 				_owner.removeChild(DisplayObject(aUIDisplayObject));
			}
			
			var event:UIEvent = new UIEvent(UIEvent.ANIMATEDOUT, aUIDisplayObject)
			this.dispatchEvent(event)
			
			var filters:Array = new Array()
			DisplayObject(aUIDisplayObject).filters = filters;
			
			delete _currentUIObjects[aUIDisplayObject]
			
			aUIDisplayObject.animatedOut()
		}
		
		// update current objects in controller if you have the controller itself being updated. 
		public override function execute(aStep:uint=0):void
		{
			for each(var prop:UIDisplayObject in _currentUIObjects){
				_currentUIObjects[prop].execute(aStep)
			}
		} 
		
		public function get lastExecutionTime():uint{
			return _lastExecutionTime
		}
		
		public function set outputExecutionTime(aBool:Boolean):void{
			_outputExecutionTime = aBool
		}

	}
}