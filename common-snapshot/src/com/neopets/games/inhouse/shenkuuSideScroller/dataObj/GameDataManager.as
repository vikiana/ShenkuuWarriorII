/**
 *	Sort of a bridge class between GameData and Shenkuu_Game this was mainly created to make the game class shorter...
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  aug.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.dataObj
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import com.neopets.games.inhouse.shenkuuSideScroller.characters.*;
	import com.neopets.util.display.DisplayUtils;
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class GameDataManager
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GameDataManager():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
				
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/*
		 *	is called only once.  assigns basic elements needed for the game for gamedata
		 */
		public static function initialSetup():void
		{
			createMarker();	//create marker
			prepObjs();		//preprep objects
			setSpeeds();	//set parallax speed
			setTimer();		//set timer
			resetWeather();
			GameData.stageHeight = GameData.rootMC.stage.stageHeight;
			GameData.stageWidth = GameData.rootMC.stage.stageWidth;
			GameData.impactArray = []
		}
		
		/*
		 *	reset the current weather ot default setting
		 */
		public static function resetWeather():void
		{
			GameData.weather = GameData.dftWeather;
			GameData.wGrav = GameData.dftWGrav;
		}
		
		/*
		 *	make a marker (it's a special entity, marker indicates if player has finished level or not) 
		 */
		public static function createMarker():void
		{
			GameData.marker = new Marker ();
		}
		
		/*
		 *	reset marker
		 */
		public static function cleanupMarker():void
		{
			GameData.marker.resetCharacter();
		}
		
		/*
		 *	create 10 helpers and enemies in respected array
		 */
		public static function prepObjs():void
		{
			addObjs(Class(Helper), 10, GameData.helpers);
			addObjs(Class(Enemy), 10, GameData.enemies);
		}
		
		/*
		 *	create timer
		 */
		public static function setTimer():void
		{
			GameData.mainTimer = new Timer (GameData.SPEED_NORMAL);
		}
		
		/*
		 *	creat instance of objs to an array by given number
		 *	@PARAM		pObj		Class		obj class that needs to be instantiated
		 *	@PARAM		pNum		int			pNum num of instances that needs to be created
		 *	@PARAM		pArray		Array		array that holds created instances
		 */
		public static function addObjs(pObj:Class, pNum:int, pArray:Array):void
		{
			for (var i:int = 0 ; i < pNum; i++)
			{
				pArray[pArray.length] = new pObj ()
			}
			
		}
		
		/*
		 *	set backround midground foreground speed for parallexing effect
		 */
		public static function setSpeeds():void
		{
			GameData.bgSpeed = GameData.currSpeed * .5 //.25;
			GameData.mgSpeed = GameData.currSpeed * .75 //.5;
			GameData.fgSpeed = GameData.currSpeed * 2.5 //1.25;
		}
		
		
		/**
		 *	removes an image from its holder
		 *	@PARAM		pImage		DisplayObject	image that needs to be removed
		 *	@PARAM		pPlace		Sprite			container where image to be removed is in
		 **/
		public static function removeImage(pImage:DisplayObject, pPlace:Sprite ):void
		{
			if (pImage != null)
			{
				pPlace.removeChild(pImage)
			}
		}
		
		
		/**
		 *	relocate the object from active array to reserve Array
		 *	@PARAM		pObj		AbsCharacter	chracter
		 *	@PARAM		pFrom		Array			Array where the chracter is in
		 *	@PARAM		pTo			Array			Array twhere the character should go into
		 **/
		public static function toReserve (pObj:AbsCharacter, pFrom:Array, pTo:Array):void
		{
			for (var i:String in pFrom)
			{
				if (pObj == pFrom[i])
				{
					pFrom.splice(i,1)
					pTo.push(pObj)
				}
			}
		}
		
		/**
		 *	move all active enemies/helpers to reserve array
		  *	@PARAM		pArray		Array		resets objects (active characters) in respected array
		 **/
		public static function resetObjs(pArray):void
		{
			if (pArray.length > 0)
			{
				pArray[0].resetCharacter()
				resetObjs(pArray)
			}
		}
		
		/*
		 *	reset the player
		 */
		public static function resetPlayer():void
		{
			GameData.player.vel =  GameData.dftVel;
			GameData.player.grav = GameData.wGrav;
			GameData.player.pos = GameData.dftPos;
			GameData.player.resetCharacter();
		}
		
		/*
		 *	clear objects from an array
		 */
		public static function clearObjs():void
		{
			resetObjs(GameData.activeEnemies);
			resetObjs(GameData.activeHelpers);
			resetObjs(GameData.activeUnbreakables);
			resetWeather();
			GameData.dist = 0;
			GameData.impactArray = [];
		}
		
		/**
		 *	assign background, midground and foreground to respected sprites
		 *	@PARAM		bd		DisplayObject		backgropimage (stationary background on the way back)
		 *	@PARAM		bg		DisplayObject		background image
		 *	@PARAM		mg		DisplayObject		midground image
		 *	@PARAM		fg		DisplayObject		foreground image
		 **/
		public static function setupGameGrounds(bd:DisplayObject = null, bg:DisplayObject = null, mg:DisplayObject = null, fg:DisplayObject = null):void
		{
			bd.name = "backdrop"
			
			removeChildren (GameData.bdSprite)
			removeChildren (GameData.bgSprite);
			removeChildren (GameData.mgSprite);
			removeChildren (GameData.fgSprite);
			
			if (bd != null)GameData.bdSprite.addChild(bd);
			if (bg != null)GameData.bgSprite.addChild(bg);
			if (mg != null)GameData.mgSprite.addChild(mg);
			if (fg != null)GameData.fgSprite.addChild(fg);
			
			DisplayUtils.cacheImages(GameData.bdSprite);
			DisplayUtils.cacheImages(GameData.bgSprite);
			DisplayUtils.cacheImages(GameData.mgSprite);
			DisplayUtils.cacheImages(GameData.fgSprite);
			
			GameData.bdSprite.x = GameData.bdSprite.y = 0;
			GameData.bgSprite.x = GameData.bgSprite.y = 0;
			GameData.mgSprite.x = GameData.mgSprite.y = 0;
			GameData.fgSprite.x = GameData.fgSprite.y = 0;
		}
		
		/*
		 *	removes all children from a sprite
		 *	@PARAM		obj		Sprite		sprite that children should be removed from
		 */
		public static function removeChildren(obj:Sprite):void
		{
			while (obj.numChildren > 0)
			{
				obj.removeChildAt(0)
			}
		}
		
		/*
		 *	when speedCount runs out reset teh game speed to normal
		 */
		public static function speedCounter():void
		{
			if (GameData.speedCount > 0)
			{
				GameData.speedCount --;
				if (GameData.speedCount <= 0) 
				{
					GameData.mainTimer.delay = GameData.SPEED_NORMAL;
					GameData.slowOn = false;
				}
			}
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