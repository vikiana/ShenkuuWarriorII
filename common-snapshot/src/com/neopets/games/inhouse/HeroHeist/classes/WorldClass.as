
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.HeroHeist.classes
{
	import com.neopets.games.inhouse.HeroHeist.classes.SpriteClass;
	
	/**
	 *	This class is imported from the flash 6 version of the game.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  2.18.2010
	 */
	 
	public class WorldClass extends SpriteClass
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function WorldClass(pX:Number,pY:Number,gameObj:Object,tileW:Number,tileH:Number) {
			super(pX, pY);
			initWorld(pX, pY, gameObj, tileW, tileH);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Initialization Functions
		
		public function initWorld(pX, pY, gameObj, tileW, tileH) {
			initPosition(pX, pY);
			/*this.pGame = gameObj;
			this.pTileWidth = tileW;
			this.pTileHeight = tileH;
			this.pRoundTime = this.pGame.getRoundTime();
			this.pRoundDone = 0;
			//movieclip depths
			this.pDepths = {bg:0, tiles:1, levelMC:1, player:1000, enemy:1100, enemyNum:0, bullets:2000, bulletNum:0, pickups:3000, 
		
		pickupNum:0, showPickupPts:4000, showPickupPtsNum:0, treasureChest:5000, card:5050, cardFlip_mc:5100, prompt:6000, sb:7000, timer:9000, 
		
		endRoundPauseClip:9500};
			//my arrays
			this.pList = {enemies:[], allTiles:[], pickupTiles:[], pickupItems:[]};
			//attach the main bg, use it for bounds
			var obj = this.attachMovie("gameBG_1", "bg", this.pDepths.bg);
			this.pBounds = this.bg.getBounds(this);
			this.pBounds.xCenter = this.pBounds.xMax / 2;
			this.pBounds.yCenter = this.pBounds.yMax / 2;
			obj._visible = 0;
			//attach the scoreboard
			var obj = this.attachMovie("scoreboardSymbol", "sb", this.pDepths.sb);
			//adjust yMax to the height of the gameScreen-scoreboard
			obj.mcExtends(ScoreboardClass, 0, 0, this.pGame);*/
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}