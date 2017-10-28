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

	
	
	public class LevelCreator
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
		public function LevelCreator():void
		{			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/

		public static function testIntro(pLvl:Array, pos:Number):void
		{
			LM.curvCreator(pos, pLvl,8,8,0,"helper","Helper_Score",600,300,50,100,speed,0,"SCORE");
			LM.curvCreator(pos, pLvl,8,8,0,"helper","Helper_Morph",600,400,50,100,speed,0,"MORPH");
			LM.custCreator(pos + 250, pLvl, 2, "enemy", "Default2A", 700, 1, 500,speed - 1, 0, "DEFAULT");
			LM.curvCreator(pos + 750, pLvl,3,3,Math.PI,"enemy","WallA",700,300,140,200,speed - 1,0,"WALL");
			
			LM.lineCreator(pos + 1200, pLvl, 2, "enemy", "WallHorizontalA", 700, 100, 300, 100, speed, 0, "WALL_H");
			LM.lineCreator(pos + 1200, pLvl, 2, "enemy", "WallVerticalBottomA", 700, 350, 200, 50, speed, 0, "WALL_V");
			
			LM.lineCreator(pos + 1700, pLvl, 2, "enemy", "WallVerticalBottomB", 700, 350, 200, 50, speed, 0, "WALL_V");
			LM.lineCreator(pos + 1700, pLvl, 2, "enemy", "WallVerticalTopA", 700, 250, 300, speed - 10, speed, 0, "WALL_V");
			
			LM.lineCreator(pos + 1900, pLvl, 2, "enemy", "WallVerticalTopB", 700, 250, 400, 50, speed, 0, "WALL_V");
			
			
			
			LM.custCreator(pos + 2700, pLvl, 2, "enemy", "KillerB", 650, 1, 500,speed - 1, 0, "KILLER");
			LM.custCreator(pos + 2900, pLvl, 2, "enemy", "ShooterB", 700, 1, 500,speed - 1, 0, "DESTROYER");
		}
		
		/**
		 *	LEARN: Very basic formation of basic enemies and items
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function intro1(pLvl:Array, pos:Number):void
		{
			//LM.custCreator(pos, pLvl, 2, "enemy", "EnemySuperPirate", 700, 1, 500,speed - 1, 0, "DESTROYER");
			LM.custCreator(pos, pLvl, 2, "enemy", "KillerA", 650, 1, 500,speed, 0, "WALL_H");
			LM.curvCreator(pos, pLvl,8,8,0,"helper","Helper_Score",600,300,50,100,speed,0,"SCORE");
			LM.custCreator(pos + 250, pLvl, 2, "enemy", "DefaultA", 700, 1, 500,speed - 1, 0, "DEFAULT");
			LM.curvCreator(pos + 750, pLvl,3,3,Math.PI,"enemy","DefaultA",700,300,140,200,speed - 1,0,"DEFAULT");
			LM.lineCreator(pos + 1200, pLvl,3, "helper","Helper_Score",700,300,80,0,speed,0,"SCORE");
			LM.lineCreator(pos + 1200, pLvl, 5, "enemy", "Default2A", 700, 20, 0, 50, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 1200, pLvl, 5, "enemy", "Default2A", 700, 370, 0, 50, speed, 0, "BLOCKER");
		}
		
		/**
		 *	LEARN: Basic formation of tracker enemies and items
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function intro2(pLvl:Array, pos:Number):void
		{
			LM.curvCreator(pos, pLvl,8,8,0,"helper","Helper_Score",600,300,50,100,speed,0,"SCORE");
			LM.lineCreator(pos + 250, pLvl, 2, "enemy", "TrackerA",700, 120, 500, 0, speed - 1, 0, "TRACKER");
			LM.lineCreator(pos + 450, pLvl, 2, "enemy", "TrackerA",700, 520, 500, 0, speed - 1, 0, "TRACKER");
		}
		
		/**
		 *	LEARN: introduction to shooting enemies
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function intro3(pLvl:Array, pos:Number):void
		{
			LM.curvCreator(pos, pLvl,8,8,0,"helper","Helper_Score",600,300,50,100,speed,0,"SCORE");
			LM.lineCreator(pos + 250, pLvl, 1, "enemy", "ShooterA",700, 120, 500, 0, speed, 0, "SHOOTER");
			LM.lineCreator(pos + 800, pLvl, 1, "enemy", "ShooterA",700, 500, 500, 0, speed, 0, "SHOOTER");
		}
		
		
		/**
		 *	WAVE: maneuver, cross flying objects
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function basicCrossMove(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 3, "enemy", "DefaultA",700, 150, 0, 150, speed - 1, 0, "DEFAULT");
			LM.lineCreator(pos, pLvl, 2, "helper","Helper_Score",700,230,0,150,speed - 1,0,"SCORE");
			LM.lineCreator(pos + 180, pLvl, 2, "enemy", "DefaultA", 700, 230, 0, 150, speed - 3, 0, "DEFAULT");
			LM.custCreator(pos + 600, pLvl, 4, "helper", "Helper_Score",700, 1, 200, speed, 0, "SCORE");
			LM.lineCreator(pos + 600, pLvl, 4, "enemy", "DefaultA", 700, 50, 300, -150, speed - 3, 4, "DEFAULT");
			LM.lineCreator(pos + 600, pLvl, 4, "enemy", "DefaultA", 900, 650, 300, 150, speed - 3, speed, "DEFAULT");
			LM.custCreator(pos + 900, pLvl, 2, "enemy", "DefaultA", 700, 1, 400, speed - 2, 0, "DEFAULT");			
		}
		
		/**
		 *	WAVE: maneuver, tracker objects appearing on top and bottom creating cross flying affect
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function advCrossMove(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 3, "enemy", "TrackerA",700, 100, 120, 0, speed - 1, 0, "TRACKER");
			LM.custCreatorR(pos + 100, pLvl, 7, "helper", [0,0,0,1,1,2], 700, 1, 150,speed, 0);
			LM.lineCreator(pos + 400, pLvl, 3, "enemy", "TrackerA",700, 500, 120, 0, speed - 1, 0, "TRACKER");
			LM.lineCreator(pos + 700, pLvl, 3, "enemy", "TrackerA",700, 100, 120, 0, speed - 1, 0, "TRACKER");
		}
		
		
		/**
		 *	WAVE: maneuver, ultimate corss move with shooters
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function ultimateCrossMove(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 5, "enemy", "ShooterA",700, 120, 800, 0, speed - 2, 0, "SHOOTER");
			LM.lineCreator(pos+ 200, pLvl, 5, "enemy", "ShooterA",700, 300, 700, 0, speed -1, 0, "SHOOTER");
			LM.custCreatorR(pos + 200, pLvl, 13, "helper", [0,0,0,0,0,0,0,1,1,1,1,1,3,6],700, 1, 200, speed, 0);
			LM.lineCreator(pos + 400, pLvl, 5, "enemy", "ShooterA",700, 500, 800, 0, speed - 2, 0, "SHOOTER");
			LM.lineCreator(pos + 600, pLvl, 2, "enemy", "TrackerA",700, 100, 200, 0, speed - 2, 0, "TRACKER");
			LM.custCreator(pos + 1200, pLvl, 2, "enemy", "DefaultA",700, 1, 400, speed - 2, 0, "DEFAULT");
			LM.lineCreator(pos + 1600, pLvl, 2, "enemy", "TrackerA",700, 500, 400, 0, speed - 2, 0, "TRACKER");
			LM.custCreator(pos + 2200, pLvl, 2, "enemy", "DefaultA",700, 1, 400, speed - 2, 0, "DEFAULT");
		}
		
		/**
		 *	WAVE: flying objects from top to bottom in rain formation
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 **/
		public static function basicRain(pLvl:Array, pos:Number):void
		{
			//wave2: rain
			pLvl.push(
					  [pos, "helper","Helper_Invincible",700, 120, speed, 0, 0, 0, "INVINCIBLE"],
					  [pos, "helper","Helper_SpeedUp",700, 500, speed, 0, 0, 0, "SPEED_UP"]
					  )

			LM.lineCreator(pos + 400, pLvl, 4, "enemy", "DefaultA", 100, speed - 10, 300, 0, -2, 4, "DEFAULT");
			LM.lineCreator(pos + 400, pLvl, 4, "enemy", "DefaultA", 100, -300, 300, 0, -2, 4, "DEFAULT");
			LM.lineCreator(pos + 400, pLvl, 4, "enemy", "DefaultA", 250, -150, 300, 0, -2, 4, "DEFAULT");
		}
		
		/**
		 *	WAVE: Basic checker formation movement
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function basicCheckerBoard(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 1, "enemy", "DefaultA", 700, 300, 0, 0, speed, 0, "DEFAULT");
			LM.lineCreator(pos, pLvl, 2, "helper","Helper_Heal", 700, 150, 0, 300, speed, 0, "HEAL");
			
			LM.lineCreator(pos + 200, pLvl, 2, "enemy", "DefaultA", 700, 150, 0, 300, speed, 0, "DEFAULT");
			LM.lineCreator(pos + 200, pLvl, 1, "helper","Helper_Score", 700, 300, 0, 0, speed, 0, "SCORE");
			LM.custCreator(pos + 200, pLvl, 2, "enemy", "DefaultA", 700, 1, 500,speed - 3, 0, "DEFAULT");
			
			LM.lineCreator(pos + 400, pLvl, 1, "enemy", "DefaultA", 700, 300, 0, 0, speed, 0, "DEFAULT");
			LM.lineCreator(pos + 400, pLvl, 2, "helper","Helper_Heal", 700, 150, 0, 300, speed, 0, "HEAL");
			
			LM.lineCreator(pos + 600, pLvl, 2, "enemy", "DefaultA", 700, 150, 0, 300, speed, 0, "DEFAULT");
			LM.lineCreator(pos + 600, pLvl, 1, "helper","Helper_Score", 700, 300, 0, 0, speed, 0, "Score");
		}
		
		
		/**
		 *	WAVE: tight formation of basic checker formation movement
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function advCheckerBoard(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 3, "enemy", "DefaultA2",700, 100, 110, 70, speed, 0, "DEFAULT");
			LM.lineCreator(pos, pLvl, 3, "enemy", "DefaultA2",700, 500, 110, speed - 30, speed, 0, "DEFAULT");
			LM.lineCreator(pos + 350, pLvl, 3, "enemy", "Default2A",700, 150, 0, 150, speed, 0, "BLOCKER");
			LM.lineCreatorR(pos + 470, pLvl, 3, "helper",[0,0,0,0,1,1,6,7],700, 150, 0, 150, speed, 0);
			LM.lineCreator(pos + 470, pLvl, 4, "enemy", "Default2A",700, 75, 0, 150, speed, 0, "BLOCKER");
			LM.custCreator(pos + 470, pLvl, 3, "enemy", "DefaultA2", 700, 1, 400, speed - 2, 0, "DEFAULT");
			LM.lineCreator(pos + 590, pLvl, 3, "enemy", "Default2A",700, 150, 0, 150, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 710, pLvl, 4, "enemy", "Default2A",700, 75, 0, 150, speed, 0, "BLOCKER");
			LM.lineCreatorR(pos + 830, pLvl, 4, "helper",[0,0,0,0,3,4,5],700, 75, 0, 150, speed, 0);
			LM.lineCreator(pos + 830, pLvl, 3, "enemy", "Default2A",700, 150, 0, 150, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 950, pLvl, 4, "enemy", "Default2A",700, 75, 0, 150, speed, 0, "BLOCKER");
		}		
		
		
		/**
		 *	WAVE: Train movement for enemies flying in staggered straight formation
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function superCheckerBoard(pLvl:Array, pos:Number):void
		{
			LM.lineCreatorR(pos, pLvl, 3, "helper",[0,0,0,0,0,0,0,0,0,1,1,3,6,6], 760, 80, 120, 0, speed, 0);
			LM.lineCreatorR(pos, pLvl, 3, "helper",[0,0,0,0,0,0,0,0,0,1,1,3,6,6], 760, 560, 120, 0, speed, 0);
			
			
			LM.lineCreator(pos, pLvl, 5, "enemy", "Default2A", 700, 80, 0, 120, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 120, pLvl, 5, "enemy", "Default2A", 700, 80, 0, 120, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 240, pLvl, 5, "enemy", "Default2A", 700, 80, 0, 120, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 360, pLvl, 5, "enemy", "Default2A", 700, 80, 0, 120, speed, 0, "BLOCKER");
			
			LM.lineCreator(pos + 480, pLvl, 6, "enemy", "Default2A", 700, 20, 0, 120, speed, 0, "BLOCKER");
			LM.lineCreatorR(pos + 480, pLvl, 3, "helper",[0,0,0,0,0,0,0,0,0,1,1,3,6,6], 760, 140, 120, 0, speed, 0);
			LM.lineCreatorR(pos + 480, pLvl, 3, "helper",[0,0,0,0,0,0,0,0,0,1,1,3,6,6], 760, 500, 120, 0, speed, 0);
			LM.lineCreator(pos + 600, pLvl, 6, "enemy", "Default2A", 700, 20, 0, 120, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 720, pLvl, 6, "enemy", "Default2A", 700, 20, 0, 120, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 840, pLvl, 6, "enemy", "Default2A", 700, 20, 0, 120, speed, 0, "BLOCKER");
			
		}
		
		
		
		/**
		 *	CHANCE: To get one item that's useful, but surrounded by enemies
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function chance(pLvl:Array, pos:Number):void
		{
			LM.circCreator(pos, pLvl, 5, "enemy", "DefaultA",750, 200, 70, speed - 4, 0, "DEFAULT");
			LM.lineCreator(pos, pLvl, 1,"helper","Helper_Invincible",750,200,0,0, speed - 4, 0, "INVINCIBLE");
		}
		
		/**
		 *	WAVE: Train movement for enemies flying in staggered straight formation
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 *	@PARAM		easy		Boolean			if set to true show items to make this wave easier
		 **/
		public static function basicTrain(pLvl:Array, pos:Number, easy:Boolean = false):void
		{
			LM.lineCreator(pos, pLvl, 3, "helper","Helper_Score", 700, 300, 120, 0, speed - 3, 0, "SCORE");
			LM.lineCreator(pos + 200, pLvl, 3, "enemy", "Default2A", 700, 200, 120, 0, speed - 3, 0, "BLOCKER");
			LM.lineCreator(pos + 200, pLvl, 3, "enemy", "Default2A", 700, 400, 120, 0, speed - 3, 0, "BLOCKER");
			

			
			LM.lineCreator(pos + 400, pLvl, 3, "helper","Helper_Score",700, 200, 120, 0, speed - 3, 0, "SCORE");
			LM.lineCreator(pos + 400, pLvl, 3, "helper","Helper_Score",700, 400, 120, 0, speed - 3, 0, "SCORE");
			LM.lineCreator(pos + 400, pLvl, 3, "enemy", "Default2A", 700, 100, 120, 0, speed - 3, 0, "BLOCKER");
			LM.lineCreator(pos + 400, pLvl, 3, "enemy", "Default2A", 700, 300, 120, 0, speed - 3, 0, "BLOCKER");
			LM.lineCreator(pos + 400, pLvl, 3, "enemy", "Default2A", 700, 500, 120, 0, speed - 3, 0, "BLOCKER");
			
			if (easy)
			{
				LM.lineCreator(pos + 600,pLvl, 1, "helper","Helper_SpeedUp",700, 100,0,0,speed - 3,0, "SPEED_UP");
				LM.lineCreator(pos + 600,pLvl, 1, "helper","Helper_Kill", 820, 100, 0,0,speed - 3,0, "KILL");
				LM.lineCreator(pos + 600,pLvl, 3, "helper","Helper_Score", 700, 300, 120, 0, speed - 3, 0, "SCORE");
				LM.lineCreator(pos + 600,pLvl, 1, "helper","Helper_SpeedUp",700, 500,0,0, speed - 3, 0, "SPEED_UP");
				LM.lineCreator(pos + 600,pLvl, 1, "helper","Helper_Morph", 820, 500, 0,0,speed - 3,0, "MORPH");
			}
			else
			{
				LM.lineCreator(pos + 600, pLvl, 3, "helper","Helper_Score", 700,100, 120, 0, speed - 3, 0, "SCORE");
				LM.lineCreator(pos + 600, pLvl, 3, "helper","Helper_Score", 700,300, 120, 0, speed - 3, 0, "SCORE");
				LM.lineCreator(pos + 600, pLvl, 3, "helper","Helper_Score", 700,500, 120, 0, speed - 3, 0, "SCORE");
			}
			
			
			
			LM.lineCreator(pos + 600, pLvl, 3, "enemy", "Default2A", 700, 200, 120, 0, speed - 3, 0, "BLOCKER");
			LM.lineCreator(pos + 600, pLvl, 3, "enemy", "Default2A", 700, 400, 120, 0, speed - 3, 0, "BLOCKER");
			
			LM.lineCreator(pos + 800, pLvl, 3, "helper","Helper_Score", 700, 200, 120, 0, speed - 3, 0, "SCORE");
			LM.lineCreator(pos + 800, pLvl, 3, "helper","Helper_Score", 700, 400, 120, 0, speed - 3, 0, "SCORE");
			LM.lineCreator(pos + 800, pLvl, 3, "enemy", "Default2A", 700, 100, 120, 0, speed - 3, 0, "BLOCKER");
			LM.lineCreator(pos + 800, pLvl, 3, "enemy", "Default2A", 700, 300, 120, 0, speed - 3, 0, "BLOCKER");
			LM.lineCreator(pos + 800, pLvl, 3, "enemy", "Default2A", 700, 500, 120, 0, speed - 3, 0, "BLOCKER");
		}
		
		/**
		 *	WAVE: Train movement for enemies flying in staggered straight formation with weather added
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PRAAM		pos			Number			starting distance poistion of this formation
		 *	@PARAM		easy		Boolean			if set to true show items to make this wave easier
		 **/
		public static function advTrain(pLvl:Array, pos:Number, easy:Boolean = true):void
		{
			pLvl.push([pos, "weather", "snow", 0, 0.6])
			basicTrain(pLvl, pos + 100, easy)
			pLvl.push([pos + 1300, "weather", "none", 0, 0.1])
		}
		
		
		
		/**
		 *	WAVE: walls
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 *	@PARAM		level		int				difficulty level for this particular set
		 **/
		public static function walls(pLvl:Array, pos:Number, level:int = 4):void
		{
			switch (level)
			{
				case 0:
					break;
					
				case 1:
					LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 800, 1, 300, speed - 1, 0, "BLOCKER");
					break;
					
				case 3:
					LM.lineCreator(pos, pLvl, 3, "enemy", "ShooterA", 800, 80, 600,0, speed - 1, 0, "SHOOTER");
					LM.lineCreator(pos, pLvl, 4, "enemy", "ShooterA", 1100, 540, 600,0, speed - 1, 0, "SHOOTER");
					LM.custCreator(pos, pLvl, 4, "enemy", "EnemyD", 800, 1, 600, speed - 1, 0, "KILLER");
					break;
					
				case 2:
					LM.custCreator(pos, pLvl, 8, "enemy", "EnemyD", 800, 1, 300, speed - 1, 0, "KILLER");
					break;
			}
			
			LM.lineCreator(pos, pLvl, 5, "enemy", "Default2A", 700, 20, 0, 50, speed, 0, "BLOCKER");
			LM.lineCreator(pos, pLvl, 5, "enemy", "Default2A", 700, 370, 0, 50, speed, 0, "BLOCKER");
			
			LM.lineCreator(pos + 300, pLvl, 3, "enemy", "Default2A", 700, 20, 0, 50, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 300, pLvl, 7, "enemy", "Default2A", 700, 270, 0, 50, speed, 0, "BLOCKER");
			
			LM.lineCreator(pos + 600, pLvl, 7, "enemy", "Default2A", 700, 20, 0, 50, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 600, pLvl, 3, "enemy", "Default2A", 700, 470, 0, 50, speed, 0, "BLOCKER");
			
			LM.lineCreator(pos + 900, pLvl, 5, "enemy", "Default2A", 700, 20, 0, 50, speed, 0, "BLOCKER");
			LM.lineCreator(pos + 900, pLvl, 5, "enemy", "Default2A", 700, 370, 0, 50, speed, 0, "BLOCKER");
			
			LM.lineCreator(pos + 1200, pLvl, 8, "enemy", "Default2A", 700, 20, 0, 50, speed, 0, "BLOCKER");

			LM.lineCreator(pos + 1500, pLvl, 10, "enemy", "Default2A", 700, 140, 0, 50, speed, 0, "BLOCKER");
			
		}
		
		
		/**
		 *	WAVE: mines, randomly scattered
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PARAM		pos			Number			starting distance poistion of this formation
		 *	@PARAM		level		int				difficulty level for this particular set
		 **/
		public static function mines(pLvl:Array, pos:Number, level:int = 0):void
		{
			switch (level)
			{
				case 0:
					LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 700, 1, 200, speed, 0, "BLOCKER");
					LM.custCreatorR(pos, pLvl, 8, "helper", [0,0,0,0,0,0,0,0,1,1,1, 3],700, 1, 200, speed - 1, 0);
					break;
					
				case 1:
					LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 700, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 800, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 750, 1, 200, speed, 0, "BLOCKER");
					LM.custCreatorR(pos, pLvl, 8, "helper", [0,0,0,0,0,0,0,0,1,1,1, 3],700, 1, 200, speed - 1, 0);
					break;
					
				case 2:
					LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 700, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 800, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 750, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 850, 1, 200, speed, 0, "BLOCKER");
					LM.custCreatorR(pos, pLvl, 8, "helper", [0,0,0,0,0,0,0,0,1,1,1, 3],700, 1, 200, speed - 1, 0);
					break;
					
				case 3:
					LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 700, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 800, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 750, 1, 200, speed, 0, "BLOCKER");
					LM.custCreator(pos, pLvl, 7, "enemy", "Default2A", 850, 1, 200, speed, 0, "BLOCKER");
					LM.lineCreator(pos, pLvl, 3, "enemy", "ShooterA", 800, 80, 600,0, speed - 1, 0, "SHOOTER");
					LM.lineCreator(pos, pLvl, 3, "enemy", "ShooterA", 1100, 540, 600,0, speed - 1, 0, "SHOOTER");
					LM.custCreatorR(pos, pLvl, 8, "helper", [0,0,0,0,0,0,0,0,1,1,1],700, 1, 200, speed - 1, 0);
					break;


			}
		}
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 *	WAVE: Forms a basic track like enemy formation
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PRAAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function basicWavyTrack(pLvl:Array, pos:Number):void
		{
			LM.custCreatorR(pos, pLvl, 4, "helper", [0,0,0,0,0,1,1,2,3,4,5,6,7], 900, 1, 400, speed - 2, 0);
			LM.curvCreator(pos, pLvl,8,8,0,"enemy","Default2A",700,300,100,150,speed - 4,0,"BLOCKER");
			LM.circCreator(pos, pLvl,5,"enemy","DefaultA2",1000,100,80,speed - 4,0,"DEFAULT");
			LM.curvCreator(pos + 600, pLvl,8,8,0,"enemy","Default2A",700,300,100,150,speed - 4,0,"BLOCKER");
			LM.circCreator(pos + 600, pLvl,5,"enemy","DefaultA2",1600,500,80,speed - 4,0,"DEFAULT");
			LM.curvCreator(pos + 1200, pLvl,8,8,0,"enemy","Default2A",700,300,100,150,speed - 4,0,"BLOCKER");
			LM.lineCreator(pos + 1200, pLvl, 2, "enemy", "TrackerA",700, 150, 200, 300, speed - 4, 0, "TRACKER");
		}
		
		
		/**
		 *	WAVE: move with speed
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PRAAM		pos			Number			starting distance poistion of this formation
		 *	@PARAM		easy		Boolean			if set to true show items to make this wave easier
		 **/
		public static function speedTrack(pLvl:Array, pos:Number, easy:Boolean = true):void
		{
			LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 700, 1, 200, speed - 4, 0, "BLOCKER");
			LM.custCreator(pos, pLvl, 8, "enemy", "Default2A", 800, 1, 200, speed - 4, 0, "BLOCKER");
			LM.custCreatorR(pos + 200,pLvl, 7 ,"helper",[0,0,0,0,0,0,1,1,1,1,1,2,3,4,5],700, 1, 400, speed - 4, 0);			
			LM.custCreator(pos + 400, pLvl, 3, "enemy", "DefaultA2",700, 1, 400, -16, 0, "DEFAULT");
			LM.custCreator(pos + 1000, pLvl, 3, "enemy", "DefaultA2",700, 1, 400, -16, 0, "DEFAULT");
			if (easy)
			{
				LM.lineCreator(pos + 1200, pLvl, 2, "enemy", "TrackerA2",700, 100, 600, 400,  -14, 0, "TRACKER");
			}
			else
			{
				LM.lineCreator(pos + 1200, pLvl, 2, "enemy", "ShooterA",700, 100, 600, 400,  -14, 0, "SHOOTER");
			}
		}
		
		
		/**
		 *	WAVE: move with speed
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PRAAM		pos			Number			starting distance poistion of this formation
		 *	@PARAM		easy		Boolean			if set to true show items to make this wave easier
		 **/
		public static function speedTrack2(pLvl:Array, pos:Number, easy:Boolean = true):void
		{
			LM.lineCreator(pos, pLvl, 16, "helper", "Helper_SpeedUp",700, 50, 0, 60, speed, 0,"SPEED_UP");
		}
		
		/**
		 *	WAVE: basic reward for clearing level
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PRAAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function walmart_target(pLvl:Array, pos:Number):void
		{
			LM.circCreator(pos, pLvl,8,"helper","Helper_Heal",800,300,80,speed,0,"HEAL");
			LM.circCreator(pos, pLvl,16,"helper","Helper_Score",800,300,150,speed,0,"SCORE");
		}
		
		
		/**
		 *	WAVE: basic reward for clearing level
		 *	@PARAM		pLvl		Array 			contains array of enemies and items for a level
		 *	@PRAAM		pos			Number			starting distance poistion of this formation
		 **/
		public static function happy_frog(pLvl:Array, pos:Number):void
		{
			LM.circCreator2(pos,pLvl,8,15, 0,"helper","Helper_Heal",1000,380,80,speed,0,"HEAL");
			LM.circCreator2(pos,pLvl,5,7,Math.PI,"helper","Helper_Heal",940,150,50,speed,0,"HEAL");
			LM.circCreator2(pos,pLvl,5,7,Math.PI,"helper","Helper_Heal",1050,150,50,speed,0,"HEAL");
			LM.circCreator2(pos,pLvl,8,15,Math.PI*.5,"helper","Helper_Heal",850,300,100,speed,0,"HEAL");
			LM.circCreator2(pos,pLvl,8,15,Math.PI* 1.5,"helper","Helper_Heal",1150,300,100,speed,0,"HEAL");
			LM.lineCreator(pos,pLvl, 2, "helper", "Helper_Heal",930, 220, 120, 0, speed, 0, "HEAL");
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