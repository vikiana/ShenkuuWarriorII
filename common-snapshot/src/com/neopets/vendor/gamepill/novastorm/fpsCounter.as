package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.utils.Timer;

  /*
   *  FPS counter class file
   *  Calculates the current FPS (Frames per second)
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class fpsCounter extends Sprite
  {
    private var counter:int=0;
    public var fps:int=0;

    public function fpsCounter(frameRate)
    {
      counter=0;
      fps=frameRate;
      addEventListener(Event.ENTER_FRAME, onEnterFrameEvent);

      var fpsTimer:Timer=new Timer(1000, 0);
      fpsTimer.addEventListener("timer",onTimerEvent);
      fpsTimer.start();
    }

    private function onEnterFrameEvent(event:Event):void
    {
      counter++;
    }

    private function onTimerEvent(event:Event):void
    {
      fps=counter;
      counter=0;
    }
  }
}
