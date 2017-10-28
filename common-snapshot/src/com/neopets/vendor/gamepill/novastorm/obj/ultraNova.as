package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Ultra nova enemy
   *  Very large enemy that shoots three shot patterns
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class ultraNova extends gameObject
  {
    var shotMode:int=0;
    var shotTimer:int=0;
    var shotCount:int=0;

    var lockPlayerX:int=0;
    var lockPlayerY:int=0;

    public function ultraNova()
    {
      this.visible=true;

      this.movieClip=ultraNovaMC;
      this.sLimit=0;
      this.shotTimer=0;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=2000;
      this.health=35;
    }

    public function doLoop()
    {
      var x=0;

      this.animateLoop();

      this.shotTimer++;

      var aimPos:Point;
      var aimOffPos:Point;

      if(this.shotMode==0)
      {
        if(this.shotTimer>=4*this.container.shotTimerMult)
        {
          if(this.shotCount==0)
          {
            lockPlayerX=this.container.gamePlayer.x+this.container.gamePlayer.width/2;
            lockPlayerY=this.container.gamePlayer.y+this.container.gamePlayer.height/2;
          }
          aimPos=getPosAim(lockPlayerX,lockPlayerY,14);
          this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);

          aimOffPos=rotPos(aimPos.x,aimPos.y,32);
          this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimOffPos.x,aimOffPos.y);

          aimOffPos=rotPos(aimPos.x,aimPos.y,-32);
          this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimOffPos.x,aimOffPos.y);

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=10)
          {
            this.shotTimer=-20*this.container.shotTimerMult;
            this.shotCount=0;
            this.shotMode=1;
          }
        }
      }

      if(this.shotMode==1)
      {
        if(this.shotTimer>=8*this.container.shotTimerMult)
        {
          for(x=0; x<24; x++)
          {
            aimPos=rotPos(5,0,x*32);
            this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);
          }

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=4)
          {
            this.shotTimer=-20*this.container.shotTimerMult;
            this.shotCount=0;
            this.shotMode=2;
          }
        }
      }

      if(this.shotMode==2)
      {
        if(this.shotTimer>=4*this.container.shotTimerMult)
        {
          for(x=0; x<4; x++)
          {
            aimPos=rotPos(5,0,(this.shotCount+x)*32);
            this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);
          }

          this.shotTimer=0;
          this.shotCount++;
          if(this.shotCount>=12)
          {
            this.shotTimer=-20*this.container.shotTimerMult;
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
