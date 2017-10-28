//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.util.collision.geometry.RectangleArea;
	import com.neopets.util.collision.objects.CollisionProxy;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * public class Ledge extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Ledge extends MovieClip
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
		public var ledge:MovieClip;
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//protected var _hookX:Number;  old collision system  - delete
		protected var _proxy:CollisionProxy;
		
		protected var _proxiinit:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Ledge extends Sprite instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function Ledge()
		{
			super();
			gotoAndStop(1);
			// initialize our collision proxy [OLD: when we're added to the stage] when the ledge enter the game area
			_proxy = new CollisionProxy(this);
			//addEventListener(Event.ADDED_TO_STAGE,onProxyInit);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function update():void {
			//adding to the collision space
			if (y > -50 && !_proxiinit){
				onProxyInit();
				_proxiinit = true;
			}
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
				_proxy.area = new RectangleArea(ledge);
				_proxy.addTo(GameInfo.COLLISION_SPACE);
				removeEventListener(Event.ADDED_TO_STAGE,onProxyInit);
			}
		}
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		/*public function get hookX ():Number{
			return _hookX;
		}
		
		public function set hookX (value:Number):void {
			_hookX = value;
		}*/
		
		public function get proxy ():CollisionProxy{
			return _proxy;
		}
		
		//do I need this?
		/*public function set hooked(value:Boolean):void {
			//trace ("ledge is hooked!");
		}*/
	}
}