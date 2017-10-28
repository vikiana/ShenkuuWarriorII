package com.neopets.vendor.gamepill.novastorm
{
	
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;
  import flash.ui.Mouse;
  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.text.TextField;
  import flash.events.*;

  /*
   *  msgDisplay class
   *  used for displaying messages to player and proceeding after the player clicks OK
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class msgDisplay extends MovieClip
  {
    public var tweens=new Array();

    public var container:MovieClip;

    public var bg:MovieClip;
    public var stars:MovieClip;
    public var starBack:MovieClip;
    public var msgHeader:MovieClip;
    public var msgText:MovieClip;
    public var okBtn:rollButton;
	
	protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;

    public function msgDisplay()
    {
      for(var x=0; x<8; x++)
        tweens.push(new tweener());

      this.visible=false;

      this.okBtn.addEventListener("click",okBtnPressed,false,0,true);
      this.okBtn.buttonMode=true;
	  TranslationManager.instance.setTextField(this.okBtn.text, "<p align='center'>"+mTranslationData.IDS_BTN_OK+"</p>")
    }

    public function okBtnPressed(event:MouseEvent)
    {
      
    }

    public function showAnim()
    {
      var delay=0;
      var tweenCount=0;

      tweens[tweenCount].timedTween(bg,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(stars,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(starBack,"y",null,-460,60,0.5,delay);
      delay+=0.5; tweenCount++;

      tweens[tweenCount].timedTween(msgHeader,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(msgText,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(okBtn,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      this.visible=true;

      Mouse.show();
    }

    public function setContainer(cont)
    {
      this.container=cont;
    }
  }
}