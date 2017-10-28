//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.gamedata
{
	
	/**
	 * public class GameInfo
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class GameInfo
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
		 * The higher is the gravity multiplier, the slower (easier) is the game play.
		 * You can use this number to calibrate the general game play (non level-specific)
		 * 
		 */
		public static const G_MULTIPLIER:Number = 10000;
		
		
		//good-enough physics
		
		//gravity
		public static const G:Number = 0;
		//friction
		public static const DRAG:Number = 0;
		//kinetic loss on bounce
		public static const BOUNCE:Number = 0;
		//kinetic loss on bounce for hook
		public static const BOUNCE_HOOK:Number = 10;
		//force for launch
		public static const HOOK_LAUNCH_F:Number = 0;
		//strenght of the rope
		public static const ROPE_PULL_F:Number = 0;
		//amount of slowdown that a breaking ledge causes to the warrior
		public static const SLOWDOWN:Number = 0;
		
		//OLD DEFAULTS
		/*
		//gravity
		public static const G:Number = 7;
		//friction
		public static const DRAG:Number = .98;
		//kinetic loss on bounce
		public static const BOUNCE:Number = 3;
		//kinetic loss on bounce for hook
		public static const BOUNCE_HOOK:Number = .4;
		//force for launch
		public static const HOOK_LAUNCH_F:Number = 60;
		//strenght of the rope
		public static const ROPE_PULL_F:Number = 80;
		//amount of slowdown that a breaking ledge causes to the warrior
		public static const SLOWDOWN:Number = 2;*/
		
		//kite powerup
		public static const KITE_FORCE:Number = 3;
		
		/**
		* The higher the time interval, the choppiest is the movement (but the performance is faster
		* Use this number to test the game for movement accuracy and other things (It's the same of changing the frame rate for frame-based movements)
		* 
		* ie: set it to 1000 to see the movement a frame per second. 
		 * 
		*@internal  Note: Don't make it less than 1000/framerate, you'll not see the difference.
		* 
		*/
		public static const T_INTERVAL:Number = 31.25;
		
		//clicker timer
		public static const CLICKER_TIMER_LAPSE:Number = 2;//tenth of a second
		public static const ACCURACY_BONUS:Number = 100;
		
		//world
		public static const STAGE_HEIGHT:Number = 600//565;
		public static const STAGE_WIDTH:Number = 500;
		public static const MAX_Y:Number = 300;
		public static const MIN_Y:Number = STAGE_HEIGHT+300;
		public static const COLLISION_SPACE:String = "game_space";
		public static const LEDGE_XGAP_REDUCTION:Number = 50;
		
		//events
		public static const LOSE_ROPE:String = "lose the rope";
		public static const LEDGE_EVENT:String = "ledge event";
		public static const LEDGE_BREAK:String = "ledge break";
		public static const LEVEL_END:String = "level ends";
		public static const LEVEL_ENDING:String = "level ending";
		public static const GET_POWERUP:String = "get powerup";
		public static const ADD_POINTS:String = "get powerup";
		public static const GET_POPUP:String = "get popup";
		public static const ENABLE_SPAWN_LEDGES:String = "enable spawn ledges";
		public static const SPAWN_LEDGES_NUMBER:Number = 5;
		public static const GET_LEVELS_SCREEN:String = "getLevelsScreen";
		
		//EE
		public static const EE:String = "elevate";
	
		//powerups
		public static const POWERUP_XSPEED:Number =  5;
		public static const POWERUP_YSPEED:Number =  40;
		//how many seconds the flying powerup lasts
		public static const FLYING_POWERUP_SECS:int =  5;
		//how many seconds the ledges powerup effect lasts
		public static const LEDGES_POWERUP_SECS:int =  1;
		
		//levels: this var is set when the first level is generated. Default is 10000
		public static var ENDLESSLEVEL_BG_RANGE:Number = 10000;
		//public static const 
		
		//ANIMATIONS
		//warrior
		public static const GROUND_NEUTRAL:String = "ground-neutral";
		public static const GROUND_READY:String = "ground-ready";
		public static const GROUND_THROW:String = "ground-throw";
		public static const AIR_READY:String = "air-ready";
		public static const AIR_THROW:String = "air-throw";
		public static const AIR_MOVING:String = "air-moving";
		public static const KITE_AIR_READY:String = "kite-air-ready";
		public static const KITE_AIR_THROW:String = "kite-air-throw";
		public static const KITE_AIR_MOVING:String = "kite-air-moving";
		public static const PETPET_AIR_READY:String = "petpet-air-ready";
		public static const PETPET_AIR_THROW:String = "petpet-air-throw";
		public static const PETPET_AIR_MOVING:String = "petpet-air-moving";
		public static const JUMP_ANIMATION:String = "jump-animation";
		public static const FALLING:String = "falling";
		public static const PPU_PICKUP:String = "PPU_pickup";
		public static const BPU_PICKUP:String = "BPU_pickup";
		public static const INFLATE:String = "inflate";
		//SOUNDS
		//UI
		public static const BUTTON_SOUND:String = "BtnSound";
		//GAME FX
		public static const POINTS_SOUND:String = "Pickup";
		public static const COMBOPOINTS_SOUND:String = "ComboPickup";
		public static const WARRIOR_FAIL_SOUND:String = "Fail";
		public static const WARRIOR_FALLING_SOUND:String = "Falling";
		public static const WARRIOR_GRUNT_SOUND:String = "Grunt";
		public static const HOOK_THROW_SOUND:String = "HookThrow";
		public static const KITE_POWERUP_SOUND:String = "KitePowerup";
		public static const PP_POWERUP_SOUND:String = "PPPowerup";
		public static const X2_SOUND:String = "px2_fx";
		public static const BREAK_SOUND:String = "ledge_break";
		public static const HOOK_HARD:String = "hook_hard";
		public static const HOOK_SOFT:String = "hook_soft";
		public static const MENU_LOOP:String = "menuloop";
		public static const CELEBRATION:String = "celebration";

		
		//loops (add id if more than one loop)
		public static const LOOP:String = "Loop";
		public static const AMBIENT:String = "Ambient";

		
		//points
		public static const BRONZE:String = "fixed_powerup_BRONZE";
		public static const SILVER:String = "fixed_powerup_SILVER";
		public static const GOLD:String = "fixed_powerup_GOLD";
		public static const POINTS1:Number = 50;
		public static const POINTS2:Number = 100;
		public static const POINTS3:Number = 200;
		
		//clusters
		public static const CLUSTER_BSTRIKE:String = "ClusterPowerup_bronzestrike";
		public static const CLUSTER_BSTRIKE_P:Number = 250;
		public static const CLUSTER_SSTRIKE:String = "ClusterPowerup_silverstrike";
		public static const CLUSTER_SSTRIKE_P:Number = 500
		public static const CLUSTER_SILVERMOON:String = "ClusterPowerup_silvermoon";
		public static const CLUSTER_SILVERMOON_P:Number = 700;
		public static const CLUSTER_FULLMOON:String = "ClusterPowerup_fullmoon";
		public static const CLUSTER_FULLMOON_P:Number = 1800;
		public static const CLUSTER_STAR:String = "ClusterPowerup_star";
		public static const CLUSTER_STAR_P:Number = 1050;
		public static const CLUSTER_GOLDWAVE:String = "ClusterPowerup_goldwave";
		public static const CLUSTER_GOLDWAVE_P:Number = 1400;
		
		
		
		//popups
		public static const POPUP_FAIL:String = "fail";
		public static const POPUP_QUIT:String = "quit";
		public static const POPUP_LEVEL:String = "level";
		
		
		public static const SCORE_TIME_MULTIPLIER:Number = 134;
		public static const	SCORE_ACCURACY_MULTIPLIER:Number = 60;
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
		 * Creates a new public class GameInfo instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function GameInfo()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
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