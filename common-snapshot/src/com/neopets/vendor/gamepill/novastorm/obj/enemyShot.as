package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Enemy Seeker Shot class
   *  Generic enemy shot that moves in a constant velocity
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class enemyShot extends gameObject
  {
    public function enemyShot()
    {
      this.visible=true;

      this.zPos=2;
      this.collideWithPlayer=true;
      this.isEnemyShot=true;
    }

    public function doLoop()
    {
      this.move();

      this.checkOutOfBounds();
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
