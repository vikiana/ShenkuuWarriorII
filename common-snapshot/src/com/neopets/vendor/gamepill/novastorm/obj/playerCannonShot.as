package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Player cannon shot
   *  Shot that can take 3 hits before it's considered "spent" and dissapears
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class playerCannonShot extends gameObject
  {
    public function playerCannonShot()
    {
      this.visible=true;

      this.zPos=-1;
      this.collideWithEnemy=true;
      this.health=3;
    }

    public function doLoop()
    {
      this.move();

      this.checkOutOfBounds();
    }

    public function die()
    {
      this.health--;

      if(this.health==0)
        this.visible=false;
    }
  }
}
