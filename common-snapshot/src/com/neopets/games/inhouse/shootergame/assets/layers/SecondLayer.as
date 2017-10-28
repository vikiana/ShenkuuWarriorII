package com.neopets.games.inhouse.shootergame.assets.layers
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.ShooterGame;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractProp;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	import com.neopets.games.inhouse.shootergame.assets.targets.FlipUpTarget;
	import com.neopets.games.inhouse.shootergame.assets.targets.RunningTarget;
	import com.neopets.games.inhouse.shootergame.utils.ArrayUtils;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;


	/**
	 *	This layer is between the first layer and the background.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.19.2009
	 */
	public class SecondLayer extends AbstractLayer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const POINT_VALUE:Number = 5;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _fixed:MovieClip;
		
		/**
	 	*	Constructor
	 	* 
	 	* @param ld LayerDefiniiton
	 	* @param sl SharedListener 
	 	* @param lc layer container
	 	*
		*
	 	*/
		public function SecondLayer()
		{
			super();
		}
		
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		override public function cleanUp (e:CustomEvent=null):void {
			if (!_stageIsCleared){
				clearStage(4);
			}
			
			removeCommonEventListeners();
			removeEventListeners();
			
			if (_elementsArray){
				_elementsArray = null;
			}
			
			if (_positions){
				_positions = null;
			}
			
			if (_timer){
				removeTimer();
			}

			_fixed = null;
			
			cleanUpCommonElements ();

		}
			
		override public function createTimer (stageNo:Number=0):void {
			var randomTimeLapse:Number = Mathematic.randRange(2, 4);
			_timer = new Timer (1000, randomTimeLapse);
			_timer.addEventListener (TimerEvent.TIMER_COMPLETE, issueTarget);
			_timer.start();
		}
		
		
		override public function scroll():void {
			trace ("Warning: scrolling on second layer doesn't happen. Set 'moving' to false;");
		}

		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------	
		
		override protected function initialize():void {
			//INIT FLAGS
			found = false;
			moving = false;
			//_doIssue = true;
			//INIT ARRAY
			_elementsArray = [];
			//CREATE FIXED TARGETS CONTAINER
			if (!_fixed){
				_fixed = new MovieClip();
				_fixed.x = - ShooterGame.STAGE_WIDTH/2+50;
				_fixed.y = - ShooterGame.STAGE_HEIGHT/2;
				addChild (_fixed);
			}
			//CREATE PROP IN FRONT OF TARGETS
			//we might want to build a different prop for every stage. This will need to have a var in XML to define the class for it AND add cleaning code for old prop 
			if (!_prop){
				var pr:Class = LibraryLoader.getLibrarySymbol("Seconlayer_prop");
				_prop = new pr();
				_prop.x = - ShooterGame.STAGE_WIDTH/2;
				_prop.y = - ShooterGame.STAGE_HEIGHT/2+100;
				_elementsArray.push (_prop);
				addChild (_prop);
			}
			//FIXED TARGETS POSITIONS
			if (!_positions){
				_positions = [{x:66, y:396, taken:false, index:1}, {x:183, y:416, taken:false, index:2}, {x:302, y:438, taken:false, index:3}, {x:523, y:416, taken:false, index:4}];
			}
			//EVENT LISTENERS
			_sl.addEventListener(SharedListener.LOAD_STAGE, initialize2);
			_sl.addEventListener(SharedListener.COLLIDE2, addBullet);
			if (!_sl.hasEventListener(SharedListener.SEND_BOSS)){
				_sl.addEventListener  (SharedListener.SEND_BOSS, sendBoss);
			}
		}
		
		override protected function removeTimer():void{
			if (_timer){
				_timer.stop();
				_timer.removeEventListener (TimerEvent.TIMER_COMPLETE, issueTarget);
				_timer= null;
			}
		}
		
		override protected function removeProp(p:MovieClip=null):void {
			if (_prop.parent){
				_prop.parent.removeChild(_prop);
			}
		 	_prop = null;
		}
		
		override protected function clearStage(stageNo:Number=0):void {
		 	//cleanup remaining targets
		 	var aL:Number = _elementsArray.length;
		 	for (var i:Number = aL; i>=0; i--){
		 		var item:MovieClip = _elementsArray[i];
		 		if (item != null && item is AbstractTarget){
		 		//trace (this+": clearing array"+_elementsArray[i]+", length: "+_elementsArray.length+", i:"+i);
		 			_elementsArray.splice (i, 1);
		 			Tweener.removeTweens(item);
		 			if (_fixed.contains (item)){
		 				_fixed.removeChild(item);
		 			} 
		 			if (contains (item)){
		 				removeChild (item);
		 			}
		 			item = null;
		 		}
		 		/*if (item is FlipUpTarget){
		 			(item as FlipUpTarget).popDown(true);
		 			(item as FlipUpTarget).popped = true;
		 		} else if (item is FallingTarget){
		 			(item as FallingTarget).fall();
		 		} */
		 	}
		 	
		 	if (_positions){
		 		for (i=0; i<_positions.length; i++){
		 			_positions[i].taken = false;
		 		}
		 	}
		 	
		 	if (stageNo==4){
		 		if (_prop){
		 			removeProp();
		 		//Tweener.addTween (_prop, {y:500, time:2, delay:1, transition:"linear", onComplete:removeProp});
		 		}
		 	}
		 	_stageIsCleared = true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		override protected function issueTarget(e:TimerEvent):void {
			if (_doIssue){
				//CREATE TARGETS RANDOMLY
				var random:Number;
				var arr:Array;
				var container:MovieClip;
				var targClass:Class;
				var targ:MovieClip;
				//create target classes
				_btArray = createTargetsClasses(_ld.bottomtargets);
				arr = _btArray;
				container = _fixed;
				//random target class
				random = Mathematic.randRange (0, arr.length-1);
				targClass = arr[random];
				targ = new targClass();
				//ghost meepit
				if (targ is RunningTarget ){
					var left:Number = Mathematic.randRange(0, 1);
					var posX:Number;
					switch (left){
						case 1:
							//left
							posX  = 50;
							targ.scaleY = -1;
							targ.direction = 1;
						break;
						case 0:
							//right
							posX = ShooterGame.STAGE_WIDTH-50;
							targ.direction = -1;
						break;
					}
					targ.x = posX;
					targ.y = ShooterGame.STAGE_HEIGHT-50;
					targ.init (_sl, POINT_VALUE+10, this);
					targ.scaleX = 0.6;
					targ.scaleY = 0.6;
					container.addChild (targ);
					_elementsArray.push (targ);
					targ.startRunning ();
					if (_doIssue){
						createTimer();
					}
					return;
				} else {
				//POSITIONING the target on a random, non-taken, position from the array
				_positions = ArrayUtils.shuffle(_positions, 0, _positions.length-1);
				for (var i:Number =0; i<_positions.length; i++){
					if (!_positions[i].taken){
						var pos:Object = _positions[i];
						targ.x = pos.x;
						targ.y = pos.y;
						targ.posIndex = pos.index;
						pos.taken = true;
						//exit loop
						i = _positions.length;
					}	
				}
				//if position is available, finish to set up the target, otherwise delete istance;
				if (targ.posIndex == 0){
					targ = null;
					//a new timer will be created as soon as a position frees up.
				} else {
					targ.init (_sl, POINT_VALUE, this);
					targ.scaleX = 0.6;
					targ.scaleY = 0.6;
					targ.timeLapse = _ld.levelDef.targetFlipTime;
					//pop up flipUp targets
					if (targ is FlipUpTarget){
						targ.popUp();
						targ.popped = true;
					}
					container.addChild (targ);
					_elementsArray.push (targ);
					if (_doIssue){
						createTimer();
					}
				}
			}
			}
		}
		
		override protected function addBullet (e:CustomEvent):void {
			if (e.oData.T == this){
			var localP:Point = new Point (e.oData.X, e.oData.Y);
		     	var globalP:Point = localToGlobal(localP);
		     	var target:MovieClip;
		     	for (var i:int =0; i<_elementsArray.length; i++){
		     		if (_elementsArray[i] is AbstractTarget){
		     			target =_elementsArray[i];
		     			if (target.hitTestPoint (globalP.x, globalP.y, true)){
		     				var hitPoint:Point  = target.globalToLocal(globalP); 
		     				target.hitReaction(hitPoint);
		     				_hitSomething = true;
		     			}
		     		} else if (_elementsArray[i] is AbstractProp){
		     			target =_elementsArray[i];
		     			if (target.hitTestPoint (globalP.x, globalP.y, true)){
		     				_hitSomething = true;
		     			}
		     		}
		     	}
		     	if (!_hitSomething){
		     		var hitlayer:AbstractLayer;
		     		_sl.sendCustomEvent(SharedListener.COLLIDE_BOSS, {X:e.oData.X, Y:e.oData.Y, T:_lc}, false, true);
		     	}
		     	_hitSomething = false;
			 }
		 }
		 
		 override protected function sendBoss (e:CustomEvent):void {
			_sl.removeEventListener(SharedListener.SEND_BOSS, sendBoss);
			clearStage(e.oData.stageNo);
		}
	
		override protected function destroyTarget (e:CustomEvent):void {
			var t:AbstractTarget = e.oData.target;
			for (var i:int = 0; i< _elementsArray.length; i++){
				if (_elementsArray[i].name == t.name){
			 		var deleted:Array = _elementsArray.splice(i, 1);
			 		//stop checking
			 		i = _elementsArray.length;
				}
			}
			if (t is RunningTarget){
				//nuthin'
			} else {
				//free up position
				if (_doIssue){
					for (i=0; i<_positions.length; i++){		
						if (_positions[i].index == t.posIndex){
							_positions[i].taken = false;
						}
						if (!_timer){
							createTimer ();
						};
					}
				}
			}
		}
		
		override protected function stopTimers(e:CustomEvent):void {
			_doIssue = false;
			removeTimer();
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		private function removeEventListeners():void {
			//Specific layer listeners
			if (_sl.hasEventListener(SharedListener.LOAD_STAGE)){
				_sl.removeEventListener(SharedListener.LOAD_STAGE, initialize2);
			}
			if (_sl.hasEventListener(SharedListener.COLLIDE2)){
				_sl.removeEventListener(SharedListener.COLLIDE2, addBullet);			
			}
			if (!_sl.hasEventListener(SharedListener.SEND_BOSS)){
				_sl.removeEventListener  (SharedListener.SEND_BOSS, sendBoss);
			}
			
		}
		
		
		private function initialize2(e:CustomEvent):void {
				//INIT FLAGS
			found = false;
			moving = false;
			//_doIssue = true;
			//INIT ARRAY
			_elementsArray = [];
		}
		
	}
}