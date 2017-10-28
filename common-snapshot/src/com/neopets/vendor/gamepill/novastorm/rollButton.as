package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.MovieClip;

  import flash.events.*;
  import flash.ui.Mouse;
  import flash.events.MouseEvent;
  import flash.text.TextField;

  /**
   *  rollButton class
   *
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   *
   *  @author Clive Henrick
   *  @since  1.30.2009
   *
   *  @author Christopher Emirzian
   *  @since  12.8.2009
   */

  public class rollButton extends MovieClip
  {
    public var text:TextField;

    public function rollButton()
    {
      this.gotoAndStop("off");
      this.buttonMode=true;
      addEventListener(MouseEvent.MOUSE_OVER,onRollOver,false,0,true);
      addEventListener(MouseEvent.MOUSE_OUT,onRollOut,false,0,true);
    }

    public function onRollOver(evt:MouseEvent):void 
    {
      gotoAndStop("on");
    }

    public function onRollOut(evt:MouseEvent):void 
    {
      gotoAndStop("off");
    }
  }
}
