// ---------------------------------------------------------------
class classes.game_class_527
{
	// game state vars
	var st_init:Number;
	var st_gamehelp:Number;
	var st_level:Number;
	var st_play:Number;
	var st_cntdwn1:Number;
	var st_cntdwn2:Number;
	var st_cntdwn3:Number;
	var st_b4nextlevelwait:Number;
	var st_gameover:Number;
	var st_endwait:Number;
	var st_restart:Number;
	var st_sendscore:Number;

	var game_state:Number;
	
	var aRR:Array;  // powerup rarities
	var aGS:Array;  // holds sensitive vars
	var aFP:Array;  // play field positions
	var aGF:Array;  // boolean game flags
	var aCN:Array;  // the cannon classes
	var aPR:Array;  // the pirates
	var aEN:Array;  // the enemie classes
	var aCD:Array;  // collision distances
	var aAT:Array;  // array of char codes = names of movie clips to be attached
	var aRP:Array;  // random phrases
	var aMC:Array;  // keep track of all attached movieclips 
	
	// master chief
	var chief:Object;
	var jacques:Object;
	
	// key codes
	var kShift:Number;
	
	// in game help screen
	var bShowGameHelp:Boolean;
	
	// ---------------------------------------------------------------
	// constructor
	// ---------------------------------------------------------------
	function game_class_527()
	{
		this.st_init      = 0;
		this.st_gamehelp  = 2;
		this.st_level     = 4;
		this.st_play      = 6;
		this.st_cntdwn1   = 8;
		this.st_cntdwn2   = 10;
		this.st_cntdwn3   = 12;
		this.st_gameover  = 18;
		this.st_b4nextlevelwait = 20;
		this.st_endwait   = 22;
		this.st_restart   = 24;
		this.st_sendscore = 26;
	
		this.game_state = this.st_init;
		
		// pirate names
		this.aPR = [];
		this.aPR.push ( { name:_level0.IDS_pirate_01, value:2, iY1:160, iY2:290, rarity:900 } );
		this.aPR.push ( { name:_level0.IDS_pirate_02, value:2, iY1:180, iY2:300, rarity:800 } );
		this.aPR.push ( { name:_level0.IDS_pirate_03, value:3, iY1:167, iY2:278, rarity:700 } );
		this.aPR.push ( { name:_level0.IDS_pirate_04, value:3, iY1:138, iY2:280, rarity:600 } );
		this.aPR.push ( { name:_level0.IDS_pirate_05, value:5, iY1:130, iY2:170, rarity:100 } );
		this.aPR.push ( { name:"The PhantomOrangeShirtGuy", value:10, iY1:170, iY2:300, rarity:1 } );
		
		//var t = getTimer();
		this.aRR = [];
		for ( var i=0; i<this.aPR.length; i++ ) {
			for ( var j=0; j<this.aPR[i].rarity; j++ ) {
				this.aRR.push( i );
			}
		}
		//trace("Time: "+(getTimer()-t));
		
		// aGS = Game Score values 
		//  0 = rnr - score multiplier - obfuscation
		//  1 = game timer
		//  2 = obfuscated game score
		//  3 = lives
		//  4 = current level
		//  5 = min time between enemies/cannons
		//  6 = max time between enemies/cannons
		//  7 = text timer
		//  8 = next level score
		//  9 = wait after being hit timer
		// 10 = the player's current x spot
		// 11 = the player's current y spot
		// 12 = enemy activation timer
		// 13 = enemy duration
		// 14 = last enemy
		// 15 = cannon activation timer
		// 16 = cannon duration
		// 17 = last cannon
		// 18 = click timer
		// 19 = hit timer
		// 20 = b4 next level timer
		this.aGS = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		
		// aFP = play field positions
		this.aFP = [];
		
		// start player at the center position in the back
		this.aGS[10] = 2;
		this.aGS[11] = 1;
		
		// aRNR = Red Negg Rarity values
		// game flags
		// 0 = game over
		// 1 = get ready for next level
		// 2 = hit by scoop
		this.aGF = [false,false,false];
		
		// create movie clip linkage names
		// garin:   j7db5jdnx82k = [106,55,100,98,53,106,100,110,120,56,50,107]
		// cannon:  ks8tfdhbz5nw = [107,115,56,116,102,100,104,98,122,53,110,119]
		// balls:   auh7sr22lv0s = [97,117,104,55,115,114,50,50,108,118,48,115]
		// bucket:  0sj46vn2fd0s = [48,115,106,52,54,118,110,50,102,100,48,115]
		// enmies:  in38shn08fuh = [105,110,51,56,115,104,110,48,56,102,117,104]
		// jacques: 9knc5rsgw29s = [57,107,110,99,53,114,115,103,119,50,57,115]
		this.aAT = [];
		var ac = [[106,55,100,98,53,106,100,110,120,56,50,107],[107,115,56,116,102,100,104,98,122,53,110,119],[97,117,104,55,115,114,50,50,108,118,48,115],[48,115,106,52,54,118,110,50,102,100,48,115],[105,110,51,56,115,104,110,48,56,102,117,104],[57,107,110,99,53,114,115,103,119,50,57,115]];
		for ( var i=0; i<ac.length; i++ ) {
			this.aAT.push("");
			for ( var j=0; j<ac[i].length; j++ ) this.aAT[i]+=String.fromCharCode(ac[i][j]);
		}
		
		// the cannons
		this.aCN = [];
		
		// the enemies
		this.aEN = [];
		
		// random phrases
		this.aRP = [];
		this.aRP.push( [_level0.IDS_random_phrase1_1,_level0.IDS_random_phrase1_2,_level0.IDS_random_phrase1_3] );
		this.aRP.push( [_level0.IDS_random_phrase2_1,_level0.IDS_random_phrase2_2,_level0.IDS_random_phrase2_3] );
		this.aRP.push( [_level0.IDS_random_phrase3_1,_level0.IDS_random_phrase3_2,_level0.IDS_random_phrase3_3] );
		
		// our movieclip waste manager :)
		this.aMC = [];

		// our master chief object
		// movieclip, boolean got cannonball, boolean got water
		this.chief = { m:undefined, bBall:false, bWater:false, bFreeze:false };
		
		// the first mate and ignition chief
		this.jacques = {};
		
		// keyCodes
		this.kShift = Key.SHIFT;
		
		// in game help screen
		this.bShowGameHelp = false;
	}
	
	// ---------------------------------------------------------------
	public function initGame( t )
	{
		if ( this.game_state != this.st_init ) return;
		
		_global.gMyNeoStatus.sendTag("Game Started");
		
		// the score
		_root.GS.changeTo(0);

		// game field var
		this.setFP(0);
		
		// --------------------------------------------------------------
		// attach hero
		var clip = _root.attachMovie(this.aAT[0],this.aAT[0],5000);
		if ( clip == undefined ) {
			this.xyz(this.aAT[0]);
			this.cleanUp();
			return;
		}
		this.aMC.push( clip );
		this.chief.m = clip;
		
		this.setChiefPos( this.aGS[11] ); // pass current y - no walk animation

		// --------------------------------------------------------------
		// the enemie objects
		// bActive = enemy's on screen
		// bAvailable = enemy's spot is taken by cannon
		for ( var i=1; i<=4; i++ ) {
			// depths
			var d1 = 100 + (i*2);
			var d2 = 1200 + (i*2);
			// attach enemy
			var clip = _root.attachMovie(this.aAT[4],this.aAT[4]+"_"+String(i),(d1-10));
			if ( clip == undefined ) {
				this.xyz(this.aAT[4]);
				this.cleanUp();
				return;
			}
			clip._x = 60+((i-1)*170);
			clip._y = 130;
			this.aMC.push( clip );
			this.aEN.push( { m:clip, id:-1, state:0, bActive:false, bEntered:false, bStrike:false, iD1:d1, iD2:d2, tEnd:0 } );
			//trace("new enemy depths: "+this.aEN[i-1].iD1+", "+this.aEN[i-1].iD2);
		}
		
		// --------------------------------------------------------------
		// attach ship part
		var clip = _root.attachMovie("mcReeling","mcReeling",130);
		if ( clip == undefined ) {
			this.xyz("mcReeling");
			this.cleanUp();
			return;
		}
		clip._x =   0;
		clip._y = 256;
		this.aMC.push( clip );
		
		// --------------------------------------------------------------
		// attach jacques
		var clip = _root.attachMovie(this.aAT[5],this.aAT[5],160);
		if ( clip == undefined ) {
			this.xyz(this.aAT[5]);
			this.cleanUp();
			return;
		}
		clip._x = -500;
		clip._y = -500;
		this.aMC.push( clip );
		this.jacques = { m:clip, bActive:false, iCannon:-1, ymov:0, speed:0, tTimer:0 };
		
		// --------------------------------------------------------------
		// attach scoreboard
		var clip = _root.attachMovie("scoreboard","scoreboard",9970);
		if ( clip == undefined ) {
			this.xyz("scoreboard");
			this.cleanUp();
			return;
		}
		clip._x = 0;
		clip._y = 0;
		this.aMC.push( clip );
		
		// --------------------------------------------------------------
		// attach black frame
		var clip = _root.attachMovie("mcFrame","mcFrame",9995);
		if ( clip == undefined ) {
			this.xyz("mcFrame");
			this.cleanUp();
			return;
		}
		clip._x = -100;
		clip._y = -100;
		this.aMC.push( clip );

		// set game vars
		this.aGS[0] = 100+random(9000); // rnr
		this.aGS[1] = t; // game timer
		this.aGS[2] = 0; // score

		// test
		// this.aGS[4] = 2*this.aGS[0];
		
		this.aGS[14] = random( random(this.aEN.length) ); // random last enemy number
		this.aGS[17] = random( random(this.aCN.length) ); // random last cannon number
		
		this.xxxxx(5); // set 5 lives to start
		
		_root.displayscore = 0;
	}

	// ---------------------------------------------------------------
	// attach the cannons
	// ---------------------------------------------------------------
	public function attachCannons()
	{
		var cpos = 1;
		for ( var i=1; i<=3; i++ ) {
			// attach cannon
			var clip = _root.attachMovie(this.aAT[1],this.aAT[1],1000+i);
			if ( clip == undefined ) {
				this.xyz(this.aAT[1]);
				this.cleanUp();
				return;
			}
			clip._x = this.aFP[0][cpos].x;
			clip._y = this.aFP[0][cpos].y;
			this.aMC.push( clip );
			var objC = { m:clip, bIgnited:false, bLoaded:false, bBurning:false, pos:cpos, t:0 };
			this.aCN.push( objC );
			cpos+=2;
		}
	}
	
	// ---------------------------------------------------------------
	// attach the cannon balls and the water bucket
	// ---------------------------------------------------------------
	public function attachTools()
	{
		// --------------------------------------------------------------
		// attach cannonball pile
		var clip = _root.attachMovie(this.aAT[2],this.aAT[2],2000);
		if ( clip == undefined ) {
			this.xyz(this.aAT[2]);
			this.cleanUp();
			return;
		}
		clip._x = -9;
		clip._y = 390;
		this.aMC.push( clip );
			
		// --------------------------------------------------------------
		// attach bucket
		var clip = _root.attachMovie(this.aAT[3],this.aAT[3],3000);
		if ( clip == undefined ) {
			this.xyz(this.aAT[3]);
			this.cleanUp();
			return;
		}
		clip._x = 535;
		clip._y = 385;
		this.aMC.push( clip );
	}
	
	// ---------------------------------------------------------------
	// game field var
	// ---------------------------------------------------------------
	public function setFP( nLevel )
	{
		this.aFP = [];
		
		// front row
		var x = 150;
		var y = 150;
		this.aFP.push( [] );
		this.aFP[0].push( { x:-60+x, y:228+y, iActive:1, cannonID:-1 } );
		this.aFP[0].push( { x: 90,   y:295,   iActive:2, cannonID:-1 } ); // cannon 1
		this.aFP[0].push( { x:108+x, y:228+y, iActive:1, cannonID:-1 } );
		this.aFP[0].push( { x:270,   y:295,   iActive:2, cannonID:-1 } ); // cannon 2
		this.aFP[0].push( { x:288+x, y:228+y, iActive:1, cannonID:-1 } );
		this.aFP[0].push( { x:450,   y:295,   iActive:2, cannonID:-1 } ); // cannon 3
		this.aFP[0].push( { x:468+x, y:228+y, iActive:1, cannonID:-1 } );

		// back row
		this.aFP.push( [] );
		this.aFP[1].push( { x:-40+x, y:258+y, iActive:1, cannonID:-1 } );
		this.aFP[1].push( { x: 70+x, y:258+y, iActive:1, cannonID:-1 } );
		this.aFP[1].push( { x:250+x, y:258+y, iActive:1, cannonID:-1 } );
		this.aFP[1].push( { x:430+x, y:258+y, iActive:1, cannonID:-1 } );
		this.aFP[1].push( { x:500+x, y:258+y, iActive:1, cannonID:-1 } );
		
		// set cannon positions
		if ( nLevel > 2 ) {
			this.aFP[0][1].iActive  = 0;
			this.aFP[0][1].cannonID = 0;
			this.aFP[0][3].iActive  = 0;
			this.aFP[0][3].cannonID = 1;
			this.aFP[0][5].iActive  = 0;
			this.aFP[0][5].cannonID = 2;
		}
	}
	
	// ---------------------------------------------------------------
	// public function resetCannons()
	// ---------------------------------------------------------------
	public function rrrCCC1()
	{
		for ( var i=0; i<this.aCN.length; i++ ) {
			this.rrrCCC2(i);
		}
	}
	
	// ---------------------------------------------------------------
	// public function resetEnemies()
	// ---------------------------------------------------------------
	public function rrrEEE()
	{
		for ( var i=0; i<this.aEN.length; i++ ) {
			this.eed(i); // deactivateEnemy
		}
	}
	
	// ---------------------------------------------------------------
	public function setScore() {
		_root.GS.changeTo( (this.aGS[2]/this.aGS[0]) );
	}
	
	// ---------------------------------------------------------------
	public function endGame() {
		this.game_state = this.st_gameover;
	}

	// ---------------------------------------------------------------
	public function restart() {
		this.game_state = this.st_restart;
	}

	// ---------------------------------------------------------------
	public function sendScore() {
		this.game_state = this.st_sendscore;
	}

	// ---------------------------------------------------------------
	public function showGameOverScreen( iFrame )
	{
		if ( _root.mcLevelText != undefined ) {
			_root.mcLevelText.removeMovieClip();
		}
		var lev = this.getCurrentLevel();
		if ( lev > 10 ) lev = 10;
		_root.levelText = _level0["IDS_level_"+lev];
		var clip = _root.attachMovie("mcGameOver","mcGameOver",9985);
		clip._x = 0;
		clip._y = 0;
		clip.gotoAndStop(iFrame);
		this.aMC.push( clip );
	}
	
	// ---------------------------------------------------------------
	private function showGameHelp()
	{
		var bShow = false;
		
		if ( _global.bGameHelp ) {
			if ( _root.displaylevel <= 3 ) {
				var clip = _root.attachMovie("mcGameHelp","mcGameHelp",9981,{_x:50,_y:50});
				clip.gotoAndStop( _root.displaylevel );
				this.aMC.push( clip );
				bShow = true;
			}
			
			if ( _root.displaylevel >= 3 ) this.bShowGameHelp = true;
		}
		else {
			this.bShowGameHelp = true;
		}
		
		return( bShow );
	}
	
	// ---------------------------------------------------------------
	public function hideGameHelp()
	{
		_root.mcGameHelp.removeMovieClip();
		this.game_state = this.st_level;
	}
	
	// ---------------------------------------------------------------
	public function skipGameHelp()
	{
		_global.bGameHelp = false;
		_root.mcGameHelp.removeMovieClip();
		this.game_state = this.st_level;
	}
	
	// ---------------------------------------------------------------
	public function initLevelText()
	{
		var lev = this.getCurrentLevel();
		_root.curlevel = lev;
		_root.nextlevel = (this.aGS[8] / this.aGS[0]);
		var clip = _root.attachMovie("mcLevelText","mcLevelText",9990);
		clip._x = 0;
		clip._y = 0;
		this.aMC.push( clip );
	}
	
	// ---------------------------------------------------------------
	public function mainLoop()
	{
		var t = getTimer();
		
		// make sure game runs with the same speed on fast machines!
		if ( t < this.aGS[1] ) return ( -1 );
		this.aGS[1] = t + 10;
		
		// clear text field
		if ( this.aGS[1] >= this.aGS[7] ) {
			this.showHelpText("");
		}
		
		switch ( this.game_state )
		{
			case this.st_init:
				// initialize game vars and attach stuff
				this.initGame( t );
				this.game_state = this.st_cntdwn1;
				break;
				
			case this.st_cntdwn1:
				this.zz(t); // init level
				this.initLevelText();
				this.game_state = this.st_cntdwn2;
				break;
				
			case this.st_cntdwn2:
				if ( _root.mcBlackLayer != undefined ) {
					_root.mcBlackLayer.removeMovieClip();
				}
				// nothing - wait for user to click
				break;
				
			case this.st_cntdwn3:
				this.game_state = this.st_gamehelp;
				_root.mcLevelText.removeMovieClip();
				break;
				
			case this.st_gamehelp:
				if ( !this.bShowGameHelp ) {
					var bShow = this.showGameHelp();
					if ( !bShow ) {
						this.game_state = this.st_level;
					} else {
						this.game_state = 1001;
					}
				}
				else {
					this.game_state = this.st_level;
				}
				break;
				
			case this.st_level:
				this.zz2(t); // set timer for cannon and enemy
				this.game_state = this.st_play;
				break;
				
			case this.st_play:
			
				// time for the next enemy?
				if ( t >= this.aGS[12] ) {
					// pick next available enemy
					if ( this.yy_y(t) ) { 
						// set next enemy timer if we picked an anemy
						this.zz_z(t);
					}
				}
				
				// time for the next cannon?
				// no Jacques in first 2 levels
				if ( _root.displaylevel > 2 )
				{
					if ( this.aGS[15] != -1 ) {
						if ( t >= this.aGS[15] ) {
							if ( !this.jacques.bActive ) {
								this.yy_yy(t); // pick next available cannon and activate Jacques
								this.aGS[15] = -1;
								this.zz_zz(t); // set next cannon timer
							}
						}
					}
				}
				
				// update enemies and cannons
				this.y_y( t );
				
				// reached score for next limit?
				if ( this.aGS[2] >= this.aGS[8] ) {
					//trace("level limit reached");
					// set next level var
					this.aGF[1] = true;
				}
				
				// game over?
				if ( this.aGF[0] ) this.game_state = this.st_gameover;
				// time to activate the next level?
				else if ( this.aGF[1] ) {
					this.aGS[20] = t + 1000;
					this.game_state = this.st_b4nextlevelwait;
				}
				
				break;
				
			case this.st_b4nextlevelwait:
				if ( t > this.aGS[20] ) {
					this.aGS[18] = t + 750;
					this.game_state = this.st_cntdwn1;
				}
				break;
				
			case this.st_gameover:
				this.setScore();
				//this.showGameOverScreen(2);
				this.game_state = this.st_endwait;
				this.cleanUp();
				_root.playSound(4,false);
				_root.gotoAndStop("gameoverframe");
				break;
				
			case this.st_endwait:
				// wait for user to select restart or send score
				break;
				
			case this.st_restart:
				this.cleanUp();
				_root.gotoAndStop("introframe");
				break;
				
			case this.st_sendscore:
				this.cleanUp();
				_root.gotoAndStop("sendscoreframe");
				break;
		}
	}

	// ---------------------------------------------------------------
	// init level
	// ---------------------------------------------------------------
	public function zz( t )
	{
		// increase level var
		this.aGS[4] += this.aGS[0];
		var cl = this.getCurrentLevel();
		
		_global.gMyNeoStatus.sendTag("Reached Level "+cl);
		
		// the cannonball and the water bucket start at level 2
		if ( cl > 1 ) {
			this.attachTools();
		}
		// the cannons start at level 3
		if ( cl == 3 ) {
			this.attachCannons();
		}
		
		// timer vars
		if ( cl <= 2 ) {
			this.aGS[5] = 1500;
			this.aGS[6] = 2500;
		}
		else {
			this.aGS[5] = 2000-(cl*250);
			this.aGS[6] = 4000-(cl*250);
		}
		
		// score to reach the next level
		if ( cl == 1 ) this.aGS[8] = 25 * this.aGS[0];
		else if ( cl == 2 ) this.aGS[8] = 75 * this.aGS[0];
		else if ( cl == 3 ) this.aGS[8] = 150 * this.aGS[0];
		else if ( cl == 4 ) this.aGS[8] = 300 * this.aGS[0];
		else if ( cl == 5 ) this.aGS[8] = 500 * this.aGS[0];
		else if ( cl == 6 ) this.aGS[8] = 750 * this.aGS[0];
		else if ( cl == 7 ) this.aGS[8] = 1000 * this.aGS[0];
		else this.aGS[8] = ((cl-5)*500) * this.aGS[0]; //((this.aGS[2]/this.aGS[0])+(100+(cl*50))) * this.aGS[0];
		
		// enemy duration before you'll lose a life
		if ( cl <= 3 ) this.aGS[13] = 5000;
		else this.aGS[13] = 3600-(cl*200);
		
		// reset next level booleans
		this.aGF[1] = false;
		_root.displaylevel = cl;
		
		this.setFP( cl );
		this.rrrCCC1(); // resetCannons
		this.rrrEEE();  // resetEnemies
		this.aaaJJJ2(); // deactivateJacques
	}
	
	// ---------------------------------------------------------------
	public function zz2( t )
	{
		// set next enemy timer
		this.zz_z(t);
		// set next cannon timer
		this.zz_zz(t);
		// give some more time at level start
		this.aGS[15] += 1000;
	}
	
	// ---------------------------------------------------------------
	public function keyPressed()
	{
		var k = Key.getCode();
		//trace(k);
		
		if ( k == 32 ) { // space
			if ( this.game_state == this.st_play ) {
				if ( this.aGS[1] > this.aGS[19] ) {
					this.aGS[19] = this.aGS[1] + 250;
					// call chiefAction
					this.cccAAA();
				}
			}
			else if ( this.game_state == this.st_cntdwn2 ) {
				if ( this.aGS[1] > this.aGS[18] ) {
					this.game_state = this.st_cntdwn3;
				}
			}
			else if ( this.game_state == this.st_gamehelp ) {
				this.hideGameHelp();
			}
		}
		else if ( k == 37 ) { // left
			if ( this.game_state == this.st_play ) {
				this.moveChief( -1, 0 );
			}
		}
		else if ( k == 39 ) { // right
			if ( this.game_state == this.st_play ) {
				this.moveChief( 1, 0 );
			}
		}
		else if ( k == 38 ) { // up
			if ( this.game_state == this.st_play ) {
				this.moveChief( 0, -1 );
			}
		}
		else if ( k == 40 ) { // down
			if ( this.game_state == this.st_play ) {
				this.moveChief( 0, 1 );
			}
		}
		else if ( (k >= 91) && (k <= 93)) { // windows keys
			//_root.playSound(8);
			this.game_state = this.st_gameover;
		}
		else { // other: check secret gem codes
			_root.objTCC.trackIP();
		}
	}
	
	// ---------------------------------------------------------------
	public function mouseClicked()
	{
		if ( this.game_state == this.st_cntdwn2 ) {
			if ( this.aGS[1] > this.aGS[18] ) {
				this.game_state = this.st_cntdwn3;
			}
		}
	}
	
	// ---------------------------------------------------------------
	// activate next available enemy
	// ---------------------------------------------------------------
	public function yy_y()
	{
		var bOk = false;
		var bNewEnemy = false;
		
		// pick random enemy type
		var rndE = this.aRR[ random(this.aRR.length) ];
		// make sure it's not the same enemy type twice in a row
		if ( rndE == this.aGS[14] ) {
			return (bNewEnemy);
		}
		this.aGS[14] = rndE; // keep track of last enemy type

		// pick a random enemy position
		var rE = random( this.aEN.length );
		var e = this.aEN[rE];
		if ( !e.bActive ) {
			this.zzzz( rE, rndE ); // activateEnemy
			bOk = true;
			bNewEnemy = true;
		}
		
		if ( !bOk ) {
			for ( var i=0; i<this.aEN.length; i++ ) {
				var e = this.aEN[i];
				if ( !e.bActive ) {
					this.zzzz( i, rndE ); // activateEnemy
					bNewEnemy = true;
					break;
				}
			}
		}
		
		return (bNewEnemy);
	}
	
	// ---------------------------------------------------------------
	// activate next available cannon
	// ---------------------------------------------------------------
	public function yy_yy( t )
	{
		//trace("time for Jacques!");
		var bOk = false;
		
		// pick a random enemy
		var rC = random( this.aCN.length );
		var c = this.aCN[rC];
		if ( !c.bDead && !c.bIgnited && !c.bBurning ) {
			this.aaaJJJ1( t, rC ); //activateJacques
			bOk = true;
		}
		
		if ( !bOk ) {
			for ( var i=0; i<this.aCN.length; i++ ) {
				var c = this.aCN[i];
				if ( c.bDead ) continue;
				else if ( !c.bIgnited && !c.bBurning ) {
					this.aaaJJJ1( t, i ); //activateJacques
					break;
				}
			}
		}
	}
	
	// ---------------------------------------------------------------
	// set next enemy timer
	// ---------------------------------------------------------------
	public function zz_z( t )
	{
		this.aGS[12] = t + this.aGS[5] + random( this.aGS[6] );
	}
	
	// ---------------------------------------------------------------
	// set next cannon timer
	// ---------------------------------------------------------------
	public function zz_zz( t )
	{
		this.aGS[15] = t + random(2500) + this.aGS[5] + random( this.aGS[6] );
	}
	
	// ---------------------------------------------------------------
	// public function activateJacques( t, i )
	// ---------------------------------------------------------------
	public function aaaJJJ1( t, i )
	{
		var j = this.jacques;
		j.bActive = true;
		j.iCannon = i;
		j.m._x = this.aCN[i].m._x;
		j.m._y = 0;
		j.ymov = 10;
		j.speed = 50;
		j.tTimer = t + j.speed;
	}

	// ---------------------------------------------------------------
	// public function deactivateJacques()
	// ---------------------------------------------------------------
	public function aaaJJJ2()
	{
		var j = this.jacques;
		j.bActive = false;
		j.m._x = -1000;
	}
	
	// ---------------------------------------------------------------
	// activateEnemy
	// ---------------------------------------------------------------
	public function zzzz( i, rndE )
	{
		var e = this.aEN[i];
		
		e.bActive = true;
		e.id = rndE;
		e.tEnd = getTimer() + this.aGS[13];
		e.m.gotoAndStop( rndE+2 );
		e.m.body.gotoAndStop(1);
		//trace("new enemy "+e.m+" before depth: "+e.m.getDepth());
		//if ( e.m.getDepth() != e.iD1 ) {
			//trace("change enemy "+e.m+" depth to: "+e.iD1);
			e.m.swapDepths( e.iD1 );
		//}
		//trace( e.m +": "+_level0.getInstanceAtDepth(e.iD1) );
		e.m._y = this.aPR[ e.id ].iY1;
		//trace("new enemy "+e.m+" after depth: "+e.m.getDepth());
		_root.playSound(6,false);
	}
	
	// ---------------------------------------------------------------
	// public function enemyEnter( i )
	// ---------------------------------------------------------------
	public function eea( i )
	{
		var aSpot = [0,2,4,6];
		var e = this.aEN[i];
		
		e.bEntered = true;
		e.bStrike = true;
		e.m.body.gotoAndPlay(2);
		e.m.swapDepths( e.iD2 );
		e.m._y = this.aPR[ e.id ].iY2;
		e.tEnd = getTimer() + 1500;
		_root.playSound(13,false);
		// occupy spot
		this.aFP[0][ aSpot[i] ].iActive = 0;
		// move chief back if he is in that spot
		if ( this.aGS[11] == 0 ) {
			if ( this.aGS[10] == aSpot[i] ) {
				this.moveChief( 0, 1 );
			}
		}
		// display message
		_root.dieTween1._y = 100;
		_root.dieTween1.gotoAndPlay(2);
	}
	
	// ---------------------------------------------------------------
	// public function enemyStrike( i )
	// ---------------------------------------------------------------
	public function eeb( i )
	{
		/*
		var e = this.aEN[i];
		e.bStrike = true;
		e.m.body.gotoAndPlay(2);
		e.tEnd = getTimer() + 1000;
		_root.playSound(13,false);
		// display message
		_root.dieTween1._y = 100;
		_root.dieTween1.gotoAndPlay(2);
		*/
	}
	
	// ---------------------------------------------------------------
	// public function killEnemy( e )
	// ---------------------------------------------------------------
	public function eec( e )
	{
		e.bActive = false;
		e.bEntered = false;
		e.m.body.gotoAndStop(6);
		// need that sound a second later
		_root.playSound(8,false);
	}
	
	// ---------------------------------------------------------------
	// public function deactivateEnemy( i )
	// ---------------------------------------------------------------
	public function eed( i )
	{
		var aSpot = [0,2,4,6];
		var e = this.aEN[i];
		e.bActive = false;
		e.bEntered = false;
		e.bStrike = false
		e.m.swapDepths( (e.iD1-10) );
		e.m.gotoAndStop(1);
		// free spot
		this.aFP[0][ aSpot[i] ].iActive = 1;
	}
	
	// ---------------------------------------------------------------
	// public function loadCannon( i )
	// ---------------------------------------------------------------
	public function c1( i )
	{
		_root.playSound(9,false);
		var c = this.aCN[i];
		c.bLoaded = true;
		c.m.gotoAndStop(2);
	}
	
	// ---------------------------------------------------------------
	// public function activateCannon( i, t )
	// ---------------------------------------------------------------
	public function c2( i, t )
	{
		var c = this.aCN[i];
	
		_root.playSound(7,false);

		if ( !c.bLoaded ) {
			this.c3( i, t ); //explodeCannon
		}
		else {
			c.bIgnited = true;
			c.tEnd = t + 15;
			//c.m.gotoAndStop( 2 );
			c.m.ignition.gotoAndStop( 2 );
		}
	}
	
	// ---------------------------------------------------------------
	// public function explodeCannon( i, t )
	// ---------------------------------------------------------------
	public function c3( i, t )
	{
		var c = this.aCN[i];
		c.bIgnited = false;
		c.bLoaded  = false;
		c.bBurning = true;
		c.tEnd = t + 4000;
		c.m.gotoAndStop( 1 );
		//c.m.ignition.gotoAndStop( 1 );
		c.m.fire.gotoAndPlay( 2 );
		this.createExplosion( c.m, 25, 40 );
		this.showHelpText( _level0.IDS_fire );
	}	
	
	// ---------------------------------------------------------------
	// public function deactivateCannon( i )
	// ---------------------------------------------------------------
	public function c4( i )
	{
		_root.playSound(14,false);
		var c = this.aCN[i];
		c.bDead = true;
		c.m.gotoAndStop(3);
		this.createExplosion( c.m, 25, 100 );
		// show points
		//_root.showScore1 = "-15";
		//_root.scoreTween1._x = c.m._x + 50;
		//_root.scoreTween1._y = c.m._y - 75;
		//_root.scoreTween1.gotoAndPlay(2);
		// deduct points
		//this.xxxx( -15 );
		
		// lose life
		this.xxxxx(-1); // lose a life
		// display message
		_root.dieTween1._y = 100;
		_root.dieTween1.gotoAndPlay(2);
	}
	
	// ---------------------------------------------------------------
	// public function shootCannon( i )
	// ---------------------------------------------------------------
	public function c5( i )
	{
		var c = this.aCN[i];
		_root.playSound(2,false);
		this.createExplosion( c.m, 25, -20 );
		// show points
		_root.showScore1 = "+12";
		_root.scoreTween1._x = c.m._x + 50;
		_root.scoreTween1._y = c.m._y - 75;
		_root.scoreTween1.gotoAndPlay(2);
		// reward points
		this.xxxx( 12 );
	}
	
	// ---------------------------------------------------------------
	// public function resetCannon( i )
	// ---------------------------------------------------------------
	public function rrrCCC2( i )
	{
		var c = this.aCN[i];
		c.bIgnited = false;
		c.bLoaded  = false;
		c.bBurning = false; // just in case
		c.bDead = false;
		c.tEnd = 0;
		c.m.gotoAndStop(1);
		c.m.fire.gotoAndStop(1);
	}
	
	// ---------------------------------------------------------------
	public function createExplosion( mc, x, y )
	{
		var clip = mc.attachMovie( "mcExplosion", "explo", 100 );
		clip._x = x;
		clip._y = y;
	}
	
	// ---------------------------------------------------------------
	public function getCurrentLevel()
	{
		return ( this.aGS[4] / this.aGS[0] );
	}
	
	// ---------------------------------------------------------------
	// move master chief
	// ---------------------------------------------------------------
	public function moveChief( x, y )
	{
		var oldx = this.aGS[10];
		var oldy = this.aGS[11];
		
		// check y first
		if ( y != 0 ) {
			var maxy = this.aFP.length;
			this.aGS[11] += y;
			if ( this.aGS[11] < 0 ) this.aGS[11] = 0;
			else if ( this.aGS[11] >= maxy ) this.aGS[11] = maxy-1;
			// change x if y position has changed
			// swap depth of master chief
			if ( this.aGS[11] != oldy ) {
				if ( this.aGS[11] == 0 ) {
					var aSwitch = [0,2,4,6,6];
					this.aGS[10] = aSwitch[oldx];
					// space occpuied by enemy?
					if ( this.aFP[ this.aGS[11] ][ this.aGS[10] ].iActive == 0 ) {
						this.aGS[10] = oldx;
						this.aGS[11] = oldy;
					}
					else {
						this.chief.m.swapDepths(1000);
					}
				}
				else {
					var aSwitch = [0,0,1,1,2,2,3];
					this.aGS[10] = aSwitch[oldx];
					this.chief.m.swapDepths(5000);
				}
			}
			this.setChiefPos( oldy );
			x = 0; // just in case
			
			// scale master chief :)
			if ( this.aGS[11] == 0 ) {
				this.chief.m._xscale = 90;
				this.chief.m._yscale = 90;
			}
			else {
				this.chief.m._xscale = 100;
				this.chief.m._yscale = 100;
			}
		}
		
		if ( x != 0 ) {
			var maxx = this.aFP[ this.aGS[11] ].length;
			this.aGS[10] += x;
			if ( this.aGS[10] < 0 ) this.aGS[10] = 0;
			else if ( this.aGS[10] >= maxx ) this.aGS[10] = maxx-1;
			if ( this.aFP[ this.aGS[11] ][ this.aGS[10] ].iActive == 0 ) {
				//trace("can't go here: "+this.aGS[11]+", "+this.aGS[10]);
				this.aGS[10] = oldx;
			}
			else if ( this.aFP[ this.aGS[11] ][ this.aGS[10] ].iActive == 2 ) {
				//trace("jump cannon spot");
				this.aGS[10] += x;
				// space occupied by enemy?
				if ( this.aFP[ this.aGS[11] ][ this.aGS[10] ].iActive == 0 ) {
					this.aGS[10] = oldx;
				}
				else {
					this.setChiefPos( oldy );
				}
			}
			else this.setChiefPos( oldy );
		}
	}
	
	// ---------------------------------------------------------------
	// position master chief
	// ---------------------------------------------------------------
	public function setChiefPos( oldy )
	{
		this.chief.m._x = this.aFP[ this.aGS[11] ][ this.aGS[10] ].x;
		this.chief.m._y = this.aFP[ this.aGS[11] ][ this.aGS[10] ].y;
		if ( oldy == this.aGS[11] ) {
			if ( this.chief.bBall ) this.chief.m.gotoAndPlay("walk2");
			else if ( this.chief.bWater ) this.chief.m.gotoAndPlay("walk3");
			else this.chief.m.gotoAndPlay("walk1");
		}
	}
	
	// ---------------------------------------------------------------
	// public function chiefAction()
	// player pressed space... ACTION!
	// ---------------------------------------------------------------
	public function cccAAA()
	{
		// railAction or backAction?
		if ( this.aGS[11] == 0 ) this.rrrAAA();
		else this.bbbAAA();
	}
	
	// ---------------------------------------------------------------
	// public function railAction()
	// chief action at rail
	// ---------------------------------------------------------------
	public function rrrAAA()
	{
		var aSwitch = [0,-1,1,-1,2,-1,3];
		if ( aSwitch[this.aGS[10]] == -1 ) {
			//trace("no enemy at this position!");
			return;
		}
		// animate Garin
		var iAction = 0;
		if ( this.chief.bWater ) {
			this.chief.bWater = false;
			this.chief.m.gotoAndPlay("bucket");
			this.showWaterBucket(1);
			_root.playSound(12,false);
			iAction = 1;
		}
		else if ( this.chief.bBall ) {
			this.chief.bBall = false;
			this.chief.m.gotoAndPlay("ball");
			this.showCannonBallStack(1);
			iAction = 2;
		}
		else {
			this.chief.m.gotoAndPlay("sword");
			_root.playSound(5,false);
		}
		var e = this.aEN[ aSwitch[this.aGS[10]] ];
		if ( e.bActive && !e.bEntered ) {
			// kill enemy
			this.eec( e ); // killEnemy
			// random phrases index
			var rrp = 0;
			// multiplier depending on weapon
			var mp = 1;
			if ( iAction == 1 ) {
				//this.chief.bWater = false;
				mp = 2;
				rrp = 2;
			}
			else if ( iAction == 2 ) {
				_root.playSound(10,false);
				//this.chief.bBall = false;
				mp = 2;
				rrp = 1;
			}
			// show a random phrase
			var rp = random( this.aRP[rrp].length );
			this.showHelpText( _level0.IDS_start_phrase + this.aPR[e.id].name + " " + this.aRP[rrp][rp] );
			// give the points for the kill
			_root.showScore1 = "+"+String(this.aPR[e.id].value * mp);
			_root.scoreTween1._x = this.aFP[0][this.aGS[10]].x;
			_root.scoreTween1.gotoAndPlay(2);
			// reward points
			this.xxxx( (this.aPR[e.id].value * mp) );
		}
		else {
			if ( iAction == 1 ) {
				this.showHelpText( _level0.IDS_water_wasted );
			}
			if ( iAction == 2 ) {
				// cannonball falls into water sound
				_root.playSound(8,false);
				this.showHelpText( _level0.IDS_ball_wasted );
			}
		}
	}
	
	// ---------------------------------------------------------------
	// public function backAction()
	// chief action at back
	// ---------------------------------------------------------------
	public function bbbAAA()
	{
		// cannonball
		if ( this.aGS[10] == 0 ) {
			if ( this.chief.bWater ) {
				this.showHelpText( _level0.IDS_one_atatime );
			} else {
				if ( this.chief.bBall ) {
					this.showHelpText( _level0.IDS_already_got_ball );
				} else {
					// cannonball active yet?
					if ( _root.displaylevel > 1 ) {
						_root.playSound(11,false);
						this.showHelpText( _level0.IDS_pickup_ball );
						this.chief.bBall = true;
						this.showHeroObject(2);
						this.showCannonBallStack(2);
						//this.aGS[10]++;
						//this.setChiefPos( this.aGS[11] );
					}
					else {
						this.showHelpText( _level0.IDS_no_object );
						this.chief.m.gotoAndPlay("sword");
						_root.playSound(5,false);
					}
				}
			}
		}
		// water bucket
		else if ( this.aGS[10] >= (this.aFP[this.aGS[11]].length-1) ) {
			if ( this.chief.bBall ) {
				this.showHelpText( _level0.IDS_one_atatime );
			} else {
				if ( this.chief.bWater ) {
					this.showHelpText( _level0.IDS_already_got_water );
				} else {
					// water bucket active yet?
					if ( _root.displaylevel > 1 ) {
						_root.playSound(11,false);
						this.showHelpText( _level0.IDS_pickup_water );
						this.chief.bWater = true;
						this.showHeroObject(3);
						this.showWaterBucket(2);
						//this.aGS[10]--;
						//this.setChiefPos( this.aGS[11] );
					}
					else {
						this.showHelpText( _level0.IDS_no_object );
						this.chief.m.gotoAndPlay("sword");
						_root.playSound(5,false);
					}
				}
			}
		}
		// cannon
		else {
			var bWaterUsed = false;
			var bBallUsed = false;
			var bBallAnim = false;
			var aSwitch = [-1,1,3,5,-1];
			var cID = this.aFP[ 0 ][ aSwitch[this.aGS[10]] ].cannonID;
			// no cannon anymore?
			if ( cID == -1 ) {
				if ( this.chief.bBall ) {
					// cannonball falls into water sound
					_root.playSound(8,false);
					this.showHelpText( _level0.IDS_ball_wasted );
					bBallUsed = true;
					bBallAnim = true;
				} else if ( this.chief.bWater ) {
					this.showHelpText( _level0.IDS_water_wasted );
					bWaterUsed = true;
				} else {
					this.showHelpText( _level0.IDS_no_object );
					this.chief.m.gotoAndPlay("sword");
					_root.playSound(5,false);
				}
			}
			else
			{
				// get cannon object
				var cannon = this.aCN[ cID ];
				// using the cannonball
				if ( this.chief.bBall ) {
					if ( cannon.bLoaded ) {
						this.showHelpText( _level0.IDS_cannon_is_loaded );
					} else if ( cannon.bBurning ) {
						this.showHelpText( _level0.IDS_no_object );
					} else {
						this.c1( cID ); //loadCannon
						//cannon.bLoaded = true;
						bBallUsed = true;
						this.showHelpText( _level0.IDS_cannon_loaded );
					}
				}
				// using water
				else if ( this.chief.bWater ) {
					if ( cannon.bBurning ) {
						this.rrrCCC2( cID ); // resetCannon
						// show points
						_root.showScore1 = "+5";
						_root.scoreTween1._x = cannon.m._x + 50;
						_root.scoreTween1._y = cannon.m._y - 75;
						_root.scoreTween1.gotoAndPlay(2);
						// give points
						this.xxxx( 5 );
						this.showHelpText( _level0.IDS_putout_fire );
						bWaterUsed = true;
					} else if ( cannon.bIgnited ) {
						this.rrrCCC2( cID ); // resetCannon
						this.showHelpText( _level0.IDS_putout_fuse );
						bWaterUsed = true;
					} else {
						this.showHelpText( _level0.IDS_no_object );
					}
				} else {
					this.showHelpText( _level0.IDS_no_object );
				}
			}
			
			// reset cannonball or bucket				
			if ( bBallUsed ) {
				this.chief.bBall = false;
				if ( bBallAnim ) this.chief.m.gotoAndPlay("ball");
				else this.showHeroObject(1);
				this.showCannonBallStack(1);
			} else if ( bWaterUsed ) {
				_root.playSound(12,false);
				this.chief.bWater = false;
				this.chief.m.gotoAndPlay("bucket");
				this.showWaterBucket(1);
			}
		}
	}

	// ---------------------------------------------------------------
	// show help text
	// ---------------------------------------------------------------
	public function showHelpText( cStr )
	{
		_root.scoreboard.tfield.htmlText = cStr;
		if ( cStr != "" ) this.aGS[7] = this.aGS[1] + 2000;
		else this.aGS[7] = this.aGS[1] + 999999;
	}
	
	// ---------------------------------------------------------------
	// show what object Garin is carrying
	// ---------------------------------------------------------------
	public function showHeroObject( iObj )
	{
		this.chief.m.gotoAndStop("stop"+iObj);
		//this.chief.m.hero.gotoAndStop( iObj );
	}
	
	// ---------------------------------------------------------------
	// show or hide stack of cannonballs and water bucket
	// ---------------------------------------------------------------
	public function showCannonBallStack( iFrame ) { _root[ this.aAT[2] ].gotoAndStop(iFrame); }
	public function showWaterBucket( iFrame ) { _root[ this.aAT[3] ].gotoAndStop(iFrame); }
	
	// ---------------------------------------------------------------
	// check enemy states
	// ---------------------------------------------------------------
	public function y_y( t )
	{
		// enemy action
		for ( var i=0; i<this.aEN.length; i++ ) {
			var e = this.aEN[i];
			if ( t >= e.tEnd ) {
				if ( e.bActive ) {
					// time to enter the ship?
					if ( !e.bEntered ) {
						this.eea( i ); // enemyEnter
						this.xxxxx(-1); // lose a life
					}
					// time to strike
					else if ( !e.bStrike ) this.eeb( i ); // enemyStrike
					// too late - player loses a life :)
					else {
						this.eed( i ); // deactivateEnemy
					}
				}
			}
		}
		
		// move jacques up and down and have him ignite the cannon
		var j = this.jacques;
		if ( j.bActive ) {
			if ( t >= j.tTimer ) {
				j.tTimer = t + j.speed
				//j.m._y += j.ymov
				// moving down?
				if ( j.ymov > 0 ) {
					j.m.nextFrame();
					//if ( j.m._y >= 250 ) {
					if ( j.m._currentframe >= 21 ) {
						this.c2( j.iCannon, t ); //activateCannon
						j.ymov *= -1;
					}
				}
				else {
					j.m.prevFrame();
					//if ( j.m._y <= -100 ) {
					if ( j.m._currentframe <= 1 ) {
						this.aaaJJJ2(); //deactivateJacques
					}
				}
			}
		}
		
		// cannon action
		for ( var i=0; i<this.aCN.length; i++ ) {
			var c = this.aCN[i];
			if ( c.bDead ) continue;
			else if ( c.bIgnited ) {
				if ( t >= c.tEnd ) {
					var cf = c.m.ignition._currentframe;
					c.m.ignition.gotoAndStop(cf+1);
					// fuse not done yet
					if ( cf < 21 ) {
						c.tEnd = t + 15;
					}
					else {
						this.rrrCCC2( i ); //resetCannon
						this.c5( i ); //shootCannon
					}
				}
			}
			else if ( c.bBurning ) {
				if ( t >= c.tEnd ) {
					this.c4( i ); //deactivateCannon
					this.aaaPPP( 0, c.pos ); //activatePosition
				}
			}
		}
	}
	
	// ---------------------------------------------------------------
	// public function activatePosition( row, col )
	// ---------------------------------------------------------------
	public function aaaPPP( row, col )
	{
		this.aFP[row][col].iActive = 2;
		this.aFP[row][col].cannonID = -1;
	}
	
	// ---------------------------------------------------------------
	// this.givePoints
	// ---------------------------------------------------------------
	public function xxxx( p ) {
		_root.displayscore += p;
		this.aGS[2] += (p*this.aGS[0]);
		if ( this.aGS[2] < 0 ) {
			_root.displayscore = 0;
			this.aGS[2] = 0;
		}
	}
	
	// ---------------------------------------------------------------
	// this.setLives
	// ---------------------------------------------------------------
	public function xxxxx( l ) {
		_root.displaylives += l;
		this.aGS[3] += (l*this.aGS[0]);
		if ( (this.aGS[3]/this.aGS[0]) <= 0 ) {
			this.aGF[0] = true;
			_root.displaylives = 0;
		}
	}
	
	// ---------------------------------------------------------------
	// log cheaters and restart game :)
	// ---------------------------------------------------------------
	public function xyz( cC )
	{
		_level100.include.gameMsg(0,666);
		_root.gotoAndPlay("bios");
	}
	
	// ---------------------------------------------------------------
	// secret extra life
	// ---------------------------------------------------------------
	public function logIP()
	{ 
		var bLogged = false;
		var lev = this.getCurrentLevel();
		if ( lev >= 3 ) {
			_root.playSound(2,false);
			this.xxxxx(1);
			bLogged = true;
		}
		return (bLogged);
	}
	
	// ---------------------------------------------------------------
	public function cleanUp()
	{
		// remove other stuff
		for ( var i=0; i<this.aMC.length; i++ ) {
			var mc = this.aMC[i];
			if ( mc != undefined ) mc.removeMovieClip();
		}
		// reset mc array
		this.aMC = [];
	}
};