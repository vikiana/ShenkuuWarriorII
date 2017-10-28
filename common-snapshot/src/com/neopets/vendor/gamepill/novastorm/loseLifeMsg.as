package com.neopets.vendor.gamepill.novastorm
{
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;
	
  import flash.ui.Mouse;
  import flash.display.MovieClip;
  import flash.media.Sound;

  import flash.display.DisplayObject;
  import flash.text.TextField;
  import flash.events.*;

  /*
   *  winLvl class
   *  winLvl display
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class loseLifeMsg extends msgDisplay
  {
    //public var translation=new TranslationInfo();

    public function loseLifeMsg()
    {
      super();
    }

    public override function okBtnPressed(event:MouseEvent)
    {
      this.visible=false;
      this.container.proceedStore();
    }

    public function show(livesLeft:int)
    {
      showAnim();
	  
	  TranslationManager.instance.setTextField(this.msgHeader.text, "<p align='center'>"+mTranslationData.IDS_LOSTLIFE_Ouch+"</p>");
	  TranslationManager.instance.setTextField( this.msgText.text, "<p align='center'>"+mTranslationData.IDS_LOSTLIFE_LostLife+" "+livesLeft+" "+mTranslationData.IDS_LOSTLIFE_Left+"</p>");

      //this.msgHeader.text.htmlText="<p align='center'>"+mTranslationData.IDS_LOSTLIFE_Ouch+"</p>";

      //this.msgText.text.htmlText="<p align='center'>"+mTranslationData.IDS_LOSTLIFE_LostLife+" "+livesLeft+" "+mTranslationData.IDS_LOSTLIFE_Left+"</p>";
    }
  }
}