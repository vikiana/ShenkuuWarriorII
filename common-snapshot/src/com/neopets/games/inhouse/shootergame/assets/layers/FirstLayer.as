package com.neopets.games.inhouse.shootergame.assets.layers
{
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.ShooterGame;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractProp;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	import com.neopets.games.inhouse.shootergame.assets.targets.FlipUpTarget;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import caurina.transitions.Tweener;

	/**
	 *	This is the first layer toward the player. It has scrolling targets on top and bottom and planks to cover mechanisms.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.19.2009
	 */

	public class FirstLayer extends AbstractLayer
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private static const POINT_VALUE:Number = 3;
		private static const POINT_VALUE_TOP:Number = 4;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		//targets containers
		private var _scrollingBottom:MovieClip;
		private var _scrollingTop:MovieClip;	
		//flags
		private var bossSent:Boolean;
		private var stageEnd:Boolean;
		private var targFinished:Boolean;
		//NO MIDSTAGE OVERLAY VERSION ----to revert, make this private ------------------------------
		public var _stageNo:Number = 1;
		//---------------------------------------------------------------------------------------------

		/**
	 	*	Constructor
	 	*/
		public function FirstLayer()
		{
			super();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function cleanUp (e:CustomEvent=null):void {
			moving = false;
			
			if (!_stageIsCleared){
				clearStage(4);
			}
			
			removeCommonEventListeners();
			
			if (_sl.hasEventListener(SharedListener.COLLIDE1)){
				_sl.removeEventListener(SharedListener.COLLIDE1, addBullet);
			}
			
			if (_sl.hasEventListener(SharedListener.LOAD_STAGE)){
				_sl.removeEventListener(SharedListener.LOAD_STAGE, initialize2);
			}
			
			if (_timer){
				removeTimer();
			}
			
			if (_elementsArray){
				_elementsArray = null;
			}
			
			_scrollingTop = null;
			
			_scrollingBottom = null;
			
			cleanUpCommonElements ();
		}
		
		
		
		override public function scroll():void {
			if (moving){
				for (var i:int = 0; i< _elementsArray.length; i++){
					if ( _elementsArray[i] is AbstractTarget){
						var item:AbstractTarget = _elementsArray[i];
						//SCROLLING BOTTOM
						if (item.parent == _scrollingBottom){
							item.x -= _scrollSpeed;
							if (!item.destroyed){
								//target is not 'hittable' right before exiting the screen
								if (item.x <= -ShooterGame.STAGE_WIDTH && item.x > -ShooterGame.STAGE_WIDTH-item.width){
									item.active = false;
								} else if (item.x <= -ShooterGame.STAGE_WIDTH-item.width){ 
									//target is out of screen
									item.destroy ();
								}
							}
							if (item is FlipUpTarget){
								//poupup the target when it gets to the window
								if (item.x < -item.width && !(item as FlipUpTarget).popped){
									(item as FlipUpTarget).popUp();
									(item as FlipUpTarget).popped = true;
								}
							}
						//SCROLLING TOP
						} else if (item.parent == _scrollingTop) {
							item.x += _scrollSpeed;
							if (!item.destroyed){
								if (item.x >= ShooterGame.STAGE_WIDTH && item.x < ShooterGame.STAGE_WIDTH+item.width){
									item.active = false;
								} else if (item.x >= ShooterGame.STAGE_WIDTH+item.width){ 
									item.destroy ();
								}
							}
							if (item is FlipUpTarget){
								//poupup the target when it gets to the window
								if (item.x > item.width && !(item as FlipUpTarget).popped){
									(item as FlipUpTarget).popUp();
									(item as FlipUpTarget).popped = true;
								}
							}
						}
					}
				}
			}
		}
		
		
		override public function createTimer (stage:Number=0):void {
			var randomTimeLapse:Number;
			//Targets come quicker on second and third stage
			switch (stage){
				case 1:
				 	randomTimeLapse = Mathematic.randRange(2, 4);
				break;
				case 2:
					randomTimeLapse = Mathematic.randRange(1, 3);
				break;
				case 3:
					randomTimeLapse = Mathematic.randRange(1, 2);
				break;
				default:
					randomTimeLapse = Mathematic.randRange(1, 3);
			}
			_timer = new Timer (randomTimeLapse*1000, _ld.levelDef.totTargets);
			_timer.addEventListener (TimerEvent.TIMER, issueTarget);
			_timer.addEventListener (TimerEvent.TIMER_COMPLETE, targetsFinished);
			_timer.start();
		}
		
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		
		override protected function initialize():void {
			found = false;
			moving = true;
			bossSent= false;
			targFinished = false;
			stageEnd = false;
			//_doIssue = true;
			//INIT ARRAY
			_elementsArray = [];
			if (!_scrollingBottom){
				//CREATE SCROLLING TARGETS CONTAINER
				var scrolling:Class = LibraryLoader.getLibrarySymbol("scrolling_01") ;
				//bottom scrolling container
				_scrollingBottom = new scrolling();
				_scrollingBottom.x = ShooterGame.STAGE_WIDTH/2;
				_scrollingBottom.y = ShooterGame.STAGE_HEIGHT/2-40;
				addChild (_scrollingBottom);
			}
			if (!_scrollingTop){
				//top scrolling container
				_scrollingTop = new scrolling();
				_scrollingTop.x = - ShooterGame.STAGE_WIDTH/2;
				_scrollingTop.y = - ShooterGame.STAGE_HEIGHT/2+150;
				addChild (_scrollingTop);
				//planks, top and bottom
				var plank:Class = LibraryLoader.getLibrarySymbol("woodenplank") ;
				plank1 = new plank();
				plank1.y = ShooterGame.STAGE_HEIGHT/2;
				plank2 = new plank ();
				plank3 = new plank ();
				plank4 = new plank ();
				plank2.height = plank1.height = plank3.height = plank4.height = 25;
				plank2.y = plank1.y-plank1.height;
				plank3.y = -ShooterGame.STAGE_HEIGHT/2 + plank3.height*2;
				plank4.y = plank3.y+plank3.height;
				plank2.cacheAsBitmap = plank1.cacheAsBitmap = plank3.cacheAsBitmap = plank4.cacheAsBitmap = true;
				addChild (plank1);
				addChild (plank2);
				addChild (plank3);
				addChild (plank4);
			}
			_elementsArray = [plank1, plank2, plank3, plank4];
			//event listeners
			_sl.addEventListener(SharedListener.LOAD_STAGE, initialize2);
			_sl.addEventListener(SharedListener.COLLIDE1, addBullet);
		}
		
		
		override protected function removeTimer ():void {
			if (_timer){
				_timer.removeEventListener (TimerEvent.TIMER, issueTarget);
				_timer.removeEventListener (TimerEvent.TIMER_COMPLETE, targetsFinished);
				_timer.stop();
				_timer = null;
			}
		}
		
		override protected function clearStage(stageNo:Number=0):void {
			_stageNo = stageNo;
		 	//cleanup remaining targets and props
		 	var aL:Number = _elementsArray.length;
		 	for (var i:Number = aL; i>=0; i--){
		 		var item:MovieClip = _elementsArray[i];
		 		_elementsArray.splice (i, 1);
		 		//This code was added for a smoother transition of removing targets. 
		 		//However they create a problem when calling onComplete functions.
		 		/*if (item is FlipUpTarget){
		 			(item as FlipUpTarget).popDown(true);
		 			(item as FlipUpTarget).popped = true;
		 		} else if (item is FallingTarget){
		 			(item as FallingTarget).fall();
		 		} */
		 		if (item != null && item is AbstractTarget){
		 			Tweener.removeTweens(item);
		 			item.parent.removeChild(item);
		 			item = null;
		 		}
		 	}
		 	//remove planks (only when boss comes)
		 	if (stageNo==4){
		 		removeProp (plank1);
		 		removeProp (plank2);
		 		removeProp (plank3);
		 		removeProp (plank4);
		 		//These are for smoother transitions, and they have the same problem of targets of calling onComplete functions when they already don't exhist anymore.
		 		/*Tweener.addTween (this.plank1, {y:350, time:2,delay:0, transition:"linear", onComplete:removeProp, onCompleteParams:[plank1]});
		 		Tweener.addTween (this.plank2, {y:350, time:2, delay:0, transition:"linear", onComplete:removeProp, onCompleteParams:[plank2]});
		 		Tweener.addTween (this.plank3, {y:-350, time:2,delay:0, transition:"linear", onComplete:removeProp, onCompleteParams:[plank3]});
		 		Tweener.addTween (this.plank4, {y:-350, time:2, delay:0, transition:"linear", onComplete:removeProp, onCompleteParams:[plank4]});*/
		 	}
		 	_stageIsCleared = true;
		}
		
		override protected function removeProp (prop:MovieClip=null):void {
			if (prop){
				removeChild (prop);
			switch (prop){
				case plank1:
					plank1 = null;
				break;
				case plank2:
					plank2 = null;
				break;
				case plank3:
					plank3 = null;
				break;
				case plank4:
					plank4 = null;
				break;
			}
			}
		}
		

		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		override protected function issueTarget (e:TimerEvent):void {
			if (_doIssue){
				//CREATE TARGETS RANDOMLY
				var random:Number;
				var arr:Array;
				var container:MovieClip;
				var targClass:Class;
				var targ:MovieClip;
				//CREATE TARGETS CLASSES
				_btArray = createTargetsClasses(_ld.bottomtargets);
				_ttArray = createTargetsClasses(_ld.toptargets);
				//CHOOSE A RANDOM TYPE OF TARGET (bottom or top)
				random = Mathematic.randRange (1, 2);
				var pValue:Number;
				switch(random){
					case 1:
						arr = _btArray;
						pValue = POINT_VALUE
						container = _scrollingBottom;
					break;
					case 2:
						arr = _ttArray;
						pValue = POINT_VALUE_TOP;
						container = _scrollingTop;
					break;
				}
				//IN THE CHOSEN TARGET TYPE, CHOOSE A RANDOM TARGET CLASS
				random = Mathematic.randRange (0, arr.length-1);
				targClass = arr[random];
				targ = new targClass();
				targ.timeLapse = _ld.levelDef.targetFlipTime;
				targ.init (_sl, pValue, this);
				container.addChild (targ);
				_elementsArray.push (targ);
			}
		}
		
		
		override protected function addBullet (e:CustomEvent):void {
			//check all elements in this layer for collision
			if (e.oData.T == this){
				var localP:Point = new Point (e.oData.X, e.oData.Y);
		     	var globalP:Point = localToGlobal(localP);
		     	var target:MovieClip;
		     	for (var i:int =0; i<_elementsArray.length; i++){
		     		if (_elementsArray[i] is AbstractTarget){
		     			target =_elementsArray[i];
		     			if (target.hitTestPoint (globalP.x, globalP.y, true)){
		     				target.hitReaction();
		     				_hitSomething = true;
		     			}
		     		} else if (_elementsArray[i] is AbstractProp){
		     			target =_elementsArray[i];
		     			if (target.hitTestPoint (globalP.x, globalP.y, true)){
		     				_hitSomething = true;
		     				//NO REACTION
		     			}
		     		}
		     	}
		     	//If nothing was hit, check layer behind. 
		     	if (!_hitSomething){
		     		var hitlayer:AbstractLayer;
		     		for (i  =0; i<_lc.numChildren; i++){
						if (_lc.getChildAt(i).name == "Second"){
							hitlayer = _lc.getChildAt(i) as AbstractLayer;
						}
					}
		     		_sl.sendCustomEvent(SharedListener.COLLIDE2, {X:e.oData.X, Y:e.oData.Y, T:hitlayer}, false, true);
		     	}
		     	//reset
		     	_hitSomething = false;
		 	}
		 }
		 
		 
		 override protected function targetsFinished (e:TimerEvent):void {
		 	_sl.sendCustomEvent(SharedListener.STOP_TIMERS, null, false, true);
		 	targFinished = true;
		 	//Between end of issuing targets and last target getting out of screen or beig hit, the boss warning appears
		 	if (_stageNo>=3){
				_sl.sendCustomEvent (SharedListener.WARN_BOSS, {levelNo:1, type:"WarningOverlay", message:"IDS_WARN_BOSS"}, false, true);
		  	}
		}
		

		override protected function destroyTarget (e:CustomEvent):void {
			var t:AbstractTarget = e.oData.target;
			for (var i:int = 0; i< _elementsArray.length; i++){
				if (_elementsArray[i].name == t.name){
			 		_elementsArray.splice(i, 1);
			 		i = _elementsArray.length;
				}
			}
			//CHECK IF ALL TARGETS ARE GONE, MOVE TO NEXT STAGE
			//4 are the planks
			trace ("_elementsArray", _elementsArray);
			if (_elementsArray.length <=4 && !stageEnd && targFinished){
				//TESTING======================================================================
				forceClearStage();
				//==============================================================================
				_sl.sendCustomEvent(SharedListener.INIT_STAGE_END, null, false, true);
				//this flag is to make sure this method is invoked one time only.
				stageEnd = true;
				return;
			}
			
		}
		
	
		
		override protected function stopTimers(e:CustomEvent):void {
			//stop targets timer
			_doIssue = false;
			removeTimer();
		}

		
		override protected function sendBoss (e:CustomEvent):void {
			_sl.removeEventListener(SharedListener.SEND_BOSS, sendBoss);
			clearStage(e.oData.stageNo);
		}
		

		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		//Called from stage 2 on.
		private function initialize2(e:CustomEvent):void {
			found = false;
			moving = true;
			bossSent= false;
			targFinished = false;
			stageEnd = false;
			//_doIssue = true;
			//PLANKS DON'T GET REMOVED FROM THE PARENT CONTAINER UNTIL THE LAST STAGE, BUT THEY GET REMOVED FROM THE _ELEMENTSARRAY.
			//SO EVEN THOU I DON'T BUILD THEM AGAIN IN STAGE2 AND UP, I DO ADD THEM BACK TO THE ARRAY
			_elementsArray = [plank1, plank2, plank3, plank4];
		}
		
		//TESTING ========================================================================================
		//this is added only for testing, so I can clear the targets before invoking force skip stage
		private function forceClearStage():void {
			_doIssue = false;
		 	//cleanup remaining targets
		 	var aL:Number = _elementsArray.length-4;
		 	for (var i:Number = aL; i>=0; i--){
		 		var item:MovieClip = _elementsArray[i];
		 		if (item != null && item is AbstractTarget){
		 		//trace (this+": clearing array"+_elementsArray[i]+", length: "+_elementsArray.length+", i:"+i);
		 			_elementsArray.splice (i, 1);
		 			Tweener.removeTweens(item);
		 			if (_scrollingBottom.contains (item)){
		 				_scrollingBottom.removeChild(item);
		 			} 
		 			if (_scrollingTop.contains (item)){
		 				_scrollingTop.removeChild(item);
		 			} 
		 			if (contains (item)){
		 				removeChild (item);
		 			}
		 			item = null;
		 		}
		 	}
		 	_sl.sendCustomEvent(SharedListener.STOP_TIMERS, null, false, true);
		 	targFinished = true;
		}
		//======================================================================================================================
	}
}