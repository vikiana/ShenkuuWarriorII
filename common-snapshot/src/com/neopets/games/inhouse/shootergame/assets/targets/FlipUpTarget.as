package com.neopets.games.inhouse.shootergame.assets.targets
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 *	Targets that flip up and down.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.12.2009
	 */
	public class FlipUpTarget extends AbstractTarget
	{
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _popped:Boolean;
		protected var _timer:Timer;

		/**
	 	*	Constructor
	 	*/
	 	public function FlipUpTarget() 
		{
		
			super();
			rotationX = -120;
			_active = false;
			_popped = false;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		override public function hitReaction (hitPoint:Point=null):void {
			if (_active && !_destroyed){
				_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"LightMetal", loop:false}, false, true);
				rotationX -= 45;
				_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:2}, false, true);
				if (rotationX <-89){
					_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:_pointsValue}, false, true);
					destroy();
				}
			}
		}
		
		
		public function popUp ():void {
			Tweener.addTween (this, {rotationX:0, time:1, transition:"easeOutElastic", onComplete:targetPopped});
		}
		
		
		public function popDown (slowly:Boolean, destroyme:Boolean=true):void {
			var lapse:Number;
			if (slowly){
				lapse = 1;
			} else {
				lapse = 0.3;
			}
			if (destroyme){
				Tweener.addTween (this, {rotationX:-90, time:lapse, transition:"linear", onComplete:destroy});
			} else {
				Tweener.addTween (this, {rotationX:-90, time:lapse, transition:"linear", onComplete:removeFromParent});
			}
		}
		
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		protected function targetPopped():void {
			Tweener.removeTweens(this, {rotationX:0, time:1, transition:"easeOutElastic"});
			createTimer ();
			_active = true;
		}
		
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		//timer to pop down the targets after a few seconds
		private function createTimer ():void {
			_timer = new Timer (1000, timeLapse);
			_timer.addEventListener (TimerEvent.TIMER_COMPLETE, popItDown);
			_timer.start();
		}
		
		private function removeTimer():void {
			if (_timer){
				_timer.removeEventListener (TimerEvent.TIMER_COMPLETE, popItDown);
				_timer.stop();
				_timer = null;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function popItDown(e:TimerEvent):void {
			popDown(false);
			removeTimer();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get popped():Boolean{
			return _popped;
		}
		
		public function set popped(value:Boolean):void{
			_popped = value;
		}
	}
}