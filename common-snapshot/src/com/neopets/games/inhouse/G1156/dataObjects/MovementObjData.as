
package com.neopets.games.inhouse.G1156.dataObjects
{
	/**
	 * This is for setting up the Parachute and Free Fall for a Player
	 */
	
	public class MovementObjData extends Object
	{
		public var mFallRightMove:int;
		public var mFallLeftMove:int;
		public var mFallUpMove:int;
		public var mFallDownMove:int;
		public var mFallSpeed:int;
		
		//Active = Parachute Deployed
		public var mActiveRightMove:int;
		public var mActiveLeftMove:int;
		public var mActiveUpMove:int;
		public var mActiveDownMove:int;
		public var mActiveFallSpeed:int;
		public var mActiveDownSpeed:int;
		public var mActiveUpSpeed:int;
		
		public function MovementObjData(pActRightMove:int = 5,pActLeftMove:int =5, pActUpMove:int = 0,pActDownMove:int = 0, pActFallSpeed:int = 110):void
		{
			//Free Fall Controls
			mFallSpeed = 260;
			
			// When Parachute is released
			mActiveRightMove = pActRightMove;
			mActiveLeftMove = pActLeftMove;
			mActiveUpMove = pActUpMove;
			mActiveDownMove = pActDownMove;
			mActiveFallSpeed = pActFallSpeed;
			mActiveDownSpeed = mActiveFallSpeed - 50;
			mActiveUpSpeed = mActiveFallSpeed + 50;
			
		}

	}
}