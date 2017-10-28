package com.neopets.games.inhouse.shootergame{

	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.assets.ginterface.UI;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.games.inhouse.shootergame.utils.SimpleBulletODE;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 *	This the ShooterGame game class. 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.19.2009
	 */
	  
	public class ShooterGame extends MovieClip
	{	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const STAGE_WIDTH:Number = 650;
		public static const STAGE_HEIGHT:Number = 500;
		//planks to build walls and floor. 
		public static const TOTAL_PLANKS:Number = 16; 
		//number of planks between layers
		public static const PBETWEEN:Number = 4;
		public static const GAP:Number = 2;

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _sl:SharedListener;
		private var _lc:LayerContainer;
		private var _lm:LayersManager;
		private var _ol:OverlayManager;
		//ODE solves the bullet flight path.NOT USED.
		private var _ode:SimpleBulletODE;
		private var _led:LevelDefinition;
		private var _ld:LayerDefinition;
		private var _UI:MovieClip;
		//references
		private var _MAIN:Main;
		private var _thisRoot:MovieClip;
		//counters
		private var _levelNo:Number;
		private var _stageNo:Number;
		//flags
		private var _keysEnabled:Boolean;
	
		
		/**
		 * 
		 * Constructor
		 *  
		 */
		public function ShooterGame()
		{
			//init();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/**
		 * 
		 * This is the initialization function called only when the game start.
		 *  
		 */
		public function init(main:Main, Root:MovieClip, sl:SharedListener):void {
			_MAIN = main;
			_thisRoot = Root;
			//CODE FOR NEOPETS GAME SYSTEM
			_MAIN.gamingSystem.sendTag ("Game Started");
			//shared listener
			if (sl){
				_sl = sl;
			} else {
				_sl = new SharedListener ();
			}
			//event listeners
			addEventListeners();
			//level/stage counters
			_levelNo = 1;
			_stageNo = 1;
			//level definition
			_led = new LevelDefinition();
			//setting the perspective in the 3d space
			_thisRoot.transform.perspectiveProjection.projectionCenter = new Point (325, 150);
			_thisRoot.transform.perspectiveProjection.focalLength = 100;
			_thisRoot.transform.perspectiveProjection.fieldOfView = 50;
			//Layers Manager
			_lm = new LayersManager ();
			_lm.initialize (_sl, _lc, _led);
			//Layers Container.
			_ld = new LayerDefinition ();
			_ld.levelDef = _led;
			_ld.name = "Container";
			_ld.posZ = 0;
			_lc = new LayerContainer(_MAIN.soundManager);
			_lm.initLayer (_lc, _ld, _sl, _lm);
			_lc.x = STAGE_WIDTH/2;
			_lc.y = STAGE_HEIGHT/2;
			addChild (_lc);
			_lc.thisRoot = _thisRoot;
			_lc.z = 0;
			_lc.lm = _lm;
			_lm.lc = _lc;
			//Initialize level 1
			initLevel();
		}

		
		//These are to centralize adding display elements to the game at runtime.	
		public function addChildToGame (target:DisplayObject, toUI:Boolean):void {
			if (toUI){
				addChild (target);
			} else {
				_lc.addChild (target);
			}
		}
		
		
		public function removeChildFromGame(target:DisplayObject, toUI:Boolean):void{
			if (toUI){
				if (this.contains(target)){
					removeChild (target);
				}
			} else {
				if (_lc.contains(target)){
					_lc.removeChild (target);
				}
			}
		}
		
		public function cleanUp (e:CustomEvent = null):void {
			removeEventListeners();
			cleanUpLayers ();
			//layers manager
			_lm = null;
			//layers container
			_lc = null;
			//overlay manager
			_ol.cleanUp();
			_ol = null;
			//remove children
			for (var i:Number =0; i<numChildren; i++){
				if (contains(getChildAt(i))){
					removeChildAt(i);
				}
			}
			//UI
			_UI.cleanUp();
			removeChild (_UI);
			_UI = null;

			_ode = null;
			_led = null;

			_MAIN = null;
			_thisRoot = null;

			_levelNo = 0;
			_stageNo = 0;
			//restart game
			if (e){
			 	_sl.sendCustomEvent(SharedListener.GAME_RESTART, null, false, true);
			}
			_sl = null;
			//layer container layer defintion
			_ld = null;
		}
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		
		private function addEventListeners ():void {
			_sl.addEventListener (SharedListener.STAGE_END, initNextStage);
			_sl.addEventListener (SharedListener.NEW_LEVEL, initNextLevel);
			//sounds events
			_sl.addEventListener(SharedListener.PLAY_SOUND, playSound);
			_sl.addEventListener(SharedListener.STOP_SOUND, stopSound);
			//
			_sl.addEventListener (SharedListener.GAME_CLEAN_UP, cleanUp);
		}
		
		private function removeEventListeners():void {
			if (_sl.hasEventListener(SharedListener.PLAY_SOUND)){
				_sl.removeEventListener(SharedListener.PLAY_SOUND, playSound);
			}
			if (_sl.hasEventListener(SharedListener.STOP_SOUND)){
				_sl.removeEventListener(SharedListener.STOP_SOUND, stopSound);
			}
			
			if (_sl.hasEventListener(SharedListener.STAGE_END)){
				_sl.removeEventListener(SharedListener.STAGE_END, initNextStage);
			}
			
			if (_sl.hasEventListener (SharedListener.GAME_CLEAN_UP)){
				_sl.removeEventListener (SharedListener.GAME_CLEAN_UP, cleanUp);
			}
			if (_sl.hasEventListener (SharedListener.NEW_LEVEL)){
				_sl.removeEventListener (SharedListener.NEW_LEVEL, initNextLevel);
			}
		}
		
		private function initLevel (levelNo:Number=1):void {
			//this is set up to accomodate more levels
			setupVars(levelNo);
		}
		
		private function setupVars (levelNo:Number=1):void {
			var stageNode:XML;
			var levelNode:XML;
			switch (_levelNo){
				case 1:
					levelNode = _MAIN.configXML.LEVEL1[0];
				break;
				case 2:
					levelNode = _MAIN.configXML.LEVEL2[0];
				break;
				case 3:
					levelNode = _MAIN.configXML.LEVEL3[0];
				break;
			}
			switch (_stageNo){
				case 1:
					stageNode = levelNode.STAGE1[0];
				break;
				case 2:
					stageNode = levelNode.STAGE2[0];
				break;
				case 3:
					stageNode = levelNode.STAGE3[0];
				break;
			} 
			//level vars
			_led.totTargets= Number (stageNode.levelVars.totTargets.children());
			_led.targetsDistance = Number (stageNode.levelVars.targetsDistance.children());
			_led.levelBoss = String (stageNode.levelVars.levelBoss.children());
			_led.speed = Number (stageNode.levelVars.speed.children());
			_led.targetFlipTime =  Number (stageNode.levelVars.targetFlipTime.children());
			//next level-specific setup
			if (_levelNo >1 && _stageNo == 1){
				_UI.reInit();
				_lm.initialize (_sl, _lc, _led);
				_lc.init(_ld, _sl, _lc);
			}
			//create layers
			var gameLayer:AbstractLayer;
			var layerDefinition:LayerDefinition;
			var layercount:Number =0;
			for each (var layer:XML in stageNode.layer){
				layerDefinition = new LayerDefinition();
				layerDefinition.name = layer.@name;
				layerDefinition.posZ = Number(layer.posZ.children());
				layerDefinition.asset = LibraryLoader.getLibrarySymbol(String(layer.classname.children()));
				layerDefinition.bottomtargets = String (layer.bottomtargets.children()).split (",");
				layerDefinition.toptargets = String (layer.toptargets.children()).split (",");
				layerDefinition.bkgs = String (layer.bkgs.children()).split (",");
				layerDefinition.levelDef = _led;
				//Layers are created ont the first stage only. Data to populate the layers is assigned to the lever an dlayer definitions at every stage.
				if (_stageNo <= 1){
					gameLayer = _lm.createLayer(layerDefinition);
					_lm.initLayer (gameLayer, layerDefinition, _sl, _lm);
					if (_levelNo>1){
						layercount++;
						//if setUpVars is called to initialize levels other than the first one, the function stops here.
					}
				} else {
					gameLayer = _lm.lArray[layercount];
					_lm.initLayer (gameLayer, layerDefinition, _sl, _lm);
					layercount++;
					//if setUpVars is called to initialize stages other than the first one, the function stops here. 
				}
			}
			//Otherwise, it countinues building the game.
			if (layercount==0){
				continueSetup();
			} else if (layercount>0 && _levelNo>1){
				buildWalls ();
				_lc.simpleZSort3DChildren(_lc, _lc.thisRoot);
			}
		}
		
		private function continueSetup ():void {
			//TESTING: FPS counter =============================================
			//addChild(new FPSCounter(300, 250));
			//==================================================================
			//building walls
			buildWalls ();
			//zsorting
			_lc.simpleZSort3DChildren(_lc, _lc.thisRoot);
			//overlay manager
			_ol = new OverlayManager(this, _sl);
			//HERE THE FIRST OVERLAY GETS CREATED AND DISPATCHES THE LEVEL_START EVENT ONCE HE GETS THE GAME_STARTED EVENT FROM MAIN
			_ol.createOverlays();
			//game interface
			var UI:Class = LibraryLoader.getLibrarySymbol("com.neopets.games.inhouse.shootergame.assets.ginterface.UI") ;
			_UI = new UI (_sl, this);
			_UI.x = STAGE_WIDTH/2;
			_UI.y = STAGE_HEIGHT/2;
			_UI.trackAsMenu = true;
			addChild (_UI);
		}
		
		

		private function buildWalls ():void {
			var woodplank:Class = LibraryLoader.getLibrarySymbol("woodenplank") ;
			var plank:MovieClip;
			var floor:Sprite;
			var sideLeft:Sprite;
			var sideRight:Sprite;
			for (var i:int=0; i<TOTAL_PLANKS; i++){
				//floor
				plank = new woodplank();
				///plank.height = PLANK_H;//10
				//plank.width = PLANK_W;
				plank.y = 250;
				if (i/PBETWEEN == Math.floor(i/PBETWEEN)){
					plank.z = i*(plank.height+GAP);
					//trace ("plank.z:"+plank.z+", i:"+i);
				} else {
					plank.z = i*plank.height;
				}
				plank.rotationX = -90;
				//trace ("plank.z"+plank.z);
				_lc.addChild(plank);
				//left wall
				plank = new woodplank();
				//plank.height = PLANK_H;
				//plank.width = PLANK_W;
				plank.x = -325;
				plank.y = -79;
				if (i/PBETWEEN == Math.floor(i/PBETWEEN)){
					plank.z = i*(plank.height+GAP);
				} else {
					plank.z = i*plank.height;
				}
				plank.rotation = 90;
				plank.rotationX = -90;
				_lc.addChild(plank);
				//right wall
				plank = new woodplank();
				//plank.height = PLANK_H;
				//plank.width = PLANK_W;
				plank.x = +325;
				plank.y = -79;
				if (i/PBETWEEN == Math.floor(i/PBETWEEN)){
					plank.z = i*(plank.height+GAP);
				} else {
					plank.z = i*plank.height;
				}
				plank.rotation = -90;
				plank.rotationX = -90;
				_lc.addChild(plank);
			}
		}
		
		private function cleanUpLayers ():void {
			//layers container
			if (!_lc.lcIsCleaned){
				_lc.cleanUp();
			}
			//layers manager reference to layers
			_lm.cleanUp();
		}
		
		
		//----------------------------------------------------------------------------------------------------------
		//  EVENT HANDLERS
		//------------------------------------------------------------------------------------------------------
		
		
		private function initNextStage (e:CustomEvent):void {
			_stageNo = e.oData.stageNo;
			setupVars();
		}
		
		private function initNextLevel (e:CustomEvent):void {
			cleanUpLayers();
			_stageNo = 1;
			_levelNo++;
			setupVars();
		}


		private function playSound (e:CustomEvent):void{
			//Only special effects use this function 
			if (_MAIN.soundOn){
				_MAIN.soundManager.soundPlay(e.oData.name, e.oData.loop);
			}
		}
		
		private function stopSound (e:CustomEvent):void{
			_MAIN.soundManager.stopSound(e.oData.name);
		}


		//--------------------------------------------------------------------------------------------------------
		// GETTERS AND SETTERS
		//--------------------------------------------------------------------------------------------------------
		public function get main ():Main{
			return _MAIN;
		}
		
		public function get levelNo ():Number{
			return _levelNo;
		}
	}
}
