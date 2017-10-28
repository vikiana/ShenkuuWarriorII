//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.util.collision.CollisionManager;
	import com.neopets.util.collision.geometry.CircleArea;
	import com.neopets.util.collision.geometry.RectangleArea;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.vendor.gamepill.novastorm.render.sprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * public class PowerUp extends MovieClip
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class PowerUp extends MovieClip
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
	
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		protected var _proxy:CollisionProxy;
		
		protected var _proxiinit:Boolean = false;
		
		public var hitarea:Sprite;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class PowerUp extends MovieClip instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 */
		public function PowerUp()
		{
			super();
			gotoAndStop(1);
			// initialize our collision proxy [OLD: when we're added to the stage] when the ledge enter the game area
			_proxy = new CollisionProxy(this);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		public function update ():void {
			//adding to the collision space
			if (y > -50 && !_proxiinit){
				onProxyInit();
				_proxiinit = true;
			}
			_proxy.synch();
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
		protected function onProxyInit(ev:Event=null):void {
			if(stage != null) {
				_proxy.area = new CircleArea(hitarea);
				_proxy.addTo(GameInfo.COLLISION_SPACE);
				removeEventListener(Event.ADDED_TO_STAGE,onProxyInit);
				//trace ("PROXY ADDED", this, this.parent, this.name, DisplayObjectContainer(this.parent).getChildIndex(this));
			}
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get proxy ():CollisionProxy{
			return _proxy;
		}
	}
}