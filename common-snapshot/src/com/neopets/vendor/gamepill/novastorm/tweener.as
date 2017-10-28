package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.DisplayObject;
  import fl.transitions.*;
  import fl.transitions.easing.*;
  import fl.motion.easing.*;
  import flash.utils.*;
  
  import fl.transitions.Tween;
  import fl.transitions.easing.*;


  public class tweener extends Object
  {
    public var tweenActive:Boolean=false;

    public var curTween:Tween;
    public var secTween:Tween;

    public var tweenTrigger=function() { }
    public var tweenTimer:Timer=new Timer(1000,1);

    public function stopTween()
    {
      if(tweenActive==true)
      {
        tweenTimer.stop();
        curTween.stop();
        secTween.stop();
        tweenActive=false;
      }
    }

    public function timedTween(object,prop,func,startVal,endVal,duration,delay)
    {
      if(func==undefined || func==null)
        func=Exponential.easeOut;

      if(object==undefined)
      {
        trace("Tween error: object is undefined");
        return -1;
      }
      object[prop]=startVal;
      object.visible=true;

      this.tweenTrigger=function()
      {
        this.curTween=new Tween(object,prop,func,startVal,endVal,duration,true);
        tweenActive=true;
      }

      tweenTimer.stop();
      tweenActive=false;
      tweenTimer=new Timer(delay*1000, 1);
      tweenTimer.addEventListener("timer",this.tweenTrigger);
      tweenTimer.start();
    }

    public function timedDoubleTween(object,prop1,prop2,func,startVal1,startVal2,endVal1,endVal2,duration,delay)
    {
      if(func==undefined || func==null)
        func=Exponential.easeOut;

      if(object==undefined)
      {
        trace("Tween error: object is undefined");
        return -1;
      }
      object[prop1]=startVal1;
      object[prop2]=startVal2;
      object.visible=true;

      this.tweenTrigger=function()
      {
        this.curTween=new Tween(object,prop1,func,startVal1,endVal1,duration,true);
        this.secTween=new Tween(object,prop2,func,startVal2,endVal2,duration,true);
        tweenActive=true;
      }

      tweenTimer.stop();
      tweenActive=false;
      tweenTimer=new Timer(delay*1000, 1);
      tweenTimer.addEventListener("timer",this.tweenTrigger);
      tweenTimer.start();
    }
  }
}