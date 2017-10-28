package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Dark Nova class file
   *  Enemy that goes into stealth mode and emerges after firing
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class darkNova extends gameObject
  {
    public var shotTimer:int=0; // timer for counting between shots

    public var stealthTimer:int=0; // timer for stealth mode, if >0 enemy is out of stealth

    public function darkNova()
    {
      this.visible=true;

      this.movieClip=darkNovaMC;
      this.sLimit=1;
      this.shotTimer=0;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.isStealthEnemy=true;
      this.pointValue=400;
      this.gotoAndStop(0);
    }

    public function doLoop()
    {
      // if stealth timer is >0, decrease it and check if it should go back to stealth frame

      if(this.stealthTimer>0)
      {
        this.animateOnce();

        this.stealthTimer--;

        if(this.stealthTimer==0)
        {
          this.gotoAndStop(0);
        }
      }

      // aim towards the player

      this.aimTowards(this.container.gamePlayer.x+25,this.container.gamePlayer.y+25,0.02);

      // check if over the speed limit

      this.checkSpeed();

      // add speed to x,y

      this.move();

      // check if it's time to shoot

      this.shotTimer++;
      if(this.shotTimer>=100)
      {
        var aimPos:Point;
        var aimOffPos:Point;

        aimPos=getPosAim(this.container.gamePlayer.x+this.container.gamePlayer.width/2,this.container.gamePlayer.y+this.container.gamePlayer.height/2,12.75);
        this.container.makeObject(enemyShot,enemyBigShotMC,this.x+20,this.y+18,aimPos.x,aimPos.y);

        if(this.container.skillMode==2) // if hard skill, shoot more shots
        {
          aimOffPos=rotPos(aimPos.x,aimPos.y,36);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+this.height/2)-7,aimOffPos.x,aimOffPos.y);

          aimOffPos=rotPos(aimPos.x,aimPos.y,-36);
          this.container.makeObject(enemyShot,enemyBigShotMC,(this.x+this.width/2)-7,(this.y+this.height/2)-7,aimOffPos.x,aimOffPos.y);
        }

        this.shotTimer=0;

        // emerge from stealth

        this.stealthTimer=40;
        this.gotoAndStop(1);
      }
    }

    public function die()
    {
      this.visible=false;
      this.container.makeExplosionAndJewel(this,smallExplosionMC);
    }
  }
}
