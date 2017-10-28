package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Blue Jewel class file
   *  Drops from destroyed enemies
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class blueJewel extends gameObject
  {
    public var timer:int=0;

    public function blueJewel()
    {
      this.visible=true;

      this.zPos=-1;
      this.playerCollectEffect=1;
      this.pointValue=100;
    }

    public function doLoop()
    {
      this.animateLoop();

      this.ySpeed+=0.02;
      if(this.ySpeed>=3)
        this.ySpeed=3;

      this.y+=this.ySpeed;

      if(this.y>=650)
        this.visible=false;
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
