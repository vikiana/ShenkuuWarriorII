package com.neopets.vendor.gamepill.novastorm.render
{
  /*
   *  Depth sort object class
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class sortObj
  {
    public var spr:sprite; // sprite
    public var zPos:Number; // depth

    public function sortObj(spr:sprite, zPos:Number)
    {
      this.spr=spr;
      this.zPos=zPos;
    }
  }
}
