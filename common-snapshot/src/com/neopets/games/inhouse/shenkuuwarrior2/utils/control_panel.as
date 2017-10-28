//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.utils
{
	import com.neopets.games.inhouse.shenkuuwarrior2.ShenkuuWarrior2_Game;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.Parameters;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	
	
	/**
	 * public class control_panel extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class control_panel extends Sprite
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public static const APPLY:String = "apply";
		public static const UPDATEFROMPARAMS:String = "update from params";
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public var apply_btn:MovieClip;
		public var gravity_i:TextField;
		public var drag_i:TextField;
		public var bounce_i:TextField;
		public var hookf_i:TextField;
		public var warriorf_i:TextField;
		public var slowdown_i:TextField;
		
		private var _app:ShenkuuWarrior2_Game;
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
		 * Creates a new public class control_panel extends Sprite instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function control_panel()
		{
			super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init(application:ShenkuuWarrior2_Game):void {
			_app = application;
			//
			apply_btn.addEventListener(MouseEvent.CLICK, updateParams, false, 0, true);
			//defaults
			gravity_i.text = String (GameInfo.G);
			bounce_i.text = String (GameInfo.BOUNCE);
			drag_i.text = String (GameInfo.DRAG);
			hookf_i.text = String (GameInfo.HOOK_LAUNCH_F);
			warriorf_i.text = String (GameInfo.ROPE_PULL_F);
			slowdown_i.text = String (GameInfo.SLOWDOWN);
		}
		
		public function updateFromParams ():void {
			gravity_i.text = String (Parameters.instance.g);
			bounce_i.text = String (Parameters.instance.bounce);
			drag_i.text = String (Parameters.instance.drag);
			hookf_i.text = String (Parameters.instance.hook_force);
			warriorf_i.text = String (Parameters.instance.warrior_force);
			slowdown_i.text = String (Parameters.instance.slowdown);
		
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		protected function updateParams (e:MouseEvent=null):void {
			Parameters.instance.g = Number (gravity_i.text);
			Parameters.instance.bounce = Number (bounce_i.text);
			Parameters.instance.drag = Number (drag_i.text);
			Parameters.instance.hook_force = Number (hookf_i.text);
			Parameters.instance.warrior_force = Number (warriorf_i.text);
			Parameters.instance.slowdown = Number (slowdown_i.text);
			//
			_app.updateParams();
			//
			dispatchEvent(new Event (APPLY, false, true));
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