//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.gamedata
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	
	/**
	 * public class Parameters: it describes all parameters that will change throughout the game due to 
	 * level progression or special abilities.
	 * It's  Singleton.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Parameters
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private static const mInstance:Parameters = new Parameters( SingletonEnforcer ); 
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//EDITABLE FORCES
		
		//gravity
		public var g:Number = GameInfo.G;
		//friction
		public var drag:Number = GameInfo.DRAG;
		//launch force
		public var hook_force:Number = GameInfo.HOOK_LAUNCH_F;
		//multiplier for the calculation of the warrior launch force
		public var warrior_force:Number = GameInfo.ROPE_PULL_F;
		//the strenght of the bounnce on the walls
		public var bounce:Number = GameInfo.BOUNCE;
		//amout of slowdown that a breaking ledge causes to the warrior
		public var slowdown:Number = GameInfo.SLOWDOWN;
		
		
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
		 * Creates a new public class Parameters instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function Parameters(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init(pg:Number=0, pdrag:Number=0, pbounce:Number=0, phook_force:Number=0, pwarrior_force:Number=0, pslowdown:Number=0):void {
			g = pg;
			drag = pdrag;
			hook_force = phook_force;
			warrior_force = pwarrior_force;
			bounce = pbounce;
			slowdown = pslowdown;
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
		public static function get instance():Parameters
		{ 
			return mInstance;	
		} 
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */

internal class SingletonEnforcer{}