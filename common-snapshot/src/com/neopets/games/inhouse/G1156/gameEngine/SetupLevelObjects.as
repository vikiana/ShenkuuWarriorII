
/* AS3
	Copyright 2009
*/

package  com.neopets.games.inhouse.G1156.gameEngine
{
	import com.neopets.games.inhouse.G1156.displayObjects.JumperObj;
	import com.neopets.games.inhouse.G1156.displayObjects.MapSection;
	import com.neopets.games.inhouse.G1156.displayObjects.MovingObstacle;
	import com.neopets.games.inhouse.G1156.displayObjects.Obstacle;
	import com.neopets.games.inhouse.G1156.displayObjects.PowerUp;
	import com.neopets.games.inhouse.G1156.document.G1156_AssetDocument;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	
	/**
	 *	This is for setting objects up on a Map Section
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  3.04.2009
	 */
	public class SetupLevelObjects extends EventDispatcher
	{

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function SetupLevelObjects():void
		{
			super();
		}
		
		

		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	/**
	 * @Note: This is For the Static Obstacles
	 * @param		pMapSection			MapSection					The Map the Object is going to
	 * @param		pJumper				JumperObj					The Map the Object is going to
	 * @param		ptAssetInstance		G1156_AssetDocument	The Document Class to Pull Objects From
	 * @param		pLevel					int									The Current Level
	 */
	 
		public static  function setupStaticObstacles(pMapSection:MapSection, pJumper:JumperObj, ptAssetInstance:G1156_AssetDocument, pLevel:int = 1):MapSection
		{
			var tRandomNum:int;
			var tRandomObstacleNum:int;
			var tAssetInstance:G1156_AssetDocument = ptAssetInstance;
			var tJumperObj:JumperObj = pJumper;
			var tCurrentLevel:int = pLevel;
			
			switch (pMapSection.mBaseClass)
			{
				case G1156_AssetDocument.WALL_TYPE_1:
					tRandomObstacleNum  = Math.floor((Math.random() * 3) + 1);
				break;
				case G1156_AssetDocument.WALL_TYPE_2:
					tRandomObstacleNum  = Math.floor((Math.random() * 5) + 1);
				break;
				case G1156_AssetDocument.WALL_TYPE_END:
					tRandomObstacleNum  = Math.floor((Math.random() * 2) + 1);
				break;
				default:
					tRandomObstacleNum  = Math.floor((Math.random() * 3) + 1);
				break;
			}	
			
			for (var q:int = 0; q < tRandomObstacleNum; q++)
			{
				
				tRandomNum = Math.floor(Math.random() * 2);
				
				var tPlacementRandom:int;
				var tObstacle:Obstacle;
				var tObstacleX:int;
				var tObstacleY:int;
				
	
				
				switch (tRandomNum)
				{
					case 1:
						tObstacle =	tAssetInstance.getLibraryObject("RockObstacle_1",Obstacle) as Obstacle; 
						tObstacle.mBaseType = "Obstacle_1";
						tObstacle.gotoAndStop(tCurrentLevel);
					break;
					default:
						tObstacle =	tAssetInstance.getLibraryObject("RockObstacle_2",Obstacle) as Obstacle; 
						tObstacle.mBaseType = "Obstacle_2";
						tObstacle.gotoAndStop(tCurrentLevel);
					break;
				}
				
				tObstacle.setCollisionList(tJumperObj);
				tObstacle.id = "Obstacle_" + pMapSection.id + "_o"+ q;
				
				
				
				switch (pMapSection.mBaseClass)
				{
					case G1156_AssetDocument.WALL_TYPE_2:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 208.65;
									tObstacleY = 240.25;
								break;
								case 0:
									tObstacleX = 97.70;
									tObstacleY = 757.35;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 492.90;
									tObstacleY = 87.70;
								break;
								case 0:
									tObstacleX = 432.90;
									tObstacleY = 633.50;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_6:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 208.60;
									tObstacleY = 172.30;
								break;
								case 0:
									tObstacleX = 97.70;
									tObstacleY = 757.35;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 533.50;
									tObstacleY = 123.70;
								break;
								case 0:
									tObstacleX = 487.70;
									tObstacleY = 531.35;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_7:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 249.75;
									tObstacleY = 331.20;
								break;
								case 0:
									tObstacleX = 227.65;
									tObstacleY = 533.40;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 408.95;
									tObstacleY = 218.20;
								break;
								case 0:
									tObstacleX = 432.90;
									tObstacleY = 665.50;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_8:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 164.60;
									tObstacleY = 404.20;
								break;
								case 0:
									tObstacleX = 188.20;
									tObstacleY = 717.40;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 352.15;
									tObstacleY = 268.65;
								break;
								case 0:
									tObstacleX = 419.55;
									tObstacleY = 705.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_9:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 374.55;
									tObstacleY = 314.65
								break;
								case 0:
									tObstacleX = 139.65;
									tObstacleY = 781.30;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 567.75;
									tObstacleY = 288.95;
								break;
								case 0:
									tObstacleX = 337.70;
									tObstacleY = 656.40;
								break;	
							}	
						}
						
					break;
					
					case G1156_AssetDocument.WALL_TYPE_10:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 79.65;
									tObstacleY = 373.55;
								break;
								case 0:
									tObstacleX = 66.65;
									tObstacleY = 931.40;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 543.80;
									tObstacleY = 238.40;
								break;
								case 0:
									tObstacleX = 444.85;
									tObstacleY = 771.30;
								break;	
							}	
						}
						
					break;
					
					case G1156_AssetDocument.WALL_TYPE_5:		//Long Wall Section
					
						tPlacementRandom = Math.floor(Math.random() *3);

						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 2:
									tObstacleX = 135.60;
									tObstacleY = 443.45;
								break;	
								case 1:
									tObstacleX = 155.55;
									tObstacleY = 1035.25;
								break;
								case 0:
									tObstacleX = 127.65;
									tObstacleY = 1547.05;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 2:
									tObstacleX = 559.60;
									tObstacleY = 222.35;
								break;	
								case 1:
									tObstacleX = 443.60;
									tObstacleY = 772.10;
								break;
								case 0:
									tObstacleX = 1289.95;
									tObstacleY = 124.50;
								break;	
							}	
						}
						
						
					break;
					case G1156_AssetDocument.WALL_TYPE_END:
						tPlacementRandom = Math.floor(Math.random() *2);
					
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 280.65;
									tObstacleY =292.55;
								break;
								case 0:
									tObstacleX = 70.10;
									tObstacleY = 710.30;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 602.90;
									tObstacleY = 421.60;
								break;
								case 0:
									tObstacleX = 404.90;
									tObstacleY = 671.10;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_END_L2:
					case G1156_AssetDocument.WALL_TYPE_1_L2:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 269.20;
									tObstacleY = 255.85;
								break;
								case 0:
									tObstacleX = 122.10;
									tObstacleY = 776.20;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 500.85;
									tObstacleY = 243.75;
								break;
								case 0:
									tObstacleX = 392.90;
									tObstacleY = 561.35;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_2_L2:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 245.20;
									tObstacleY = 339.85;
								break;
								case 0:
									tObstacleX = 218.40;
									tObstacleY = 528.20;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 473.85;
									tObstacleY = 454.25;
								break;
								case 0:
									tObstacleX = 420.90;
									tObstacleY = 692.35;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_3_L2:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 198.10;
									tObstacleY = 468.25;
								break;
								case 0:
									tObstacleX =261.10;
									tObstacleY = 547.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 375.85;
									tObstacleY = 221.75;
								break;
								case 0:
									tObstacleX = 491.55;
									tObstacleY = 627.75;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_4_L2:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 369.40;
									tObstacleY = 382.85;
								break;
								case 0:
									tObstacleX = 98.10;
									tObstacleY = 793.20;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 482.85;
									tObstacleY = 112.75;
								break;
								case 0:
									tObstacleX =392.45;
									tObstacleY = 692.25;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_5_L2:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 3211.20;
									tObstacleY = 298.85;
								break;
								case 0:
									tObstacleX =278.40;
									tObstacleY = 547.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 436.85;
									tObstacleY = 263.25;
								break;
								case 0:
									tObstacleX =429.90;
									tObstacleY = 837.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_1_L3:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 212.20;
									tObstacleY = 158.85;
								break;
								case 0:
									tObstacleX =145.40;
									tObstacleY = 857.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 470.85;
									tObstacleY = 454.25;
								break;
								case 0:
									tObstacleX =375.90;
									tObstacleY = 791.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_2_L3:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 199.20;
									tObstacleY = 451.85;
								break;
								case 0:
									tObstacleX =116.40;
									tObstacleY = 729.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 470.85;
									tObstacleY = 454.25;
								break;
								case 0:
									tObstacleX =375.90;
									tObstacleY = 791.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_3_L3:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 198.20;
									tObstacleY = 178.85;
								break;
								case 0:
									tObstacleX =137.40;
									tObstacleY = 785.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 499.85;
									tObstacleY = 243.25;
								break;
								case 0:
									tObstacleX =455.90;
									tObstacleY = 589.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_4_L3:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 369.20;
									tObstacleY = 382.85;
								break;
								case 0:
									tObstacleX =80.40;
									tObstacleY = 725.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 509.85;
									tObstacleY = 208.25;
								break;
								case 0:
									tObstacleX =392.90;
									tObstacleY = 686.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_5_L3:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 249.20;
									tObstacleY = 248.85;
								break;
								case 0:
									tObstacleX = 144.40;
									tObstacleY = 788.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 564.85;
									tObstacleY = 380.25;
								break;
								case 0:
									tObstacleX = 456.90;
									tObstacleY = 619.30;
								break;	
							}	
						}
						
					break;
					case G1156_AssetDocument.WALL_TYPE_END_L3:
					
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 198.20;
									tObstacleY = 178.85;
								break;
								case 0:
									tObstacleX = 137.40;
									tObstacleY = 785.95;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 499.85;
									tObstacleY = 243.25;
								break;
								case 0:
									tObstacleX = 455.90;
									tObstacleY = 589.30;
								break;	
							}	
						}
						
					break;
					default:
						tPlacementRandom = Math.floor(Math.random() *2);
						
						if (tObstacle.mBaseType == "Obstacle_1")
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 79.65;
									tObstacleY = 373.55;
								break;
								case 0:
									tObstacleX = 66.65;
									tObstacleY = 931.40;
								break;	
							}
						}
						else
						{
							switch (tPlacementRandom)
							{
								case 1:
									tObstacleX = 543.80;
									tObstacleY = 238.40;
								break;
								case 0:
									tObstacleX = 444.85;
									tObstacleY = 771.30;
								break;	
							}	
						}
					
					break;
				}
	
				tObstacle.x = tObstacleX;
				tObstacle.y = tObstacleY;
				
				pMapSection.addChildAt(tObstacle,pMapSection.numChildren);
			}
				
				return pMapSection;
		}
	
	/**
	 * @Note: This is For the Moving Obstacles
	 * @param		pMapSection			MapSection					The Map the Object is going to
	 * @param		pJumper				JumperObj					The Map the Object is going to
	 * @param		ptAssetInstance		G1156_AssetDocument	The Document Class to Pull Objects From
	 */
	 
		public static  function setupMovingObstacles(pMapSection:MapSection, pJumper:JumperObj,ptAssetInstance:G1156_AssetDocument, pLevel:int = 1):MapSection
		{		
				
				var tRandomMovingObstacleNum:int = Math.floor((Math.random() *3) + 2 + pLevel );	;
				tRandomMovingObstacleNum = (tRandomMovingObstacleNum > 6) ? 6 : tRandomMovingObstacleNum;

				var tAssetInstance:G1156_AssetDocument = ptAssetInstance;
				var tRandomNum:int;
				var tJumperObj:JumperObj = pJumper;
				
				for (var x:int = 0; x < tRandomMovingObstacleNum; x++)
				{
					var tRandomNum2:int = Math.floor(Math.random() *3);
					var tMovingObstacle:MovingObstacle;
					switch (pLevel)
					{
						case 1:
							switch (tRandomNum2) 
							{
								case 2:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle4",MovingObstacle) as MovingObstacle; 
								break;
								case 1:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle3",MovingObstacle) as MovingObstacle; 
								break;
								default:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle1",MovingObstacle) as MovingObstacle; 
								break;
							}
						break;
						case 2:
							switch (tRandomNum2) 
							{
								case 2:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle5",MovingObstacle) as MovingObstacle; 
								break;
								case 1:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle6",MovingObstacle) as MovingObstacle; 
								break;
								default:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle7",MovingObstacle) as MovingObstacle; 
								break;
							}
						break;
						case 3:
							switch (tRandomNum2) 
							{
								case 2:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle8",MovingObstacle) as MovingObstacle; 
								break;
								case 1:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle9",MovingObstacle) as MovingObstacle; 
								break;
								default:
									tMovingObstacle = 	tAssetInstance.getLibraryObject("MovingObstacle2",MovingObstacle) as MovingObstacle; 
								break;
							}
						break;
					}
					
					
					tMovingObstacle.setCollisionList(tJumperObj);
					tMovingObstacle.setWallCollisionList([pMapSection.leftWall, pMapSection.rightWall]);
					tMovingObstacle.id = "MovingObstacle_" + pMapSection.id + "_o"+ x;
					
				switch (pMapSection.mBaseClass)
				{
					case G1156_AssetDocument.WALL_TYPE_1_L2:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 287;
								tMovingObstacle.y = 73;	
							break;
							case 1:
								tMovingObstacle.x = 425;
								tMovingObstacle.y = 159;	
							break;
							case 2:
								tMovingObstacle.x = 404;
								tMovingObstacle.y = 306;	
							break;
							case 3:
								tMovingObstacle.x = 304;
								tMovingObstacle.y = 402;	
							break;
							case 4:
								tMovingObstacle.x = 175;
								tMovingObstacle.y = 567;	
							break;
							default:
								tMovingObstacle.x = 271;
								tMovingObstacle.y = 741;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_2_L2:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 287;
								tMovingObstacle.y = 73;	
							break;
							case 1:
								tMovingObstacle.x = 381;
								tMovingObstacle.y = 159;	
							break;
							case 2:
								tMovingObstacle.x = 404;
								tMovingObstacle.y = 306;	
							break;
							case 3:
								tMovingObstacle.x = 304;
								tMovingObstacle.y = 402;	
							break;
							case 4:
								tMovingObstacle.x = 267;
								tMovingObstacle.y = 567;	
							break;
							default:
								tMovingObstacle.x = 271;
								tMovingObstacle.y = 741;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_4_L2:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 216;
								tMovingObstacle.y = 889;	
							break;
							case 1:
								tMovingObstacle.x = 381;
								tMovingObstacle.y = 817;	
							break;
							case 2:
								tMovingObstacle.x = 525;
								tMovingObstacle.y = 306;	
							break;
							case 3:
								tMovingObstacle.x = 474;
								tMovingObstacle.y = 413;	
							break;
							case 4:
								tMovingObstacle.x = 267;
								tMovingObstacle.y = 567;	
							break;
							default:
								tMovingObstacle.x = 271;
								tMovingObstacle.y = 741;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_3_L2:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 287;
								tMovingObstacle.y = 73;	
							break;
							case 1:
								tMovingObstacle.x = 232;
								tMovingObstacle.y = 222;	
							break;
							case 2:
								tMovingObstacle.x = 318;
								tMovingObstacle.y = 335;	
							break;
							case 3:
								tMovingObstacle.x = 324;
								tMovingObstacle.y = 574;	
							break;
							case 4:
								tMovingObstacle.x = 175;
								tMovingObstacle.y = 679;	
							break;
							default:
								tMovingObstacle.x = 323;
								tMovingObstacle.y = 810;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_5_L2:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 287;
								tMovingObstacle.y = 73;	
							break;
							case 1:
								tMovingObstacle.x = 384;
								tMovingObstacle.y = 222;	
							break;
							case 2:
								tMovingObstacle.x = 375;
								tMovingObstacle.y = 419;	
							break;
							case 3:
								tMovingObstacle.x = 297;
								tMovingObstacle.y = 662;	
							break;
							case 4:
								tMovingObstacle.x = 245;
								tMovingObstacle.y = 795;	
							break;
							default:
								tMovingObstacle.x = 343;
								tMovingObstacle.y = 939;	
							break;
						}
					
					break;
					case G1156_AssetDocument.WALL_TYPE_2:
					case G1156_AssetDocument.WALL_TYPE_5:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 227;
								tMovingObstacle.y = 108;	
							break;
							case 1:
								tMovingObstacle.x = 364;
								tMovingObstacle.y = 214;	
							break;
							case 2:
								tMovingObstacle.x = 458;
								tMovingObstacle.y = 383;	
							break;
							case 3:
								tMovingObstacle.x = 266;
								tMovingObstacle.y = 553;	
							break;
							case 4:
								tMovingObstacle.x = 265;
								tMovingObstacle.y = 669;	
							break;
							default:
								tMovingObstacle.x = 318;
								tMovingObstacle.y = 872;	
							break;
						}		
					break;
						case G1156_AssetDocument.WALL_TYPE_10:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 444;
								tMovingObstacle.y = 536;	
							break;
							case 1:
								tMovingObstacle.x = 195;
								tMovingObstacle.y = 776;	
							break;
							case 2:
								tMovingObstacle.x = 458;
								tMovingObstacle.y = 383;	
							break;
							case 3:
								tMovingObstacle.x = 266;
								tMovingObstacle.y = 553;	
							break;
							case 4:
								tMovingObstacle.x = 265;
								tMovingObstacle.y = 669;	
							break;
							default:
								tMovingObstacle.x = 318;
								tMovingObstacle.y = 872;	
							break;
						}		
					break;
					case G1156_AssetDocument.WALL_TYPE_6:
					switch (x)
						{
							case 0:
								tMovingObstacle.x = 422;
								tMovingObstacle.y = 108;	
							break;
							case 1:
								tMovingObstacle.x = 364;
								tMovingObstacle.y = 214;	
							break;
							case 2:
								tMovingObstacle.x = 428;
								tMovingObstacle.y = 383;	
							break;
							case 3:
								tMovingObstacle.x = 310;
								tMovingObstacle.y = 553;	
							break;
							case 4:
								tMovingObstacle.x = 265;
								tMovingObstacle.y = 669;	
							break;
							default:
								tMovingObstacle.x = 318;
								tMovingObstacle.y = 872;	
							break;
						}
							
					break;
					case 	G1156_AssetDocument.WALL_TYPE_7:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 227;
								tMovingObstacle.y = 108;	
							break;
							case 1:
								tMovingObstacle.x = 364;
								tMovingObstacle.y = 214;	
							break;
							case 2:
								tMovingObstacle.x = 458;
								tMovingObstacle.y = 383;	
							break;
							case 3:
								tMovingObstacle.x = 269;
								tMovingObstacle.y = 553;	
							break;
							case 4:
								tMovingObstacle.x = 265;
								tMovingObstacle.y = 669;	
							break;
							default:
								tMovingObstacle.x = 318;
								tMovingObstacle.y = 872;	
							break;
						}
					break;
					case 	G1156_AssetDocument.WALL_TYPE_8:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 227;
								tMovingObstacle.y = 108;	
							break;
							case 1:
								tMovingObstacle.x = 319;
								tMovingObstacle.y = 214;	
							break;
							case 2:
								tMovingObstacle.x = 346;
								tMovingObstacle.y = 383;	
							break;
							case 3:
								tMovingObstacle.x = 303;
								tMovingObstacle.y = 553;	
							break;
							case 4:
								tMovingObstacle.x = 265;
								tMovingObstacle.y = 669;	
							break;
							default:
								tMovingObstacle.x = 318;
								tMovingObstacle.y = 872;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_9:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 371;
								tMovingObstacle.y = 155;	
							break;
							case 1:
								tMovingObstacle.x = 438;
								tMovingObstacle.y = 431;	
							break;
							case 2:
								tMovingObstacle.x = 320;
								tMovingObstacle.y = 588;	
							break;
							case 3:
								tMovingObstacle.x = 225;
								tMovingObstacle.y = 704;	
							break;
							default:
								tMovingObstacle.x = 279;
								tMovingObstacle.y = 835;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_END:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 371;
								tMovingObstacle.y = 155;	
							break;
							case 1:
								tMovingObstacle.x = 425;
								tMovingObstacle.y = 230;	
							break;
							case 2:
								tMovingObstacle.x = 435;
								tMovingObstacle.y = 410;	
							break;
							case 3:
								tMovingObstacle.x = 320;
								tMovingObstacle.y = 588;	
							break;
							default:
								tMovingObstacle.x = 339;
								tMovingObstacle.y = 704;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_END_L3:
					case G1156_AssetDocument.WALL_TYPE_END_L2:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 192;
								tMovingObstacle.y = 28;	
							break;
							case 1:
								tMovingObstacle.x = 503;
								tMovingObstacle.y = 36;	
							break;
							case 2:
								tMovingObstacle.x = 304;
								tMovingObstacle.y = 89;	
							break;
							case 3:
								tMovingObstacle.x = 407;
								tMovingObstacle.y = 275;	
							break;
							case 4:
								tMovingObstacle.x = 298;
								tMovingObstacle.y = 399;	
							break;
							default:
								tMovingObstacle.x = 248;
								tMovingObstacle.y = 468;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_1_L3:
					case G1156_AssetDocument.WALL_TYPE_3_L3:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 192;
								tMovingObstacle.y = 28;	
							break;
							case 1:
								tMovingObstacle.x = 392;
								tMovingObstacle.y = 159;	
							break;
							case 2:
								tMovingObstacle.x = 299;
								tMovingObstacle.y = 257;	
							break;
							case 3:
								tMovingObstacle.x = 410	;
								tMovingObstacle.y = 463;	
							break;
							case 4:
								tMovingObstacle.x = 237	;
								tMovingObstacle.y = 671;	
							break;
							default:
								tMovingObstacle.x = 331;
								tMovingObstacle.y = 841;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_2_L3:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 192;
								tMovingObstacle.y = 28;	
							break;
							case 1:
								tMovingObstacle.x = 247;
								tMovingObstacle.y = 159;	
							break;
							case 2:
								tMovingObstacle.x = 243;
								tMovingObstacle.y = 257;	
							break;
							case 3:
								tMovingObstacle.x = 410	;
								tMovingObstacle.y = 463;	
							break;
							case 4:
								tMovingObstacle.x = 237	;
								tMovingObstacle.y = 671;	
							break;
							default:
								tMovingObstacle.x = 331;
								tMovingObstacle.y = 841;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_5_L3:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 192;
								tMovingObstacle.y = 28;	
							break;
							case 1:
								tMovingObstacle.x = 392;
								tMovingObstacle.y = 159;	
							break;
							case 2:
								tMovingObstacle.x = 427;
								tMovingObstacle.y = 257;	
							break;
							case 3:
								tMovingObstacle.x = 410	;
								tMovingObstacle.y = 463;	
							break;
							case 4:
								tMovingObstacle.x = 237	;
								tMovingObstacle.y = 671;	
							break;
							default:
								tMovingObstacle.x = 331;
								tMovingObstacle.y = 841;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_4_L3:
						switch (x)
						{
							case 0:
								tMovingObstacle.x = 505;
								tMovingObstacle.y = 354;	
							break;
							case 1:
								tMovingObstacle.x = 264;
								tMovingObstacle.y = 763;	
							break;
							case 2:
								tMovingObstacle.x = 427;
								tMovingObstacle.y = 257;	
							break;
							case 3:
								tMovingObstacle.x = 410	;
								tMovingObstacle.y = 463;	
							break;
							case 4:
								tMovingObstacle.x = 237	;
								tMovingObstacle.y = 671;	
							break;
							default:
								tMovingObstacle.x = 331;
								tMovingObstacle.y = 841;	
							break;
						}
					break;
				}
					
					//Place Moving Objects
					
					
					pMapSection.addChildAt(tMovingObstacle,pMapSection.numChildren);
				}
				
				return pMapSection;
		}
		
		
		
	/**
	 * @Note: This is For the PowerUps
	 * @param		pMapSection			MapSection					The Map the Object is going to
	 * @param		pJumper				JumperObj					The Map the Object is going to
	 * @param		ptAssetInstance		G1156_AssetDocument	The Document Class to Pull Objects From
	 */
		
		
		public static  function setupPowerUps(pMapSection:MapSection, pJumper:JumperObj,  ptAssetInstance:G1156_AssetDocument, pLevel:int = 1):MapSection
		{
				var tRandomNum:int;
				var tRandomPowerUpsNum:int = Math.floor((Math.random() *3) + 1 + pLevel );	;
				tRandomPowerUpsNum = (tRandomPowerUpsNum > 6) ? 6 : tRandomPowerUpsNum;

				
			 	var tAssetInstance:G1156_AssetDocument = ptAssetInstance;
			 	var tJumperObj:JumperObj = pJumper;
			 	
				for (var x:int = 0; x < tRandomPowerUpsNum; x++)
				{
					var tPowerUp:PowerUp;
					var tRandomNum2:int = Math.floor(Math.random() * 8) +1 - pLevel;
					
					switch (tRandomNum2) 
					{
						case 7:
						case 6:
						case 5:
						case 4:
							tPowerUp = selectGemType(pLevel,tAssetInstance) 
						break;
						case 3:
							tPowerUp = 	tAssetInstance.getLibraryObject("powerup_time",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_3;
							tPowerUp.scaleX = .75;
							tPowerUp.scaleY = .75;
						break;
						case 2:
							tPowerUp = 	tAssetInstance.getLibraryObject("powerup_points",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_2;
							tPowerUp.scaleX = .75;
							tPowerUp.scaleY = .75;
						break;
						default:
							tPowerUp = 	tAssetInstance.getLibraryObject("powerup_health",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_1;
							tPowerUp.scaleX = .75;
							tPowerUp.scaleY = .75;
						break;
					}
					
					tPowerUp.setCollisionList(tJumperObj);
					tPowerUp.id = "PowerUp_" + pMapSection.id + "_o"+ x;
					
					switch (pMapSection.mBaseClass)
				{
					case G1156_AssetDocument.WALL_TYPE_1_L2:
						switch (x)
						{
							case 0:
								tPowerUp.x = 297;
								tPowerUp.y = 62;	
							break;
							case 1:
								tPowerUp.x = 313;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 351;
								tPowerUp.y = 343;	
							break;
							case 3:
								tPowerUp.x = 250;
								tPowerUp.y = 463;	
							break;
							case 4:
								tPowerUp.x = 152;
								tPowerUp.y = 657;	
							break;
							default:
								tPowerUp.x = 351;
								tPowerUp.y = 849;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_4_L2:
						switch (x)
						{
							case 0:
								tPowerUp.x = 407;
								tPowerUp.y = 277;	
							break;
							case 1:
								tPowerUp.x = 440;
								tPowerUp.y = 502;	
							break;
							case 2:
								tPowerUp.x = 511;
								tPowerUp.y = 374;	
							break;
							case 3:
								tPowerUp.x = 250;
								tPowerUp.y = 463;	
							break;
							case 4:
								tPowerUp.x = 152;
								tPowerUp.y = 657;	
							break;
							default:
								tPowerUp.x = 351;
								tPowerUp.y = 849;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_2_L2:
						switch (x)
						{
							case 0:
								tPowerUp.x = 297;
								tPowerUp.y = 62;	
							break;
							case 1:
								tPowerUp.x = 313;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 351;
								tPowerUp.y = 343;	
							break;
							case 3:
								tPowerUp.x = 308;
								tPowerUp.y = 505;	
							break;
							case 4:
								tPowerUp.x = 190;
								tPowerUp.y = 773;	
							break;
							default:
								tPowerUp.x = 351;
								tPowerUp.y = 849;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_3_L2:
						switch (x)
						{
							case 0:
								tPowerUp.x = 371;
								tPowerUp.y = 81;	
							break;
							case 1:
								tPowerUp.x = 72;
								tPowerUp.y = 257;	
							break;
							case 2:
								tPowerUp.x = 376;
								tPowerUp.y = 397;	
							break;
							case 3:
								tPowerUp.x = 369;
								tPowerUp.y = 656;	
							break;
							case 4:
								tPowerUp.x = 196;
								tPowerUp.y = 849;	
							break;
							default:
								tPowerUp.x = 475;
								tPowerUp.y = 916;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_5_L2:
						switch (x)
						{
							case 0:
								tPowerUp.x = 297;
								tPowerUp.y = 62;	
							break;
							case 1:
								tPowerUp.x = 279;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 342;
								tPowerUp.y = 448;	
							break;
							case 3:
								tPowerUp.x = 358;
								tPowerUp.y = 607;	
							break;
							case 4:
								tPowerUp.x = 255;
								tPowerUp.y = 845;	
							break;
							default:
								tPowerUp.x = 405;
								tPowerUp.y = 960;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_2:
					case G1156_AssetDocument.WALL_TYPE_5:
				
						switch (x)
						{
							case 0:
								tPowerUp.x = 221;
								tPowerUp.y = 92;	
							break;
							case 1:
								tPowerUp.x = 424;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 500;
								tPowerUp.y = 374;	
							break;
							case 3:
								tPowerUp.x = 351;
								tPowerUp.y = 463;	
							break;
							case 4:
								tPowerUp.x = 275;
								tPowerUp.y = 704;	
							break;
							default:
								tPowerUp.x = 200;
								tPowerUp.y = 857;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_10:
							switch (x)
							{
								case 0:
									tPowerUp.x = 393;
									tPowerUp.y = 315;	
								break;
								case 1:
									tPowerUp.x = 284;
									tPowerUp.y = 830;	
								break;
								case 2:
									tPowerUp.x = 197;
									tPowerUp.y = 296;	
								break;
								case 3:
									tPowerUp.x = 432;
									tPowerUp.y = 624;	
								break;
								case 4:
									tPowerUp.x = 95;
									tPowerUp.y = 746;	
								break;
								default:
									tPowerUp.x = 379;
									tPowerUp.y = 964;	
								break;
							}
					break;	
					case G1156_AssetDocument.WALL_TYPE_6:
						switch (x)
						{
							case 0:
								tPowerUp.x = 275;
								tPowerUp.y = 92;	
							break;
							case 1:
								tPowerUp.x = 424;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 351;
								tPowerUp.y = 311;	
							break;
							case 3:
								tPowerUp.x = 351;
								tPowerUp.y = 463;	
							break;
							case 4:
								tPowerUp.x = 172;
								tPowerUp.y = 624;	
							break;
							default:
								tPowerUp.x = 389;
								tPowerUp.y = 843;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_7:
						switch (x)
							{
								case 0:
									tPowerUp.x = 310;
									tPowerUp.y = 217;	
								break;
								case 1:
									tPowerUp.x = 284;
									tPowerUp.y = 170;	
								break;
								case 2:
									tPowerUp.x = 322;
									tPowerUp.y = 311;	
								break;
								case 3:
									tPowerUp.x = 351;
									tPowerUp.y = 463;	
								break;
								case 4:
									tPowerUp.x = 291;
									tPowerUp.y = 690;	
								break;
								default:
									tPowerUp.x = 183;
									tPowerUp.y = 840;	
								break;
							}
					break;
					case G1156_AssetDocument.WALL_TYPE_8:
						switch (x)
							{
								case 0:
									tPowerUp.x = 200;
									tPowerUp.y = 82;	//
								break;
								case 1:
									tPowerUp.x = 196;//
									tPowerUp.y = 135;	
								break;
								case 2:
									tPowerUp.x = 308;
									tPowerUp.y = 852;	
								break;
								case 3:
									tPowerUp.x = 239;//
									tPowerUp.y = 463;	
								break;
								case 4:
									tPowerUp.x = 291;
									tPowerUp.y = 690;	//
								break;
								default:
									tPowerUp.x = 183;
									tPowerUp.y = 840;	//
								break;
							}
					break;
					case G1156_AssetDocument.WALL_TYPE_9:
						switch (x)
						{
							case 0:
								tPowerUp.x = 200;
								tPowerUp.y = 82;	
							break;
							case 1:
								tPowerUp.x = 284;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 471;
								tPowerUp.y = 311;	
							break;
							case 3:
								tPowerUp.x = 351;
								tPowerUp.y = 463;	
							break;
							case 4:
								tPowerUp.x = 141;
								tPowerUp.y = 631;	
							break;
							default:
								tPowerUp.x = 183;
								tPowerUp.y = 840;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_END:
						switch (x)
						{
							case 0:
								tPowerUp.x = 200;
								tPowerUp.y = 82;	
							break;
							case 1:
								tPowerUp.x = 284;
								tPowerUp.y = 170;	
							break;
							case 2:
								tPowerUp.x = 440;
								tPowerUp.y = 285;	
							break;
							case 3:
								tPowerUp.x = 452;
								tPowerUp.y = 463;	
							break;
							case 4:
								tPowerUp.x = 325;
								tPowerUp.y = 521;	
							break;
							default:
								tPowerUp.x = 177;
								tPowerUp.y = 546;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_END_L2:
					case G1156_AssetDocument.WALL_TYPE_END_L3:
						switch (x)
						{
							case 0:
								tPowerUp.x = 379;
								tPowerUp.y = 170;	
							break;
							case 1:
								tPowerUp.x = 379;
								tPowerUp.y = 334;	
							break;
							case 2:
								tPowerUp.x = 335;
								tPowerUp.y = 457;	
							break;
							case 3:
								tPowerUp.x = 268;
								tPowerUp.y = 558;	
							break;
							case 4:
								tPowerUp.x = 268;
								tPowerUp.y = 598;	
							break;
							default:
								tPowerUp.x = 195;
								tPowerUp.y = 689;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_1_L3:
					case G1156_AssetDocument.WALL_TYPE_2_L3:
					case G1156_AssetDocument.WALL_TYPE_3_L3:
						switch (x)
						{
							case 0:
								tPowerUp.x = 379;
								tPowerUp.y = 130;	
							break;
							case 1:
								tPowerUp.x = 335;
								tPowerUp.y = 457;	
							break;
							case 2:
								tPowerUp.x = 268;
								tPowerUp.y = 558;	
							break;
							case 3:
								tPowerUp.x = 339	;
								tPowerUp.y = 704;	
							break;
							case 4:
								tPowerUp.x = 319	;
								tPowerUp.y = 724;	
							break;
							default:
								tPowerUp.x = 279;
								tPowerUp.y = 835;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_5_L3:
						switch (x)
						{
							case 0:
								tPowerUp.x = 513;
								tPowerUp.y = 324;	
							break;
							case 1:
								tPowerUp.x = 416;
								tPowerUp.y = 525;	
							break;
							case 2:
								tPowerUp.x = 216;
								tPowerUp.y = 537;	
							break;
							case 3:
								tPowerUp.x = 154;
								tPowerUp.y = 747;	
							break;
							case 3:
								tPowerUp.x = 255;
								tPowerUp.y = 845;	
							break;
							default:
								tPowerUp.x = 405;
								tPowerUp.y = 875;	
							break;
						}
					break;
					case G1156_AssetDocument.WALL_TYPE_4_L3:
						switch (x)
						{
							case 0:
								tPowerUp.x = 379;
								tPowerUp.y = 130;	
							break;
							case 1:
								tPowerUp.x = 509;
								tPowerUp.y = 457;	
							break;
							case 2:
								tPowerUp.x = 268;
								tPowerUp.y = 558;	
							break;
							case 3:
								tPowerUp.x = 237;
								tPowerUp.y = 704;	
							break;
							case 3:
								tPowerUp.x = 267;
								tPowerUp.y = 734;	
							break;
							default:
								tPowerUp.x = 279;
								tPowerUp.y = 835;	
							break;
						}
					break;
				}
				
					
					
					pMapSection.addChildAt(tPowerUp,pMapSection.numChildren);
				}
				
				return pMapSection;

			}
			
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
			
			
		protected static function selectGemType(pLevel:int,tAssetInstance:G1156_AssetDocument ):PowerUp
		{
				var tPowerUp:PowerUp;
				var tRandom:int = Math.floor(Math.random() *3);
				
				switch (pLevel)
				{
					case 1:
						if (tRandom == 1)
						{
							tPowerUp = 	tAssetInstance.getLibraryObject("ruby_big",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_RUBY_L;	
						}
						else
						{
							tPowerUp = 	tAssetInstance.getLibraryObject("ruby_small",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_RUBY_S;		
						}
					break;
					case 2:
						if (tRandom == 1)
						{
							tPowerUp = 	tAssetInstance.getLibraryObject("emerald_big",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_EMERALD_L;	
						}
						else
						{
							tPowerUp = 	tAssetInstance.getLibraryObject("emerald_small",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_EMERALD_S;		
						}
					break;
					case 3:
						if (tRandom == 1)
						{
							tPowerUp = 	tAssetInstance.getLibraryObject("diamond_big",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_DIAMOND_L;	
						}
						else
						{
							tPowerUp = 	tAssetInstance.getLibraryObject("diamond_small",PowerUp) as PowerUp; 
							tPowerUp.powerUpType = PowerUp.POWERUP_TYPE_DIAMOND_S;		
						}
					break;	
				}
				
				return tPowerUp;
		}	
	 }
}