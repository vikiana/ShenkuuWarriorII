//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{

	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * public class ClusterPowerup extends PowerUp
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ClusterPowerup extends PowerUp
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var _handler:Function;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ClusterPowerup extends PowerUp instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ClusterPowerup()
		{
			//super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		/*public function checkPoints():Number {
			var points:Number = 0;
			var p:PointsPowerup;
			for (var i:int =0; i< numChildren; i++){
				p = PointsPowerup(getChildAt(i));
				if (p.pickedUp){
					points = PointsPowerup.assignPointValue(p);
					removeChild(p);
				}
			}
			return points;
		}*/
		
		public function checkClusterComplete ():Number {
			for (var i:int =0; i<numChildren; i++){
				if (!PointsPowerup(getChildAt(i)).pickedUp){
					return 0;
				}
			}
			return ClusterPowerup.assignPointValue(this);
		}

		
		override public function update():void {
			if (y > -50){
				for (var i:int =0; i<numChildren; i++){
					PointsPowerup(getChildAt(i)).update();
				}
			}
		}
		
		public static function assignPointValue (obj:*):Number {
			var n:String = getQualifiedClassName(obj);
			var p:Number =0;
			switch (n){
				case GameInfo.CLUSTER_BSTRIKE:
					p = GameInfo.CLUSTER_BSTRIKE_P;
					break;
				case GameInfo.CLUSTER_FULLMOON:
					p = GameInfo.CLUSTER_FULLMOON_P
					break;
				case GameInfo.CLUSTER_GOLDWAVE:
					p = GameInfo.CLUSTER_GOLDWAVE_P;
					break;
				case GameInfo.CLUSTER_SILVERMOON:
					p = GameInfo.CLUSTER_SILVERMOON_P;
					break;
				case GameInfo.CLUSTER_SSTRIKE:
					p = GameInfo.CLUSTER_SSTRIKE_P;
					break;
				case GameInfo.CLUSTER_STAR:
					p = GameInfo.CLUSTER_STAR_P;
					break;
				default:
					p =0;
			}
			return p;
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		public function addListeners(handler:Function):void {
			_handler = handler;
			var p:PointsPowerup;
			for (var i:int =0; i< numChildren; i++){
				p = PointsPowerup(getChildAt(i));
				p.addEventListener(GameInfo.GET_POWERUP, handler, false, 0, true);
			}
		}
		
		public function cleanUp ():void {
			var p:PointsPowerup;
			var length:int = numChildren;
			for (var i:int=length-1; i >= 0 ; i--){
				p = PointsPowerup(getChildAt(i));
				if (p.hasEventListener(GameInfo.GET_POWERUP)){
					p.removeEventListener(GameInfo.GET_POWERUP, _handler);
				}
				removeChild(p);
			}
			_handler = null;
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}