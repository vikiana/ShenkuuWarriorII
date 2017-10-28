package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Mine Nova
   *  Enemy that bounces off the walls and drops mines
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class mineNova extends gameObject
  {
    var shotTimer:int=0;

    public function mineNova()
    {
      this.visible=true;

      this.movieClip=mineNovaMC;
      this.sLimit=1.5;
      this.shotTimer=15;
      this.collideWithPlayer=true;
      this.isEnemy=true;
      this.pointValue=200;
    }

    public function doLoop()
    {
      // make it start moving if it's standing still

      if(this.xSpeed==0 || this.ySpeed==0)
      {
        if(Math.round(Math.random()*2)==0)
          this.xSpeed=-4;
        else
          this.xSpeed=4;

        if(Math.round(Math.random()*2)==0)
          this.ySpeed=-4;
        else
          this.ySpeed=4;
      }

      this.animate();

      this.bounceWalls();

      this.move();

      this.shotTimer++;
      if(this.shotTimer>=30*this.container.shotTimerMult)
      {
        this.container.makeObject(enemyMine,enemyMineMC,(this.x+this.width/2)-13,(this.y+this.height/2)-13,0,0);
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
