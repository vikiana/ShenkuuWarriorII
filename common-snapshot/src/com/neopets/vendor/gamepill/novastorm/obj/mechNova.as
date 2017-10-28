package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  MechNova
   *  Enemy that does basic seek and fire at player
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class mechNova extends gameObject
  {
    var shotTimer:int=0;

    public function mechNova()
    {
      this.visible=true;

      this.movieClip=mechNovaMC;
      this.sLimit=1.5;
      this.shotTimer=0;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=200;
    }

    public function doLoop()
    {
      this.animate();

      this.aimTowards(this.container.gamePlayer.x+25,this.container.gamePlayer.y+25,0.03);

      this.checkSpeed();

      this.move();

      this.shotTimer++;
      if(this.shotTimer>=32*this.container.shotTimerMult)
      {
        var aimPos:Point=getPosAim(this.container.gamePlayer.x+this.container.gamePlayer.width/2,this.container.gamePlayer.y+this.container.gamePlayer.height/2,14);
        this.container.makeObject(enemyShot,enemyShotMC,(this.x+this.width/2)-5,(this.y+this.height/2)-5,aimPos.x,aimPos.y);
        this.shotTimer=0;
        this.animTimer=1;
      }
    }

    public function die()
    {
      this.visible=false;
      this.container.makeExplosionAndJewel(this,smallExplosionMC);
    }
  }
}
