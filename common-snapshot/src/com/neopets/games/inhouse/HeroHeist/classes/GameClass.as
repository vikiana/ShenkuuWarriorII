
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.HeroHeist.classes
{
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.games.inhouse.HeroHeist.classes.PickupItemObj;
	import com.neopets.games.inhouse.HeroHeist.classes.WorldClass;
	import com.neopets.games.inhouse.HeroHeist.globals.gMyNeoStatus;
	
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
	 
	public class GameClass
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// flash 6 variables
		public var pTileWidth:Number;
		public var pTileHeight:Number;
		public var pCardURL:String;
		public var pCardIndex:int;
		public var pLastGraphicsSet:int;
		public var pGraphicsSet:int;
		public var pBGIndex:int;
		public var pBGNum:int;
		public var gotTenThousandBonus:Boolean;
		public var gotHundredThousandBonus:Boolean;
		public var pRoundTime:Number;
		public var eLevel:NP9_Evar;
		public var eLives:NP9_Evar;
		public var eTimeBonus:NP9_Evar;
		public var mapList:Array;
		public var pCardObjects:Array;
		public var pickupList:Array;
		public var eKillPts:Number;
		public var ePickupPts:Number;
		public var pMaxLevels:int;
		public var pWorld:WorldClass;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameClass(tileW:Number,tileH:Number,roundTime:Number):void {
			init(tileW, tileH, roundTime);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Initialization Functions
		
		public function init(tileW:Number,tileH:Number,roundTime:Number) {
			//EventBroadcaster
			//Eventbroadcaster.initialize(this);
			this.pTileWidth = tileW;
			this.pTileHeight = tileH;
			//this.pCardURL;
			this.pCardIndex = 0;
			//which 'set' of graphics to use
			this.pLastGraphicsSet = this.pGraphicsSet = 1;
			//which background we're on
			this.pBGIndex = 1;
			this.pBGNum = 1;
			//bonus for extra lives
			//this.gotTenThousandBonus;
			//this.gotHundredThousandBonus;
			//time for round
			this.pRoundTime = roundTime;
			//Evars
			//this.eScore = new gMyScoringSystem.Evar(0);
			this.eLevel = new NP9_Evar(0);
			this.eLives = new NP9_Evar(3);
			this.eTimeBonus = new NP9_Evar(0);
			//the array of all maps
			this.mapList = [];
			this.pCardObjects = [];
			//the different pickup items
			this.pickupList = [];
			//Scoring Vars
			this.eKillPts = 100;
			this.ePickupPts = 150;
		}
		
		// Start Game Functions
		
		public function startGame() {
			//gMyNeoStatus.sendTag("Game Started"); // already handled by flash 9 game template
			// clear previously added elements before we start
			//();
			//-------------------------------attach the world
			//this.pWorld = _root.createEmptyMovieClip("gameWorld", 10);
			//this.pWorld.mcExtends(WorldClass, 0, 0, this, this.pTileWidth, this.pTileHeight);
			//this.addListener(this.pWorld);
			pWorld = new WorldClass(0, 0, this, this.pTileWidth, this.pTileHeight);
			//-------------------------------
			/*this.nextBG = _root.createEmptyMovieClip("nextBG", 1);
			this.nextBG.createEmptyMovieClip("bgHolder", 1);
			//this.nextBG.bgHolder
			//the current bg
			this.currentBG = _root.createEmptyMovieClip("currentBG", 2);
			this.currentBG.createEmptyMovieClip("bgHolder", 1);
			this.currentBG.bgHolder.attachMovie("gameBG_1", "bg", 1);
			//-------------------------------
			//load the 1st card
			this.preloadCardImage();
			//load the 2nd background
			this.preloadBackgroundImage();
			//increment the level
			this.nextLevel();*/
		}
		
		// Card Functions 
		
		public function addCardPath(path:String) {
			this.pCardURL = path;
		}
		
		public function addCard(cardObj:Object) {
			this.pCardObjects.push(cardObj);
		}
		
		// Map Functions
		
		public function addMap(map:Array) {
			this.mapList.push(map);
			this.pMaxLevels = this.mapList.length;
		}
		
		// Pick Up Item Functions
		
		public function addPickupItem(obj:Object) {
			this.pickupList.push(obj);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
