package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Buy Button class file
   *  Appears in store, user clicks to buy stuff
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class buyBtn extends MovieClip
  {
    public var cost:int;   // cost in tokens
    public var effect:int; // effect on player (3-way shot, shield bonus, etc)

    public var rollOverText:String=""; // roll over info

    public var cover:MovieClip;
  }
}
