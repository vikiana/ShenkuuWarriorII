package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Simple Animation class
   *  Designed for movie clips with looping animations
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class simpleLoopAnim extends gameObject
  {
    public var timer:int=0;

    public function simpleLoopAnim()
    {
      this.visible=true;

      this.zPos=-2;
      this.gotoAndStop(0);
    }

    public function doLoop()
    {
      this.timer++;

      if(this.timer==this.totalFrames)
        this.timer=0;

      this.gotoAndStop(timer);
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
