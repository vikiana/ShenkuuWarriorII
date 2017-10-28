package com.neopets.vendor.gamepill.novastorm
{
	import flash.media.Sound;
  	import flash.media.SoundChannel;
 	import flash.media.SoundTransform;
	
  	import flash.display.MovieClip;

  	import flash.events.*;
	import flash.utils.*;
 	import flash.ui.Mouse;
  	import flash.geom.Point;
	import flash.text.TextField;

  	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.events.CustomEvent;

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

  public class title extends OpeningScreen
  {
    public var translation=new TranslationInfo();

    public var tweens=new Array();

    public var bg:MovieClip;
    public var stars:MovieClip;
    public var starBack:MovieClip;
    public var titleBack:MovieClip;
    public var titleFull:MovieClip;
    public var gem1:MovieClip;
    public var gem2:MovieClip;
    public var gem3:MovieClip;
    public var player:MovieClip;
    public var enemy:MovieClip;
    public var boss:MovieClip;
    public var flare:MovieClip;
	public var legal_txt:TextField
	
	public var musicCloudWalking=new cloudWalkingMusic() as Sound;
    public var musicChannel=new SoundChannel();
    public var curMusic:Sound;
	public var container;

    //public var startGameButton:NeopetsButton;
    //public var instructionsButton:NeopetsButton;
    //public var soundToggleBtn:SelectedButton;
    //public var musicToggleBtn:SelectedButton;

    public function title()
    {
      startGameButton.gotoAndStop(1);
      instructionsButton.gotoAndStop(1);

      for(var x=0; x<24; x++)
        tweens.push(new tweener());

      this.visible=false;

      MenuManager.instance.addEventListener("MenuSpecialEvent",show,false,0,true);

      //startGameButton["text"].htmlText=translation.IDS_TITLE_StartGame;
      //instructionsButton["text"].htmlText=translation.IDS_TITLE_Instructions;
    }
	
	 // set container

    public function setContainer(cont)
    {
      this.container=cont;
    }

    // start music loop

    public function startMusicLoop()
    {
      if(this.container.playMusic==false)
        return;

      curMusic=musicCloudWalking;

      musicChannel.stop();
      musicChannel=curMusic.play(0,9999999);

      var sndTransform=musicChannel.soundTransform;
      sndTransform.volume=0.4;
      musicChannel.soundTransform=sndTransform;
    }

    // stop music loop

    public function stopMusicLoop()
    {
      musicChannel.stop();
    }

    public function show(e:CustomEvent)
    {
	  if(e.oData.MENU!="mIntroScreen")
      {
        stopMusicLoop();
      }
      if(e.oData.MENU=="mIntroScreen")
      {
        startMusicLoop();
		
		var delay=0;
        var tweenCount=0;

        tweens[tweenCount].timedTween(bg,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(stars,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(starBack,"alpha",null,0,0.6,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(titleBack,"x",null,665,120,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(titleFull,"x",null,-200,333,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(gem1,"alpha",null,0,1,0.5,delay); tweenCount++;
        tweens[tweenCount].timedTween(gem2,"alpha",null,0,1,0.5,delay+0.3); tweenCount++;
        tweens[tweenCount].timedTween(gem3,"alpha",null,0,1,0.5,delay+0.6); tweenCount++;
        delay+=0.25;

        tweens[tweenCount].timedTween(flare,"alpha",null,0,1,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(player,"y",null,-140,113,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(enemy,"y",null,-120,138,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(boss,"y",null,-144,142,0.5,delay);
        delay+=0.25; tweenCount++;

        tweens[tweenCount].timedTween(startGameButton,"alpha",null,0,1,0.5,delay); tweenCount++;
        tweens[tweenCount].timedTween(soundToggleBtn,"alpha",null,0,1,0.5,delay); tweenCount++;
        delay+=0.25; 

        tweens[tweenCount].timedTween(instructionsButton,"alpha",null,0,1,0.5,delay); tweenCount++;
        tweens[tweenCount].timedTween(musicToggleBtn,"alpha",null,0,1,0.5,delay); tweenCount++;
        delay+=0.25;
      }
    }
  }
}
