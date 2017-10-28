package com.neopets.vendor.gamepill.novastorm
{
	
  import flash.display.MovieClip;

  import flash.events.*;
  import flash.utils.*;
  import flash.ui.Mouse;
  import flash.geom.Point;

  import com.neopets.projects.gameEngine.gui.Interface.GameOverScreen;
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

  public class gameOver extends GameOverScreen
  {
    //public var trans=new translationInfo();
	protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;

    public var tweens=new Array();

    public var bg:MovieClip;
    public var stars:MovieClip;
    public var starBack:MovieClip;
    public var gameOverTxt:MovieClip;
    public var stats:MovieClip;
    //public var playAgainBtn;
    //public var reportScoreBtn;

    public function gameOver()
    {
      playAgainBtn.gotoAndStop(1);
      reportScoreBtn.gotoAndStop(1);

      for(var x=0; x<12; x++)
        tweens.push(new tweener());

      this.visible=false;

      MenuManager.instance.addEventListener("MenuSpecialEvent",show,false,0,true);

      //playAgainBtn["text"].htmlText=mTranslationData.IDS_GAMEOVER_PlayAgain;
      //reportScoreBtn["text"].htmlText=mTranslationData.IDS_GAMEOVER_SubmitScore;
    }

    public function setup(msg,score,level,enemies,gems)
    {
      gameOverTxt.text.htmlText=msg;
	  TranslationManager.instance.setTextField(stats.text, "<p align='center'>"+mTranslationData.IDS_GAMEOVER_FinalScore+"\n"+score+"\n"+mTranslationData.IDS_WINLEVEL_LevelsCompleted+"\n"+level+"\n"+mTranslationData.IDS_WINLEVEL_EnemiesBlasted+"\n"+mTranslationData.IDS_WINLEVEL_GemsCollected+"\n"+gems)
      //stats.text.htmlText=mTranslationData.IDS_GAMEOVER_FinalScore+"\n"+score+"\n"+IDS_WINLEVEL_LevelsCompleted+"\n"+level+"\n"+IDS_WINLEVEL_EnemiesBlasted+"\n"+IDS_WINLEVEL_GemsCollected+"\n"+gems;
    }

    public function show(e:CustomEvent)
    {
      if(e.oData.MENU=="mGameOverScreen")
      {
        var delay=0;
        var tweenCount=0;

        tweens[tweenCount].timedTween(bg,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(stars,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(starBack,"alpha",null,0,0.4,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(gameOverTxt,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(stats,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(playAgainBtn,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(reportScoreBtn,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;
      }
    }
  }
}
