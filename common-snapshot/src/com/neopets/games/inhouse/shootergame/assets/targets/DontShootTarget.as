package com.neopets.games.inhouse.shootergame.assets.targets
{
	import flash.geom.Point;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	
	/**
	*	Targets that flip up and down but that you should not shoot.
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*	
	* 
	*	@author Viviana Baldarelli
	*	@since  05.12.2009
	*/
	public class DontShootTarget extends FlipUpTarget
	{
		
		/**
		* 
		* Constructor
		* 
		*/
		public function DontShootTarget()
		{
			super();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		override public function hitReaction (hitPoint:Point=null):void {
			if (_active && !_destroyed){
				_sl.sendCustomEvent(SharedListener.DONTSHOOT, {dontshoot:true, type:"WarningOverlay", message:"IDS_DONTSHOOT"}, false, true);
				_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"witchlaugh", loop:false}, false, true);
				popDown(true);
			}
		}
	}
}