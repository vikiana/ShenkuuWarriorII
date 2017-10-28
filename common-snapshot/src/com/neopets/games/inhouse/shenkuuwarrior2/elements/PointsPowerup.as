//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.collision.CollisionManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * public class PointsPowerup extends PowerUp
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class PointsPowerup extends PowerUp
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
		public var pickedUp:Boolean = false;
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class PointsPowerup extends PowerUp instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function PointsPowerup()
		{
			super();
			addEventListener(MouseEvent.ROLL_OVER, getPowerup, false, 0, true);
			useHandCursor = true;
			var hac:Class = Class (getDefinitionByName("collision_circle"));
			hitarea = new hac();
			hitarea.alpha = 0;
			addChild(Sprite(hitarea));
		}
		
		
		public function cleanUp():void {
			if (hasEventListener(MouseEvent.ROLL_OVER)){
				removeEventListener(MouseEvent.ROLL_OVER, getPowerup);
			}
		}
		
		public function getPowerup(e:MouseEvent=null):void {
			if (!pickedUp){
				pickedUp = true;
				removeEventListener(MouseEvent.ROLL_OVER, getPowerup);
				dispatchEvent(new CustomEvent ({type:"points"}, GameInfo.GET_POWERUP, false, true));
				//_proxy.space.removeItem (_proxy);
				//TODO: CLEANUP
				gotoAndPlay(2);
				hitarea.visible = false;
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public static function assignPointValue (obj:*):Number {
			var n:String = getQualifiedClassName(obj);
			var p:Number =0;
			switch (n){
				case GameInfo.BRONZE:
					p = GameInfo.POINTS1;
					break;
				case GameInfo.SILVER:
					p = GameInfo.POINTS2;
					break;
				case GameInfo.GOLD:
					p = GameInfo.POINTS3;
					break;
				default:
					p =0;
			}
			return p;
		}
		

		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		
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