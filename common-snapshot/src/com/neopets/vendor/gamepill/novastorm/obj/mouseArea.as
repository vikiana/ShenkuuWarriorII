package com.neopets.vendor.gamepill.novastorm.obj
{
  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Fire Zone class
   *  Yellow ring that shows where the player's shots should be going
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class mouseArea extends gameObject
  {
    public var timer:int=0;
    public var offX:Number;
    public var offY:Number;

    public function mouseArea()
    {
      this.visible=true;

      this.zPos=-1;
      this.removeable=false;
    }

    public function doLoop()
    {
      
    }
  }
}
