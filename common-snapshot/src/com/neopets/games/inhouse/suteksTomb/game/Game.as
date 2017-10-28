/**
 * 
 *
 *@langversion ActionScript 3.0
 *@playerversion Flash 9.0 
 *@author Abraham Lee
 *@since  01.08.2010
 */

package com.neopets.games.inhouse.suteksTomb.game{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;

	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;
	import com.neopets.util.managers.ScoreManager;
	import com.neopets.util.sound.GameSoundManager;
	import com.neopets.games.inhouse.suteksTomb.game.userCheats.Gems;


	public class Game extends MovieClip
	{
		/**
		 *	************** IMPORTANT  **************
		 *
		 *	For whatever reason when you check the "omit trace actions"  in publish setting,
		 *	The game will stall.  Wasn't able to quite figure that out.  Since the game is
		 *	originally designed in AS1, by Ollie, I am not sure if some syntax is off or not
		 *	So DO NOT omit trace unless you can figure it out!!
		 *
		 *	************** IMPORTANT  **************
		 **/
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------
		protected const ST_GAME         = 1;
		protected const ST_DROP         = 2;
		protected const ST_KILL         = 3;
		protected const ST_CHECKWIN     = 4;
		protected const ST_SWAP         = 5;
		protected const ST_CHECKBOMBS   = 6;
		protected const ST_CREATELEVEL  = 7;
		protected const ST_CLEANUP      = 8;
		protected const ST_CLEANUPDONE  = 9;
		protected const ST_SECRETCHECK  = 10;
		protected const ST_SECRETCHECK2 = 11;
		protected const ST_UEBERSECRET  = 12;
		protected const ST_RESHUFFLE    = 13;
		protected const ST_RESHUFFLE2   = 14;
		protected const ST_GAMEPAUSED   = 111;
		protected const ST_GAMEOVER     = 666;
		
		

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//translated data
		private var mTranslationData:TranslationData = TranslationManager.instance.translationData;
		
		protected var mRootMC:Object;	//main timeline
		protected var mGame:MovieClip;	//play field movie clip.  all game play will be taking place here
		
		protected var mToggleButton:MovieClip;  //button that'll affect sound/music status 
		private var objGem:Gems; //for user cheat codes
		
		protected var game_state = 999;

		// main game var //
		
		
		protected var cubesObj:Cubes;
		
		protected var keyAllowed = true; // prevents holding down a key	//may not be needed
		
		// the different level parameters
		protected var aInit:Array = new Array();
		// ( xCubes, yCubes, size, drawX, drawY, numColors, time (min) )
		
	
		// points for combos
		protected var aPoints:Array     = [];
		
		// points for bomb combos
		protected var aBombPoints:Array = [];
		
		// time bonus - milliseconds per symbol
		protected var aTimeBonus:Array = [500,1000];
		
		protected var numLevels:int  = aInit.length;
		protected var difficulty:int// = 0//_global.difficulty;	//difficulty level...
		protected var bZenmode:Boolean;
	
		// help with next move
		protected var aNextMove:Array = [];
		// where to show the points
		protected var aShowPoints:Array = [];
		// bomb exploded
		protected var bombExploded:Boolean = false;
		// true if tile to swap is marked
		public var marked:Boolean = false;
		// true if cubes have been swapped without win
		protected var unswap:Boolean = false;
		// game over
		protected var gameOver:Boolean = false;
		// game speed timer
		protected var timer:Number = 0;
		// the game duration
		protected var game_timer:Number    = 0;
		protected var game_duration:Number = 0;
		// time is stopped during killing and dropping
		protected var addKillDropTimer:Number = 0;
		// timer when game is paused
		protected var pauseTimer:Number = 0;
		// play drop sound just once
		protected var playDropSound:Boolean = false;
		//
		protected var rnr = 1+Math.floor(Math.random() * 1000);
		// GS, C, AP, PB
		protected var aGAMESCORE:Array = [0,0,0,0];

		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function Game():void 
		{

		}

		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		

		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		public function setupDoc(pRootMC:Object):void
		{
			mRootMC = pRootMC;
			setupVars()
		}
		
		
		// ---------------------------------------- //	

		public function init (pDifficulty:int, pZenMode:Boolean)
		{
			objGem.resetGems();
			matchSoundSetting ();
			mGame.hourglass.gotoAndStop(1);
			difficulty = pDifficulty;
			bZenmode = pZenMode;
			//come back to these later
			//mGame.pauseGame  = _level0.ttext_pausegame;
			//mGame.pauseGame2 = _level0.ttext_pausegame2;
			
			ScoreManager.instance.changeScoreTo(0);
			aGAMESCORE[0] = 0;
			
			// pause button
			aGAMESCORE[3] = 0;
			
			begin(); // start the game //
		}



		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		// ---------------------------------------- //	
		protected function begin ():void 
		{
			cubesObj.beginRound( aInit[difficulty] );
			
			unswap = false;
			marked = false
	
			game_state = ST_CREATELEVEL;
			
			//
			mGame.showmainscore.text = mGame.showmainscoreShadow.text = "0";
			mGame.playfield.gotoAndStop(difficulty+1);
			
			if (!bZenmode )
			{
				TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_time + " " + (aInit[difficulty][6]*60) + " " + mTranslationData.IDS_seconds+"</font></font></p>");
				mGame.hourglass.alpha = 1;
			} 
			else 
			{
				TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_notimelimit+"</font>");
				mGame.hourglass.alpha = .5;
			}
			
		}
		
		// ---------------------------------------- //	
		//GEM function
		// ---------------------------------------- //	
		public function resetTime ():Boolean
		{
			if ( game_state != ST_GAME) return (false);
						
			GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SCHWING);
			game_timer += 30000;
			var t = getTimer();
			if ( (game_timer - t) > game_duration ) game_timer = t + game_duration;	
			
			TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_time2 + " " + (aInit[difficulty][6]*60) + " " + mTranslationData.IDS_seconds+"</font></font></p>");
			
			return ( true );
		}
		
		// ---------------------------------------- //
		//review this function later
		protected function sendScore (evt:MouseEvent)
		{
			if ( (game_state != ST_GAME) &&   (game_state != ST_GAMEOVER) ) {
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SCHWING);
				return (-1);
			}
			
			var s = (aGAMESCORE[0]/rnr);
			if ( Math.round(s) != s ) 
			{
				ScoreManager.instance.changeScoreTo((10*10*10*10*10)*-10);
			}
			else
			{
				ScoreManager.instance.changeScoreTo((aGAMESCORE[0]/rnr));
			}
			
			GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TILE);
	
			cubesObj.cleanUp();
			if (mGame.getChildByName("popup_end") != null) mGame.removeChild(mGame.getChildByName("popup_end"));
			if (mGame.getChildByName("popup_pause") != null) 
			{
				var popup:MovieClip = MovieClip(mGame.getChildByName("popup_pause"))
				popup.continueButton_btn.removeEventListener(MouseEvent.MOUSE_DOWN, continueGame)
				mGame.removeChild(popup);
			}
	
			game_state = ST_CLEANUP;

		}

		// ---------------------------------------- //	
		protected function restart(e:MouseEvent):void
		{
			if ( (game_state != ST_GAME) && (game_state != ST_GAMEOVER) ) 
			{
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TILE);
			}
			else 
			{
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SCHWING);
				if (mGame.getChildByName("popup_end") != null) mGame.removeChild(mGame.getChildByName("popup_end"));
				game_state = ST_CLEANUP;

			}
		}
		
		// ---------------------------------------- //	
		protected function pauseGame (e:MouseEvent):void 
		{
			if ( (game_state != ST_GAME) || (aGAMESCORE[3]>=3) ) {
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SCHWING);
				//return;
			}
			if (game_state != ST_GAMEPAUSED)
			{
				mGame.pauseGame  = "";
				mGame.pauseGame2 = "";
				// keep track of time
				pauseTimer = getTimer();
				// popup
				var popup:MovieClip = AssetTool.getMC("popup_pause")
				TranslationManager.instance.setTextField(popup.gamePaused_txt, "<font color='#FFFF31'>"+mTranslationData.IDS_paused+"</font>");
				TranslationManager.instance.setTextField(popup.continue_txt, "<font color='#FFFF00'>"+mTranslationData.IDS_continue+"</font>");
				
				popup.name = "popup_pause"
				mGame.addChild(popup);
				popup.x = 69;
				popup.y = 67;

				popup.continueButton_btn.addEventListener(MouseEvent.MOUSE_DOWN, continueGame, false, 0, true)
				
				// pause game
				aGAMESCORE[3]++;
				game_state = ST_GAMEPAUSED;
			}
		}
		
		// ---------------------------------------- //	
		protected function continueGame (e:MouseEvent):void
		{
			if ( game_state != ST_GAMEPAUSED ) {
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TILE);
				//return;
			}
			if ( aGAMESCORE[3]<3 ) {
				//_root.pauseGame  = _level0.ttext_pausegame;
				//_root.pauseGame2 = _level0.ttext_pausegame2;
			}
			//just in case
			addKillDropTimer = 0;
			//remove popup
			if (mGame.getChildByName("popup_pause") != null) 
			{
				var popup:MovieClip = MovieClip(mGame.getChildByName("popup_pause"))
				popup.continueButton_btn.removeEventListener(MouseEvent.MOUSE_DOWN, continueGame)
				mGame.removeChild(popup);
			}

			// reset timer
			game_timer += ( getTimer() - pauseTimer );
			// back to game
			game_state = ST_GAME;
			
		}
		
		// ---------------------------------------- //	
		protected function continueAfterShuffle (evt:MouseEvent):void 
		{
			trace ("popup clicked")
			if ( game_state != 999 ) {

				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TILE);
				//return;
			}
			//just in case
			addKillDropTimer = 0;
			//remove popup
			
			if (mGame.getChildByName("popup_end") != null) 
			{
				var popup:MovieClip = MovieClip (mGame.getChildByName("popup_end"))
				popup.continueButton.addEventListener(MouseEvent.MOUSE_DOWN, continueAfterShuffle);
				mGame.removeChild(popup);
			}
			// reset timer
			game_timer += ( getTimer() - pauseTimer );
			// back to game		
			game_state = ST_CHECKWIN;
		}
		
		

		// ---------------------------------------- //	
		// main loop
		public function mainLoop ():void
		{
			//trace (game_state)
			var t:int  = getTimer();
			var found:Number;
			var aDiffMulti:Array;
			if ( t < timer ) return; //return ( -1 );
			
			timer = t + 0;
			
			switch (game_state )
			{
				case ST_GAME:
					if ( !bZenmode ) showGameTimer(t);
					
					if ( cubesObj.changeCubes(t) )
					{
						unswap = false;
						game_state = ST_CHECKWIN;
					}
					//showNextMove(); //this is for cheat during testing
					break;
					
				case ST_GAMEOVER:
					// that's it my friend!
					break;
				
				case ST_CREATELEVEL:
				
					if ( cubesObj.createLevel() ) {
						game_duration = aInit[difficulty][6] * 60 * 1000;
						game_timer    = t + game_duration;
						//trace (game_timer, game_duration)
						game_state = ST_CHECKWIN;
					}
					break;
				
				case ST_DROP: // dropping cubes
	
					if ( !playDropSound ) {
						playDropSound = true;
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SLIDE);
					}
					if ( cubesObj.dropCubes() == 0 ) 
					{
						game_state = ST_SECRETCHECK;
					}
					break;
	
				case ST_SECRETCHECK: // look for the secret beetles
				
					// for the sound
					bombExploded = false;
					
					found = cubesObj.secretBeetles();
					aDiffMulti = [3,5];
									
					if ( found > 0 ) {
						TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_bomb4+"</font>");
						
						aShowPoints = cubesObj.getPointsPosition();
						aGAMESCORE[2]   = found * aDiffMulti[difficulty];
						game_timer += int(found/2)*aTimeBonus[difficulty];
						if ( (game_timer - t) > game_duration ) game_timer = t + game_duration;
						bombExploded = true;
						game_state   = ST_KILL;
						addKillDropTimer = t;
					}
					else 
					{
						game_state = ST_SECRETCHECK2;
					}
						
					break;
					
				case ST_SECRETCHECK2: // look for the secret ankh
				
					// for the sound
					bombExploded = false;
					
					found = cubesObj.secretAnkh();
					aDiffMulti = [3,5];
									
					if ( found > 0 ) 
					{
						TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_bomb5+"</font>");
						aShowPoints = cubesObj.getPointsPosition();
						aGAMESCORE[2]   = found * aDiffMulti[difficulty];
						game_timer += int(found/2)*aTimeBonus[difficulty];
						if ( (game_timer - t) > game_duration ) game_timer = t + game_duration;
						bombExploded = true;
						game_state   = ST_KILL;
						addKillDropTimer = t;
					}
					else 
					{
						game_state = ST_UEBERSECRET;
					}
						
					break;
					
				case ST_UEBERSECRET: // look for the magic face
				
					// for the sound
					bombExploded = false;
					
					found = cubesObj.magicFace();
					aDiffMulti = [3,5];
									
					if ( found > 0 ) 
					{
						TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_bomb6+"</font>");
						aShowPoints = cubesObj.getPointsPosition();
						aGAMESCORE[2]   = found * aDiffMulti[difficulty];
						game_timer += int(found/2)*aTimeBonus[difficulty];
						if ( (game_timer - t) > game_duration ) game_timer = t + game_duration;
						bombExploded = true;
						game_state   = ST_KILL;
						addKillDropTimer = t;
					}
					else 
					{
						game_state = ST_CHECKBOMBS;
					}
						
					break;
					
				case ST_CHECKBOMBS:
					bombExploded = false;
					
					var aTemp:Array   = cubesObj.bombsExploded();
					found  = aTemp[0];
					var foundWC = aTemp[1];
					var wasBomb = aTemp[2];
					
					if (  wasBomb ) 
					{

						TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_bomb2+"</font>");
						aShowPoints  = cubesObj.getPointsPosition();
						aGAMESCORE[2]    = aBombPoints[difficulty][found];
						game_timer += int(found/2)*aTimeBonus[difficulty];
						if ( (game_timer - t) > game_duration ) game_timer = t + game_duration;
						bombExploded = true;
						game_state   = ST_KILL;
						addKillDropTimer = t;
					}
					else {
						game_state = ST_CHECKWIN;
					}
					
					break;
					
				case ST_SWAP:
					if ( cubesObj.swapCubes() )
					{
						aGAMESCORE[1] = 0;
						timer  = t + 390;
						unswap = true;
						game_state = ST_CHECKWIN;
					}
					marked = false;
					break;				
	
				case ST_CHECKWIN:
					// check for win
					checkWinningLines(	unswap, t );
					break;
					
				case ST_KILL:
					// destroying cubes
					if ( cubesObj.destroyCubes(bombExploded) == 0 )
					{
						if ( aGAMESCORE[2] > 0 ) {
							mGame.theScore.gotoAndPlay(2);	//on the game field, next to text box top left
							mGame.theScore.x = aShowPoints[0]; 
							mGame.theScore.y = aShowPoints[1];
							mGame.setChildIndex(mGame.theScore, mGame.numChildren-1)
							if ( difficulty == 0 ) 
							{
								mGame.theScore._x += 10;
							}
							else 
							{
								mGame.theScore._y -= 3;
							}
							// show message
							if ( aGAMESCORE[1] > 1 ) {
								if (!bZenmode )
								{
									var displaythecombo:String = "<p align='center'>"+mTranslationData.IDS_bomb3+aGAMESCORE[1]+"</p>";
									
									TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+ displaythecombo+"</font>");
									aGAMESCORE[2] *= aGAMESCORE[1];
								}
							}
							// give the points
							setPoints(aGAMESCORE[2]);
						}
						
	
						timer = t + 500;
						playDropSound = false;
						game_state = ST_DROP;
					}
					else
					{
						timer = t + 50;
					}
					break;
					
				case ST_RESHUFFLE:
					// reset score in Zen mode
					
					if ( bZenmode ) 
					{
						aGAMESCORE[0] = 0;
						mGame.showmainscore.text = "0";
						mGame.showmainscoreShadow.text = "0";
					}
					
					// reset cubes object
					cubesObj.beginRound( aInit[difficulty] );
					game_state = ST_RESHUFFLE2;
					timer = t + 100;
					break;
					
				case ST_RESHUFFLE2:
					// create new level row by row
					if ( cubesObj.createLevel() ) {
						//trace("bETA");
						var popup:MovieClip = MovieClip(mGame.getChildByName("popup_end"))
						TranslationManager.instance.setTextField (popup.shuffleText_txt,"<font color='#FFFFFF'>"+mTranslationData.IDS_reshuffle2+"</font>");
						TranslationManager.instance.setTextField (mGame.helptext_txt,"<font color='#FFFFFF'>"+mTranslationData.IDS_reshuffle2+"</font>");
						popup.continueButton.visible = true;
						game_state = ST_GAMEOVER;
					}
					
					timer = t + 100;
					break;
					
				case ST_CLEANUP:
					if ( cubesObj.cleanUp() )
						game_state = ST_CLEANUPDONE;
					break;
					
				case ST_CLEANUPDONE:
					game_state = 999;
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TRANS);
					//
					if (mGame.getChildByName("popup_end") != null) mGame.removeChild(mGame.getChildByName("popup_end"));
					if (mGame.getChildByName("popup_pause") != null) 
					{
						var popup2:MovieClip = MovieClip(mGame.getChildByName("popup_pause"))
						popup2.continueButton_btn.removeEventListener(MouseEvent.MOUSE_DOWN, continueGame)
						mGame.removeChild(popup2);
					}
					MovieClip(this.parent).endGame()
					break;
			}
		}
		
		
		// ---------------------------------------- //	
		protected function showGameTimer (t:int):void 
		{
			if ( addKillDropTimer > 0 ) {
				var diff = t - addKillDropTimer
				addKillDropTimer = 0;
				game_timer += diff;
			}
			
	
			if ( game_timer < t) {
				GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TRANS);
				TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_gameover1+"</font>");
				var popup:MovieClip = AssetTool.getMC("popup_timeMC")
				TranslationManager.instance.setTextField(popup.timesup_txt, "<font color='#FFFF31'>"+mTranslationData.IDS_timesup+"</font>");
				popup.name = "popup_end"
				mGame.addChild(popup);
				popup.x = 69;
				popup.y = 67;
				game_state = ST_GAMEOVER;
			}
			else {
				var perc:Number = ( (game_timer-t) * 100 ) / game_duration;
				var f:Number = Math.floor(200 * (perc/100));
				mGame.hourglass.gotoAndStop(200-f);
			}
		}
		
		// ---------------------------------------- //	
		public function mouseClick ():void
		{
			if ( game_state != ST_GAME )
			{
				trace ("mouse click off", 1)
				return;
			}
			
			if ( !cubesObj.hitCube() ) 
			{
				trace ("mouse click off", 2)
				return;
			}
			
			GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TILE);
			if ( cubesObj.clickCube( marked ) )
			{
				if ( marked )
				{
					game_state = ST_SWAP;
				}
				else marked = true;
			}
		}
		
		// ---------------------------------------- //	
		protected function checkWinningLines ( bUnswap:Boolean, t:int )
		{
			unswap = false;
	
			var aFound:Array = cubesObj.checkForWin();
			var found:Number  = 0;
	
			aGAMESCORE[2] = 0;
	
			if ( aFound.length > 0 ) {
				if ( aGAMESCORE[1] < 10 ) aGAMESCORE[1]++;
				aShowPoints = cubesObj.getPointsPosition();
				for ( var i=0; i<aFound.length; i++ ) {
					found += aFound[i];
					aGAMESCORE[2] += aPoints[difficulty][ aFound[i] ];
				}
				game_timer += int(found/2) * aTimeBonus[difficulty];
				if ( (game_timer - t) > game_duration ) game_timer = t + game_duration;
				marked = false;
				game_state = ST_KILL;
				addKillDropTimer = t;
			}
			else
			{
	
				if ( bUnswap ) {
	
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SCHWING);
					TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_lineup+"</font>");
										cubesObj.unswapCubes();
				}
				
				aNextMove = cubesObj.getMoves();
		
				if (aNextMove.length < 3 ) {
	
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_TRANS);
					
					TranslationManager.instance.setTextField (mGame.helptext_txt,"<font color='#FFFFFF'>"+mTranslationData.IDS_reshuffle+"</font>");
					
					var popup:MovieClip = AssetTool.getMC("popup_endMC")
					TranslationManager.instance.setTextField (popup.shuffleText_txt,"<font color='#000000'>"+mTranslationData.IDS_reshuffle+"</font>");
					TranslationManager.instance.setTextField (popup.nomoremoves_txt,"<font color='#FFFF31'>"+mTranslationData.IDS_nomoremoves+"</font>");
					popup.name = "popup_end"
					mGame.addChild(popup);
					popup.x = 69;
					popup.y = 67;
					popup.continueButton.visible = false;
					//TranslationManager.instance.setTextField(popup.continueButton.continue_txt,"<font color='#FFFF31'>"+mTranslationData.IDS_nomoremoves+"</font>");
					popup.continueButton.addEventListener(MouseEvent.MOUSE_DOWN, continueAfterShuffle, false, 0, true)
					// reshuffle board
					pauseTimer = t;
					
					game_state = ST_RESHUFFLE;

				}
				else 
				{
		
					game_state = ST_GAME;
				}
			}
		}
		
		// ---------------------------------------- //	
		public function showNextMove ():void
		{
			if ( game_state != ST_GAME )
			{
				//return;
			}
			else
			{
				//GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_WILD); // When called each frame, this is painful to listen to.
				//this.marked = true;
				cubesObj.markNextMove( this.aNextMove );
			}
		}
		
		// ---------------------------------------- //	
		protected function setPoints ( pAdd ):void
		{
			if ( bZenmode ) pAdd = 1;
			
			aGAMESCORE[0] += (pAdd * rnr);
			mGame.theScore.score.scoreText.text = pAdd.toString();
			mGame.theScore.scoreShadow.scoreText.text = pAdd.toString();
			

			mGame.showmainscore.text = (aGAMESCORE[0]/rnr).toString(); //_root.GAMESCORE.show();
			mGame.showmainscoreShadow.text = mGame.showmainscore.text;
		}
		
		// ---------------------------------------- //
		protected function setupVars():void
		{
			//by default, unless changed other wise at init() stage
			bZenmode = false;
			difficulty = 0;
			
			// ( xCubes, yCubes, size, drawX, drawY, numColors, time (min) )
			aInit.push( new Array(  8,  8, 50, 29, 27, 5, 1 ) );
			aInit.push( new Array( 10, 10, 40, 29, 27, 7, 1 ) );
			aPoints.push( [1,1,1, 3, 6,12, 24, 48, 96, 192, 384, 768, 1536] );
			aPoints.push( [3,3,3,10,20,40, 80,160,320, 640,1280,2560, 5120] );
			aBombPoints.push( [0,2,4,6,8,10,12,14,16,18,20] );
			aBombPoints.push( [0,4,8,12,16,20,24,28,32,36,40] );
			
			//set up gaming field
			mGame = AssetTool.getMC("GamePlayField")
			mGame.hourglass.addEventListener(MouseEvent.MOUSE_DOWN, pauseGame, false, 0, true);
			mGame.restartButton.addEventListener(MouseEvent.MOUSE_DOWN, restart, false, 0, true);
			mGame.sendScoreButton.addEventListener(MouseEvent.MOUSE_DOWN, sendScore, false, 0, true);
			
			mGame.hourglass.buttonMode = true;
			mGame.sendScoreButton.btnArea.buttonMode = true;
			
			//mGame.showmainscore.text = mGame.showmainscoreShadow.text = "0";
			cubesObj = new Cubes (mGame, this);
			
			addChild (mGame)
			
			mToggleButton = mGame.toggleButton
			mToggleButton.addEventListener(MouseEvent.MOUSE_DOWN, toggleButtonClicked, false, 0, true);
			
			//set various text
			TranslationManager.instance.setTextField(mGame.tempText, "<font color='#FF9A00'>"+mTranslationData.IDS_pausegame+"</font>")
			TranslationManager.instance.setTextField(mGame.tempText2, "<font color='#FF9A00'>"+mTranslationData.IDS_pausegame2+"</font>")
			TranslationManager.instance.setTextField (mGame.sendScoreButton.button_txt,"<font color='#000000'>"+mTranslationData.IDS_endgame+"</font>");
			TranslationManager.instance.setTextField (mGame.restartButton.button_txt,"<font color='#000000'>"+mTranslationData.IDS_restartgame+"</font>");
			
			//for cheat purposes
			objGem = new Gems (this);
			if (!mRootMC.stage.hasEventListener(KeyboardEvent.KEY_UP))
				mRootMC.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased, false, 0, true);
				
			
		}
		
		/**
		 *	When the sound button is clicked the sound will change its settings
		 *	this toggleButtonClicked and matchSoundSetting is redundant (take a look at ExtInstructionScreen)
		 * 	but don't argue with me. it was just fast fix :p
		 **/
		private function toggleButtonClicked (evt:MouseEvent):void
		{
			if (GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				GameSoundManager.musicOn = false
				GameSoundManager.stopSound(Sounds.SND_LOOP);
				mToggleButton.gotoAndStop("sound")
			}
			else if (!GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				GameSoundManager.soundOn = false
				mToggleButton.gotoAndStop("off")
			}
			else if (!GameSoundManager.musicOn && !GameSoundManager.soundOn)
			{
				GameSoundManager.soundOn = true
				GameSoundManager.musicOn = true
				GameSoundManager.soundPlay(GameSoundManager.musicOn, Sounds.SND_LOOP, true);
				mToggleButton.gotoAndStop("on")
			}
		}
		
		/**
		 *	The toggle button's display will be set based on GameSoundManager's music and sound setting (on or off)
		 *	This public function should be called whenever game is started (since the setting might have changed from the instructions button
		 **/
		public function matchSoundSetting ():void
		{
			if (GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				mToggleButton.gotoAndStop("on")
			}
			else if (!GameSoundManager.musicOn && GameSoundManager.soundOn)
			{
				mToggleButton.gotoAndStop("sound")
			}
			else if (!GameSoundManager.musicOn && !GameSoundManager.soundOn)
			{
				mToggleButton.gotoAndStop("off")
			}
		}
		
		/**
		*	carry out various actions based on user keyboard input
		**/			
		public function keyReleased ( e:KeyboardEvent ):void
		{
			objGem.checkGem(e.charCode);
		}
		






		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------

		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

	}

}