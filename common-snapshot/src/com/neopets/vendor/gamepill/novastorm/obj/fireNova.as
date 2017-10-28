package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Fire Nova Shot class
   *  Enemy that moves in dashes and shoots seeker shots
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class fireNova extends gameObject
  {
    var moveTimer:int=0; // time between movements

    public function fireNova()
    {
      this.visible=true;

      this.movieClip=fireNovaMC;
      this.sLimit=1.5;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=400;
      this.moveTimer=1000; // set moveTimer so that it begins moving immediatly
      this.health=2;
    }

    public function doLoop()
    {
      this.animate();

      this.move();

      this.divideSpeed(1.02);

      this.bounceWalls();

      this.moveTimer++;
      if(this.moveTimer>=80)
      {
        this.moveTimer=0;
        this.xSpeed=((Math.random()*140)-70)/10;
        this.ySpeed=((Math.random()*140)-70)/10;
      }

      var shotTime=int(64*this.container.shotTimerMult);

      if(this.container.gCount%shotTime==0)
      {
        var aimPos=getPosAim(this.container.gamePlayer.x+this.container.gamePlayer.width/2,this.container.gamePlayer.y+this.container.gamePlayer.height/2,14);
        this.container.makeObject(enemySeekerShot,enemySeekerShotMC,(this.x+this.width/2)-6,(this.y+this.height/2)-6,aimPos.x,aimPos.y);
        this.animTimer=1;
      }
    }

    public function die()
    {
      this.health--;

      if(this.health<=0)
      {
        this.visible=false;
        this.container.makeExplosionAndJewel(this,smallExplosionMC);
      }
    }
  }
}
