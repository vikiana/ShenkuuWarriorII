package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Pulsar Nova
   *  Enemy that moves around and fires towards the center of the screen
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class pulsarNova extends gameObject
  {
    var shotTimer:int=0;

    public function pulsarNova()
    {
      this.visible=true;

      this.movieClip=pulsarNovaMC;
      this.sLimit=4;
      this.shotTimer=0;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=300;
    }

    public function doLoop()
    {
      this.animateLoop();

      this.aimTowards(650/2,600/2,0.07);

      this.checkSpeed();

      this.move();

      this.shotTimer++;
      if(this.shotTimer>=32*this.container.shotTimerMult)
      {
        var aimPos:Point=getPosAim(650/2,600/2,14);
        this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);
        this.shotTimer=0;
      }
    }

    public function die()
    {
      this.visible=false;
      this.container.makeExplosionAndJewel(this,smallExplosionMC);
    }
  }
}
