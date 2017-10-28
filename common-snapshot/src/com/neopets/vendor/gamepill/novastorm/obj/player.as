package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.game;
  import com.neopets.vendor.gamepill.novastorm.obj.*;

  import com.neopets.vendor.gamepill.novastorm.render.*;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.media.Sound;

  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.events.*;
  import flash.ui.Keyboard;

  /*
   *  Player class
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class player extends gameObject
  {
    public var playerShootSnd=new playerShootSound() as Sound;
    public var playerHitSnd=new playerHitSound() as Sound;
    public var playerSuperSnd=new playerSuperSound() as Sound;
    public var playerHyperSnd=new playerHyperSound() as Sound;

    public var shieldDownSnd=new shieldDownSound() as Sound;
    public var shieldUpSnd=new shieldUpSound() as Sound;
    public var shieldReadySnd=new shieldReadySound() as Sound;

    public var mouseArea=new Rectangle(17,18,12,12);
    public var killArea=new Rectangle(18,18,13,13);
    public var grabArea=new Rectangle(0,0,48,46);
    public var followArea=new Rectangle(-5,-7,60,60);
    public var superArea=new Rectangle(-30,-32,110,110);

    public var shield:simpleLoopAnim; // shield animation
    public var shieldReadyPulse:simpleAnim; // shield ready pulse animation
    public var superPulse:simpleAnim; // super pulse animation
    public var hyperPulse:simpleAnim; // hyper pulse animation

    // lives, score, tokens

    public var lives=0;
    public var score=0;
    public var tokens=0;

    // shield/super mode

    public var superTimer=0;
    public var shieldTimer=0;
    public var shieldStat=false;
    public var shieldReady=false;
    public var shieldChargeTime=25;
    public var shieldActiveTime=0;

    // power-ups

    public var threeWayShot=false;
    public var twoWayShot=false;
    public var shieldBonus=false;
    public var cannonShot=false;
    public var backShot=false;
    public var hyperNova=false;

    // key presses

    public var keyLeftPressed=false;
    public var keyRightPressed=false;
    public var keyUpPressed=false;
    public var keyDownPressed=false;
    public var keySpacePressed=false;

    public var eventListenersSet=false; // event listeners

    public var shotTimer=0; // shot timer
    public var hitTimer=0; // hit timer

    public function player()
    {
      this.visible=false;
      this.removeable=false;

      this.shield=new simpleLoopAnim();
      this.shieldReadyPulse=new simpleAnim();
      this.superPulse=new simpleAnim();
      this.hyperPulse=new simpleAnim();

      this.renderList=new Array(shield,shieldReadyPulse,superPulse,hyperPulse);
    }

    public function setupAnimations()
    {
      shield.setContainer(container);
      shield.parseMovieClip(new playerShieldMC());
      shield.x=(this.width/2)-(shield.width/2);
      shield.y=(this.height/2)-(shield.height/2);

      shieldReadyPulse.setContainer(container);
      shieldReadyPulse.parseMovieClip(new shieldReadyPulseMC());
      shieldReadyPulse.x=(this.width/2)-(shieldReadyPulse.width/2);
      shieldReadyPulse.y=(this.height/2)-(shieldReadyPulse.height/2);

      superPulse.setContainer(container);
      superPulse.parseMovieClip(new superPulseMC());
      superPulse.x=(this.width/2)-(superPulse.width/2);
      superPulse.y=(this.height/2)-(superPulse.height/2);

      hyperPulse.setContainer(container);
      hyperPulse.parseMovieClip(new hyperPulseMC());
      hyperPulse.x=(this.width/2)-(hyperPulse.width/2);
      hyperPulse.y=(this.height/2)-(hyperPulse.height/2);
    }

    // setup player for a new game

    public function newGame()
    {
      this.lives=3;
      this.score=0;
      this.tokens=0;

      this.threeWayShot=false;
      this.twoWayShot=false;
      this.shieldBonus=false;
      this.cannonShot=false;
      this.backShot=false;
      this.hyperNova=false;
    }

    // setup player for a new level

    public function setup()
    {
      this.x=650/2;
      this.y=600/2;
      this.health=3;
      this.superTimer=0;
      this.hitTimer=0;

      this.shieldTimer=0;
      this.shieldStat=false;
      this.shieldReady=false;

      this.keyLeftPressed=false;
      this.keyRightPressed=false;
      this.keyUpPressed=false;
      this.keyDownPressed=false;
      this.keySpacePressed=false;

      this.shield.visible=false;
      this.shieldReadyPulse.visible=false;
      this.superPulse.visible=false;
      this.hyperPulse.visible=false;

      this.visible=true;
      this.alpha=1;

      this.setupEventListeners();
    }

    // setup event listeners (keys)

    public function setupEventListeners()
    {
      if(eventListenersSet==false)
      {
        if(this.container.stage!=null)
        {
          this.container.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressDown,false,0,true);
          this.container.stage.addEventListener(KeyboardEvent.KEY_UP,keyPressUp,false,0,true);
          eventListenersSet=true;
        }
      }
    }

    // key pressed down

    private function keyPressDown(event:KeyboardEvent)
    {
      var keyCode=event.keyCode;

      if(keyCode==Keyboard.LEFT || keyCode==65)
      {
        keyLeftPressed=true;
      }
      if(keyCode==Keyboard.RIGHT || keyCode==68)
      {
        keyRightPressed=true;
      }
      if(keyCode==Keyboard.UP || keyCode==87)
      {
        keyUpPressed=true;
      }
      if(keyCode==Keyboard.DOWN || keyCode==83)
      {
        keyDownPressed=true;
      }
      if(keyCode==Keyboard.SPACE)
      {
        keySpacePressed=true;
      }
    }

    // key released

    private function keyPressUp(event:KeyboardEvent)
    {
      var keyCode=event.keyCode;

      if(keyCode==Keyboard.LEFT || keyCode==65)
      {
        keyLeftPressed=false;
      }
      if(keyCode==Keyboard.RIGHT || keyCode==68)
      {
        keyRightPressed=false;
      }
      if(keyCode==Keyboard.UP || keyCode==87)
      {
        keyUpPressed=false;
      }
      if(keyCode==Keyboard.DOWN || keyCode==83)
      {
        keyDownPressed=false;
      }
      if(keyCode==Keyboard.SPACE)
      {
        keySpacePressed=false;
      }
    }

    // animate shield/super, increment timers, move, etc.

    public function doLoop()
    {
      if(this.shieldReadyPulse.visible==true) this.shieldReadyPulse.doLoop();
      if(this.superPulse.visible==true) this.superPulse.doLoop();
      if(this.hyperPulse.visible==true) this.hyperPulse.doLoop();
      if(this.shield.visible==true) this.shield.doLoop();

      if(shieldStat==false)
      {
        if(shieldReady==false)
        {
          shieldTimer++;

          if(shieldTimer>=shieldChargeTime*this.container.frameRate)
          {
            shieldReady=true;

            if(this.container.container.playSound==true)
              shieldReadySnd.play();

            this.shieldReadyPulse.timer=1;
            this.shieldReadyPulse.visible=true;
          }
        }
      }
      if(shieldStat==true)
      {
        shieldTimer--;

        if(shieldTimer<=3*this.container.frameRate)
        {
          if(this.container.gCountHalf==0)
            this.shield.alpha=0;
          else
            this.shield.alpha=1;
        }

        if(shieldTimer<=0)
        {
          shieldStat=false;
          this.shield.visible=false;

          if(this.container.container.playSound==true)
            shieldDownSnd.play();
        }
      }

      if(superTimer>0)
      {
        superTimer--;

        makeSuperShot();
      }
      else
      {
        doKeyboardInput();
      }

      moveTowardsMouse();

      if(shotTimer>0)
        shotTimer--;

      if(this.health==0)
      {
        this.visible=false;
      }
      else
      {
        if(hitTimer>0)
        {
          hitTimer--;

          if(this.container.gCount%2==0)
            this.alpha=0;
          else
            this.alpha=1;
        }
        else
        {
          this.alpha=1;
        }
      }
    }

    // do keyboard input

    public function doKeyboardInput()
    {
      if(keyLeftPressed || keyRightPressed || keyUpPressed || keyDownPressed)
        fireTowardsArrowKeys();
      //else
      //  fireTowardsFireZone();

      if(keySpacePressed==true)
        fireHyperNova();
    }

    // move player towards mouse

    public function moveTowardsMouse()
    {
      var xSeek=this.container.mouseX;
      var ySeek=this.container.mouseY;

      if(!hitTest(xSeek,ySeek,this.x+mouseArea.x,this.y+mouseArea.y,this.x+mouseArea.x+mouseArea.width,this.y+mouseArea.y+mouseArea.height))
      {
        var tx=xSeek;
        var ty=ySeek;

        var tx2=this.x+48/2;
        var ty2=this.y+46/2;

        var a=Math.round(10*this.container.playerSpeedMult);

        var dx=tx-tx2;
        var dy=ty-ty2;

        var z=Math.abs(dx)+Math.abs(dy);
        z*=(a/100); if(z==0) z=1;

        dx=dx/z;
        dy=dy/z;

        this.x+=dx; this.x=Math.round(this.x);
        this.y+=dy; this.y=Math.round(this.y);
      }
      else
      {
        this.x=xSeek-(48/2);
        this.y=ySeek-(46/2);
      }
    }

    // fire towards fire zone

    public function fireTowardsFireZone()
    {
      if(shotTimer>0) return;

      this.container.playerFireZone.visible=true;

      var xSeek=(this.container.playerFireZone.x+this.container.playerFireZone.width/2)-5;
      var ySeek=(this.container.playerFireZone.y+this.container.playerFireZone.height/2)-5;

      var tx=xSeek;
      var ty=ySeek;

      var tx2=this.x+(48/2)-4;
      var ty2=this.y+(46/2)-4;

      var a=8;

      var dx=tx-tx2;
      var dy=ty-ty2;

      var z=Math.abs(dx)+Math.abs(dy);
      z*=(a/100); if(z==0) z=1;

      dx=dx/z;
      dy=dy/z;

      makeShot(dx,dy);
    }

    // fire towards arrow keys

    public function fireTowardsArrowKeys()
    {
      if(shotTimer>0) return;

      this.container.playerFireZone.visible=false;

      var xs=0;
      var ys=0;

      if(keyLeftPressed==true)
        xs=-8;
      else if(keyRightPressed==true)
        xs=8;

      if(keyUpPressed==true)
        ys=-8;
      else if(keyDownPressed==true)
        ys=8;

      if(xs==0 && ys==0) return;

      makeShot(xs,ys);
    }

    // make player shot

    public function makeShot(xSpd,ySpd)
    {
      shotTimer=12;

      if(this.cannonShot==true) // make cannon shot
        this.container.makeObject(playerCannonShot,playerCannonShotMC,this.x+(48/2)-7,this.y+(46/2)-7,xSpd,ySpd);
      else
        this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,xSpd,ySpd);

      var aimPos:Point;

      if(this.threeWayShot==true) // make three-way spread shot
      {
        aimPos=rotPos(xSpd,ySpd,-32);
        this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,aimPos.x,aimPos.y);
        aimPos=rotPos(xSpd,ySpd,32);
        this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,aimPos.x,aimPos.y);
      }
      if(this.twoWayShot==true) // make two-way fast shot
      {
        aimPos=rotPos(xSpd*1.25,ySpd*1.25,72);
        this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,aimPos.x,aimPos.y);
        aimPos=rotPos(xSpd*1.25,ySpd*1.25,-72);
        this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,aimPos.x,aimPos.y);
      }
      if(this.backShot==true) // make back shot
      {
        this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,-xSpd,-ySpd);
      }

      if(this.container.container.playSound==true)
        playerShootSnd.play();
    }

    // make super shot, spirals

    public function makeSuperShot()
    {
      var point:Point=rotPos(5,0,this.superTimer*32);

      this.container.makeObject(playerShot,playerShotMC,this.x+(48/2)-4,this.y+(46/2)-4,point.x,point.y);
    }

    // activate shield

    public function activateShield()
    {
      if(shieldReady==true)
      {
        if(this.container.container.playSound==true)
          shieldUpSnd.play();

        shieldReady=false;
        shieldStat=true;
        this.shield.visible=true;
        this.shield.alpha=1;

        if(shieldBonus==true)
          shieldActiveTime=15;
        else
          shieldActiveTime=10;

        shieldTimer=shieldActiveTime*this.container.frameRate; // 10 seconds

        shieldReadyPulse.timer=1;
        shieldReadyPulse.visible=true;
      }
    }

    // activate super

    public function activateSuper()
    {
      superTimer=2*this.container.frameRate;
      this.superPulse.timer=1;
      this.superPulse.visible=true;
      this.hitTimer=0;

      if(this.container.container.playSound==true)
        playerSuperSnd.play();
    }

    // fire hyper nova

    public function fireHyperNova()
    {
      if(hyperNova==true)
      {
        hyperNova=false;
        this.hyperPulse.visible=true;
        this.container.damageAllEnemyObjects();

        if(this.container.container.playSound==true)
          playerHyperSnd.play();
      }
    }

    // harm player if hit

    public function die()
    {
      if(this.hitTimer==0)
      {
        this.health--;
        this.hitTimer=80;

        if(this.health<=0)
          this.visible=false;

        if(this.container.container.playSound==true)
          playerHitSnd.play();
      }
    }
  }
}
