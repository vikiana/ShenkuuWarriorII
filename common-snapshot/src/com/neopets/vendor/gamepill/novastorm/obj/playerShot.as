package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Player shot
   *  Regular player shot
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class playerShot extends gameObject
  {
    public function playerShot()
    {
      this.visible=true;

      this.zPos=-1;
      this.collideWithEnemy=true;
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
