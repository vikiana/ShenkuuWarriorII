package com.neopets.vendor.gamepill.novastorm
{
  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.ui.Mouse;
  import virtualworlds.lang.TranslationManager;
  import virtualworlds.lang.TranslationData;

  /*
   *  chooseDifficulty class
   *  Allows player to choose a difficulty mode (easy, normal or hard)
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class chooseDifficultyClass extends MovieClip
  {
    //public var translation=new TranslationInfo();
	protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;


    public var container:MovieClip;

    public var bg:MovieClip;
    public var stars:MovieClip;
    public var starBack:MovieClip;
    public var chooseDiffText:MovieClip;
    public var easyBtn:rollButton;
    public var normalBtn:rollButton;
    public var hardBtn:rollButton;

    public var tweens=new Array();

    public function chooseDifficultyClass()
    {
      for(var x=0; x<8; x++)
        tweens.push(new tweener());

      this.visible=false;

      easyBtn.addEventListener("click",easyBtnClicked,false,0,true);
      easyBtn.buttonMode=true;

      normalBtn.addEventListener("click",normalBtnClicked,false,0,true);
      normalBtn.buttonMode=true;

      hardBtn.addEventListener("click",hardBtnClicked,false,0,true);
      hardBtn.buttonMode=true;


      //chooseDiffText.text.htmlText=mTranslationData.IDS_DIFFICULTY_Choose;
      //easyBtn.text.htmlText=mTranslationData.IDS_DIFFICULTY_Easy;
      //normalBtn.text.htmlText=mTranslationData.IDS_DIFFICULTY_Normal;
      //hardBtn.text.htmlText=mTranslationData.IDS_DIFFICULTY_Hard;
	  
	  TranslationManager.instance.setTextField(chooseDiffText.text, mTranslationData.IDS_DIFFICULTY_Choose);
	  TranslationManager.instance.setTextField( easyBtn.text, mTranslationData.IDS_DIFFICULTY_Easy);
	  TranslationManager.instance.setTextField(normalBtn.text, mTranslationData.IDS_DIFFICULTY_Normal);
	  TranslationManager.instance.setTextField(hardBtn.text, mTranslationData.IDS_DIFFICULTY_Hard);
	  
    }

    public function easyBtnClicked(event)
    {
      this.container.skillMode=0;
      this.container.newGame();
    }

    public function normalBtnClicked(event)
    {
      this.container.skillMode=1;
      this.container.newGame();
    }

    public function hardBtnClicked(event)
    {
      this.container.skillMode=2;
      this.container.newGame();
    }

    public function show()
    {
      var delay=0;
      var tweenCount=0;

      tweens[tweenCount].timedTween(bg,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(stars,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(starBack,"alpha",null,0,0.7,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(chooseDiffText,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(easyBtn,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(normalBtn,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(hardBtn,"alpha",null,0,1,0.5,delay);
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
