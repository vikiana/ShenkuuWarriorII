package com.neopets.games.inhouse.shootergame.abstract
{
	import com.neopets.games.inhouse.shootergame.LayerDefinition;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.games.inhouse.shootergame.LayerContainer;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 *	This the abstract layer class. It contains some standard functionality common to all layers 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.19.2009
	 */
	public class AbstractLayer extends MovieClip
	{

		//--------------------------------------
		//  PUBLIC AND PROTECTED VARIABLES
		//--------------------------------------
		
		protected var _ld:LayerDefinition;
		protected var _sl:SharedListener;
		protected var _lc:MovieClip;	
		//timer for issuing targets
		protected var _timer:Timer;
		//Array of targets classes. Bottom and Top.
		protected var _btArray:Array;
		protected var _ttArray:Array;
		//Targets and positions arrays
		protected var _elementsArray:Array;
		protected var _positions:Array;
		//
		protected var _scrollSpeed:Number;
		//flags
		protected var _hitSomething:Boolean;
		protected var _isActive:Boolean;
		protected var _doIssue:Boolean = true;
		protected var _stageIsCleared:Boolean;
		public var found:Boolean;
		public var moving:Boolean;
		public var ready:Boolean;
		//PROPS
		//First Layer planks
		protected var plank1:MovieClip;
		protected var plank2:MovieClip;
		protected var plank3:MovieClip;
		protected var plank4:MovieClip;
		//Second Layer prop
		protected var _prop:MovieClip;
		

		/**
	 	*	Constructor
	 	*
		*
	 	*/
		public function AbstractLayer ():void {
		
		}
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/**
	 	*	Initialization common to all layers. Layers initialize at the beginning of every stage and every level.
	 	* 
	 	* @param ld  LayerDefiniiton
	 	* @param sl  SharedListener 
	 	* @param lc Layer Container
	 	*
		*
	 	*/
		public function init (ld:LayerDefinition, sl:SharedListener, lc:MovieClip):void {
			//references
			_ld = ld;
			_sl = sl;
			_lc = lc;
			//flags
			_isActive = true;
			_hitSomething = false;
			_stageIsCleared = false;
			ready = false;
			//vars
			trace ("INITIALIZING LAYER", this);
			_scrollSpeed = _ld.levelDef.speed;
			//event listeners
			_sl.addEventListener(SharedListener.DESTROY_TARGET, destroyTarget);
			_sl.addEventListener(SharedListener.STAGE_END, endStage);
			_sl.addEventListener(SharedListener.STOP_TIMERS, stopTimers);
			_sl.addEventListener(SharedListener.SEND_BOSS, sendBoss);
			//Initialization specific to every layer
			initialize();
		}
		
		//These two methods are both called from LayersManager and trigger the layers to start issuing and animating targets.
		public function createTimer (stageNo:Number=0):void { 
			//trace ("Abstract: implement createTimer on "+this);
		} 
		
		public function scroll():void {
			//trace ("Abstract: override 'scroll' in "+this);
		}
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		
		protected function cleanUpCommonElements ():void {
			if (this is LayerContainer){
				//nothing. How do I negate 'is'?
			} else {
				_ld.cleanUp();
				_ld = null;
			}
			_sl = null;
			_lc = null;
		};
		
		protected function initialize ():void {
			trace ("Abstract Layer - TODO: implement 'initialize()' on"+this);
		}
		
		//The classes created below will be used rendomly to create targets.
		protected function createTargetsClasses (namesArray:Array):Array {
			var tA:Array = [];
			if (namesArray){
				for (var i:int =0; i<namesArray.length; i++){
					var symbol:Class = LibraryLoader.getLibrarySymbol(namesArray[i]);
		 			tA.push (symbol);
				}
			}
			return tA;
		}
		
		
		//Srolling elements are fixed and not reactive to being hit. However, they do stop the bullet flight, so they exhist in the same _elementsArray;
		//In this version of the game this method is only used in the Background layer to create backgrounds.
		protected function createScrollingElements(stringsArray:Array, initY:Number, initX:Number):Array {
			var _scrElm:Array = [];
			for (var i:int=0; i<stringsArray.length; i++){
				var cl:Class = LibraryLoader.getLibrarySymbol(stringsArray[i]);
				_scrElm.push (new cl());
			}
			for (var j:Number =0; j< _scrElm.length; j++){
				_scrElm[j].y  = initY;
				if (j>0){
					_scrElm[j].x  = _scrElm[j-1].x+_scrElm[j-1].width;
				} else if (j==0) {
					_scrElm[j].x = initX;
				}
				addChild (_scrElm[j]);
			}
			return _scrElm;
		}
		
		protected function issueTarget(e:TimerEvent):void {
			//trace ("Called from Abstract: please implement 'issueTarget' on "+this);
		}

		protected function removeTimer ():void {
			//trace ("Abstract: called removeTimer on "+this);
		}
		
		protected function removeProp (p:MovieClip=null):void {
		 	//trace ("Abstract: called removeProp on "+this);
		}
		
		protected function removeCommonEventListeners():void {
			if (_sl.hasEventListener(SharedListener.DESTROY_TARGET)){
				_sl.removeEventListener(SharedListener.DESTROY_TARGET, destroyTarget);
			}
			if (_sl.hasEventListener(SharedListener.STAGE_END)){
				_sl.removeEventListener(SharedListener.STAGE_END, endStage);
			}
			if (_sl.hasEventListener(SharedListener.STOP_TIMERS)){
				_sl.addEventListener(SharedListener.STOP_TIMERS, stopTimers);
			}
			if (_sl.hasEventListener(SharedListener.SEND_BOSS)){
				_sl.removeEventListener(SharedListener.SEND_BOSS, sendBoss);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function endStage(e:CustomEvent):void{
			clearStage(e.oData.stageNo);
		}
		
		public function cleanUp (e:CustomEvent=null):void {
			//trace ("Abstract: implement cleanUp on "+this);
		};
	
		//Override this to adapt to the specific layer. COLLISION event handler for all layers.
		protected function addBullet (e:CustomEvent):void {
			//trace ("Abstract: implement addBullet on "+this);  	
		 }
		  
		protected function targetsFinished (e:TimerEvent):void {
			//trace ("Abstract. Implement targetsFinished on "+this);
		}
		
		protected function stopTimers(e:CustomEvent):void {
			//trace ("Abstract. Implement stopTimers on "+this);
		}
		
		protected function sendBoss (e:CustomEvent):void {
			//trace ("Abstract: sendBoss on "+this);
		}
		
		protected function clearStage(stageNo:Number=0):void {
		 	//trace ("Abstract: called clearStage on "+this);
		}
		 
		protected function destroyTarget (e:CustomEvent):void {
			//trace ("Abstract:override destroyTarget on "+this);
		}	
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get isActive ():Boolean {
			return _isActive;
		}
		
		public function set isActive (value:Boolean):void {
			_isActive = value;
		}
		
		public function get ld ():Object {
			return _ld;
		}
		
		public function get ttArray ():Array {
			return _ttArray;
		}
		
		public function get btArray ():Array {
			return _btArray;
		}
		
		public function get doIssue ():Boolean {
			return _doIssue;
		}
		public function set doIssue (value:Boolean):void {
			_doIssue = value;
		}
	}	
}