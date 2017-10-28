/**
 *	This is the main game class that runs the game.  
 *	note that FaerieBubble.as is the actual driving force that runs the game every frame.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  Nov.2009
 */
 
 

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	
	/**
	*	@NOTE:	This game has been directly adopted from g358, which was coded in AS1.0
	*			Our goal was adopt to AS3.0 as fast as we can, not make it a perfect code
	*			At the end of the day, it's not structured perfectly but it works.
	*
	*			The code was not commented well.  I don't quite understand everything.
	*			I will comment major functions and what I understand.
	*
	*			There might be some variables and functions that are not necessary 
	*			But they are here just because I am not 100% sure what they do...
	*
	*
	*			----------------
	*	@NOTE:	BASIC GAME FLOW
	*			----------------
	*			- FaerieBubble.as runs the function called "run" every frame.
	*			- "run" function runs mainloop function in this class
	*			- mainloop checks the current "game_state" (there are near 30 states) 
	*			- mainloop runs appropreate set of functions accoding to game_state.
	**/
	
	
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.utils.getTimer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	import com.neopets.projects.gameEngine.gui.MenuManager;
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.GameSoundManager;
	
	
	public class Game
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		private const MOVE_RIGHT:String = "angle_cannon_to_right"
		private const MOVE_LEFT:String = "angle_cannon_to_left"
		private const MOVE_UP:String = "reset_cannon_angle"
		private const DO_NOT_MOVE:String = "do_not_move_cannon"
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//can't find game mode but it's basically easy:hard =  0:1, I don't think hard mode ever made it
		private var gameMode:Number = 0
		
		
		// added 10/05/2006 by Ollie
		private var aRemoveTxtFields:Array = [];
		
		// game state
		private var game_state:Number        = 999;	//999 is sort of "default" or "do nothing" state
		private var next_game_state:Number   = 999; //state it should be after the current game_state
		private var save_game_state:Number  = 999; //999 is sort of "default" or "do nothing" state
		private var next_course_step:Number  = -1; //next tutorial state

		// random number
		private var rnr:Number = 10+Math.floor(Math.random() * 100);//not sure: probably used for anti-cheat for game scores
	
		// level size
		private var maxy:Number   = 10; // # of rows
		private var maxx:Number   =  9; // # of columns
		//
		
		private var ballW:Number  =  40; //this was 32 in ball class...maybe buffer (4*2) is added...??
		private var ballR:Number  =  (ballW/2);
		// ball-width minus yDist is the y distance to the next ball!
		private var yDist:Number  =  4;
				
		// bubble rarities
		private var aRare:Array = [15,15,15,15,15,15,0,0,0,0,1,1];// has to do with special bubbles 
		private var aTemp:Array = [];
		private var aRarity:Array = [];
		
		// ball stuff
		private var ballDepth:Number   = 1000;	//depth is not used in AS3 for movieclips
		private var activeBall:Ball;	//currently active moving ball(bubble)
		private var power:Number       = 28;
		private var centerAngle:Number = 1.58; //~90 in radian angle
		private var angle = centerAngle;
		
		// speed up cannon as longe as button is pressed
		private var nKeyDown:Number    = 0;	// builds inertia when arrow key is held down (righ or left)
		private var bSpaceDown:Boolean  = false;
		
		// nice effect if cannon goes back into center pos
		private var aCannonShake:Array = []; //when cannon resets, it gives visual shake
				
		private var bCannonShake:Boolean     = false;
		private var cannonShakeIndex:Number = 0;
		
		// the next n balls in the cannon
		private var aBubblePipeline:Array  = [];  //bubbles that's in cannon pipeline (first 2 shown)
		// the different bubble types
		private var maxBubbles:Number = 6; // only Faerie bubbles
		//
		private var B_FIRE:Number    = 1; //bubble combo number/id
		private var B_WATER:Number   = 2; //bubble combo number/id
		private var B_LIGHT:Number   = 3; //bubble combo number/id
		private var B_EARTH:Number   = 4; //bubble combo number/id
		private var B_AIR:Number     = 5; //bubble combo number/id
		private var B_DARK:Number    = 6; //bubble combo number/id
		
		private var _DESTROY:Number =  999;	//game state id(?)
		private var _EXPLODE:Number = 1000; //game state id(?)
		private var _KILLED:Number  = 1001; //game state id(?)
		
		// level stuff
		private var objLevel:Level //obj contains all level info
		private var courseLevels:Number = 6; //end of tutorial beginning of game number (game_state)
		private var curLevel:Number     = 0; //current level users are viewing
	
		// instruction course object
		private var objCourse:Course; //object containing all tutorial info	
		private var bInstructions = false;	//true means users are in "tutorial state"
		private var aBubbles:Array = []; // array to create levels bubble by bubble		
		private var objs:Array = [];// the array of bubble objects
		private var aLevel:Array = []; // the level array with references to objs array
		private var mainColors:Number = 6;// the colors left on the screen
		private var aColors:Array = [];
		private var remainingColors:Number = 0;
		private var aScrambledColors:Array = [];// change levels!
		
		
		private var aCombos:Array  = [];// holds the winning combos positions
		private var lastSetX:Number = 0;// where the last shot bubble was placed
		private var lastSetY:Number = 0;
		private var collidedX:Number = -1;// the bubble that collided with the last shot bubble
		private var collidedY:Number = -1;
		
		
		private var aPFPos:Array   = [ [72,18] ];// the playfield positions - depending on play mode
		private var aBallPos:Array = [ [261,408] ];// the ball start positions - depending on play mode
		// game borders - depending on play mode
		// left, right, top, bottom
		private var aBorders:Array = [ [81,441,27,353] ]
		private var _LEFT:Number    = 0;
		private var _RIGHT:Number   = 1;
		private var _TOP:Number     = 2;
		private var _BOTTOM:Number  = 3;
		
		// the current toprow - because of row drop
		private var topRow:Number = 0;
		
		// staggered level look
		private var aAddX:Array = [];
		// get level grid center to position ball 
		// in the right grid cell when collision
		private var aCenterPos:Array = [];
		// the win combo obj - takes care of win stuff!
		private var objCombos:Combo
		
		// creating bubbles row by row
		private var createBubbleRow:Number = 0;
		// delete bubbles row by row
		private var deleteBubbleRow:Number = 0;
		// dropping bubbles in this row when game over
		private var gameOverDropRow:Number = 0;
		// dropped bubbles
		private var dropped:Number = 0;
		
		// game over flag
		private var bGameOver:Boolean = false;
		
		// BT, BD, BK, CT, ST, LT, GT, BP, CP, LB, GB
		private var aGAMESCORE:Array = [0,0,0,0,0,0,0,1,5,0,(5*10*5)];
		
		// game timer
		private var timer:Number         = 0;
		private var pausetimer:Number    = 0;
		private var droptimer:Number     = 0;
		private var dropStopTimer:Number = 0;
		private var textTimer:Number     = 0;
		private var dropCounter:Number   = 0;
		private var lastShot:Number      = 0;
		// milliseconds til' the next row drops
		private var nextdrop:Number = 30000;
		
		// FPS test
		private var FPS_count:Number = 0;
		private var FPS_total:Number = 0;
		private var FPS_time:Number  = 0;
		
		private var gameMC:Object;	//movie clip where game will take place in
		private var mRootMC:Object; //document class
		private var objGem:Gems; //for user cheat codes
		private var playfield:MovieClip; //PlayField
		private var bShootingAllowed:Boolean // allow shooing or not
		private var textID:String;	//this replaces the title of the popup...
		private var courseMC:MovieClip; //MC for tutorial popup
		
		private var mTranslationData:TranslationData = TranslationManager.instance.translationData;//translated date
		private var cannonStatus:String = DO_NOT_MOVE;	//state of the cannon

		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Game():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		*	set up main game bocjects
		*	@PARAM		pRoot		Object(movieClip)		Where actual game will be in
		*	@PARAM		pRootMC		Object					the document class's main timeline
		**/
		public function setupDoc(pRoot:Object, pRootMC:Object):void
		{
			gameMC = pRoot
			mRootMC = pRootMC
			setupStuff()
			setupVars()
			
		}
		
		/**
		*	setups various bubble arrays to start the game
		**/
		public function setupStuff():void
		{
			for ( var i=0; i<aRare.length; i++ )
			{
				for ( var j=0; j<aRare[i]; j++ )
				{
					aTemp.push( (i+1) );
				}
			}
		
		
			while ( aTemp.length > 0 ) 
			{
				var num:int = Math.floor(Math.random() * aTemp.length );
				
				aRarity.push( aTemp[num] );
				aTemp.splice( num, 1 );
			}
			
			for ( var k=3; k>0; k-- ) 
			{
				aCannonShake.push( centerAngle+(k/100) );
				aCannonShake.push( centerAngle-(k/100) );
			}
			aCannonShake.push(centerAngle );
			
			for ( var l=0; l < mainColors; l++ ) aColors.push(0);
		}
		
		
		// ---------------------------------------- //	
		// set center pos Array
		public function setCenterPosArray():void
		{
			aCenterPos = [];
			var r = ballR;
			for ( var i=0; i<=maxy; i++ ) {
				aCenterPos.push( [] );
				for ( var j=0; j<maxx; j++ ) 
				{
					if ( (aAddX[i] > 0) && (j == (maxx-1)) ) aCenterPos[i].push( -1 );
					else aCenterPos[i].push( [ (aBorders[gameMode][_LEFT]+aAddX[i]+(j*ballW)+r), (aBorders[gameMode][_TOP]+(i*(ballW-yDist))+r) ] );
				}
			}
		}
		
		// ---------------------------------------- //	
		// set staggered pos Array
		public function setAddXArray ():void
		{
			var addX   = 0;
			aAddX = [];
			for ( var i=0; i<=maxy; i++ ) {
				aAddX.push( addX );
				addX = (addX==0) ? ballR : 0;
			}
		}
		
		
		// ---------------------------------------- //	
		// set vars 
		public function init (bTutorial:Boolean)
		{
			bInstructions = bTutorial
			//curLevel = courseLevels;
			resetVars();
			//look into this later
			
			// more fun
			objGem.resetGems();
	
			//center the playfield
			playfield.alpha = 0;
			playfield.x = aPFPos[gameMode][0];
			playfield.y = aPFPos[gameMode][1];
			playfield.gotoAndStop(gameMode+1);
			playfield.theCannon.color1.gotoAndStop(20);
			playfield.theCannon.color2.gotoAndStop(20);
	
			// hide topdrop
			playfield.topdrop.height  = 0;
			playfield.topdrop.visible = false;
			
			
			// player is about to go thru the instruction course
			
			if ( bInstructions ) {
				attachCoursePopup();
				//
				playfield.showleveltext_txt.text = "";
				playfield.mainScore_txt.text = "";
			}
			
				
			game_state = GameStates.ST_SHOWPLAYFIELD; // start the game //
		}
		
		
		// ---------------------------------------- //
		
		public function giveNova ():void 
		{ 
			changeActiveBubble(12,7); 
		}
		
		public function giveRainbow ():void 
		{ 
			changeActiveBubble(11,8); 
		}
		
		public function giveExtra ():void
		{
			var newColor = aRarity[ Math.floor(Math.random ()* aRarity.length) ];		
			for ( var row=(maxy-1); row>=topRow; row-- ) {
				for ( var col=(maxx-1); col>=0; col-- ) {
					if ( aLevel[row][col] != -1 ) {
						// get reference to actual bubble obj
						var obj = objs[ aLevel[row][col] ];
						obj.ballType = newColor;
						obj.goto( newColor );
					}
				}
			}
		}
		
		public function changeActiveBubble ( col:Number, snd:Number ):void
		{
			activeBall.ballType = col;
			activeBall.goto(col);
			playfield.theCannon.color1.gotoAndStop( col );
		}
		
		
		
		
		/**
		*	when applicable, show the popup menu (end game, resume options during the game)
		**/
		public function showMainMenu ():void
		{
			if (( game_state == GameStates.ST_AIMBALL  )
			||  ( game_state == GameStates.ST_COURSE_1 )
			||  ( game_state == GameStates.ST_COURSE_2 ))
			{
				save_game_state = game_state;
				pausetimer = getTimer();
				
				if ( bInstructions ) {
					objCourse.savePopupPos();
					objCourse.hidePopup();
				}
	
				game_state = GameStates.ST_GAMEPAUSED;
			}
		}
		
		

		/**
		*	close the popup and resume the game
		**/
		public function resume ():void
		{
			
			if ( bInstructions ) 
			{
				gameMC.removeChild(gameMC.getChildByName("popup_game"))
				objCourse.restorePopupPos();
			}
			else {
				var addTimer = getTimer() - pausetimer;
				gameMC.removeChild(gameMC.getChildByName("popup_game"))
			}
	
			if (game_state != GameStates.ST_LEVELSCREEN)
			{
				game_state = save_game_state;
			}
			
			mRootMC.stage.focus = mRootMC.stage;
		}
		
		
		/**
		*	clean up the game and restrat it
		**/
		public function restart():void 
		{
			deleteBubbleRow = maxy-1;
			game_state = GameStates.ST_CLEANUP;
			next_game_state = GameStates.ST_RESTART;
		}
		
		
		/**
		*	Send Score is taken care of at FaerieBubblesAS3Engine.as level
		**/
		public function sendScore()
		{
			deleteBubbleRow = maxy-1;
			game_state = GameStates.ST_CLEANUP;
			next_game_state = GameStates.ST_SENDSCORE;
		}
		
		
		/**
		*	main function that drives teh game.  Based on the game_state, various actions are performed
		**/
		public function mainLoop ()
		{
			moveCannon()
			var t:Number  = getTimer();
			
			if ( t < timer ) return ( -1 );
			timer = t + 10;
			if ( (textTimer>0) && (t>textTimer) ) {
				textTimer = 0;
				TranslationManager.instance.setTextField(playfield.showInfoButton_txt, "");
			}
			//trace("state: "+game_state);
			
			switch ( game_state )
			{
				case GameStates.ST_SHOWPLAYFIELD:
				
					if ( playfield.alpha < 1 ) 
					{
						playfield.alpha = 1;
					}
					else {
						if ( bInstructions ) nextCourseStep();
						else game_state = GameStates.ST_NEXTLEVEL;
					}
					break;
					
				case GameStates.ST_COURSE_1:
					bShootingAllowed = false;

					break;
				case GameStates.ST_COURSE_2:
					game_state = GameStates.ST_CREATEBALL;
					break;
					
				case GameStates.ST_NEXTLEVEL:
					trace (curLevel >= objLevel.maxLevels)				
					if ( curLevel >= objLevel.maxLevels ) {
						game_state = GameStates.ST_GAMEFINISHED;
					}
					else {
						if ( curLevel == 6 ) 
						{
							playfield.endButton.visible = true;
							if (playfield.theCannon.getChildByName("aimline1") == null)
							{
								var aim:MovieClip = AssetTool.getMC ("aimLine")//new aimline ();
								aim.name = "aimline1"
								playfield.theCannon.addChild(aim);
								aim.x = -16;
								aim.y = -310;
							}
							else 
							{
								MovieClip(playfield.theCannon.getChildByName("aimline1")).visible= true;
							}
						} else {
							if ( playfield.theCannon.getChildByName("aimline1") != null )
							{
								MovieClip(playfield.theCannon.getChildByName("aimline1")).visible = false;
															}
						}
						// game start?
						if ( (curLevel- courseLevels) == 0 ) 
						{
							TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_gamestart);
							textTimer = t + 3000;
						}
						topRow = 0;
						setAddXArray();
						setCenterPosArray();
						nextLevel();
						game_state = GameStates.ST_CREATELEVEL;
					}
					break;
					
				case GameStates.ST_CREATELEVEL:
				
					// load the level data
					createLevel();
	
					// scamble colors 1 in 2 times
					// except during tutorial
					var bScramble = false;
					if ( !bInstructions && (Math.floor(Math.random()*2)==1) ) bScramble = true;
					scrambleColors( bScramble );
					
					createBubbleRow = 0;
					for ( var i=0; i<mainColors; i++ ) aColors[i] = 0;
					game_state = GameStates.ST_CREATEBUBBLES;
					break;
				
				case GameStates.ST_CREATEBUBBLES:
					// create every single bubble
					if ( createBubbles( createBubbleRow ) == 0 ) {
						
						// player is playing instruction course!
						if ( bInstructions ) 
						{
							dropCounter = 0;
						}
						else 
						{ 
							dropCounter = 0;
						}
							
						game_state = GameStates.ST_CREATEBALL;
						timer = t + 100;
					}
					else 
					{
						createBubbleRow++;
						timer = t + 25;
					}
					break;
				
				case GameStates.ST_CREATEBALL:
					createActiveBall();
					game_state = GameStates.ST_AIMBALL;
					break;
					
				case GameStates.ST_AIMBALL:
					var bDrop = false;
					var dc = (dropCounter/rnr);
					if ( (remainingColors == 1) && (dc == 3) ) bDrop = true;
					else if ( (curLevel>10) && (dc >= 5) ) bDrop = true;
					else if ( (curLevel<=10) && (dc >= 6) ) bDrop = true;
					
					if ( bDrop ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DROP);
						if ( dropRows( false ) ) 
						{
							dropCounter = 0;
						}
						else 
						{
							bGameOver  = true;
							game_state = GameStates.ST_LEVELSCREEN;
						}
						// set topdrop field
						topRow++;
						playfield.topdrop.height = topRow * (ballW-yDist);
						playfield.topdrop.visible = true;
					}
					else bShootingAllowed = true;
					break;
					
				case GameStates.ST_BALLROLLS:
					activeBall.setPos();
					if ( wallCollisionDetection() ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_HIT);
						game_state = GameStates.ST_BALLSTOPPED;
					}
					else if ( collisionDetection() ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_HIT);
						game_state = GameStates.ST_BALLSTOPPED;
					}
					activeBall.updatePos();
					break;
					
				case GameStates.ST_BALLSTOPPED:
					// continue course if it's active!
					
					if ( bInstructions && (next_course_step == GameStates.ST_BALLSTOPPED) ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
						gameMC.removeChild(activeBall.ballMC);
						nextCourseStep();
						return;
					}
	
					// stop droptimer while combos may happen
					// so slow computers still have the same time 
					// dropStopTimer = t;
					
					//trace ("ball stopped", !setNewActivePos())
	
					if ( !setNewActivePos() ) {
						trace("----- game over -----\n");
						bGameOver  = true;
						game_state = GameStates.ST_LEVELSCREEN;
						//game_state = GameStates.ST_GAMEOVERSCREEN;
					}
					else game_state = GameStates.ST_CHECKCOMBOS;
					
	
					break;
					
				case GameStates.ST_CHECKCOMBOS:
					// reset win array
					objCombos.reset( aLevel, objs,aAddX, topRow );
					// set the last shot ball		
					objCombos.initSearch( lastSetY, lastSetX );
					// was last set bubble a cannon bubble?
					if ( activeBall.ballType == 12 ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_EXPL);
						game_state = GameStates.ST_CANNONBUBBLE;
					}
					else {
						// was last set bubble a multi colored bubble?
						if ( activeBall.ballType == 11 ) {
							GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_RAIN);
							switchRainbowBubble();
						}
						var combo = checkForCombos();
						if ( lastSetY == maxx ) {
							if ( combo < 3 ) { 
								bGameOver  = true;
								game_state = GameStates.ST_LEVELSCREEN;
								//game_state = GameStates.ST_GAMEOVERSCREEN;
							}
							else {
								hideOneBubble( [ lastSetY, lastSetX ] );
							}
						}
						if ( combo >= 4 ) {
							aGAMESCORE[3]++;
							setPoints( aGAMESCORE[8] );
							timer = t + 100;
						}
						else if ( combo >= 3 ) {
							timer = t + 100;
						}
						else if ( !bGameOver ) {
							game_state = GameStates.ST_CREATEBALL;
						}
					}
					break;
					
				case GameStates.ST_CANNONBUBBLE:
					attachExplosion();
					game_state = GameStates.ST_CANNONBUBBLE2;
					break;
				
				case GameStates.ST_CANNONBUBBLE2:
					triggerCannonBubble();
					timer = t + 50;
					game_state = GameStates.ST_SEARCHFREE;
					break;
					
				case GameStates.ST_CHECKEMPTYLEVEL:
				
					// continue course if it's active!
					if ( bInstructions && (next_course_step == GameStates.ST_CHECKEMPTYLEVEL) ) {
						cleanAllAtOnce();
						nextCourseStep();
						return;
					}
					
					if ( checkEmptyLevel() ) {
						emptyCannon();
						timer = t + 500;
						game_state = GameStates.ST_LEVELSCREEN; //GameStates.ST_NEXTLEVEL;
					}
					else game_state = GameStates.ST_CREATEBALL;
					break;
					
				case GameStates.ST_SETFIRE:
					game_state = GameStates.ST_FIRECOMBO;
					timer = t + 1000;
					break;
					
				case GameStates.ST_FIRECOMBO:
					var aKill = objCombos.getNextBall_FIRE();
					if ( aKill.length > 0 ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
						destroyBubbles( aKill );
						aGAMESCORE[2]+=aKill.length;
					}
					game_state = GameStates.ST_DROPBUBBLES;
					next_game_state = GameStates.ST_SEARCHFREE;
					break;
					
				case GameStates.ST_SETWATER:
					game_state = GameStates.ST_WATERCOMBO;
					timer = t + 1000;
					break;
					
				case GameStates.ST_WATERCOMBO:
					var aKill2 = objCombos.getNextBall_WATER();
					if ( aKill2.length > 0 ) {
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
						destroyBubbles( aKill2 );
						aGAMESCORE[2]+=aKill2.length;
					}
					game_state = GameStates.ST_DROPBUBBLES;
					next_game_state = GameStates.ST_SEARCHFREE;
					break;
					
				case GameStates.ST_SETLIGHT:
					game_state = GameStates.ST_LIGHTCOMBO;
					timer = t + 1000;
					break;
					
				case GameStates.ST_LIGHTCOMBO:
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
					objCombos.setNextBall_LIGHT(aLevel,objs);
					game_state = GameStates.ST_DROPBUBBLES;
					next_game_state = GameStates.ST_SEARCHFREE;
					break;
					
				case GameStates.ST_SETEARTH:
					game_state = GameStates.ST_EARTHCOMBO;
					timer = t + 1000;
					break;
					
				case GameStates.ST_EARTHCOMBO:
					if ( dropRows( true ) ) {
						dropCounter = 0;
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DROP);
						game_state = GameStates.ST_DROPBUBBLES;
						next_game_state = GameStates.ST_SEARCHFREE;
					}
					else {
						bGameOver  = true;
						game_state = GameStates.ST_LEVELSCREEN;
					}
					break;
	
				case GameStates.ST_SETAIR:
					game_state = GameStates.ST_AIRCOMBO;
					createBubbleRow = 0;
					timer = t + 1000;
					break;
					
				case GameStates.ST_AIRCOMBO:
					var aNewbubbles = objCombos.setNextBall_AIR(createBubbleRow,aLevel,objs);
					if ( aNewbubbles.length > 0 ) GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
					for ( var i2=0; i2<aNewbubbles.length; i2++ )
					{
						if ( aNewbubbles[i2] != -1 ) {
							if ( (aNewbubbles[i2].gridX == (maxx-1)) && (aAddX[aNewbubbles[i2].gridY] > 0) ) {
								// nothing
							}
							else {
								//trace("new bubble: "+newbubble.gridX+", "+newbubble.gridY+" - addX: "+aAddX[newbubble.gridY]);
								createBallClip( aNewbubbles[i2] );
							}
						}
					}
					
					if ( ++createBubbleRow >= maxy ) {
						game_state = GameStates.ST_DROPBUBBLES;
						next_game_state = GameStates.ST_SEARCHFREE; //GameStates.ST_CHECKEMPTYLEVEL;
					}
					else timer = t + 100;
					
					break;
					
				case GameStates.ST_SETDARK:
					game_state = GameStates.ST_DARKCOMBO;
					timer = t + 1000;
					break;
					
				case GameStates.ST_DARKCOMBO:
					// just switches bubble types
					if ( objCombos.setNextBall_DARK(aLevel,objs) == 0 ) {
						game_state = GameStates.ST_CHECKEMPTYLEVEL;
					}
					else timer = t + 150;
					break;
					
				case GameStates.ST_DROPBUBBLES:
					// drop bubbles down to row 0
					if ( dropBubbles(0) == 0 ) {
						aGAMESCORE[1]+=dropped;
						var bonus = dropped*aGAMESCORE[7];
						textTimer  = t + 2000;
						dropped = 0;
						game_state = next_game_state;
					}
					break;
					
				case GameStates.ST_DESTROY:
					var aKill3 = objCombos.getNextBubble();
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
					destroyBubbles( aKill3 );
					aGAMESCORE[2]+=aKill3.length;
					game_state = GameStates.ST_SEARCHFREE;
					break;
					
				case GameStates.ST_SEARCHFREE:
				
					if (gameMC.getChildByName("explosion") != null)
					{
						gameMC.removeChild(gameMC.getChildByName("explosion"))
					}
					
					// reset combo arry first
					objCombos.reset( aLevel, objs,aAddX, topRow );
					// now search for free bubbles
					//trace( "Start search");
					dropped = objCombos.searchForFreeBubbles( aLevel, objs );
					//trace( "free search: "+(getTimer()-t)+" ms" );
					if ( dropped > 0 ) {
						game_state = GameStates.ST_DROPBUBBLES;
						next_game_state = GameStates.ST_CHECKEMPTYLEVEL;
					}
					else game_state = GameStates.ST_CHECKEMPTYLEVEL;
					//trace("time 2 search for free bubbles :"+((getTimer()-t1)/1000)+" seconds");
					break;
					
				case GameStates.ST_LEVELSCREEN:
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_BONU);
					playfield.topdrop.visible = false;
					emptyCannon();
					// levelBonus
					setLevelBonus();
					levelEndMessage()
					
					if ( bGameOver ) 
					{
						if (bInstructions)
						{
							bInstructions = false;
							next_course_step = -1;
							cleanAllAtOnce();
							removeCoursePopup();							
						}
						// let all bubbles drop
						prepareAllBubblesToDrop();
						// end game
						gameOverDropRow = maxy-1;
						game_state = GameStates.ST_GAMEOVERDROP;
						next_game_state = GameStates.ST_LEVELSCREEN2;
					}
					else 
					{
						game_state = GameStates.ST_LEVELSCREEN2;
					}
					showLevelScreen();
					break;
					
				case GameStates.ST_LEVELSCREEN2:
					waitForShiftKey();
					break;
					
				case GameStates.ST_GAMEPAUSED:
					showEndScreen();
					game_state = 999;
					break;
					
				case GameStates.ST_GAMEFINISHED:
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_OVER);
					// hide stuff
					emptyCannon();
					playfield.topdrop.visible = false;
					
					// show popup
					
					showEndScreen();					
					textID = mTranslationData.IDS_gamefinished;
					game_state = 999;
					break;
	
				case GameStates.ST_GAMEOVERSCREEN:
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_OVER);
					// hide stuff
					emptyCannon();
					playfield.topdrop.visible = false;
					// show popup
					// let all bubbles drop
					prepareAllBubblesToDrop();
					// end game
					gameOverDropRow = maxy-1;
					//
					if ( !bGameOver ) {
						game_state = GameStates.ST_GAMEOVERDROP;
						next_game_state = 999;
					}
					else game_state = 999;
					restart();
					break;
					
				case GameStates.ST_GAMEOVERDROP:
					// drop bubbles row by row
					if ( dropBubbles( gameOverDropRow ) == 0 ) {
						if ( --gameOverDropRow < 0 ) {
							timer = t + 1000;
							game_state = next_game_state;
						}
					}
					break;
					
				case GameStates.ST_RESTART:
					game_state	= 999;
					mRootMC.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
					mRootMC.stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
					trace ("actually goto game over page")
					MenuManager.instance.menuNavigation(MenuManager.MENU_GAMEOVER_SCR)
					
					
					break;
					
				case GameStates.ST_SENDSCORE:
					game_state	= 999;
					break;
					
				case GameStates.ST_CLEANUP:
					if ( deleteBubbleRow < 0 )
					{
						game_state = GameStates.ST_HIDEPLAYFIELD;
					}
					else 
					{
						cleanUp( deleteBubbleRow )
						deleteBubbleRow--;
						timer = t + 25;
					}
					break;
					
				case GameStates.ST_HIDEPLAYFIELD:
					game_state = next_game_state;
					break;
			}
		}
		
		/**
		*	reset various score related array elements (combo score, bonus, raw score, total score, etc., Haven't looked at it so it's unclear which is what but aGAMESCORE[6] is the ultimate main score, but it needs to be divided by rnr factor number for anti-cheat purposes I think)
		**/	
		public function resetCounters ()
		{
			aGAMESCORE[0] = 0;
			aGAMESCORE[1] = 0;
			aGAMESCORE[2] = 0;
			aGAMESCORE[3] = 0;
			aGAMESCORE[4] = 0;
			aGAMESCORE[5] = 0;
		}
		
		
		
		/**
		*	create levels for the game
		**/
		public function createLevel()
		{
			objs   = [];
			aLevel = objLevel.returnEmptyLevel();
			aBubbles = objLevel.returnLevel( curLevel );
			
			
			ballDepth = 1000;
		}
		

		
		// ---------------------------------------- //
		public function setLevelBonus ()
		{
			var aBonus:Array = [250,175,150,125,100,90,80,70,60,50,50,40,40,40,30,30,30,30,20,20,20,20,15,15,15,15,10,10,10,10,5,5,5,5];
	
			aGAMESCORE[9] = 0;
			if ( !bGameOver ) {
				if ( (aGAMESCORE[4] / rnr) <= aBonus.length ) {
					aGAMESCORE[9] = aBonus[ (aGAMESCORE[4] / rnr) - 1 ];
				}
			}
			setPoints( aGAMESCORE[9] );
		}
		
			
		/**
		*	up the current level by 1
		**/	
		public function nextLevel ()
		{
			resetCounters();
			// increase curLevel var and get new level
			curLevel++; 
			nextdrop -= 1000;
			//
			if ( !bInstructions ) {
				var UseThisText = "<font color='#000000'>"+mTranslationData.IDS_level + " " + String(curLevel-courseLevels)+"</font></p></font>";
				TranslationManager.instance.setTextField(playfield.showleveltext_txt, UseThisText)
			}
		}
		
		
		/**
		*	create bubbles according to obj info
		*	@PARAM		bubbleRow		Number		...not too sure other than it indicates row the bubble is on...
		**/	
		public function createBubbles ( bubbleRow:Number ):Number
		{
			var obj   = {};
			var count:Number = 0;
			for ( var i=0; i<aBubbles.length; i++ ) {
				obj = aBubbles[i];
				if ( obj.gridY == bubbleRow ) {
					// scramble color to have different levels
					// with the same structure!

					obj.ball = aScrambledColors[ obj.ball - 1 ] + 1;
					// keep track of colors on screen
					if ( obj.ball < mainColors )
						aColors[ obj.ball - 1 ]++;
					createBallClip( obj );
					obj.gridY = -1;
					count++;
				}
			}
			
			return ( count );
		}
	
		/**
		*	based on the cell's number create a correct image of the bubble: -1 means empty
		**/	
		public function createBallClip( objBall:Cell ):void
		{
			// create new ball class
			var newBall = new Ball();
			// attach and set the movie clip
			var clip:MovieClip = AssetTool.getMC("theBalls")//new theBalls ();
			clip.name = "ball"+objBall.gridY+"_"+objBall.gridX;
			gameMC.addChild(clip);
			
			// set movie clip frame and pos
			clip.gotoAndStop( objBall.ball );
			var xyPos = getXYPos( objBall.gridX, objBall.gridY );
			clip.x = xyPos[0];
			clip.y = xyPos[1];
			// initialze ball object
			newBall.init( clip, objBall.ball );
			// add bubble obj to objs array
			objs.push( newBall );
			// add bubble obj reference to level arr
			aLevel[objBall.gridY][objBall.gridX] = objs.length-1;
		}
		
		// --------------------------------------------------- //
		public function getXYPos ( px:Number, py:Number ):Array
		{
			var xyPos:Array = [ aBorders[gameMode][_LEFT], aBorders[gameMode][_TOP] ];
			xyPos[0] += (ballW * px) + ballR +aAddX[py];
			xyPos[1] += ((ballW-yDist) * py) + ballR;
			return ( xyPos );
		}
		
		/**
		*	create a bubble/ball that's about to be aimed and launched
		**/	
		public function createActiveBall():void
		{
			// make sure we always have 3 bubbles in pipeline
			// and only use colors that are left on the screen
			fillPipeline()
	
			// show bubbles in cannon
			showCannonPipeline();
			
			// create new ball class
			activeBall = new Ball();
			// attach and set the movie clip
			var clip:MovieClip = AssetTool.getMC("theBalls")
			clip.name = "ball_"+ballDepth;			
			gameMC.addChild (clip)
			// set movie clip frame and pos
			clip.gotoAndStop( aBubblePipeline[0] );
			clip.x = aBallPos[gameMode][0];
			clip.y = aBallPos[gameMode][1];
			clip.visible = false;
			// initialze ball object
			activeBall.init( clip, aBubblePipeline[0] );
			// reset last collision bubble vars
			collidedX = -1;
			collidedY = -1;
		}
		
		/**
		*	fill up the pipeline of the cannon (bubbles that'll be shot in order)
		**/	
		public function fillPipeline():void
		{
			var rBubble = -1;
			var loop = (3-aBubblePipeline.length);
			for ( var i=0; i<loop; i++ ) {
				
				rBubble = aRarity[ Math.floor(Math.random()*aRarity.length) ];
				if ( rBubble <= mainColors ) {
					while ( aColors[ rBubble-1 ] == 0 )
						rBubble = 1 + Math.floor(Math.random()*mainColors);
				}
					
				aBubblePipeline.push(rBubble );
			}
		}
		
		// ---------------------------------------- //
		public function deleteFirstInCannonPipeline ():void
		{
			// delete active ball in pipeline
			aBubblePipeline.shift();
			showCannonPipeline();
		}
		
		// ---------------------------------------- //
		public function showCannonPipeline ():void
		{
			playfield.theCannon.color1.gotoAndStop( aBubblePipeline[0] );
			playfield.theCannon.color2.gotoAndStop( aBubblePipeline[1] );
		}
	
		/**
		*	empty pipline and hide bubbles in connon
		**/	
		public function emptyCannon ():void
		{
			angle = centerAngle;
			setAngle();
			aBubblePipeline  = [];
			playfield.theCannon.color1.gotoAndStop( 20 );
			playfield.theCannon.color2.gotoAndStop( 20 );
			if (playfield.theCannon.getChildByName("aimline1") != null)
			MovieClip(playfield.theCannon.getChildByName("aimline1")).visible = false;
		}
		
		/**
		*	carry out various actions based on user keyboard input
		**/			
		public function keyPressed ( e:KeyboardEvent ):void
		{
			var setThisAngle = false;
			switch (e.keyCode)
			{
				case Keyboard.LEFT:
				if (game_state == GameStates.ST_AIMBALL)
				{
					cannonStatus = MOVE_LEFT;
				}
				break;
				
				case Keyboard.RIGHT:
				if (game_state == GameStates.ST_AIMBALL)
				{
					cannonStatus = MOVE_RIGHT
				}
				break;
				
				case Keyboard.UP:
				cannonStatus = MOVE_UP;
				break;
				
				case Keyboard.SPACE:
				if ( bShootingAllowed ) 
				{
					if ( !bSpaceDown ) 
					{
						bSpaceDown = true;
						nKeyDown = 0;
						aGAMESCORE[4]+=rnr;
						dropCounter+=rnr;
						setBallAngle();
						activeBall.shoot();
						bShootingAllowed = false
						deleteFirstInCannonPipeline();
						game_state = GameStates.ST_BALLROLLS;
					}
				}
				if (game_state == GameStates.ST_LEVELSCREEN2)
				{
					removeLevelScreen();
				}				
				if ( bInstructions ) {
					if (( game_state == GameStates.ST_COURSE_1 ) 
					||  ( game_state == GameStates.ST_COURSE_2 )
					||  ( game_state == GameStates.ST_AIMBALL  )) 
					{
						if ( game_state == GameStates.ST_COURSE_1 )nextCourseStep();
					}
				}
				
				break;
				
				
				default:
				nKeyDown = 0;
				break;
			}
		}
		
		
		/**
		*	carry out various actions based on user keyboard input
		**/			
		public function keyReleased ( e:KeyboardEvent ):void
		{
			switch (e.keyCode)
			{
				
				case Keyboard.LEFT:
				cannonStatus = DO_NOT_MOVE;
				break;
				
				case Keyboard.RIGHT:
				cannonStatus = DO_NOT_MOVE;
				break;
				
				case Keyboard.UP:
				cannonStatus = DO_NOT_MOVE;
				break;
				
				case Keyboard.SPACE:
				bSpaceDown = false;
				break;
			}
			//check for gems user cheat code during the game
			if (curLevel >= 6)
			{
				trace ("Check for gems", e.keyCode, e.charCode)
				objGem.checkGem(e.charCode)
			}
		}
		
		
		/**
		*	rotate the cannon according to its setting
		**/			
		public function moveCannon():void
		{
			var setThisAngle:Boolean = false
			if (game_state == GameStates.ST_AIMBALL)
			{
				switch (cannonStatus)
				{
					case MOVE_RIGHT:
						trace('changed to 1');
						if ( lastShot == 1 ) nKeyDown = 0;
						lastShot = 2;
						bCannonShake = false;
						angle-=(0.01+(0.01*nKeyDown));
						nKeyDown += 1; // originally .3 in AS1 version
						setThisAngle = true;
						break;
					
					case MOVE_LEFT:
						//trace('move right');
						if ( lastShot == 2 ) nKeyDown = 0;
						lastShot = 1;
						bCannonShake = false;
						angle+=(0.01+(0.01*nKeyDown));
						nKeyDown += 1; // originally .3 in AS1 version
						setThisAngle = true;
						break;
						
					case MOVE_UP:
						if ( !bCannonShake && (angle != centerAngle) ) 
						{
							nKeyDown = 0;
							bCannonShake     = true;
							cannonShakeIndex = 0;
							angle = centerAngle;
							setThisAngle = true;
						}
						break
				}
			}
			
			
			if ( !setThisAngle ) {
				if ( bCannonShake ) {
					angle = aCannonShake[ cannonShakeIndex ];
					setThisAngle   = true;
					if ( ++cannonShakeIndex >= aCannonShake.length )
						bCannonShake = false;
						cannonStatus = DO_NOT_MOVE;
				}
			}
			if (setThisAngle)
			{
				setAngle();
			}
		}
		
		
		/**
		*	set the angle the cannon should be rotated to
		**/			
		public function setAngle ():void
		{
			if ( angle < 0.4 ) angle = 0.4;
			else if ( angle > 2.74 ) angle = 2.74;
			//trace("angle: "+angle);
			var angle2 = (angle * -1) * 180 / Math.PI;
			playfield.theCannon.rotation = angle2 + 90;
		}
		
		/**
		*	set the angle of the ball
		**/			
		public function setBallAngle ():void 
		{
			activeBall.xVelocity = power*Math.cos( (angle*-1) );
			activeBall.yVelocity = power*Math.sin( (angle*-1) );
		}
		
		/**
		*	while the ball/bubble is in move, check for collision and return boolean
		*	This is for active ball to bubble collision detection
		**/			
		public function collisionDetection ():Boolean
		{
			var collision = false;
			
			var y1 = activeBall.yPos;
			var x1 = activeBall.xPos;
			var y2 = 0;
			var x2 = 0;
			
			var dist = 0;
			var obj  = {};
			
			var bSetColl = false;
			for ( var row=(maxy-1); row>=topRow; row-- ) 
			{
				for ( var col=(maxx-1); col>=0; col-- ) 
				{
					if ( aLevel[row][col] != -1 ) {
						// get reference to actual bubble obj
						obj = objs[ aLevel[row][col] ];
						y2  = obj.yPos;
						x2  = obj.xPos;
						dist = Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
						if ( (dist < (ballW-10)) )
							bSetColl = true;
						else if ( (dist < (ballW-4)) && (row==topRow) )
							bSetColl = true;
						if ( bSetColl ) 
						{
							collisionReaction(x2,y2);
							collidedX = col;
							collidedY = row;
							collision = true;
							row = -1;
							col = -1;
						}
					}
				}
			}
			
			return ( collision );
		}
		
		
		
		
		/**
		*	based on collision angle and set the position of the active ball
		**/			
		public function collisionReaction ( x2, y2 ):void
		{
			var x1 = activeBall.ballMC.x;
			var y1 = activeBall.ballMC.y;
			
			var tx = x1 - x2;
			var ty = y1 - y2;
			var nAngle = Math.atan( ty / tx );
			
			var dist = ballW+1;
			
			if(tx >= 0 && ty >= 0) 
			{
				activeBall.xPos = (Math.cos(nAngle) * dist) + x2;
				activeBall.yPos = (Math.sin(nAngle) * dist) + y2;
			}
			else if(tx >= 0 && ty < 0) 
			{
				activeBall.xPos = (Math.cos(nAngle) * dist) + x2;
				activeBall.yPos = (Math.sin(nAngle) * dist) + y2;
			}
			else if(tx < 0 && ty >= 0) 
			{
				activeBall.xPos = -(Math.cos(nAngle) * dist) + x2;
				activeBall.yPos = -(Math.sin(nAngle) * dist) + y2;
			}
			else 
			{
				activeBall.xPos = -(Math.cos(nAngle) * dist) + x2;
				activeBall.yPos = -(Math.sin(nAngle) * dist) + y2;
			}
		}
		
		
		// ---------------------------------------- //	
		public function setNewActivePos ():Boolean
		{
			var bOK = true;
			
			var indexY = 0;
			var indexX = 0;
			
			// get closest available y position for ball
			var closest = 999999;
			var dist    = 0;
			
			for ( var py=topRow; py<maxy; py++ ) {
				dist = Math.abs(aCenterPos[py][0][1]-activeBall.yPos);
				if ( dist < closest ) {
					closest = dist;
					indexY  = py;
				}
			}
			
			// get closest available x position for ball
			var closest2 = 999999;
			var dist2    = 0;
			for ( var px=0; px<maxx; px++ ) {
				if ( (aCenterPos[indexY][px] != -1) && (aLevel[indexY][px] == -1) ) {
					dist2 = Math.abs(aCenterPos[indexY][px][0]-activeBall.xPos);
					if ( dist2 < closest2 ) {
						closest2 = dist2;
						indexX  = px;
					}
				}
			}
			
			// game over if bubble y is last row & x dist greater 20!
			if ((indexY >= (maxy-1)) && (closest>=20) )  {
				activeBall.hide();
				bOK = false;
			}
			else {
				if ( indexX == -1 ) trace("cell occupied!!");
				else {
					
					// place shot ball
					activeBall.setEndPos( aCenterPos[indexY][indexX] );
					// add bubble obj to objs array
					objs.push( activeBall );
					// add bubble obj reference to level arr
					aLevel[indexY][indexX] = objs.length-1;
				}
				
				// track pos where active ball was placed
				// for win combo search
				lastSetX = indexX;
				lastSetY = indexY;
			}
			return ( bOK );
		}
		
		
		/**
		*	while the active ball is in move, check collision with the walls
		**/	
		public function wallCollisionDetection ():Boolean
		{
			var collision = false;
			
			if ( (activeBall.xPos - ballR) < aBorders[gameMode][_LEFT] ) {
				activeBall.xVelocity *= -1;
				activeBall.xPos = aBorders[gameMode][_LEFT] + ballR;
			}
			if ( (activeBall.xPos + ballR) > aBorders[gameMode][_RIGHT] ) {
				activeBall.xVelocity *= -1;
				activeBall.xPos = aBorders[gameMode][_RIGHT] - ballR;
			}
			var top = aBorders[gameMode][_TOP];
			top += ( topRow * (ballW-yDist) );
			if ( (activeBall.yPos - ballR) < top ) {
				activeBall.yVelocity *= -1;
				activeBall.yPos = top + ballR;
				// place active ball!
				collision = true;
			}
			
			return ( collision );
		}
		
		
		/**
		*	when rainbow bubble stops, change the rainbow to whatever bubble it came in contact with
		**/		
		public function switchRainbowBubble ():void
		{
			// get the last set object
			var obj = objs[ aLevel[lastSetY][lastSetX] ];
			var newcol = -1;
			
			GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DRIP);
			
			if ( (collidedY != -1) && (collidedX != -1) ) {
				var objLast = objs[ aLevel[ collidedY ][ collidedX ] ];
				newcol = objLast.ballType;
			}
			else {
				var aN = objCombos.getNeighbours( lastSetY, lastSetX, -1 );
				if ( aN.length <= 0 ) 
				{
					//trace("rainbow bubble was set 2 random color");
					newcol = aRarity[ Math.floor(Math.random()*aRarity.length) ];
					while ( (newcol == activeBall.ballType) && (newcol >= 10) )
						newcol = aRarity[ Math.floor(Math.random()*aRarity.length) ];
				}
				else 
				{
					//trace("rainbow bubble was set 2 neighbour bubble color");
					var objN = objs[ aLevel[ aN[0][0] ][ aN[0][1] ] ];
					newcol = objN.ballType;
				}
			}
			obj.ballType = newcol;
			obj.goto( newcol );
			//trace("rainbow object "+obj+" gets new color: "+newcol+"\n");
		}
		
		
		/**
		*	add the explosion movie clip on the stage
		**/	
		public function attachExplosion ():void
		{
			var clip:MovieClip = AssetTool.getMC("explosionMC") //new explosionMC ()
			clip.name = "explosion"
			gameMC.addChild(clip)
			clip.x = activeBall.xPos;
			clip.y = activeBall.yPos;
			clip.gotoAndPlay(1);
		}
			
		// ---------------------------------------- //	
		public function triggerCannonBubble ():void
		{
			var perimeter = 85;
			var aDestroy = getPerimeterBubbles( activeBall.yPos, activeBall.xPos, perimeter );
			for ( var i=0; i<aDestroy.length; i++ ) destroyOneBubble( aDestroy[i] );
		}
		
		/**
		*	after every shot, check if there are any combos
		**/		
		public function checkForCombos ():Number
		{
			// get the last set object
			var obj = objs[ aLevel[lastSetY][lastSetX] ];
			var bcolor = obj.ballType;
			// count shot ball as well - that's why 1 + ...
			var count = 1 + objCombos.searchForCombos( lastSetY, lastSetX, bcolor );
	
			//
			// faerie balls need to be a combo of at least 5
			if ( count >= 4 ) //5
			{
				textTimer = getTimer() + 3000;
				if ( bcolor == B_FIRE ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_GOOD);
					objCombos.setFireCombo( aLevel, objs );
					game_state = GameStates.ST_SETFIRE;
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_firecombo);
				}
				else if ( bcolor == B_WATER ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_GOOD);
					objCombos.setWaterCombo( aLevel, objs );
					game_state = GameStates.ST_SETWATER;
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_watercombo);
				}
				else if ( bcolor == B_LIGHT ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_GOOD);
					objCombos.setLightCombo( aLevel, objs );
					game_state = GameStates.ST_SETLIGHT;
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_lightcombo);
				}
				else if ( bcolor == B_EARTH ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_BAD);
					objCombos.setEarthCombo( aLevel, objs );
					game_state = GameStates.ST_SETEARTH;
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_earthcombo);
				}
				else if ( bcolor == B_AIR ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_BAD);
					objCombos.setAirCombo( aLevel, objs );
					game_state = GameStates.ST_SETAIR;
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_aircombo);
				}
				else if ( bcolor == B_DARK ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_BAD);
					objCombos.setDarkCombo( aLevel, objs );
					game_state = GameStates.ST_SETDARK;
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, mTranslationData.IDS_darkcombo);
				}
				else 
				{
					objCombos.setRegularCombo( aLevel, objs );
					game_state = GameStates.ST_DESTROY;
				}
			}
			else if ( count >= 3 )
			{
				objCombos.setRegularCombo( aLevel, objs );
				game_state = GameStates.ST_DESTROY;
			}
			
			return ( count );
		}
		
		
		// -------------------------------------------------- //
		public function getPerimeterBubbles( y1, x1, perimeter ):Array
		{
			var aP  = [];
			var y2  = 0;
			var x2  = 0;
			var obj = {};
			
			for ( var i=0; i<maxy; i++ ) {
				for ( var j=0; j<maxx; j++ ) {
					if ( aLevel[i][j] != -1 ) {
						obj = objs[ aLevel[i][j] ]; // get reference to actual bubble obj
						y2  = obj.yPos;
						x2  = obj.xPos;
						if ( Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)) <= perimeter )
							aP.push( [i,j] );
					}
				}
			}
			
			return ( aP );
		}

		
		/**
		*	if there are no bubbles left on the screen, return true: this should end the level
		**/	
		public function checkEmptyLevel ():Boolean
		{
			var empty = true;
			var obj   = undefined;
			
			for ( var i=0; i<mainColors; i++ ) aColors[i] = 0;

			for ( var row=0; row<maxy; row++ ) {
				for ( var col=0; col<maxx; col++ ) {
					if ( aLevel[row][col] != -1 ) {
						obj = objs[ aLevel[row][col] ];
						aColors[ obj.ballType - 1 ]++;
						empty = false;
					}
				}
			}
			//trace( "checkEmptyLevel: "+( getTimer() - t )+" ms" );
			aColors[ playfield.theCannon.color1.currentFrame - 1 ]++;
			aColors[ playfield.theCannon.color2.currentFrame - 1 ]++;
	
			remainingColors = 0;
			for ( i=0; i<mainColors; i++ ) {
				if ( aColors[i] > 0 ) remainingColors++;
			}
	
			return ( empty );
		}
		
		// -------------------------------------------------- //
		// move all bubbles down one row
		// game is over when there's a bubble in the last row
		// -------------------------------------------------- //
		public function dropRows ( bFillFirstRow:Boolean ):Boolean
		{
			var bOK = true;
			
			// change staggered look
			if (aAddX[0] == 0 )aAddX.unshift( ballR );
			else aAddX.shift();
			setCenterPosArray();
	
			var obj = {};
			
			// clear last row and check for game over
			var row = maxy - 2;
			for ( var col=0; col<maxx; col++ ) {
				if ( aLevel[row][col] != -1 ) {
					// get reference to actual bubble obj
					obj = objs[ aLevel[row][col] ];
					gameMC.removeChild (obj.ballMC);
					objs[ aLevel[row][col] ] = -1;
					aLevel[row][col] = -1;
					bOK = false;
				}
			}
	
			// drop all rows
			var old   = 0;
			var xyPos = [];
			for ( row=(maxy-2); row>topRow; row-- ) {
				for ( col=0; col<maxx; col++ ) {
					objs[ aLevel[row][col] ] = -1;
					aLevel[row][col] = -1; // clear target first
					if ( aLevel[row-1][col] != -1 ) {
						// get reference to actual bubble obj
						old = aLevel[row-1][col];
						obj = objs[ old ];
						aLevel[row-1][col] = -1;  // empty old cell
						aLevel[row][col]   = old; // set new cell
						xyPos = getXYPos( col, row );
						obj.dropRow( xyPos[0], xyPos[1] );
					}
				}
			}
				
			if ( bFillFirstRow ) 
			{
				// set new first row
				row = topRow;
				var newobj  = {};
				var rBall   = 0;
				var maxCols = (aAddX[topRow] == 0 ) ? maxx : (maxx-1);
				for ( var col2=0; col2<maxCols; col2++ ) {
					rBall = 1 + Math.floor(Math.random()*maxBubbles);
					newobj = new Cell( row, col2, rBall );
					createBallClip( newobj );
				}
			}
			
			return ( bOK );
		}
		
		// ---------------------------------------- //	
		// put rows back up
		public function giveTop ():void
		{
			trace ("give top", topRow)
			if ( topRow == 0 ) return;
			
			GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_DROP);
			
			// change staggered look
			if (aAddX[0] != aAddX[topRow] ) {
				if (aAddX[0] == 0 )aAddX.unshift( ballR );
				else aAddX.shift();
				setCenterPosArray();
			}
			
			var old   = 0;
			var xyPos = [];
			for ( var row=0; row<(maxy-topRow); row++ ) {
				for ( var col=0; col<maxx; col++ ) {
					// clear target first
					objs[ aLevel[row][col] ] = -1;
					aLevel[row][col] = -1;
					if ( aLevel[topRow+row][col] != -1 ) {
						// get reference to actual bubble obj
						old = aLevel[topRow+row][col];
						var obj = objs[ old ];
						aLevel[topRow+row][col] = -1;  // empty old cell
						aLevel[row][col] = old; // set new cell
						xyPos = getXYPos( col, row );
						obj.dropRow( xyPos[0], xyPos[1] );
					}
				}
			}
			
			// reset stuff
			topRow = 0;
			playfield.topdrop.visible = false;
			droptimer = getTimer() + nextdrop;
		}
		
		// ---------------------------------------- //	
		public function hideOneBubble( aHide ):void
		{
			var toHide = aLevel[ aHide[0] ][ aHide[1] ];
			var obj    = objs[ toHide ];
			obj.ballMC.x = -1000;
		}
		
		// ---------------------------------------- //	
		public function destroyOneBubble ( aKill ):void
		{
			aGAMESCORE[0]++;
			var tokill = aLevel[ aKill[0] ][ aKill[1] ];
			var obj    = objs[ tokill ];
			gameMC.removeChild(obj.ballMC);
			objs[ tokill ] = -1;
			aLevel[ aKill[0] ][ aKill[1] ] = -1;
			setPoints( aGAMESCORE[7] );
		}
		
		
		// ---------------------------------------- //	
		public function destroyBubbles ( aKill ):void
		{
			aGAMESCORE[0]+=aKill.length;
			var tokill = -1;
			var obj    = {};
			for ( var i=0; i<aKill.length; i++ ) {
				tokill = aLevel[ aKill[i][0] ][ aKill[i][1] ];
				obj    = objs[ tokill ];
				gameMC.removeChild (obj.ballMC)
				objs[ tokill ] = -1;
				aLevel[ aKill[i][0] ][ aKill[i][1] ] = -1;
			}
			setPoints( aKill.length*aGAMESCORE[7] );
		}
		
		// -------------------------------------------------- //
		public function prepareAllBubblesToDrop():void
		{
			var obj      = {};
			var newDepth = 9000;
			var dropYStart     = 0;
			var dropMultiplier = 2;
			var half = (maxx/2);
			
			for ( var row=0; row<maxy; row++ ) {
				dropYStart = 3;
				for ( var col=0; col<maxx; col++ ) {
					
					if ( col < half ) dropYStart += 3;
					else if ( col > half ) dropYStart -= 3;
					
					if ( aLevel[row][col] != -1 ) {
						obj = objs[ aLevel[row][col] ];
						obj.prepareDrop( dropYStart, dropMultiplier, newDepth++ );
					}
				}
			}
		}
		
		// -------------------------------------------------- //
		// drop falling bubbles
		// -------------------------------------------------- //
		public function dropBubbles ( dropRow ):Number
		{
			if ( dropRow == undefined ) dropRow = 0;
			
			var count = 0;
			var obj   = {};
			
			for ( var row=(maxy-1); row>=dropRow; row-- ) {
				for ( var col=0; col<maxx; col++ ) {
					if ( aLevel[row][col] != -1 ) {
						// get reference to actual bubble obj
						obj = objs[ aLevel[row][col] ];
						if ( obj.moving ) {
							count++;
							obj.setDropPos();
							if ( obj.bottomDetection( aBorders[gameMode][_BOTTOM] ) ) {
								aGAMESCORE[0]++;
								if ( game_state != GameStates.ST_GAMEOVERDROP ) {
									setPoints( aGAMESCORE[7] );
								}
								count--;
								gameMC.removeChild(obj.ballMC)
								objs[ aLevel[row][col] ] = -1;
								aLevel[row][col] = -1;
							}
							else
								obj.updatePos();
						}
					}
				}
			}
			
			return ( count );
		}
		
		// ---------------------------------------- //	
		public function scrambleColors( bScramble ):void
		{
			aScrambledColors = [];
			var aTemp = [];
			
			// scramble or leave it as it is?
			if ( bScramble ) {
				for ( var i=0; i<maxBubbles; i++ ) aTemp.push( i );
				while ( aTemp.length > 0 ) {
					i = Math.floor(Math.random()* aTemp.length );
					aScrambledColors.push( aTemp[i] );
					aTemp.splice( i, 1 );
				}
			}
			else {
				for ( var i2=0; i2<maxBubbles; i2++ ) aScrambledColors.push( i2 );
			}
		}
		
		// ---------------------------------------- //	
		public function setPoints ( pAdd ):void
		{
			if ( !bInstructions ) {
				aGAMESCORE[5]+=pAdd;
				aGAMESCORE[6]+=(pAdd*rnr);
				playfield.mainScore_txt.text = (aGAMESCORE[6]/rnr).toString()
				ScoreManager.instance.changeScoreTo (aGAMESCORE[6]/rnr);
			}
		}
	
		// ---------------------------------------- //	
		public function cleanUp( deleteRow ):Number
		{
			var count = 0;
			
			for ( var col=0; col<maxx; col++ ) {
				if ( aLevel[deleteRow][col] != -1 ) {
					var obj = objs[ aLevel[deleteRow][col] ];
					gameMC.removeChild (obj.ballMC);
					aLevel[deleteRow][col]  = -1;
					count++;
				}
			}
			
			return ( count );
		}
		
		// ---------------------------------------- //	
		public function cleanAllAtOnce ():void
		{
			for ( var row=(maxy-1); row>=0; row-- )
				cleanUp( row );
		}
		
		// ---------------------------------------- //	
		public function showEndScreen ():void 
		{
			var clip:MovieClip = AssetTool.getMC("popup_game");
			clip.name = "popup_game"
			gameMC.addChild (clip)
			
			clip.x = 160;
			clip.y = 105;
			
			if (game_state == GameStates.ST_GAMEPAUSED)
			{
				TranslationManager.instance.setTextField(clip.gameOverText_txt, mTranslationData.IDS_gamepaused);
				TranslationManager.instance.setTextField(clip.sendScoreText_txt, mTranslationData.IDS_sendscore);
				TranslationManager.instance.setTextField(clip.resumeGameText_txt, mTranslationData.IDS_resume);
				TranslationManager.instance.setTextField(clip.restartGameText_txt, mTranslationData.IDS_endGame);
				clip.resumeGameBtn.addEventListener(MouseEvent.MOUSE_DOWN, resumeGame, false, 0, true)
				clip.endGameBtn.addEventListener(MouseEvent.MOUSE_DOWN, endGame, false, 0, true)
			}
		}
		
		// ---------------------------------------- //	
		public function showLevelScreen ():void
		{
			var clip:MovieClip = AssetTool.getMC("popup_level")//new popup_level ();
			clip.name = "popup_level"
			clip.nextButton.addEventListener(MouseEvent.MOUSE_DOWN, onRemoveLevelScreen, false, 0 , true);
			gameMC.addChild (clip)
			// set before bonus
			clip.level_points.text = (aGAMESCORE[5] - aGAMESCORE[9]);
			// show game bonus
			if ( curLevel >= objLevel.maxLevels ) 
			{
				setPoints(aGAMESCORE[10]);
				clip.level_gbonus.text = aGAMESCORE[10];
			} 
			else 
			{
				clip.level_gbonus.text = "";
			}
			clip.level_shots.text     = (aGAMESCORE[4] / rnr);
			clip.level_bonus.text     = aGAMESCORE[9];
			clip.level_total.text     = aGAMESCORE[5];
			clip.x = (playfield.x+28);
			clip.y = (playfield.y+28);
			//call in translation...
			clip.level_headlineText_txt.text = ""
			clip.level_gamebonusText_txt.text = ""
			TranslationManager.instance.setTextField(clip.level_headlineText_txt, textID);
			TranslationManager.instance.setTextField(clip.bubblePointsText_txt, mTranslationData.IDS_leveltext_01);
			TranslationManager.instance.setTextField(clip.shotsTotalText_txt, mTranslationData.IDS_leveltext_03);
			TranslationManager.instance.setTextField(clip.bonusTextText_txt, mTranslationData.IDS_leveltext_04);
			TranslationManager.instance.setTextField(clip.totalPointsText_txt, mTranslationData.IDS_leveltext_06);
			TranslationManager.instance.setTextField(clip.continueText_txt, mTranslationData.IDS_continue);
			
		}
		
		public function endGameMessage ():void
		{
			trace ("end game message, game.as")
		}
		
		public function levelEndMessage():void
		{
			
			if ( bGameOver ) 
			{
				textID = mTranslationData.IDS_levelhead_03;
			}
			else if ( curLevel >= objLevel.maxLevels ) 
			{
				textID = mTranslationData.IDS_levelhead_02;
			}
			else 
			{
				textID = mTranslationData.IDS_levelhead_01;
			}
			
		}
		
		// ---------------------------------------- //	
		public function waitForShiftKey ():void
		{
		}
	
		// ---------------------------------------- //
		
		public function removeLevelScreen ():void
		{
			if ( bGameOver ) game_state = GameStates.ST_GAMEOVERSCREEN;
			else game_state = GameStates.ST_NEXTLEVEL;
			var clip:MovieClip = MovieClip(gameMC.getChildByName("popup_level"))
			clip.nextButton.removeEventListener(MouseEvent.MOUSE_DOWN, onRemoveLevelScreen)
			gameMC.removeChild(clip);
			mRootMC.stage.focus = mRootMC.stage
		}
	
		// ---------------------------------------- //	
		public function attachCoursePopup():void
		{
			var clip:MovieClip = AssetTool.getMC("popup_course")
			clip.name = "popup_course"
			gameMC.addChild(clip);
			clip.x = 700;
			clip.y = 500;
			clip.nextButton.addEventListener(MouseEvent.MOUSE_DOWN, onTutorialNext, false, 0, true);
			objCourse.initPopup( clip );
			TranslationManager.instance.setTextField(clip.continueText_txt, "<font color='#000000'>"+mTranslationData.IDS_continue+"</font>");
			courseMC = clip;
		}
		
		// ---------------------------------------- //	
		public function removeCoursePopup ():void
		{
			removeTextFields();
			courseMC.nextButton.removeEventListener(MouseEvent.MOUSE_DOWN, onTutorialNext);
			gameMC.removeChild(courseMC);
			courseMC = null;
			mRootMC.stage.focus = mRootMC.stage
		}
		
		// ---------------------------------------- //	
		public function nextCourseStep ():void
		{
			TranslationManager.instance.setTextField(playfield.showInfoButton_txt, "");
			var sObj = objCourse.getNextStep();
			if ( sObj == undefined ) 
			{
				endCourse();
			}
			else 
			{
				if ( sObj.bPopUp ) 
				{
					TranslationManager.instance.setTextField(courseMC.mainTextpop_txt, "<font color='#000000'>"+sObj.stext+"</font>");
					objCourse.showPopup( (playfield.x+28), (playfield.y+28) );
				}
				else objCourse.hidePopup();
				if ( sObj.helptext != "" ) {
					TranslationManager.instance.setTextField(playfield.showInfoButton_txt, sObj.helptext);
					textTimer += 999999;
				}
				aBubblePipeline = sObj.pipeLine;
				showCannonPipeline();
				game_state = sObj.game_state;
				next_course_step = sObj.trigger_next_step;
				timer+=100;
			}
		}
		
		// ---------------------------------------- //	
		public function endCourse ()
		{
			bInstructions = false;
			next_course_step = -1;
			// clean level in case there is one loaded
			cleanAllAtOnce();
			removeCoursePopup();
			aBubblePipeline = [];
			curLevel = courseLevels;
			
			game_state = GameStates.ST_NEXTLEVEL;
		}
		
	
		// ---------------------------------------- //
		public function removeTextFields () :void
		{
			trace("\n-- IN GAME --------------------------------------------------------------------");
			for ( var i=0; i<aRemoveTxtFields.length; i++ ) 
			{
			}
			aRemoveTxtFields = [];
		}

	
	
	
	
	

		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		*	setup variables 
		**/	
		private function setupVars():void
		{
			playfield = AssetTool.getMC("PlayField")
			gameMC.addChild(playfield);
			playfield.endButton.addEventListener(MouseEvent.MOUSE_DOWN, onGamePause, false, 0, true);
			playfield.endButton.buttonMode = true;
			objGem = new Gems (this);
		}
		
		/**
		*	reset vars to restart the game
		**/	
		private function resetVars():void
		{
			aGAMESCORE = [0,0,0,0,0,0,0,1,5,0,(5*10*5)];
			ScoreManager.instance.changeScoreTo(0);
			
			setPoints (0)
			objLevel = new Level();
			objLevel.init( gameMode, maxy, maxx, false );
			aLevel = objLevel.returnEmptyLevel();
			objCourse = new Course();
			objCombos = new Combo();
			objCombos.init(maxy, maxx,maxBubbles );
			
			curLevel = bInstructions? 0 : courseLevels;
			bGameOver = false;
			//playfield.endButton.visible = false;
			if (!mRootMC.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				mRootMC.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed, false, 0, true); 
			if (!mRootMC.stage.hasEventListener(KeyboardEvent.KEY_UP))
				mRootMC.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased, false, 0, true); 
			

		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		private function onTutorialNext(evt:MouseEvent):void
		{
			if ( bInstructions ) 
			{
				if (( game_state == GameStates.ST_COURSE_1 ) 
				||  ( game_state == GameStates.ST_COURSE_2 )
				||  ( game_state == GameStates.ST_AIMBALL  )) 
				{
					if ( game_state == GameStates.ST_COURSE_1 )nextCourseStep();
				}
			}
		}
		
		private function onRemoveLevelScreen(evt:MouseEvent):void
		{
			removeLevelScreen()
		}
		
		private function onGamePause(evt:MouseEvent):void
		{
			trace (game_state)
			if (game_state != 999)
			{
				trace ("pause clicked");
				showMainMenu();
			}

		}
		
		private function resumeGame(evt:MouseEvent):void
		{
			var clip:MovieClip = gameMC.getChildByName("popup_game") as MovieClip;
			clip.resumeGameBtn.removeEventListener(MouseEvent.MOUSE_DOWN, resumeGame);
			clip.endGameBtn.removeEventListener(MouseEvent.MOUSE_DOWN, endGame);
			resume()
		}
		
		private function endGame(evt:MouseEvent):void
		{
			var clip:MovieClip = gameMC.getChildByName("popup_game") as MovieClip;
			clip.resumeGameBtn.removeEventListener(MouseEvent.MOUSE_DOWN, resumeGame);
			clip.endGameBtn.removeEventListener(MouseEvent.MOUSE_DOWN, endGame);
			bGameOver = true;
			bShootingAllowed = false
			game_state = GameStates.ST_LEVELSCREEN
			resume()
		}
	}
	
}



