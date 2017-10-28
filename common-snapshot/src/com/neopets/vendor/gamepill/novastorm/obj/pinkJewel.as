package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Pink Jewel class
   *  When grabbed by player, player enters super mode
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class pinkJewel extends gameObject
  {
    public var timer:int=0; // counter for jewel dissapearing

    public function pinkJewel()
    {
      this.visible=true;

      this.zPos=-1;
      this.playerCollectEffect=2;
      this.pointValue=1000;
    }

    public function doLoop()
    {
      this.animateLoop();

      this.timer++;

      if(this.timer>=4*48)
        this.alpha=this.container.gCountHalf; // make it flash

      if(this.timer>=5*48)
        this.visible=false;
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
