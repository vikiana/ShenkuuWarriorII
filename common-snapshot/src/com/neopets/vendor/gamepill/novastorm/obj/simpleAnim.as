package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Simple Animation class
   *  Designed for movie clips with animations
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class simpleAnim extends gameObject
  {
    public var timer:int=0;

    public function simpleAnim()
    {
      this.visible=true;

      this.zPos=-2;
      this.gotoAndStop(0);
    }

    public function doLoop()
    {
      this.timer++;

      if(this.timer==this.totalFrames)
        this.visible=false;
      else
        this.gotoAndStop(timer);
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
