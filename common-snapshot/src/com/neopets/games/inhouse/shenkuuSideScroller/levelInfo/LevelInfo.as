/**
 *	ContainsInformation for each level
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

	
	
	public class LevelInfo
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public static var mLevelOne:Array;
		public static var mLevelTwo:Array;
		public static var mLevelThree:Array;
		
		public static var mLevelOneElements:Array;
		public static var mLevelTwoElements:Array;
		public static var mLevelThreeElements:Array;
			
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LevelInfo():void
		{			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		*	Init all levels
		**/
		public static function init():void
		{
			setLevelOne()
			setLevelTwo()
			setLevelThree()
		}
		
		/**
		*	reset levels (empty level arrays)
		**/
		public static function resetLevels():void
		{
			mLevelOne = [];
			mLevelTwo = [];
			mLevelThree = [];
		}
		
		/**
		*	set up level 1
		**/
		public static function setLevelOne():void
		{
			mLevelOne = [];
			mLevelOne.push([0, "marker", "Marker_Dock1",180, 350, -4, 0, 0, 0, "DUMMY"])
			
			
			FillerLevels.set1A(mLevelOne, 0) //1700
			FillerLevels.set1B(mLevelOne, 1700) //2700
			
			MikeMaglioLevels.set1A(mLevelOne, 4400); //1500
			MikeMaglioLevels.set1B(mLevelOne, 5900); //800
			MikeMaglioLevels.set1C(mLevelOne, 6700); // 900
			MikeMaglioLevels.set1D(mLevelOne, 7600); // 1000
			MikeMaglioLevels.set1E(mLevelOne, 8600); //1500
			
			mLevelOne.push([10100, "marker", "Marker_Flag",700, 450, -4, 0, 0, 0, "LEVEL_END"])
			mLevelOneElements = [["BackdropA","BG1","MG1","FG1"]]
			
		}
		
		/**
		*	set up level 2
		**/
		public static function setLevelTwo():void
		{
			
			mLevelTwo = []
			
			MikeMaglioLevels.set2A(mLevelTwo, 0); //1000
			MikeMaglioLevels.set2B(mLevelTwo, 1000); //1000
			LevelCreator.advCrossMove(mLevelTwo, 2000) //1400
			MikeMaglioLevels.set2C(mLevelTwo, 3400); //900
			MikeMaglioLevels.set2D(mLevelTwo, 4300); //1700
			
			MikeMaglioLevels.set2E(mLevelTwo, 6000); //1200
			MikeMaglioLevels.set2F(mLevelTwo, 7200); //1500
			LevelCreator.ultimateCrossMove(mLevelTwo, 9000)//3300
			MikeMaglioLevels.set2F(mLevelTwo, 12300); //1500
			mLevelTwo.push([13800, "marker", "Marker_Flag",700, 450, -4, 0, 0, 0, "LEVEL_END"])

			mLevelTwoElements = [["BackdropB","BG2","MG2","FG2"]]
			
		}
		
		
		/**
		*	set up level 3
		**/
		public static function setLevelThree():void
		{
			mLevelThree= []
			
			LevelCreator.happy_frog(mLevelThree, 0); //900
			MikeMaglioLevels.set3A(mLevelThree, 900); //900
			MikeMaglioLevels.set3B(mLevelThree, 1900);//1000
			FillerLevels.set3A(mLevelThree, 2900);//2100
			MikeMaglioLevels.set3C(mLevelThree, 5000); //1200
			
			MikeMaglioLevels.set3D(mLevelThree,6200); //1600			
			MikeMaglioLevels.set3E(mLevelThree, 7800); //1000
			
			MikeMaglioLevels.set3F(mLevelThree, 8800); //1500
			
			MikeMaglioLevels.set3G(mLevelThree, 10300); //1500
			MikeMaglioLevels.set3H(mLevelThree, 11800); //1400
			
			mLevelThree.push([13200, "weather", "snow", 10]);
			FillerLevels.set3B(mLevelThree, 13200)
			mLevelThree.push([13700, "weather", "snow", 20]);
			mLevelThree.push([15700, "weather", "snow", 35]);
			FillerLevels.set3C(mLevelThree, 16700)
			
			FillerLevels.set3D(mLevelThree, 21000)
			FillerLevels.set3E(mLevelThree, 31000)
			FillerLevels.set3F(mLevelThree, 41000)
			
			mLevelThree.push([50000, "weather", "none", 0]);
			
			mLevelThree.push([51000, "marker", "Marker_Dock2",700, 450, -4, 0, 0, 0, "GAME_END"])
			
			mLevelThreeElements = [["BackdropC","BG3","MG3","FG3"]]
			
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