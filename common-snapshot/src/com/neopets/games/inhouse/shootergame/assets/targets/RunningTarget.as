package com.neopets.games.inhouse.shootergame.assets.targets
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	
	/**
	 *	Targets that run around.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.12.2009
	 */
	public class RunningTarget extends AbstractTarget
	{
		
		private var _timer:Timer;
		private var _popped:Boolean;
		
		public var direction:Number;
		
		public var body:MovieClip;
		
		
		/**
	 	*	Constructor
	 	*/
		public function RunningTarget()
		{
			super();
			_active = true;
			_popped = false;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		override public function hitReaction (hitPoint:Point=null):void {
			if (_active && !_destroyed){
				_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"HitHard", loop:false}, false, true);
				popDown();
				_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:_pointsValue}, false, true);
			}
		}
		
		
		public function popDown ():void {
			if (!_popped){
				Tweener.addTween (this, {rotationX:-90, time:0.2, transition:"easeOutCubic", onComplete:destroy});
				_popped = true;
			}
		}
		
		public function startRunning():void {
			Tweener.addTween(this.body, {x:600*direction, time:0.8, transition:"linear", onComplete:popDown});
			_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"meepit", loop:false}, false, true);
		}
		
		//--------------------------------------------------------------------
		//	PRIVATE / PROTECTED METHODS
		//--------------------------------------------------------------------
	
	}
}