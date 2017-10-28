package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.MovieClip;

  import flash.events.*;
  import flash.utils.*;
  import flash.ui.Mouse;
  import flash.geom.Point;

  import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;

  /*
   *  NovaStorm Title class
   *  Title screen class
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class inst extends InstructionScreen
  {
    //public var trans=new TranslationInfo();
	protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;

    public var tweens=new Array();

    public var bg:MovieClip;
    public var stars:MovieClip;
    public var starBack:MovieClip;
    public var instTxt:MovieClip;
    public var instScreen0:MovieClip;
    public var instScreen1:MovieClip;
    //public var returnBtn;
    public var nextBtn:rollButton;
    public var prevBtn:rollButton;

    public var pageNum:int=0;

    public function inst()
    {
      returnBtn.gotoAndStop(1);

      for(var x=0; x<8; x++)
        tweens.push(new tweener());

      this.visible=false;

      this.prevBtn.addEventListener("click",prevBtnPressed,false,0,true);
      this.prevBtn.buttonMode=true;

      this.nextBtn.addEventListener("click",nextBtnPressed,false,0,true);
      this.nextBtn.buttonMode=true;

      MenuManager.instance.addEventListener("MenuSpecialEvent",show,false,0,true);

      //instTxt.text.htmlText=mTranslationData.IDS_INSTRUCTIONS_Instructions;
	   TranslationManager.instance.setTextField(instTxt.text, mTranslationData.IDS_INSTRUCTIONS_Instructions);
	   TranslationManager.instance.setTextField(instScreen0.text, mTranslationData.IDS_INSTRUCTIONS_PageZeroPart1+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageZeroPart2+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageZeroPart3+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageZeroPart4);
	   TranslationManager.instance.setTextField(instScreen1.text, mTranslationData.IDS_INSTRUCTIONS_PageOnePart1+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart2+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart3+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart4+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart5+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart6+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart7);

      //instScreen0.text.htmlText=mTranslationData.IDS_INSTRUCTIONS_PageZeroPart1+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageZeroPart2+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageZeroPart3+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageZeroPart4;
      //instScreen1.text.htmlText=mTranslationData.IDS_INSTRUCTIONS_PageOnePart1+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart2+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart3+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart4+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart5+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart6+"\n"+mTranslationData.IDS_INSTRUCTIONS_PageOnePart7;
    }

    public function prevBtnPressed(event:MouseEvent)
    {
      if(pageNum>0)
      {
        this["instScreen"+pageNum].visible=false;
        pageNum--;
        this["instScreen"+pageNum].visible=true;
      }
    }

    public function nextBtnPressed(event:MouseEvent)
    {
      if(pageNum<1)
      {
        this["instScreen"+pageNum].visible=false;
        pageNum++;
        this["instScreen"+pageNum].visible=true;
      }
    }

    public function show(e:CustomEvent)
    {
      if(e.oData.MENU=="mInstructionScreen")
      {
        pageNum=0;

        instScreen0.visible=false;
        instScreen1.visible=false;

        var delay=0;
        var tweenCount=0;

        tweens[tweenCount].timedTween(bg,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(stars,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(starBack,"alpha",null,0,0.4,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(instTxt,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(instScreen0,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(nextBtn,"alpha",null,0,1,0.5,delay); tweenCount++;
        tweens[tweenCount].timedTween(prevBtn,"alpha",null,0,1,0.5,delay); tweenCount++;
        tweens[tweenCount].timedTween(returnBtn,"alpha",null,0,1,0.5,delay); tweenCount++;
        delay+=0.25;
      }
    }
  }
}
