//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.levelData
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * public class GameIntrospectionUtil
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class GameIntrospectionUtil
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
		public static function gaugePoints (pointsArray:Vector.<ImagePlacement>):void {
			var bronze:int = 0;
			var silver:int = 0;
			var gold:int = 0;
			
			var cBStrike500:int = 0;
			var cSilverS1000:int = 0;
			var cSilverMoon1400:int = 0;
			var cStar2100:int = 0;
			var cFullMoon3600:int = 0;
			
			for (var i:int = 0; i< pointsArray.length; i++){
				if (pointsArray[i].imageClass== "fixed_powerup_BRONZE"){
					bronze++;
				} else if (pointsArray[i].imageClass== "fixed_powerup_SILVER"){
					silver++;
				} else if (pointsArray[i].imageClass== "fixed_powerup_GOLD"){
					gold++;
				} else if (pointsArray[i].imageClass== "ClusterPowerup_star"){
					cStar2100++;
				} else if (pointsArray[i].imageClass== "ClusterPowerup_silverstrike"){
					cSilverS1000++;
				} else if (pointsArray[i].imageClass== "ClusterPowerup_silvermoon"){
					cSilverMoon1400++;
				} else if (pointsArray[i].imageClass== "ClusterPowerup_fullmoon"){
					cFullMoon3600++;
				} else if (pointsArray[i].imageClass== "ClusterPowerup_bronzestrike"){
					cBStrike500++;
				} 
			}
			
			var totPoints:Number = (50*bronze)+ (100*silver)+ (200*gold)+(500*cBStrike500)+(1000*cSilverS1000)+(1400*cSilverMoon1400)+(2100*cStar2100)+(3600*cFullMoon3600);
			
			/*trace ("MAX POINTS:", totPoints);
			trace ("50 X ", bronze);
			trace ("100 X ", silver);
			trace ("200 X ", gold);
			trace ("500 X ", cBStrike500);
			trace ("1000 X ", cSilverS1000);
			trace ("1400 X ", cSilverMoon1400);
			trace ("2100 X ", cStar2100);
			trace ("3600 X ", cFullMoon3600);*/
			
		}
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
		 * Creates a new public class GameIntrospectionUtil instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function GameIntrospectionUtil()
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