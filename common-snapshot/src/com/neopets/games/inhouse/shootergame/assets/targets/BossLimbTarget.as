package com.neopets.games.inhouse.shootergame.assets.targets
{
	
	import flash.geom.Point;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import caurina.transitions.Tweener;
	
	
	/**
	 *	Targets that compose the boss.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.29.2009
	 */
	public class BossLimbTarget extends FallingTarget
	{
		
		//------------------------------------------
		// VARIABLES
		// -----------------------------------------
		
		public static var TOT_HITS:Number = 5;
		private var _hitCount:Number;
		
	
		/**
		* 
		* Constructor
		* 
		*/
		public function BossLimbTarget()
		{
			super();
			_hitCount = 0;
			_active = true;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		override public function hitReaction (hitPoint:Point=null):void {
			if (_active && !_destroyed){
				_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"HollowMetal", loop:false}, false, true);
				if (_hitCount < TOT_HITS){
					gotoAndPlay("hit");
					_hitCount ++;
					_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:2}, false, true);
				} else {
					rotateAndFall ();
					_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:_pointsValue}, false, true);
				}
			}
		}
		

		public function rotateAndFall ():void {
			Tweener.addTween (this, {y:500, rotation:90, time:0.5, transition:"easeINCubic", onComplete:destroy});
		}
	}
}