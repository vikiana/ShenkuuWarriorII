package com.neopets.vendor.gamepill.novastorm
{
  import flash.ui.Mouse;
  import flash.display.MovieClip;
  import flash.media.Sound;

  import flash.display.DisplayObject;
  import flash.text.TextField;
  import flash.events.*;
  import virtualworlds.lang.TranslationManager;
  import virtualworlds.lang.TranslationData;

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

  public class winLvlMsg extends msgDisplay
  {
    //public var translation=new TranslationInfo();

    public var winLevelSnd=new winLevelSound() as Sound;

    public function winLvlMsg()
    {
      super();

      msgText.text.height+=60;
      okBtn.y+=100;
    }

    public override function okBtnPressed(event:MouseEvent)
    {
      this.visible=false;
      this.container.proceedStore();
    }

    public function show(levelNum:int,enemiesDestroyed:int,jewelCollected:int,levelScore:int)
    {
      showAnim();

      if(this.container.container.playSound==true)
        winLevelSnd.play();

      //this.msgHeader.text.htmlText="<p align='center'>"+mTranslationData.IDS_WINLEVEL_Nice+"</p>";

      //this.msgText.text.htmlText="<p align='center'><font size='12'>"+mTranslationData.IDS_WINLEVEL_Level+" "+(levelNum)+" "+mTranslationData.IDS_WINLEVEL_Complete+"!\n\n"+mTranslationData.IDS_WINLEVEL_EnemiesBlasted+": "+enemiesDestroyed+"\n"+mTranslationData.IDS_WINLEVEL_GemsCollected+": "+jewelCollected+"\n\n"+mTranslationData.IDS_WINLEVEL_PointsEarned+"\n"+levelScore+"</font></p>";
	  
	  TranslationManager.instance.setTextField(this.msgHeader.text, "<p align='center'>"+mTranslationData.IDS_WINLEVEL_Nice+"</p>");
	  TranslationManager.instance.setTextField(this.msgText.text, "<p align='center'><font size='12'>"+mTranslationData.IDS_WINLEVEL_Level+" "+(levelNum)+" "+mTranslationData.IDS_WINLEVEL_Complete+"!\n\n"+mTranslationData.IDS_WINLEVEL_EnemiesBlasted+enemiesDestroyed+"\n"+mTranslationData.IDS_WINLEVEL_GemsCollected+jewelCollected+"\n\n"+mTranslationData.IDS_WINLEVEL_PointsEarned+"\n"+levelScore+"</font></p>");
    }
  }
}