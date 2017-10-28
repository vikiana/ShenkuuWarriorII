package com.neopets.vendor.gamepill.novastorm
{
  /*
   *  level data class
   *  Class for an individual level
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class levelData extends Object
  {
    public var desc:String="";
    public var goal:int=0; // level goal
    public var goalVal:int=0; // level goal value
    public var pinkJewelAppearTime:int=-1;
    public var enemyPopTimer:int=0;
    public var enemyLimit:int=20;
    public var enemyType=new Array();
    public var superNovaPopTimer=new Array(-1,-1);
    public var ultraNovaPopTimer=new Array(-1,-1);
    public var mechaNovaPopTimer=new Array(-1,-1);
    public var bossNovaPopTimer=new Array(-1,-1);
  }
}
