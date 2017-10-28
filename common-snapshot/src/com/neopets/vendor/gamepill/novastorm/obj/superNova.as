package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Super nova enemy
   *  Larger enemy that shoots two shot patterns
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class superNova extends gameObject
  {
    var shotMode:int=0;
    var shotTimer:int=0;
    var shotCount:int=0;

    public function superNova()
    {
      this.visible=true;

      this.movieClip=superNovaMC;
      this.sLimit=1;
      this.shotTimer=0;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=1000;
      this.health=20;
    }

    public function doLoop()
    {
      this.animateLoop();

      this.aimTowards(this.container.gamePlayer.x+25,this.container.gamePlayer.y+25,0.03);

      this.checkSpeed();

      this.move();

      this.shotTimer++;

      var aimPos:Point;

      if(this.shotMode==0)
      {
        if(this.shotTimer>=4*this.container.shotTimerMult)
        {
          aimPos=getPosAim(this.container.gamePlayer.x+this.container.gamePlayer.width/2,this.container.gamePlayer.y+this.container.gamePlayer.height/2,14);
          this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=10)
          {
            this.shotCount=0;
            this.shotMode=1;
          }
        }
      }

      if(this.shotMode==1)
      {
        if(this.shotTimer>=6*this.container.shotTimerMult)
        {
          aimPos=rotPos(5,0,this.shotCount*32);
          this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=20)
          {
            this.shotCount=0;
            this.shotMode=0;
          }
        }
      }
    }

    public function die()
    {
      this.health--;

      if(this.health<=0)
      {
        this.visible=false;
        this.container.makeExplosionAndJewel(this,mediumExplosionMC);
      }
    }
  }
}
