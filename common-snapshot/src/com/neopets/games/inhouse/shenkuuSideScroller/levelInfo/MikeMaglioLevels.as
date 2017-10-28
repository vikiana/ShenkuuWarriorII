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

	
	
	public class MikeMaglioLevels
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------



		public static var speed:Number = GameData.movingSpeed * -1
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MikeMaglioLevels():void
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
		public static function set1A(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,300,480,200,speed,0,"DEFAULT2");
			pLvl.push([pos + 260, "enemy","WallA", 700, 100, speed, 0, 0, 0, "WALL"])
			pLvl.push([pos + 700, "enemy","Default2B", 700, 500, speed, 0, 0, 0, "DEFAULT2"])
			LM.lineCreator(pos + 800, pLvl, 2, "helper","Helper_Score",700,300,120,80,speed,0,"SCORE");
			LM.lineCreator(pos + 800, pLvl, 2, "helper","Helper_Score",940,460,120,-80,speed,0,"SCORE");
			LM.circCreator(pos + 900, pLvl, 3, "enemy", "DefaultB",840, 250, 60, speed, 0, "DEFAULT");
			pLvl.push([pos + 900, "enemy","WallHorizontalA", 800, 100, speed, 0, 0, 0, "WALL_H"])
		}
		
		public static function set1B(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","WallA",750,100,350,130,speed,0,"WALL");
			LM.archCreator(pos, pLvl,7,28,0,"helper","Helper_Score",700,120,280,speed,0,"SCORE");
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2C",850,500,150,-110,speed,0,"DEFAULT2");
			LM.lineCreator(pos + 340, pLvl, 2, "enemy","DefaultA",700,450,80,-140,speed -1,0,"DEFAULT");
			pLvl.push([pos + 600, "enemy","WallVerticalBottomA", 700, 300, speed, 0, 0, 0, "WALL_V"])
		}
		
		public static function set1C(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","WallHorizontalA",750,80,400,480,speed,0,"WALL_H");
			pLvl.push([pos + 100, "enemy","WallVerticalBottomA", 700, 250, speed, 0, 0, 0, "WALL_V"])
			LM.lineCreator(pos + 200, pLvl, 2, "enemy","DefaultA",860,150,150,330,speed-2,0,"DEFAULT");
			pLvl.push([pos + 200, "enemy","Default2A", 1000, 150, speed, 0, 0, 0, "DEFAULT2"])
			LM.lineCreator(pos + 200, pLvl, 2, "helper","Helper_Score",700,200,50,100,speed,0,"SCORE");
			pLvl.push([pos + 370, "helper","Helper_Kill", 700, 400, speed, 0, 0, 0, "KILL"])
			pLvl.push([pos + 400, "enemy","WallVerticalTopA", 700, 350, speed, 0, 0, 0, "WALL_V"])
			LM.lineCreator(pos + 470, pLvl, 2, "helper","Helper_Score",700,450,50,-180,speed,0,"SCORE");
		}
		
		public static function set1D(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,100,350,80,speed,0,"DEFAULT2");
			LM.lineCreator(pos, pLvl, 3, "enemy","DefaultB",700,350,0,60,speed,0,"DEFAULT");
			pLvl.push([pos + 100, "enemy","WallVerticalBottomB", 700, 250, speed, 0, 0, 0, "WALL_V"])
			LM.lineCreator(pos + 240, pLvl, 3, "helper","Helper_Score",700,330,0,90,speed,0,"SCORE");
			pLvl.push([pos + 480, "enemy","Default2C", 700, 450, speed, 0, 0, 0, "DEFAULT2"])
			pLvl.push([pos + 480, "enemy","WallA", 700, 350, speed, 0, 0, 0, "WALL"])
			pLvl.push([pos + 480, "enemy","DefaultA", 800, 220, speed - 2, 0, 0, 0, "DEFAULT"])
			pLvl.push([pos + 480, "enemy","TrackerA", 800, 100, speed - 2, 0, 0, 0, "TRACKER"])
			pLvl.push([pos + 600, "enemy","WallVerticalTopB", 700, 300, speed, 0, 0, 0, "WALL_V"])
			pLvl.push([pos + 600, "helper","Helper_Heal", 700, 350, speed, 0, 0, 0, "HEAL"])
		}
		
		public static function set1E(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","DefaultA",700,-180,100,-80,speed,-speed * .75,"DEFAULT");
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,400,250,30,speed,0,"DEFAULT2");
			LM.lineCreator(pos, pLvl, 3, "helper","Helper_Score",700,300,90,0,speed,0,"SCORE");
			pLvl.push([pos, "helper","Helper_Morph", 1150, 300, speed, 0, 0, 0, "MORPH"]);
			pLvl.push([pos, "helper","Helper_Score", 1240, 300, speed, 0, 0, 0, "SCORE"])
			pLvl.push([pos, "helper","Helper_Heal", 1330, 300, speed, 0, 0, 0, "HEAL"])
			
			pLvl.push([pos + 100, "enemy","WallVerticalBottomA", 700, 450, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 200, "enemy","WallHorizontalA", 900, 380, speed, 0, 0, 0, "WALL_H"]);
			pLvl.push([pos + 400, "enemy","WallVerticalBottomB", 700, 360, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 600, "enemy","WallA", 700, 160, speed, 0, 0, 0, "WALL"]);
			
			LM.lineCreator(pos + 600, pLvl, 3, "enemy","TrackerA",800,100,0,400,speed -3,0,"TRACKER");
		}
		
		
		////////////////////////Level two ///////////////////////////////
		
		
		public static function set2A(pLvl:Array, pos:Number):void
		{
			LM.archCreator(pos, pLvl,8,13, 0, "helper","Helper_Score", 850, 250, 150, speed, 0, "SCORE");
			LM.archCreator(pos, pLvl,5,13, Math.PI + Math.PI * 3/13, "helper","Helper_Heal", 850, 250, 150, speed, 0, "HEAL");
			LM.archCreator(pos, pLvl,3,4, 0, "helper","Helper_Score", 850, 250, 60, speed, 0, "SCORE");
			LM.archCreator(pos, pLvl,1,4, Math.PI* 1.5, "helper","Helper_Double", 850, 250, 60, speed, 0, "DOUBLE");
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,500,500,-400,speed,0,"DEFAULT2");
			LM.lineCreator(pos + 500, pLvl, 2, "enemy","DefaultA",700,450,40,60,speed -2,0,"DEFAULT");
		}
		
		public static function set2B(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","WallVerticalBottomA",680,340,350,80,speed,0,"WALL_V");
			LM.lineCreator(pos + 50, pLvl, 2, "enemy","Default2A",700,150,350,50,speed,0,"DEFAULT2");
			pLvl.push([pos + 150, "enemy","WallVerticalTopA", 700, 300, speed, 0, 0, 0, "WALL_V"]);
			LM.lineCreator(pos + 160, pLvl, 2, "helper","Helper_Heal",700,390,0,80,speed,0,"HEAL");
			LM.archCreator(pos + 300, pLvl,4,10, Math.PI * 1.5, "helper","Helper_Score", 800, 200, 120, speed, 0, "SCORE");
			pLvl.push([pos + 340, "helper","Helper_Double", 700, 100, speed, 0, 0, 0, "DOUBLE"]);			
			pLvl.push([pos + 500, "helper","Helper_Invincible", 700, 500, speed, 0, 0, 0, "INVINCIBLE"]);
		}
		
		public static function set2C(pLvl:Array, pos:Number):void
		{
			
			LM.lineCreator(pos, pLvl, 3, "enemy","DefaultB",700,80,30,50,speed,0,"DEFAULT");
			LM.lineCreator(pos, pLvl, 2, "enemy","DefaultB",800,105,30,50,speed,0,"DEFAULT");
			LM.lineCreator(pos + 120, pLvl, 2, "enemy","Default2B",700,230,30,100,speed,0,"DEFAULT2");
			LM.lineCreator(pos + 180, pLvl, 2, "enemy","WallVerticalBottomB",700,380,120,-50,speed,0,"WALL_V");
			
			pLvl.push([pos + 230, "helper","Helper_Kill", 700, 130, speed, 0, 0, 0, "KILL"]);
			LM.lineCreator(pos + 270, pLvl, 2, "helper","Helper_Heal",700,250,150,0,speed,0,"HEAL");
			pLvl.push([pos + 330, "enemy", "WallHorizontalA", 850, 150, speed, 0, 0, 0, "WALL_H"]);
			
			LM.lineCreator(pos + 420, pLvl, 2, "helper","Helper_Score",700,380,0,100,speed,0,"SCORE");
			LM.lineCreatorR(pos + 490, pLvl, 7, "helper",[0,0,0,0,0,0,0,1,1,3],700, 80, 90, 3, speed, 0);
			
			pLvl.push([pos + 580, "enemy","TrackerB", 750, 350, speed-2, 0, 0, 0, "TRACKER"]);
			pLvl.push([pos + 600, "enemy", "WallHorizontalA", 850, 150, speed, 0, 0, 0, "WALL_H"]);
		}
		
		public static function set2D(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "WallHorizontalA", 850, 150, speed, 0, 0, 0, "WALL_H"]);
			pLvl.push([pos + 240, "helper", "Helper_Double", 700, 100, speed, 0, 0, 0, "DOUBLE"]);
			LM.lineCreator(pos + 300, pLvl, 2, "helper","Helper_Score",700,100,60,60,speed,0,"SCORE");
			pLvl.push([pos + 300, "enemy", "WallVerticalBottomA", 700, 280, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 480, "enemy", "WallA", 700, 480, speed, 0, 0, 0, "WALL"]);
			pLvl.push([pos + 500, "enemy", "WallVerticalTopA", 700, 300, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 550, "helper", "Helper_Score", 700, 400, speed, 0, 0, 0, "SCORE"]);
			pLvl.push([pos + 620, "helper", "Helper_Morph", 700, 500, speed, 0, 0, 0, "MORPH"]);
			LM.lineCreator(pos + 700, pLvl, 2, "helper","Helper_Score",700,200,150,0,speed,0,"SCORE");
			pLvl.push([pos + 800, "enemy", "WallVerticalBottomB", 700, 280, speed, 0, 0, 0, "WALL_V"]);
			LM.lineCreator(pos + 800, pLvl, 2, "enemy","TrackerA",750,120,200,350,speed-2,0,"TRACKER");
			LM.lineCreator(pos + 900, pLvl, 2, "enemy","DefaultC",780,300,80,150,speed-2,0,"DEFAULT");
			LM.lineCreator(pos + 1000, pLvl, 2, "helper","Helper_Heal",700,450,0,80,speed,0,"HEAL");
			pLvl.push([pos + 1000, "enemy", "WallVerticalTopB", 700, 300, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 1400, "enemy", "WallHorizontalA", 850, 300, speed, 0, 0, 0, "WALL_H"]);
		}
		
		public static function set2E(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "WallHorizontalA", 850, 370, speed, 0, 0, 0, "WALL_H"]);
			LM.lineCreator(pos, pLvl, 2, "enemy","ShooterA",900,500,650,-400,speed-1,0,"SHOOTER");
			pLvl.push([pos + 80, "helper", "Helper_Heal", 700, 100, speed, 0, 0, 0, "HEAL"]);
			LM.lineCreator(pos + 250, pLvl, 2, "helper","Helper_Score",700,300,100,-150,speed,0,"SCORE");
			LM.lineCreator(pos + 250, pLvl, 2, "enemy","WallVerticalTopB",700,250,550,0,speed,0,"WALL_V");
			
			pLvl.push([pos +  400, "helper", "Helper_Invincible", 700, 100, speed, 0, 0, 0, "INVINCIBLE"]);
			pLvl.push([pos +  400, "helper", "Helper_Double", 700, 450, speed, 0, 0, 0, "DOUBLE"]);
			LM.lineCreator(pos + 400, pLvl, 2, "helper","Helper_Score",700,400,0,-50,speed, 0,"SCORE");
			pLvl.push([pos +  500, "enemy", "WallA", 700, 200, speed, 0, 0, 0, "WALL"]);
			
			
			
			pLvl.push([pos +  550, "enemy", "DefaultC", 800, 200, speed-2, -speed * .3, 0, 0, "DEFAULT"]);
			
			pLvl.push([pos + 570, "enemy", "WallVerticalBottomA", 700, 330, speed, 0, 0, 0, "WALL_V"]);
			
			pLvl.push([pos +  600, "enemy", "TrackerA", 950, 300, speed -2, 0, 0, 0, "TRACKER"]);
			
			LM.lineCreator(pos + 670, pLvl, 2, "helper","Helper_Heal",700,400,0,60,speed,0,"HEAL");
		}
		
		public static function set2F(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "KillerB", 800, 360, speed - 3, 0, 0, 0, "KILLER"]);
			LM.circCreator(pos + 450, pLvl, 4, "helper", "Helper_Score",820, 350, 170, speed, 0, "SCORE");
			
			pLvl.push([pos + 600, "enemy", "ShooterB", 700, 300, speed, 0, 0, 0, "DESTROYER"]);
			pLvl.push([pos + 800, "enemy", "ShooterA", 800, 450, speed-2, 0, 0, 0, "SHOOTER"]);
			
			pLvl.push([pos + 600, "enemy", "WallA", 700, 100, speed, 0, 0, 0, "WALL"]);
		}
		
		
		
		////////////////////////Level three ///////////////////////////////
		
		public static function set3A(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 5, "helper","Helper_Heal",700,180,90,0,speed,0,"HEAL");
			LM.lineCreator(pos, pLvl, 5, "helper","Helper_Score",700,300,90,0,speed,0,"SCORE");
			LM.lineCreator(pos, pLvl, 5, "helper","Helper_Heal",880,420,90,0,speed,0,"HEAL");
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,420,480,-240,speed,0,"DEFAULT2");
			pLvl.push([pos + 360, "helper", "Helper_Invincible", 700,100, speed, 0, 0, 0, "INVINCIBLE"]);
			LM.lineCreator(pos + 480, pLvl, 2, "enemy","DefaultB",700,100,60,40,speed,0,"DEFAULT");
			pLvl.push([pos + 540, "enemy", "DefaultA", 800, 480, speed - 2, 0, 0, 0, "DEFAULT"]);
		}
		
		public static function set3B(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "WallVerticalBottomB", 670,380, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos, "enemy", "WallA", 700,100, speed, 0, 0, 0, "WALL"]);
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,250,600,0,speed,0,"DEFAULT2");
			LM.lineCreator(pos + 50, pLvl, 2, "helper","Helper_Score",700,150,480,0,speed,0,"SCORE");
			LM.lineCreator(pos + 50, pLvl, 2, "helper","Helper_Score",700,400,500,0,speed,0,"SCORE");
			pLvl.push([pos + 300, "helper", "Helper_Double", 700,250, speed, 0, 0, 0, "DOUBLE"]);
			LM.lineCreator(pos + 300, pLvl, 2, "enemy","WallA",700,350,320,180,speed,0,"WALL");
			LM.lineCreator(pos + 300, pLvl, 2, "enemy","ShooterA",800,100,200,400,speed-2,0,"SHOOTER");
			pLvl.push([pos + 600, "enemy", "DefaultC", 780,200, speed - 2, 0, 0, 0, "DEFAULT"]);
			pLvl.push([pos + 700, "enemy", "TrackerB", 780,400, speed - 2, 0, 0, 0, "TRACKER"]);
		}
		
		public static function set3C(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "WallVerticalBottomB", 700,350, speed, 0, 0, 0, "WALL_V"]);
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,100,350,350,speed,0,"DEFAULT2");
			pLvl.push([pos + 100, "enemy", "WallA", 700,180, speed, 0, 0, 0, "WALL"]);
			pLvl.push([pos + 150, "helper", "Helper_Score", 700,450, speed, 0, 0, 0, "SCORE"]);
			pLvl.push([pos + 300, "helper", "Helper_Invincible", 700,180, speed, 0, 0, 0, "INVINCIBLE"]);
			pLvl.push([pos + 300, "helper", "Helper_Morph", 700,80, speed, 0, 0, 0, "MORPH"]);
			LM.lineCreator(pos + 380, pLvl, 2, "enemy","ShooterA",780,300,250,-200,speed - 2,0,"SHOOTER");
			pLvl.push([pos + 500, "helper", "Helper_Heal", 700,420, speed, 0, 0, 0, "HEAL"]);
			pLvl.push([pos + 700, "enemy", "WallVerticalBottomA", 700,400, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 780, "enemy", "KillerB", 780,250, speed - 1, 0, 0, 0, "KILLER"]);
			LM.lineCreator(pos + 800, pLvl, 3, "enemy","TrackerA",770,140,100,120,speed - 2,0,"TRACKER");
			pLvl.push([pos + 800, "enemy", "DefaultC", 700,500, speed -4, 0, 0, 0, "DEFAULT"]);
		}
		
		public static function set3D(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","WallA",700,200,0,300,speed,0,"WALL");
			LM.lineCreator(pos + 150, pLvl, 2, "helper","Helper_Score",700,200,200,300,speed,0,"SCORE");
			LM.lineCreator(pos + 100, pLvl, 2, "enemy","Default2A",700,100,500,0,speed,0,"DEFAULT2");
			
			pLvl.push([pos + 300, "enemy", "WallVerticalTopA", 700, 230, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 450, "enemy", "ShooterB", 700, 350, speed * .5, 0, 0, 0, "DESTROYER"]);
			
			pLvl.push([pos + 500, "helper", "Helper_Double", 700, 100, speed, 0, 0, 0, "DOUBLE"]);
			LM.lineCreator(pos + 700, pLvl, 2, "enemy","TrackerB",780,500,100,-200,speed-2,0,"TRACKER");
			pLvl.push([pos + 700, "enemy", "WallA", 700, 500, speed, 0, 0, 0, "WALL"]);
			pLvl.push([pos + 800, "helper", "Helper_Heal", 700, 500, speed, 0, 0, 0, "HEAL"]);
			
		}
		
		public static function set3E(pLvl:Array, pos:Number):void
		{
			LM.lineCreator(pos, pLvl, 2, "enemy","Default2A",700,400,300,100,speed,0,"DEFAULT2");			
			LM.archCreator(pos, pLvl,4,25, Math.PI * 1.7, "helper","Helper_Heal", 600, 450, 300, speed, 0, "HEAL");
			LM.archCreator(pos + 100, pLvl,5,25, 0, "helper","Helper_Score", 720, 230, 240, speed, 0, "SCORE");
			pLvl.push([pos + 200, "helper", "Helper_Double", 700, 450, speed, 0, 0, 0, "DOUBLE"]);
			pLvl.push([pos + 300, "helper", "Helper_Invincible", 700, 100, speed, 0, 0, 0, "INVINCIBLE"]);
			
			LM.circCreator(pos + 550, pLvl, 3, "enemy", "DefaultB",740, 480, 60, speed, 0, "DEFAULT");
			pLvl.push([pos + 650, "enemy", "KillerA", 780, 300, speed-2, 0, 0, 0, "KILLER"]);
		}
		
		public static function set3F(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "WallVerticalBottomA", 700,300, speed, 0, 0, 0, "WALL_V"]);
			LM.lineCreator(pos + 50, pLvl, 2, "enemy","WallA",700,100,400,300,speed,0,"WALL");
			LM.lineCreator(pos + 50, pLvl, 2, "enemy","DefaultA",700,-180,200,-80,speed,-speed *.75,"DEFAULT");
			LM.lineCreator(pos + 120, pLvl, 2, "helper","Helper_Score",700,320,480,80,speed,0,"SCORE");
			pLvl.push([pos + 160, "helper", "Helper_Morph", 700,400, speed, 0, 0, 0, "MORPH"]);
			LM.lineCreator(pos + 180, pLvl, 2, "helper","Helper_Score",700,100,220,0,speed,0,"SCORE");
			pLvl.push([pos + 280, "enemy", "WallVerticalBottomB", 700,350, speed, 0, 0, 0, "WALL_V"]);
			LM.lineCreator(pos + 320, pLvl, 2, "enemy","Default2C",700,100,450,150,speed,0,"DEFAULT2");
			pLvl.push([pos + 380, "helper", "Helper_Kill", 700,550, speed, 0, 0, 0, "KILL"]);
			pLvl.push([pos + 600, "enemy", "WallVerticalTopA", 700,300, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 600, "enemy", "WallHorizontalA", 850,480, speed, 0, 0, 0, "WALL_H"]);
			pLvl.push([pos + 640, "helper", "Helper_Double", 700,550, speed, 0, 0, 0, "DOUBLE"]);
			LM.lineCreator(pos + 750, pLvl, 2, "helper","Helper_Heal",700,100,0,80,speed,0,"HEAL");
			LM.lineCreator(pos + 700, pLvl, 3, "helper","Helper_Score",700,550,60,0,speed,0,"SCORE");
			LM.lineCreator(pos + 900, pLvl, 2, "enemy","TrackerA",780,100,0,100,speed-2,0,"TRACKER");
			pLvl.push([pos + 900, "enemy", "TrackerB", 780,500, speed - 2, 0, 0, 0, "TRACKER"]);
			LM.lineCreator(pos + 950, pLvl, 2, "enemy","DefaultC",780,300,0,100,speed-2,0,"DEFAULT");
			
		}
		
		public static function set3G(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "WallVerticalBottomA", 700,450, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos, "enemy", "Default2A", 700,300, speed, 0, 0, 0, "DEFAULT2"]);
			pLvl.push([pos, "enemy", "WallVerticalTopA", 700,150, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 100, "helper", "Helper_Invincible", 700,480, speed, 0, 0, 0, "INVINCIBLE"]);
			pLvl.push([pos + 100, "helper", "Helper_Double", 700,80, speed, 0, 0, 0, "DOUBLE"]);
			pLvl.push([pos + 100, "helper", "Helper_Score", 700,150, speed, 0, 0, 0, "SCORE"]);
			LM.lineCreator(pos + 250, pLvl, 2, "enemy","Default2A",700,80,250,230,speed,0,"DEFAULT2");
			LM.lineCreator(pos + 250, pLvl, 2, "enemy","WallA",700,160,450,300,speed,0,"WALL");
			LM.lineCreator(pos + 200, pLvl, 2, "enemy","ShooterA",780,280,450,-180,speed-2,0,"SHOOTER");
			pLvl.push([pos + 300, "enemy", "WallVerticalBottomB", 700,350, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 450, "helper", "Helper_Heal", 700,80, speed, 0, 0, 0, "HEAL"]);
			pLvl.push([pos + 450, "helper", "Helper_Score", 700,150, speed, 0, 0, 0, "SCORE"]);
			LM.archCreator(pos + 650, pLvl,5,8,0, "helper","Helper_Score", 750, 460, 90, speed, 0, "SCORE");
			pLvl.push([pos + 600, "enemy", "WallVerticalTopB", 700,150, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 600, "helper", "Helper_Morph", 700,400, speed, 0, 0, 0, "MORPH"]);
			
			pLvl.push([pos + 600, "enemy", "WallVerticalTopB", 700,150, speed, 0, 0, 0, "WALL_V"]);
			
			pLvl.push([pos + 800, "helper", "Helper_Kill", 700,520, speed, 0, 0, 0, "KILL"]);
			
			LM.lineCreator(pos + 800, pLvl, 2, "enemy","DefaultC",780,150,20,200,speed-2,0,"DEFAULT");
			
			LM.circCreator(pos + 900, pLvl, 3, "enemy", "DefaultB",700, 200, 40, speed, 0, "DEFAULT");
			pLvl.push([pos + 900, "enemy", "TrackerA", 700,550, speed -2, 0, 0, 0, "TRACKER"]);
			
			
			
		}
		
		public static function set3H(pLvl:Array, pos:Number):void
		{
			pLvl.push([pos, "enemy", "KillerB", 700,200, speed -3, 0, 0, 0, "KILLER"]);
			pLvl.push([pos, "enemy", "KillerB", 700,400, speed -2, 0, 0, 0, "KILLER"]);
			LM.lineCreator(pos, pLvl, 3, "enemy","DefaultA",700,-180,200,-80,speed,-speed * .75,"DEFAULT");
			pLvl.push([pos, "enemy", "WallVerticalBottomA", 700,260, speed, 0, 0, 0, "WALL_V"]);
			pLvl.push([pos + 80, "helper", "Helper_Invincible", 700,480, speed, 0, 0, 0, "INVINCIBLE"]);
			pLvl.push([pos + 80, "helper", "Helper_Score", 700,530, speed, 0, 0, 0, "SCORE"]);
			LM.lineCreator(pos + 250, pLvl, 1, "enemy","ShooterB",780,180,200,300,speed,0,"DESTROYER");
			LM.lineCreator(pos + 350, pLvl, 2, "enemy","ShooterA",780,100,600,500,speed - 2,0,"SHOOTER");
			LM.lineCreator(pos + 350, pLvl, 2, "enemy","WallA",700,500,350,-200,speed,0,"WALL");
			LM.lineCreator(pos + 600, pLvl, 2, "helper","Helper_Score",700,100,0,80,speed,0,"SCORE");
			LM.lineCreator(pos + 600, pLvl, 2, "helper","Helper_Score",700,450,80,0,speed,0,"SCORE");
			pLvl.push([pos + 700, "enemy", "WallVerticalTopA", 700,200, speed, 0, 0, 0, "WALL_V"]);
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