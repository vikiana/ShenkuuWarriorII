package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Ram Nova
   *  Enemy that attempts to ram into the player
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class ramNova extends gameObject
  {
    var shotTimer=0;

    public function ramNova()
    {
      this.visible=true;

      this.movieClip=ramNovaMC;
      this.sLimit=3.5;
      this.shotTimer=0;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=200;
    }

    public function doLoop()
    {
      this.animateLoop();

      this.aimTowards(this.container.gamePlayer.x+25,this.container.gamePlayer.y+25,0.15);

      this.checkSpeed();

      this.move();
    }

    public function die()
    {
      this.visible=false;
      this.container.makeExplosionAndJewel(this,smallExplosionMC);
    }
  }
}
