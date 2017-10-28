package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Enemy bomb shot class
   *  Enemy shot that explodes into smaller shots after one second
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class enemyBombShot extends gameObject
  {
    var timer:int=0;

    public function enemyBombShot()
    {
      this.visible=true;

      this.zPos=2;
      this.collideWithPlayer=true;
      this.isEnemyShot=true;
    }

    public function doLoop()
    {
      this.timer++;

      if(this.timer>=1*this.container.frameRate)
      {
        for(var x=0; x<11; x++)
        {
          var aimPos:Point=rotPos(4,0,x*34);
          this.container.makeObject(enemyShot,enemyShotMC,this.x+this.width/2,this.y+this.height/2,aimPos.x,aimPos.y);
        }

        this.visible=false;
      }

      this.x+=this.xSpeed;
      this.y+=this.ySpeed;
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
