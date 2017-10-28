package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.MovieClip;

  import flash.events.*;
  import flash.ui.Mouse;
  import flash.events.MouseEvent;
  
  /**
   *  pushButton class
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
   
  public class pushButton extends MovieClip
  {
    public var btnState:String;

    public function pushButton()
    {
      this.buttonMode=true;

      addEventListener(MouseEvent.MOUSE_OVER,onRollOver,false,0,true);
      addEventListener(MouseEvent.MOUSE_OUT,onRollOut,false,0,true);
      addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
      addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);

      btnState="";
    }

    public function select()
    {
      btnState="selected";
      gotoAndStop("selected");
    }

    public function deselect()
    {
      btnState="notSelected";
      gotoAndStop("off");
    }

    public function onRollOver(evt:MouseEvent):void 
    {
      if(btnState!="selected")
      {
        gotoAndStop("on");    
      }
      else
      {
        gotoAndStop("selected");  
      }
    }

    public function onRollOut(evt:MouseEvent):void 
    {
      if(btnState!="selected")
      {
        gotoAndStop("off");    
      }
      else
      {
        gotoAndStop("selected");
      }
    }

    public function onDown(evt:MouseEvent):void 
    {
      if(btnState!="selected")
      {
        btnState="selected";
        gotoAndStop("selected");
      }
      else
      {
        btnState="notSelected";
        gotoAndStop("down");
      }
    }

    public function onUp(evt:MouseEvent):void 
    {
      if(btnState!="selected")
      {
        gotoAndStop("off");    
      }
      else
      {
        gotoAndStop("selected");  
      }
    }
  }
}
