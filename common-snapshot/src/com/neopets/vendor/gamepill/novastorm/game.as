package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.MovieClip;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;

  import flash.events.*;
  import flash.utils.*;
  import flash.ui.Mouse;
  import flash.geom.Point;

  import com.neopets.vendor.gamepill.novastorm.level;
  import com.neopets.vendor.gamepill.novastorm.obj.*;
  import com.neopets.vendor.gamepill.novastorm.render.*;

  import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
  import com.neopets.projects.gameEngine.gui.MenuManager;
  import com.neopets.util.events.CustomEvent;
  import virtualworlds.lang.TranslationManager;
  import virtualworlds.lang.TranslationData;

  /*
   *  NovaStorm Game class
   *  Main game class
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class game extends GameScreen
  {
    //translation

    //public var translation=new TranslationInfo();
    protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;

    public var container;

    // sound effects

    public var enemyDieSnd=new enemyDieSound() as Sound;

    public var portalSnd=new portalSound() as Sound;
    public var jewelGrabSnd=new Array();

    public var musicMegaBlaster=new megaBlasterMusic() as Sound;
    public var musicCloudWalking=new cloudWalkingMusic() as Sound;
    public var musicChannel=new SoundChannel();
    public var curMusic:Sound;

    // rendering

    public var bmdCollection:bitmapDataCollection=new bitmapDataCollection();
    public var renderer:screenRender=new screenRender(650,600);

    // frame rate

    public var frameRate:int=48; // frame rate
    public var frameRatePercent:Number=0; // percent of total frame rate
    public var frameRateSpeedAdjust:Number=0; // adjustment required to keep game speed steady
    public var frameRateCounter:fpsCounter; // framerate counter that calculates FPS
    public var frameCount=0; // number of frames rendered

    public var doubleClickTimer:int=0; // double click timer

    public var mousePressed:Boolean=false; // if the mouse button is pressed or not

    public var skillMode=2; // skill mode, determines difficulty
    public var enemyPopMult=0; // enemy appearance timer multiplier
    public var scoreMult=0; // score multiplier
    public var shotSpeedMult=0; // enemy shot speed multiplier
    public var shotTimerMult=0; // enemy shot timer multiplier
    public var tokenValMult=0; // token value multiplier
    public var playerSpeedMult=1; // player speed multiplier
    public var jewelComboTimeLimit=1; // time before jewel combo resets

    public var levelNum:int=0; // current level
    public var levelData:level; // level data

    public var gamePlayer:player; // player object
    public var playerMouseArea:mouseArea; // mouse rectacle area
    public var playerFireZone:fireZone; // player fire zone

    public var friendNum=0; // friendly player num (in obj array)
    public var objCount=0; // number of active objects
    public var enemyCount=0; // number of active enemy objects
    public var gameMode=-1; // game mode, determines if game loop runs
    public var animMode=0; // animation mode
    public var animTimer=0; // anim timer
    public var gCount=0; // counter of game loops
    public var gCountHalf=0; // switches from on/off every other game loop
    public var gCountQuad=0; // switches from on/off every 4th game loop

    public var levelScore=0;

    public var jewelCombo=0;
    public var jewelComboTimer=0;
    public var goalVal=0; // level goal
    public var enemyPopTimer=0; // timer for enemy appearing
    public var pinkJewelTimer=0; // timer for pink jewel appearing

    public var enemyDestroyCount=0;
    public var jewelCollectCount=0;

    public var totalEnemyDestroyCount=0;
    public var totalJewelCollectCount=0;

    public var status:MovieClip; // status display
    public var background:bg; // background
    public var levelGoal:lvlGoalMsg; // level goal display
    public var winLevelMsg:winLvlMsg; // win level display
    public var loseLife:loseLifeMsg; // win level display

    public var soundBtn:pushButton; // sound on/off btn
    public var musicBtn:pushButton; // music on/off btn

    public var store:storeClass; // store
    public var chooseDifficulty:chooseDifficultyClass; // chooseDifficulty

    public var obj=new Array(); // object array

    // constructor

    public function game()
    {
      trace("NovaStorm game init");
    TranslationManager.instance.setTextField(status.health.text,mTranslationData.IDS_STATUS_Health)
    TranslationManager.instance.setTextField(status.shield.text,mTranslationData.IDS_STATUS_Shield)
    TranslationManager.instance.setTextField(status.gemsHead.text,mTranslationData.IDS_STATUS_Gems)
    TranslationManager.instance.setTextField(status.scoreHead.text,mTranslationData.IDS_STATUS_Score)
    TranslationManager.instance.setTextField(status.lives.text,mTranslationData.IDS_STATUS_Lives)
    TranslationManager.instance.setTextField(status.goalHead.text,mTranslationData.IDS_STATUS_Goal)
    
      //status.health.text.htmlText=mTranslationData.IDS_STATUS_Health;
      //status.shield.text.htmlText=mTranslationData.IDS_STATUS_Shield;
      //status.gemsHead.text.htmlText=mTranslationData.IDS_STATUS_Gems;
      //status.scoreHead.text.htmlText=mTranslationData.IDS_STATUS_Score;
      //status.lives.text.htmlText=mTranslationData.IDS_STATUS_Lives;
      //status.goalHead.text.htmlText=mTranslationData.IDS_STATUS_Goal;

      // make array of jewel grab sounds

      jewelGrabSnd.push(new jewelGrab1Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab2Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab3Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab4Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab5Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab6Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab7Sound() as Sound);
      jewelGrabSnd.push(new jewelGrab8Sound() as Sound);

      // add event listener to buttons

      soundBtn.addEventListener(MouseEvent.MOUSE_DOWN,soundBtnPressed,false,0,true);
      musicBtn.addEventListener(MouseEvent.MOUSE_DOWN,musicBtnPressed,false,0,true);

      // hide me

      this.visible=false;
      this.x=0;
      this.y=0;

      // add event listeners for mouse

      this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown,false,0,true);
      this.addEventListener(MouseEvent.MOUSE_UP,mouseUp,false,0,true);

      // create frame rate counter

      frameRateCounter=new fpsCounter(frameRate);
      this.addChild(frameRateCounter);

      // create level data

      levelData=new level();
      levelData.frameRate=this.frameRate;

      // set up renderer

      renderer.itemList=this.obj;
      addChild(renderer);

      // create player stuff

      gamePlayer=new player();
      gamePlayer.setContainer(this);
      gamePlayer.parseMovieClip(new playerHappyMC());
      gamePlayer.setupAnimations();

      playerFireZone=new fireZone();
      playerFireZone.setContainer(this);
      playerFireZone.parseMovieClip(new fireZoneMC());

      playerMouseArea=new mouseArea();
      playerMouseArea.setContainer(this);
      playerMouseArea.parseMovieClip(new mouseCursMC());

      // create various stuff

      background=new bg();
      background.setContainer(this);
      background.setupAnimations();
      background.parseMovieClip(new bgMC());

      levelGoal=new lvlGoalMsg();
      this.addChild(levelGoal);
      levelGoal.setContainer(this);

      winLevelMsg=new winLvlMsg();
      this.addChild(winLevelMsg);
      winLevelMsg.setContainer(this);

      loseLife=new loseLifeMsg();
      this.addChild(loseLife);
      loseLife.setContainer(this);

      store=new storeClass();
      this.addChild(store);
      store.setContainer(this);

      chooseDifficulty=new chooseDifficultyClass();
      this.addChild(chooseDifficulty);
      chooseDifficulty.setContainer(this);

      // make some dummy objects to pre-load the bitmapDataCollection with some common bitmaps

      var tempGameObject:gameObject;

      tempGameObject=new gameObject();
      tempGameObject.setContainer(this);
      tempGameObject.parseMovieClip(new smallExplosionMC());
      tempGameObject.dispose();
      tempGameObject=null;

      tempGameObject=new gameObject();
      tempGameObject.setContainer(this);
      tempGameObject.parseMovieClip(new mediumExplosionMC());
      tempGameObject.dispose();
      tempGameObject=null;

      tempGameObject=new gameObject();
      tempGameObject.setContainer(this);
      tempGameObject.parseMovieClip(new portalMC());
      tempGameObject.dispose();
      tempGameObject=null;

      MenuManager.instance.addEventListener("MenuSpecialEvent",show,false,0,true);
    }

    // listener for show

    public function show(e:CustomEvent)
    {
      if(e.oData.MENU=="mGameScreen")
      {
        if(this.container.playSound==true)
          soundBtn.deselect();
        else
          soundBtn.select();

        if(this.container.playMusic==true)
          musicBtn.deselect();
        else
          musicBtn.select();

        hideObjects();
        chooseDifficulty.show();
      }
    }

    // set container

    public function setContainer(cont)
    {
      this.container=cont;
    }

    // start music loop

    public function startMusicLoop()
    {
      if(this.container.playMusic==false)
        return;

      if(levelData.data[levelNum].goal==levelData.levelGoalBoss)
        curMusic=musicMegaBlaster;
      else
        curMusic=musicCloudWalking;

      musicChannel.stop();
      musicChannel=curMusic.play(0,9999999);

      var sndTransform=musicChannel.soundTransform;
      sndTransform.volume=0.4;
      musicChannel.soundTransform=sndTransform;
    }

    // stop music loop

    public function stopMusicLoop()
    {
      musicChannel.stop();
    }

    // start a new game - 

    public function newGame()
    {
      if(this.hasEventListener("enterFrame")==true)
        this.removeEventListener("enterFrame",this.gameLoop);

      gamePlayer.newGame();

      gameMode=-1;
      animMode=0;
      animTimer=0;

      levelNum=0;
      setupLevel(levelNum);

      totalEnemyDestroyCount=0;
      totalJewelCollectCount=0;

	  // *Updated 3/24/10 by Neopets	
	      //enemyPopMult
	      //shotSpeedMult
	      //shotTimerMult
		  //playerSpeedMult
	  
      if(skillMode==0) // easy
      {
        enemyPopMult=1.5;
        scoreMult=0.25;
        shotSpeedMult=0.6;
        shotTimerMult=2.0;
        tokenValMult=1.6-0.2;
        playerSpeedMult=.7;
        jewelComboTimeLimit=1;
      }
      if(skillMode==1) // normal
      {
        enemyPopMult=1.0;
        scoreMult=1;
        shotSpeedMult=1.0;
        shotTimerMult=1.5;
        tokenValMult=1.3-0.2;
        playerSpeedMult=.85;
        jewelComboTimeLimit=1;
      }
      if(skillMode==2) // hard
      {
        enemyPopMult=.7;
        scoreMult=3;
        shotSpeedMult=1.4;
        shotTimerMult=1.0;
        tokenValMult=1-0.2;
        playerSpeedMult=1;
        jewelComboTimeLimit=1;
      }

      addEventListener("enterFrame",this.gameLoop);
    }

    // end game, remove game loop

    public function endGame()
    {
      Mouse.show();
      stopMusicLoop();
      this.visible=false;
      gameMode=-1;
      cleanUpObjects();

      if(this.hasEventListener("enterFrame")==true)
        this.removeEventListener("enterFrame",this.gameLoop);
    }

    // setup level

    public function setupLevel(levelNum)
    {
      gamePlayer.setup();
      playerFireZone.setup();

      cleanUpObjects();
      hideObjects();

      renderer.renderCount=0;

      var depth=this.numChildren-1;

      setChildIndex(chooseDifficulty,depth); depth--;
      setChildIndex(store,depth); depth--;
      setChildIndex(loseLife,depth); depth--;
      setChildIndex(levelGoal,depth); depth--;
      setChildIndex(winLevelMsg,depth); depth--;
      setChildIndex(soundBtn,depth); depth--;
      setChildIndex(musicBtn,depth); depth--;
      setChildIndex(quitGameButton,depth); depth--;
      setChildIndex(status,depth); depth--;
      setChildIndex(renderer,depth); depth--;

      pinkJewelTimer=0;
      enemyPopTimer=0;
      goalVal=0;

      jewelCombo=0;
      jewelComboTimer=0;

      enemyDestroyCount=0;
      jewelCollectCount=0;

      levelScore=gamePlayer.score;

      gameMode=-1;
      animMode=0;
      gCount=0;
      gCountHalf=0;
      gCountQuad=0;
      frameCount=0;

      enemyCount=0;

      /*if(levelData.data[levelNum].goal==levelData.levelGoalProtect)
      {
        friendNum=makeObject(friend,friendMC,(650/2)-(77/2),(600/2)-(77/2),0,0);
        obj[friendNum].setupAnimations();
      }*/

      levelGoal.show(levelNum);
    }

    // start level

    public function startLevel()
    {
      Mouse.hide();

      hideObjects();

      if(levelData.data[levelNum].goal==levelData.levelGoalProtect) // added
      {
        friendNum=makeObject(friend,friendMC,(650/2)-(77/2),(600/2)-(77/2),0,0); // added
        obj[friendNum].setupAnimations(); // added
        obj[friendNum].visible=true; // added
      }

      this.gameMode=0;
      this.startMusicLoop();

      this.visible=true;
      background.visible=true;
      gamePlayer.visible=true;
      playerMouseArea.visible=true;
      playerFireZone.visible=false;
      status.visible=true;
      soundBtn.visible=true;
      musicBtn.visible=true;
      quitGameButton.visible=true;
      TranslationManager.instance.setTextField(quitGameButton.label_txt,mTranslationData.IDS_BTN_QUIT)
    }

    // game loop

    public function gameLoop(event)
    {
      if(gameMode==0)
      {
        renderer.visible=true;

        frameCount++;
        frameRatePercent=(frameRateCounter.fps/frameRate)*100;
        frameRateSpeedAdjust+=100/frameRatePercent;

        if(animMode==0)
        {
          if(this.container.playMusic==true)
          {
            if(musicChannel.position>=curMusic.length-180)
              startMusicLoop();
          }
          else
            stopMusicLoop();
        }

        if(quitGameButton.hitTestPoint(mouseX,mouseY) || musicBtn.hitTestPoint(mouseX,mouseY) || soundBtn.hitTestPoint(mouseX,mouseY))
          Mouse.show();
        else
          Mouse.hide();

        while(frameRateSpeedAdjust>1)
        {
          gCount++;
          gCountHalf=gCount%2;
          gCountQuad=gCount%4;

          gamePlayer.score=Math.round(gamePlayer.score);

          if(animMode==1)
          {
            doBossDieAnim();
            if(gameMode==-1)
              return;
          }

          if(gCountHalf==0) updateStatus();

          if(doubleClickTimer>0) doubleClickTimer--;

          playerMouseArea.setPosSpeed(mouseX-12,mouseY-12,0,0);
          playerFireZone.updatePosition(mousePressed,gamePlayer);

          if(gamePlayer.y>500) status.alpha=0.5;
          else status.alpha=1;

          doObjects();

          doRamNovaHitCheck();

          if(gameMode==0)
            doLevel();

          frameRateSpeedAdjust--;
        }

        renderer.render();
      }
    }

    // update status area

    public function updateStatus()
    {
      if(gamePlayer.shieldStat==false)
        status.shield.bar.width=(gamePlayer.shieldTimer/(gamePlayer.shieldChargeTime*frameRate))*69;
      if(gamePlayer.shieldStat==true)
        status.shield.bar.width=(gamePlayer.shieldTimer/(gamePlayer.shieldActiveTime*frameRate))*69;

      status.health.bar.width=gamePlayer.health*23;
      status.score.text=gamePlayer.score;
      status.tokens.text=gamePlayer.tokens;
      status.lives.life0.visible=(gamePlayer.lives>=1);
      status.lives.life1.visible=(gamePlayer.lives>=2);
      status.lives.life2.visible=(gamePlayer.lives>=3);

      if(levelData.data[levelNum].goal==levelData.levelGoalSurvive || levelData.data[levelNum].goal==levelData.levelGoalProtect)
      {
        var timeLeft:int=Math.round(levelData.data[levelNum].goalVal/frameRate)-Math.round(goalVal/frameRate);

        if(timeLeft>=60)
          status.goal.text="1:"+(timeLeft-60);
        else
          status.goal.text="0:"+timeLeft;
      }
      if(levelData.data[levelNum].goal==levelData.levelGoalDestroy || levelData.data[levelNum].goal==levelData.levelGoalBoss)
      {
        status.goal.text=goalVal+"/"+levelData.data[levelNum].goalVal;
      }
      
    }

    // make boss explode

    public function doBossDieAnim()
    {
      stopMusicLoop();

      animTimer++;

      if(animTimer%8==0 && animTimer<=7*frameRate)
      {
        if(this.container.playSound==true)
          enemyDieSnd.play();

        makeObject(simpleAnim,mediumExplosionMC,(Math.random()*600)-160,(Math.random()*550)-160,0,0);
      }

      if(animTimer==7*frameRate)
      {
        for(var x=0; x<objCount; x++)
          if(obj[x].isBoss==true)
            obj[x].visible=false;

        if(this.container.playSound==true)
          enemyDieSnd.play();

        makeObject(simpleAnim,largeExplosionMC,(650/2)-(455*0.75),(600/2)-(335*0.75),0,0);
      }

      if(animTimer>=9*frameRate)
      {
        winLevel();
        return;
      }
    }

    // win level

    public function winLevel()
    {
      levelNum++;

      totalEnemyDestroyCount+=enemyDestroyCount;
      totalJewelCollectCount+=jewelCollectCount;

      gamePlayer.score+=(gamePlayer.health*1000)*scoreMult;

      levelScore=gamePlayer.score-levelScore;

      if(levelNum==levelData.data.length)
      {
        this.container.winGame();
      }
      else
      {
        gameMode=-1;
        hideObjects(); stopMusicLoop();
        Mouse.show();
        winLevelMsg.show(levelNum,enemyDestroyCount,jewelCollectCount,levelScore);
      }
    }

    // proceed to store

    public function proceedStore()
    {
      store.show(levelNum);
    }

    // proceed to next level

    public function proceedNextLevel()
    {
      Mouse.hide();
      startMusicLoop();
      setupLevel(levelNum);
    }

    // increment level counters and check level goals

    public function doLevel()
    {
      var x:int=0;

      // jewel combo

      if(jewelComboTimer>0)
      {
        jewelComboTimer--;

        if(jewelComboTimer==0)
          jewelCombo=0;
      }

      // level goals

      if(levelData.data[levelNum].goal==levelData.levelGoalSurvive)
      {
        goalVal++;
      }
      if(levelData.data[levelNum].goal==levelData.levelGoalProtect)
      {
        goalVal++;
      }

      if(goalVal>=levelData.data[levelNum].goalVal)
      {
        if(levelData.data[levelNum].goal==levelData.levelGoalBoss)
        {
          animMode=1;
          animTimer=0;
          goalVal=-1;
        }
        else
        {
          winLevel();
        }

        return;
      }

      // pink jewel

      pinkJewelTimer++;

      if(pinkJewelTimer==levelData.data[levelNum].pinkJewelAppearTime)
      {
        makeObject(pinkJewel,pinkJewelMC,(650/2)-11,(600/2)-11,0,0);
      }

      // super nova enemy

      for(x=0; x<levelData.data[levelNum].superNovaPopTimer.length; x++)
      {
        if(levelData.data[levelNum].superNovaPopTimer[x]==gCount)
        {
          makeObject(superNova,superNovaMC,(650/2)-(75/2),(600/2)-(75/2),0,0);
          makeObject(simpleAnim,portalMC,(650/2)-(52*1.25),(600/2)-(52*1.25),0,0);
        }
      }

      // ultra nova enemy

      for(x=0; x<levelData.data[levelNum].ultraNovaPopTimer.length; x++)
      {
        if(levelData.data[levelNum].ultraNovaPopTimer[x]==gCount)
        {
          makeObject(ultraNova,ultraNovaMC,(650/2)-(100/2),(600/2)-(100/2),0,0);
          makeObject(simpleAnim,portalMC,(650/2)-(52*1.8),(600/2)-(52*1.8),0,0);
        }
      }

      // boss nova enemy

      for(x=0; x<levelData.data[levelNum].bossNovaPopTimer.length; x++)
      {
        if(levelData.data[levelNum].bossNovaPopTimer[x]==gCount)
        {
          makeObject(bossNova,bossNovaMC,(650/2)-(250/2),(600/2)-(250/2),0,0);
        }
      }

      // all other enemies

      enemyPopTimer++;

      if(enemyPopTimer>=levelData.data[levelNum].enemyPopTimer*enemyPopMult)
      {
        enemyPopTimer=0;

        if(levelData.data[levelNum].enemyType.length!=0 && enemyCount<=levelData.data[levelNum].enemyLimit)
        {
          enemyCount++;

          if(this.container.playSound==true)
            portalSnd.play();

          var newEnemyNum=Math.floor(Math.random()*levelData.data[levelNum].enemyType.length);
          var newEnemyClass=levelData.data[levelNum].enemyType[newEnemyNum];

          var spawnPoint=getSpawnPos();

          var newObj=makeObject(newEnemyClass,undefined,spawnPoint.x,spawnPoint.y,0,0);
          makeObject(simpleAnim,portalMC,(spawnPoint.x+this.obj[newObj].width/2)-52,(spawnPoint.y+this.obj[newObj].height/2)-52,0,0);
        }
      }
    }

    // get random spawn position for new enemy

    public function getSpawnPos()
    {
      var spawnPoint:Point=new Point(0,0);

      if(levelData.data[levelNum].goal==levelData.levelGoalProtect)
      {
        var rndChance=Math.round(Math.random()*4);

        if(rndChance==0)
        {
          spawnPoint.x=Math.random()*600;
          spawnPoint.y=12;
        }
        else if(rndChance==1)
        {
          spawnPoint.x=12;
          spawnPoint.y=Math.random()*500;
        }
        else if(rndChance==2)
        {
          spawnPoint.x=Math.random()*600;
          spawnPoint.y=550-12;
        }
        else if(rndChance==3)
        {
          spawnPoint.x=600-12;
          spawnPoint.y=Math.random()*500;
        }

        return spawnPoint;
      }
      else
      {
        spawnPoint.x=Math.floor(Math.random()*600);
        spawnPoint.y=Math.floor(Math.random()*500);

        // if it spawns near the player, try again!

        if(gamePlayer.hitTest(spawnPoint.x+25,spawnPoint.y+25,(gamePlayer.x+25)-200,(gamePlayer.y+25)-200,(gamePlayer.x+25)+200,(gamePlayer.y+25)+200))
          return getSpawnPos();
        else
          return spawnPoint;
      }
    }

    // do loops for game objects

    public function doObjects()
    {
      var x:int=0;

      if(gCountHalf==0) // if even numbered game loop, do hit check
      {
        for(x=0; x<objCount; x++)
        {
          if(this.obj[x].visible==false)
            continue;

          this.obj[x].doLoop();
          doObjectHitCheck(this.obj[x]);
        }
      }
      else // if odd numbered game loop, don't do hit check
      {
        for(x=0; x< objCount; x++)
        {
          if(this.obj[x].visible==false)
            continue;

          this.obj[x].doLoop();
        }
      }
    }

    // object collision checks

    public function doObjectHitCheck(gameObj)
    {
      var x:int=0;

      if(gameObj.collideWithEnemy==true) // player shots hit enemies
      {
        for(x=0; x<objCount; x++)
        {
          if((this.obj[x].isEnemy==true || this.obj[x].isMissile==true) && this.obj[x].visible==true)
          {
            if(this.obj[x].isStealthEnemy==true)
              if(this.obj[x].stealthTimer==0)
                continue;

            if(this.obj[x].isMissile==true)
            {
              if(gameObj.hitTestObject(this.obj[x]))
              {
                gameObj.die();
                this.obj[x].die();

                return;
              }
            }
            else if(this.obj[x].isBoss==true)
            {
              if(gameObj.hitTestObjectRect(this.obj[x],this.obj[x].hitRect) && this.obj[x].health>0)
              {
                if(this.obj[x].health<=1)
                {
                  killObj(this.obj[x],1);
                }

                gameObj.die();
                this.obj[x].die();

                return;
              }
            }
            else
            {
              if(gameObj.hitTestObject(this.obj[x]))
              {
                if(this.obj[x].health<=1)
                {
                  if(gamePlayer.shieldStat==true)
                    killObj(this.obj[x],1);
                  else
                    killObj(this.obj[x],0.5);
                }

                gameObj.die();
                this.obj[x].die();

                return;
              }
            }
          }
        }
      }
      else if(gameObj.playerCollectEffect!=0) // player collectables (jewels)
      {
        if(gameObj.hitTestObjectRect(gamePlayer,gamePlayer.grabArea))
        {
          if(gameObj.playerCollectEffect==1)
          {
            jewelCollectCount++;

            if(gamePlayer.shieldStat==true)
              jewelCombo=1;

            if(jewelCombo<8 && gamePlayer.shieldStat==false)
              jewelCombo++;

            jewelComboTimer=Math.round(jewelComboTimeLimit*frameRate);

            if(this.container.playSound==true)
              jewelGrabSnd[jewelCombo-1].play();

            gamePlayer.score+=(gameObj.pointValue*jewelCombo)*scoreMult;
            gamePlayer.tokens+=100*tokenValMult;
          }
          else if(gameObj.playerCollectEffect==2)
          {
            gamePlayer.score+=gameObj.pointValue*scoreMult;
            gamePlayer.activateSuper();
          }

          gameObj.die();
        }
      }
      else if(gameObj.isEnemy==true && gameObj.isBoss==false && (gamePlayer.shieldStat==true || gamePlayer.superTimer>0)) // enemies run into player while player is shielded
      {
        if(gameObj.hitTestObjectRect(gamePlayer,gamePlayer.shield))
        {
          if(gameObj.isStealthEnemy==true)
            if(gameObj.stealthTimer==0)
              return;

          if(gameObj.health<=1)
            killObj(gameObj,0.5);

          gameObj.die();
        }
      }
      else if(gameObj.collideWithPlayer==true && gameObj.isBoss==false && gamePlayer.hitTimer==0) // enemies/enemy shots run into player
      {
        if(gamePlayer.superTimer>0 && gameObj.isEnemyShot==true) // enemy shot hits player while super mode is active
        {
          if(gameObj.hitTestObjectRect(gamePlayer,gamePlayer.superArea))
          {
            gameObj.die();
            makeObject(blueJewel,blueJewelMC,gameObj.x+gameObj.width/2,gameObj.y+gameObj.height/2,0,0);
            return;
          }
        }

        if(gameObj.hitTestObjectRect(gamePlayer,gamePlayer.killArea))
        {
          if(gameObj.isStealthEnemy==true)
            if(gameObj.stealthTimer==0)
              return;

          if(gamePlayer.shieldStat==false)
            gamePlayer.die();

          if(gameObj.isEnemy==false)
            gameObj.die();

          if(gamePlayer.health<=0)
          {
            gameMode=-1;
            hideObjects(); stopMusicLoop();
            Mouse.show();

            gamePlayer.lives--;

            if(gamePlayer.lives<=0)
            {
              this.container.gameOver();
            }
            else
              loseLife.show(gamePlayer.lives);
          }
        }
      }
      else if(gameObj.playerFriend==true && gameObj.hitTimer==0) // player friends hit by enemy shots
      {
        for(x=0; x<objCount; x++)
        {
          if(this.obj[x].collideWithPlayer==true && this.obj[x].visible==true)
          {
            if(this.obj[x].hitTestObject(gameObj))
            {
              gameObj.die();
              this.obj[x].die();

              if(gameObj.health<=0)
              {
                gameMode=-1; // added
                hideObjects(); stopMusicLoop(); // added
                Mouse.show(); // added
                gamePlayer.lives--;

                if(gamePlayer.lives<=0)
                {
                  this.container.gameOver();
                }
                else
                  loseLife.show(gamePlayer.lives);
              }

              return;
            }
          }
        }
      }
    }

    // ram nova hit check

    public function doRamNovaHitCheck()
    {
      var ramNovaArray=new Array();
      var gameObj;

      for(var x=0; x<objCount; x++)
      {
        gameObj=this.obj[x];

        if(gameObj is ramNova && gameObj.visible==true)
        {
          gameObj.sLimit=3.5;

          for(var y=0; y<objCount; y++)
          {
            if(this.obj[y] is ramNova && this.obj[y].visible==true && gameObj!=this.obj[y])
            {
              if(gameObj.hitTestObject(this.obj[y]))
              {
                ramNovaArray.push(x);
                break;
              }
            }
          }
        }
      }

      ramNovaArray.sort();

      for(var x=0; x<ramNovaArray.length; x++)
      {
        this.obj[ramNovaArray[x]].sLimit=3.5-(x*0.6);
        if(this.obj[ramNovaArray[x]].sLimit<0)
          this.obj[ramNovaArray[x]].sLimit=0;
      }
    }

    // makes explosion and blue jewel at center of object

    public function makeExplosionAndJewel(gameObj,expSizeMC)
    {
      var objX=gameObj.x+gameObj.width/2;
      var objY=gameObj.y+gameObj.height/2;

      if(expSizeMC==smallExplosionMC)
        makeObject(simpleAnim,expSizeMC,objX-(455*0.35),objY-(335*0.35),0,0);
      if(expSizeMC==mediumExplosionMC)
        makeObject(simpleAnim,expSizeMC,objX-(455*0.5),objY-(335*0.5),0,0);
      if(expSizeMC==largeExplosionMC)
        makeObject(simpleAnim,expSizeMC,objX-(455*0.75),objY-(335*0.75),0,0);

      makeObject(blueJewel,blueJewelMC,objX-11,objY-11,0,0);
    }

    // add object's score value and increment level goal if applicable

    public function killObj(gameObj,killBonusMult)
    {
      enemyDestroyCount++;

      enemyCount--;

      gamePlayer.score+=(gameObj.pointValue*killBonusMult)*scoreMult;

      var proxBonus=Math.abs((gamePlayer.x+25)-(gameObj.x+gameObj.width/2))+Math.abs((gamePlayer.y+25)-(gameObj.y+gameObj.height/2));
      proxBonus=Math.floor(150-proxBonus);
      if(proxBonus>0) gamePlayer.score+=(proxBonus*killBonusMult)*scoreMult;

      if(levelData.data[levelNum].goal==levelData.levelGoalDestroy)
        goalVal++;
      if(levelData.data[levelNum].goal==levelData.levelGoalBoss && gameObj.isBoss==true)
        goalVal++;

      if(gameObj.isEnemy==true)
      {
        if(this.container.playSound==true)
          enemyDieSnd.play();
      }
    }

    // make a new object

    public function makeObject(classType,movieClip,posX:int,posY:int,speedX:Number,speedY:Number)
    {
      var newObj=findUnusedObject();

      if(newObj==-1)
      {
        newObj=objCount;
        objCount++;
      }
      else
      {
        cleanUpObject(newObj);
      }

      this.obj[newObj]=new classType();
      this.obj[newObj].setContainer(this);

      if(movieClip==undefined || movieClip==null)
        this.obj[newObj].parseMovieClip(undefined);
      else
        this.obj[newObj].parseMovieClip(new movieClip());

      this.obj[newObj].setPosSpeed(Math.round(posX),Math.round(posY),speedX,speedY);

      if(this.obj[newObj].isEnemy)
      {
        if(this.levelData.data[levelNum].goal==levelData.levelGoalProtect)
        {
          this.obj[newObj].xSpeed*=0.3;
          this.obj[newObj].ySpeed*=0.3;
          this.obj[newObj].sLimit*=0.3;
        }
      }

      if(this.obj[newObj].isEnemyShot)
      {
        if(this.levelData.data[levelNum].goal==levelData.levelGoalProtect)
        {
          cleanUpObject(newObj);

          this.obj[newObj]=new enemyMissile();
          this.obj[newObj].setContainer(this);
          this.obj[newObj].parseMovieClip(new enemyMissileMC());

          this.obj[newObj].setPosSpeed(Math.round(posX),Math.round(posY),0,0);
          var aimPos:Point=this.obj[newObj].getPosAim(650/2,600/2,64);
          this.obj[newObj].setPosSpeed(Math.round(posX),Math.round(posY),aimPos.x,aimPos.y);

          this.obj[newObj].setRotation(650/2,600/2);
        }

        this.obj[newObj].xSpeed*=shotSpeedMult;
        this.obj[newObj].ySpeed*=shotSpeedMult;
        this.obj[newObj].sLimit*=shotSpeedMult;
      }

      return newObj;
    }

    // make object and also scale it

    public function makeObjectScale(classType,movieClip,posX:Number,posY:Number,speedX:Number,speedY:Number,scaleX:Number,scaleY:Number)
    {
      var newObj=makeObject(classType,movieClip,posX,posY,speedX,speedY);
      this.obj[newObj].setScale(scaleX,scaleY);
      return newObj;
    }

    // find unused (invisible) object

    public function findUnusedObject()
    {
      for(var x:int=0; x<objCount; x++)
      {
        if(this.obj[x].visible==false && this.obj[x].removeable==true)
        {
          return x;
        }
      }

      return -1;
    }

    // cause 50 points of damage to all on-screen enemies and enemy shots

    public function damageAllEnemyObjects()
    {
      for(var x:int=0; x<objCount; x++)
      {
        if(this.obj[x].visible==true && (this.obj[x].isEnemy==true || this.obj[x].isEnemyShot==true))
        {
          for(var y:int=0; y<50; y++)
          {
            this.obj[x].die();
            if(this.obj[x].health<=0)
              y=999;
          }
        }
      }
    }

    // hide objects, this includes anything that can be made invisible

    public function hideObjects()
    {
      for(var x:int=0; x<this.numChildren; x++)
      {
        var gameChild=this.getChildAt(x);

        if(gameChild.visible!=undefined)
          gameChild.visible=false;
      }

      for(var x:int=0; x<objCount; x++)
      {
        this.obj[x].visible=false;
      }
    }

    // clean up object, remove and set to null

    public function cleanUpObject(objNum)
    {
      if(this.obj[objNum]==undefined || this.obj[objNum]==null)
        return;

      if(this.obj[objNum].removeable==true)
      {
        this.obj[objNum].dispose();
        this.obj[objNum]=null;
      }
      else
      {
        this.obj[objNum]=undefined;
        this.obj[objNum]=null;
      }
    }

    // clean up all objects

    public function cleanUpObjects()
    {
      for(var x:int=0; x<512+objCount; x++)
      {
        try
        {
          cleanUpObject(x);
        }
        catch(error)
        {
          continue;
        }
      }

      objCount=0;

      obj[objCount]=gamePlayer;
      objCount++;

      obj[objCount]=playerFireZone;
      objCount++;

      obj[objCount]=playerMouseArea;
      objCount++;

      obj[objCount]=background;
      objCount++;
    }

    // event for mouse button pushed down

    public function mouseDown(event:MouseEvent)
    {
      if(gameMode==0)
      {
        mousePressed=true;
        playerFireZone.setOffset(gamePlayer);

        if(doubleClickTimer>0)
          gamePlayer.activateShield();

        doubleClickTimer=30;
      }
    }

    // event for mouse button pushed up

    public function mouseUp(event:MouseEvent)
    {
      mousePressed=false;
    }

    // event for sound button

    public function soundBtnPressed(event:MouseEvent)
    {
      if(this.container.playSound==true)
        this.container.playSound=false;
      else
        this.container.playSound=true;
    }

    public function musicBtnPressed(event:MouseEvent)
    {
      if(this.container.playMusic==true)
      {
        this.container.playMusic=false;
        stopMusicLoop(); // changed
      }
      else
      {
        this.container.playMusic=true;
        startMusicLoop();
      }
    }
  }
}
