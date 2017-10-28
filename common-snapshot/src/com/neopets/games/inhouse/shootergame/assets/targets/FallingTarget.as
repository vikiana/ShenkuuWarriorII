package com.neopets.games.inhouse.shootergame.assets.targets
{
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	import caurina.transitions.Tweener;
	
	import flash.geom.Point;
	
	/**
	 *	Falling Targets Class
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.29.2009
	 */
	public class FallingTarget extends AbstractTarget
	{
			
		/**
		* 
		* Constructor
		* 
		*/
		public function FallingTarget()
		{
			super();
			_active = true;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		override public function hitReaction (hitPoint:Point=null):void {
			if (_active && !_destroyed){
				_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"HitHard", loop:false}, false, true);
				if (rotation >-89){
					rotation -= 45;
					_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:2}, false, true);
				} else {
					fallAndDestroy();
					_sl.sendCustomEvent(SharedListener.ADD_SCORE, {value:_pointsValue}, false, true);
				}
			}
		}
		
		
		public function fall():void {
			Tweener.addTween (this, {y:500, time:1, transition:"easyInQuint", onComplete:removeFromParent});
		}
		
		
		//--------------------------------------------------------------------
		//	PRIVATE / PROTECTED METHODS
		//--------------------------------------------------------------------
		protected function fallAndDestroy():void {
			Tweener.addTween (this, {y:600, time:1, transition:"easyInCubic", onComplete:destroy});
		}
	}
}