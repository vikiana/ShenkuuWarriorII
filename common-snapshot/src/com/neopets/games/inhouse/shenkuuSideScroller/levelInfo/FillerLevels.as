/**
 *	For each level, there are waves/formations of enemies.
 *	This class deals with creating each formations that compose a level
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  aug.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.levelInfo
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class FillerLevels
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------


		
		public static var speed:Number = -GameData.movingSpeed
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FillerLevels():void
		{			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		
		/**
		 *	seting up the levels
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function set1A(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 5, "helper","Helper_Score",700,300,60,0,speed,0,"SCORE");
			LM.lineCreator(pos, pLvl, 2, "helper","Helper_Score",880,260,0,80,speed,0,"SCORE");
			
			LM.lineCreator(pos + 600, pLvl, 5, "helper","Helper_Score",700,300,60,-30,speed,0,"SCORE");
			LM.lineCreator(pos + 600, pLvl, 2, "helper","Helper_Score",880,170,30,70,speed,0,"SCORE");
			
			LM.lineCreator(pos + 1200, pLvl, 5, "helper","Helper_Score",700,250,50,45,speed,0,"SCORE");
			LM.lineCreator(pos + 1200, pLvl, 2, "helper","Helper_Score",850,430,40,-60,speed,0,"SCORE");
		}
		
		public static function set1B(pLvl:Array, pos:Number):void
		{
			
			LM.archCreator(pos, pLvl,6,20,Math.PI*1.9,"helper","Helper_Score",700,250,250,speed,0,"SCORE");
			LM.lineCreator(pos + 50, pLvl, 2, "enemy","Default2A",700,300,80,0,speed,0,"DEFAULT2");
			LM.lineCreator(pos + 350, pLvl, 2, "enemy","Default2A",700,300,80,0,speed,0,"DEFAULT2");
			
			LM.lineCreator(pos + 700, pLvl, 6, "enemy","Default2A", 850,300,300,0,speed,0,"DEFAULT2");
			LM.curvCreator(pos + 700, pLvl,12,4,0,"helper","Helper_Score",700,300,120,150,speed,0,"SCORE");
		}

		public static function set3A(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 6, "enemy","WallA", 850,300,240,0,speed,0,"WALL");
			LM.lineCreator(pos, pLvl, 6, "enemy","WallVerticalTopB", 850,100,240,21,speed,0,"WALL_V");
			LM.lineCreator(pos, pLvl, 6, "enemy","WallVerticalBottomB", 850,500,240,-19,speed,0,"WALL_V");
			LM.lineCreator(pos + 120, pLvl, 6, "helper","Helper_Score", 850,300,240,0,speed,0,"SCORE");
			
		}
		
		public static function set3B(pLvl:Array, pos:Number):void
		{
			LM.custCreator(pos, pLvl, 20, "enemy", "DefaultC", 700, 1, 200, speed * 2.5, 0, "DEFAULT");
		}
		
		public static function set3C(pLvl:Array, pos:Number):void
		{
			LM.custCreator(pos, pLvl, 40, "enemy", "DefaultC", 700, 1, 100, speed * 3, 0, "DEFAULT");
		}
		
		public static function set3D(pLvl:Array, pos:Number):void
		{
			LM.custCreator(pos, pLvl, 20, "enemy", "WallA", 700, 1, 200, speed * 2.5, 0, "WALL");
			LM.custCreator(pos, pLvl, 15, "enemy", "DefaultC", 700, 1, 400, speed * 3, 0, "DEFAULT");
		}
		
		public static function set3E(pLvl:Array, pos:Number):void
		{
			LM.custCreator(pos, pLvl, 20, "enemy", "WallA", 700, 1, 200, speed * 2.5, 0, "WALL");
			LM.custCreator(pos, pLvl, 15, "enemy", "DefaultC", 700, 1, 400, speed * 3, 0, "DEFAULT");
			LM.custCreator(pos, pLvl, 15, "enemy", "KillerA", 700, 1, 400, speed * 1.5, 0, "KILLER");
		}
		
		public static function set3F(pLvl:Array, pos:Number):void
		{
			
			LM.custCreator(pos, pLvl, 12, "enemy", "KillerA", 700, 1, 200, speed * 2, 0, "KILLER");
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------

		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}