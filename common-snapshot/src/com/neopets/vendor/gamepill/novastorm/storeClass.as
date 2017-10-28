package com.neopets.vendor.gamepill.novastorm
{
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;
  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.media.Sound;

  import flash.text.TextField;
  import flash.events.*;

  /*
   *  Store class
   *  Store that user can click on buttons to buy new weapons/upgrades
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class storeClass extends MovieClip
  {
    //public var translation=new TranslationInfo();
	protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;

    public var buyUpgradeSnd=new buyUpgradeSound() as Sound;
    public var buyFailSnd=new buyFailSound() as Sound;

    public var container:MovieClip;

    public var rollOverActive:Boolean=false;

    public var yourTokens:TextField;
    public var rollOverText:MovieClip;
    public var playBtn:rollButton;
    public var bg:MovieClip;
    public var stars:MovieClip;
    public var upgradeBack:MovieClip;
    public var levelBack:MovieClip;
    public var weaponHeader:MovieClip;
    public var levelHeader:MovieClip;

    public var buy0:buyBtn;
    public var buy1:buyBtn;
    public var buy2:buyBtn;
    public var buy3:buyBtn;
    public var buy4:buyBtn;
    public var buy5:buyBtn;

    public var star0:MovieClip;
    public var star1:MovieClip;
    public var star2:MovieClip;
    public var star3:MovieClip;
    public var star4:MovieClip;
    public var star5:MovieClip;

    public var tweens=new Array();

    public function storeClass()
    {
      for(var x=0; x<32; x++)
        tweens.push(new tweener());

      this.visible=false;

      buy0.cost=3000;
      buy1.cost=8000;
      buy2.cost=9000;
      buy3.cost=10000;
      buy4.cost=15000;
      buy5.cost=2500;

      buy0.effect=1;
      buy1.effect=2;
      buy2.effect=3;
      buy3.effect=4;
      buy4.effect=5;
      buy5.effect=6;

      for(var x=0; x<6; x++)
      {
        this["buy"+x].addEventListener("rollOver",btnRollOver,false,0,true);
        this["buy"+x].addEventListener("rollOut",btnRollOut,false,0,true);
        this["buy"+x].addEventListener("click",buyBtnClicked,false,0,true);
        this["buy"+x].buttonMode=true;
        this["buy"+x].gotoAndStop(x+1);
      }

      for(var x=0; x<10; x++)
      {
        this["lvlBtn"+x].level=x;
        this["lvlBtn"+x].addEventListener("rollOver",btnRollOver,false,0,true);
        this["lvlBtn"+x].addEventListener("rollOut",btnRollOut,false,0,true);
        this["lvlBtn"+x].addEventListener("click",lvlBtnClicked,false,0,true);
        //this["lvlBtn"+x].buttonMode=true;
        this["lvlBtn"+x].gotoAndStop(x+1);
      }

      //playBtn.text.htmlText=mTranslationData.IDS_STORE_Play;
	  TranslationManager.instance.setTextField(playBtn.text, mTranslationData.IDS_STORE_Play)
      playBtn.addEventListener("click",playBtnClicked,false,0,true);
      //playBtn.buttonMode=true;

      this.addEventListener("enterFrame",onEnter,false,0,true);

      this.rollOverText.mouseEnabled=false;
      this.rollOverText.mouseChildren=false;
	  
	  TranslationManager.instance.setTextField(weaponHeader.text, mTranslationData.IDS_HEADER_WEAPONS)
	  TranslationManager.instance.setTextField(levelHeader.text, mTranslationData.IDS_HEADER_LEVELS)
    }

    public function onEnter(event:Event)
    {
      if(this.visible==true)
      {
        if(this.rollOverActive==true)
        {
          this.rollOverText.x=mouseX+8;
          this.rollOverText.y=mouseY+8;
          this.rollOverText.visible=true;

          if(this.rollOverText.x+this.rollOverText.width>650)
            this.rollOverText.x-=this.rollOverText.width;

          if(this.rollOverText.y+this.rollOverText.height>600)
            this.rollOverText.y-=this.rollOverText.height;
        }
        else
          this.rollOverText.visible=false;
      }
    }

    public function btnRollOver(event)
    {
	  TranslationManager.instance.setTextField(this.rollOverText.text, event.currentTarget.rollOverText);
      //this.rollOverText.text.autoSize="center";
      //this.rollOverText.text.htmlText=event.currentTarget.rollOverText;
      this.rollOverText.back.height=this.rollOverText.text.textHeight+22;
      this.rollOverActive=true;
    }

    public function btnRollOut(event)
    {
      this.rollOverActive=false;
    }

    public function lvlBtnClicked(event)
    {
		//trace (this.container.levelNum);
      if(event.currentTarget.cover.alpha==0)
      {
        this.visible=false;
        this.container.proceedNextLevel();
      }
    }
    public function buyBtnClicked(event)
    {
      if(event.currentTarget.cover.alpha!=0)
        return;

      if(this.container.gamePlayer.tokens>=event.currentTarget.cost)
      {
        if(this.container.container.playSound==true)
          buyUpgradeSnd.play();

        this.container.gamePlayer.tokens-=event.currentTarget.cost;
		TranslationManager.instance.setTextField(this.yourTokens, mTranslationData.IDS_STORE_YourGems+ Math.round(this.container.gamePlayer.tokens))
        //this.yourTokens.htmlText=mTranslationData.IDS_STORE_YourGems+": "+this.container.gamePlayer.tokens;

        event.currentTarget.cover.alpha=0.8;
        event.currentTarget.checkMark.visible=true;

        if(event.currentTarget.effect==1)
          this.container.gamePlayer.threeWayShot=true;
        if(event.currentTarget.effect==2)
          this.container.gamePlayer.twoWayShot=true;
        if(event.currentTarget.effect==3)
          this.container.gamePlayer.shieldBonus=true;
        if(event.currentTarget.effect==4)
          this.container.gamePlayer.cannonShot=true;
        if(event.currentTarget.effect==5)
          this.container.gamePlayer.backShot=true;
        if(event.currentTarget.effect==6)
          this.container.gamePlayer.hyperNova=true;
      }
      else
      {
        if(this.container.container.playSound==true)
          buyFailSnd.play();
      }
    }

    public function playBtnClicked(event)
    {
      this.visible=false;
      this.container.proceedNextLevel();
    }

    public function show(levelNum)
    {
		//make only the active button button mode
	  for(var x=0; x<10; x++)
      {
        this["lvlBtn"+x].buttonMode=false;
      }
	   this["lvlBtn"+this.container.levelNum].buttonMode=true
		
      var delay=0;
      var tweenCount=0;

      tweens[tweenCount].timedTween(bg,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(stars,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(playBtn,"y",null,614,528,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(upgradeBack,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(weaponHeader,"x",null,-325,7,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(yourTokens,"alpha",null,0,1,0.5,delay); tweenCount++;

      for(var x=0; x<6; x++)
      {
        tweens[tweenCount].timedTween(this["star"+x],"alpha",null,0,1,0.5,delay); tweenCount++;
        tweens[tweenCount].timedTween(this["buy"+x],"alpha",null,0,1,0.5,delay); tweenCount++;
        delay+=0.1;
      }

      delay=0.5;

      tweens[tweenCount].timedTween(levelBack,"alpha",null,0,1,0.5,delay);
      delay+=0.25; tweenCount++;

      tweens[tweenCount].timedTween(levelHeader,"x",null,655,335,0.5,delay);
      delay+=0.25; tweenCount++;

      for(var x=0; x<10; x++)
      {
        tweens[tweenCount].timedTween(this["lvlBtn"+x],"alpha",null,0,1,0.5,delay); tweenCount++;
        delay+=0.1;
      }

      this.visible=true;
	  
	  //TranslationManager.instance.setTextField(this.yourTokens, mTranslationData.IDS_STORE_YourGems+this.container.gamePlayer.tokens)
	  TranslationManager.instance.setTextField(this.yourTokens, mTranslationData.IDS_STORE_YourGems+ Math.round(this.container.gamePlayer.tokens))

      //this.yourTokens.htmlText=mTranslationData.IDS_STORE_YourGems+": "+this.container.gamePlayer.tokens;

      this.rollOverText.visible=false;

      this.rollOverActive=false;

      for(var x=0; x<6; x++)
      {
        this["buy"+x].gotoAndStop(x+1);
        this["buy"+x].visible=true;
        this["buy"+x].cover.alpha=0;
        this["buy"+x].checkMark.visible=false;
      }

      buy0.rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Upgrade0+"\n3000\n"+mTranslationData.IDS_STORE_UpgradeDesc0+"</p>";
      buy1.rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Upgrade1+"\n8000\n"+mTranslationData.IDS_STORE_UpgradeDesc1+"</p>";
      buy2.rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Upgrade2+"\n9000\n"+mTranslationData.IDS_STORE_UpgradeDesc2+"</p>";
      buy3.rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Upgrade3+"\n10000\n"+mTranslationData.IDS_STORE_UpgradeDesc3+"</p>";
      buy4.rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Upgrade4+"\n15000\n"+mTranslationData.IDS_STORE_UpgradeDesc4+"</p>";
      buy5.rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Upgrade5+"\n2500\n"+mTranslationData.IDS_STORE_UpgradeDesc5+"</p>";

      if(this.container.gamePlayer.threeWayShot==true)
      {
        this.buy0.checkMark.visible=true;
        this.buy0.cover.alpha=0.8;
        this.buy0.rollOverText=mTranslationData.IDS_STORE_Upgrade0+"\n(PURCHASED)";
      }
      if(this.container.gamePlayer.twoWayShot==true)
      {
        this.buy1.checkMark.visible=true;
        this.buy1.cover.alpha=0.8;
        buy1.rollOverText=mTranslationData.IDS_STORE_Upgrade1+"\n("+mTranslationData.IDS_STORE_Purchased+")";
      }
      if(this.container.gamePlayer.shieldBonus==true)
      {
        this.buy2.checkMark.visible=true;
        this.buy2.cover.alpha=0.8;
        buy2.rollOverText=mTranslationData.IDS_STORE_Upgrade2+"\n("+mTranslationData.IDS_STORE_Purchased+")";
      }
      if(this.container.gamePlayer.cannonShot==true)
      {
        this.buy3.checkMark.visible=true;
        this.buy3.cover.alpha=0.8;
        buy3.rollOverText=mTranslationData.IDS_STORE_Upgrade3+"\n("+mTranslationData.IDS_STORE_Purchased+")";
      }
      if(this.container.gamePlayer.backShot==true)
      {
        this.buy4.checkMark.visible=true;
        this.buy4.cover.alpha=0.8;
        buy4.rollOverText=mTranslationData.IDS_STORE_Upgrade4+"\n("+mTranslationData.IDS_STORE_Purchased+")";
      }
      if(this.container.gamePlayer.hyperNova==true)
      {
        this.buy5.checkMark.visible=true;
        this.buy5.cover.alpha=0.8;
        buy5.rollOverText=mTranslationData.IDS_STORE_Upgrade5+"\n("+mTranslationData.IDS_STORE_Purchased+")";
      }

      for(var x=0; x<10; x++)
      {
        if(x==levelNum)
        {
          this["lvlBtn"+x].gotoAndStop(x+1);
          this["lvlBtn"+x].visible=true;
          this["lvlBtn"+x].cover.alpha=0;
          this["lvlBtn"+x].checkMark.visible=false;
          this["lvlBtn"+x].rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Level+" "+(x+1)+"</p>";
        }
        if(x<levelNum)
        {
          this["lvlBtn"+x].gotoAndStop(x+1);
          this["lvlBtn"+x].visible=true;
          this["lvlBtn"+x].cover.alpha=0.25;
          this["lvlBtn"+x].checkMark.visible=true;
          this["lvlBtn"+x].rollOverText="<p align='center'>"+mTranslationData.IDS_STORE_Level+" "+(x+1)+"\n("+mTranslationData.IDS_STORE_Complete+")</p>";
        }
        if(x>levelNum)
        {
          this["lvlBtn"+x].gotoAndStop((x+10)+1);
          this["lvlBtn"+x].visible=true;
          this["lvlBtn"+x].cover.alpha=0.75;
          this["lvlBtn"+x].checkMark.visible=false;
          this["lvlBtn"+x].rollOverText=mTranslationData.IDS_STORE_Level+" "+(x+1)+"\n("+mTranslationData.IDS_STORE_Locked+")";
        }
      }
    }

    public function setContainer(cont)
    {
      this.container=cont;
    }
  }
}
