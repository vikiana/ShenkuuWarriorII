package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.media.Sound;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  /*
   *  Boss Nova class file
   *  Appears in final level
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class bossNova extends gameObject
  {
    public var hitRect:Rectangle=new Rectangle(67,79,186-67,192-79);

    var shotPulse:int=0;    // value for controlling shot pattern movement
    var shotMode:int=0;     // current shot pattern
    var shotTimer:int=0;    // shot pattern timer
    var shotTwoTimer:int=0; // shot pattern second timer
    var shotCount:int=0;    // number of shots fired

    var doneEnemySpawn:Boolean=false; // if enemy spawn attack has been triggered

    public function bossNova()
    {
      this.visible=true;

      this.zPos=-10;
      this.movieClip=bossNovaMC;
      this.sLimit=0;
      this.shotTimer=-100;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.isBoss=true;
      this.pointValue=10000;
      this.health=700;
    }

    public override function getPosAim(xSeek:Number,ySeek:Number,speed:Number)
    {
      var tx=xSeek;
      var ty=ySeek;

      var tx2=this.x+this.width/2;
      var ty2=this.y+95;

      var dx=tx-tx2;
      var dy=ty-ty2;

      var z=Math.abs(dx)+Math.abs(dy);
      z*=(speed/100); if(z==0) z=1;

      dx=dx/z;
      dy=dy/z;

      var point=new Point(dx,dy);

      return point;
    }

    public function doLoop()
    {
      var x:int=0;

      this.animate();

      if(this.health<=0)
      {
        this.x+=(Math.random()*2)-1;
        this.y+=(Math.random()*2)-1;
        return;
      }

      this.shotTimer++;    // increment shot timer 1
      this.shotTwoTimer++; // increment shot timer 2

      var aimPos:Point; // point for aiming
      var aimOffPos:Point; // point for aiming at an angle

      if(this.shotMode==0)
      {
        if(this.shotTimer>=4*this.container.shotTimerMult)
        {
          aimPos=getPosAim(this.container.gamePlayer.x+this.container.gamePlayer.width/2,this.container.gamePlayer.y+this.container.gamePlayer.height/2,14);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,aimPos.y);

          shotPulse+=1;
          if(shotPulse>5)
            shotPulse=0;

          aimPos=getPosAim(0,shotPulse*20,14);
          this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,aimPos.y);

          for(x=1; x<=5; x++)
          {
            aimOffPos=rotPos(aimPos.x,aimPos.y,x*64);
            this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimOffPos.x,aimOffPos.y);
          }

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=77)
          {
            this.shotTimer=-50;
            this.shotCount=0;
            this.shotMode=1;
          }
        }
      }

      if(this.shotMode==1)
      {
        if(this.shotTimer>=8*this.container.shotTimerMult)
        {
          aimPos=rotPos(8,0,this.shotCount*16);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,-aimPos.x,-aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,-aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,-aimPos.x,aimPos.y);

          for(x=0; x<22; x++)
          {
            aimPos=rotPos(5,0,x*32);
            this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+95)-5,aimPos.x,aimPos.y);
          }

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=65)
          {
            this.shotTimer=-50;
            this.shotCount=0;
            this.shotMode=2;
          }
        }
      }

      if(this.shotMode==2)
      {
        if(this.shotTwoTimer>=2*this.container.shotTimerMult)
        {
          aimPos=rotPos(8,0,this.shotCount*16);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,-aimPos.x,-aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,-aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,-aimPos.x,aimPos.y);

          this.shotTwoTimer=0;
        }

        if(this.shotTimer>=16*this.container.shotTimerMult)
        {
          for(x=0; x<22; x++)
          {
            aimPos=rotPos(5,0,(x*32)+this.shotCount*4);
            this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+95)-5,aimPos.x,aimPos.y);
          }

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=45)
          {
            this.shotTimer=-50;
            this.shotTwoTimer=0;
            this.shotCount=0;
            this.shotMode=3;
          }
        }
      }

      if(this.shotMode==3)
      {
        if(this.shotTwoTimer>=16*this.container.shotTimerMult)
        {
          aimPos=rotPos(8,0,this.shotCount*16);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,-aimPos.x,-aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,-aimPos.y);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+95)-7,-aimPos.x,aimPos.y);

          this.shotTwoTimer=0;
        }

        if(this.shotTimer>=8*this.container.shotTimerMult)
        {
          aimPos=rotPos(4,0,this.shotCount*4);
          this.container.makeObject(enemyBombShot,enemyBombShotMC,(this.x+this.width/2)-7,(this.y+95)-7,aimPos.x,aimPos.y);

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=80)
          {
            this.shotTimer=-60;
            this.shotTwoTimer=0;
            this.shotCount=0;
            if(this.doneEnemySpawn==false)
            {
              this.shotMode=4;
              this.doneEnemySpawn=true;
            }
            else
              this.shotMode=0;
          }
        }
      }

      if(this.shotMode==4)
      {
        if(this.shotTwoTimer==Math.round(48*this.container.shotTimerMult))
        {
          this.animTimer=1;
        }
        if(this.shotTwoTimer>=48.5*this.container.shotTimerMult)
        {
          this.container.makeObject(mechNova,undefined,(this.x+125)-25,(this.y+38)-25,0,0);
          this.container.makeObject(mechNova,undefined,(this.x+210)-25,(this.y+95)-25,0,0);
          this.container.makeObject(mechNova,undefined,(this.x+186)-25,(this.y+209)-25,0,0);
          this.container.makeObject(mechNova,undefined,(this.x+63)-25,(this.y+209)-25,0,0);
          this.container.makeObject(mechNova,undefined,(this.x+38)-25,(this.y+96)-25,0,0);

          this.shotTwoTimer=0;
        }

        if(this.shotTimer>=32*this.container.shotTimerMult)
        {
          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=5)
          {
            this.shotTimer=Math.round(-5.5*48);
            this.shotTwoTimer=0;
            this.shotCount=0;
            this.shotMode=0;
          }
        }
      }
    }

    public function die()
    {
      this.health--;
    }
  }
}
