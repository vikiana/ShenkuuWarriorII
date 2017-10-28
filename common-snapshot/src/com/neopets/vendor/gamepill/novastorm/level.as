package com.neopets.vendor.gamepill.novastorm
{
  import com.neopets.vendor.gamepill.novastorm.obj.*;
  import com.neopets.vendor.gamepill.novastorm.levelData;
  
  import virtualworlds.lang.TranslationManager;
  import virtualworlds.lang.TranslationData;

  /*
   *  level class
   *  Sets up data for each level
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class level extends Object
  {
    //public var translation=new TranslationInfo();
	protected var mTranslationData:TranslationData = TranslationManager.instance.translationData;

    public var levelGoalDestroy:int=0;
    public var levelGoalSurvive:int=1;
    public var levelGoalProtect:int=2;
    public var levelGoalBoss:int=3;

    public var data=new Array();

    public var frameRate:int=48;

    public function level()
    {
      var levelNum=0;

      // level 0
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level0;
      data[levelNum].goal=levelGoalDestroy;
      data[levelNum].goalVal=30;
      data[levelNum].pinkJewelAppearTime=-1;
      data[levelNum].enemyPopTimer=60;
      data[levelNum].enemyLimit=5;
      data[levelNum].enemyType[0]=ramNova;
      levelNum++;

      // level 1
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level1;
      data[levelNum].goal=levelGoalDestroy;
      data[levelNum].goalVal=40;
      data[levelNum].pinkJewelAppearTime=20*frameRate;
      data[levelNum].enemyPopTimer=50;
      data[levelNum].enemyLimit=10;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=ramNova;
      levelNum++;

      // level 2
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level2;
      data[levelNum].goal=levelGoalSurvive;
      data[levelNum].goalVal=(1.25*60)*frameRate;
      data[levelNum].pinkJewelAppearTime=40*frameRate;
      data[levelNum].enemyPopTimer=40;
      data[levelNum].enemyLimit=20;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=ramNova;
      data[levelNum].enemyType[2]=fireNova;
      levelNum++;

      // level 3
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level3;
      data[levelNum].goal=levelGoalProtect;
      data[levelNum].goalVal=(1.25*60)*frameRate;
      data[levelNum].pinkJewelAppearTime=-1;
      data[levelNum].enemyPopTimer=40;
      data[levelNum].enemyLimit=10;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=fireNova;
      levelNum++;

      // level 4
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level4;
      data[levelNum].goal=levelGoalSurvive;
      data[levelNum].goalVal=(1.25*60)*frameRate;
      data[levelNum].pinkJewelAppearTime=40*frameRate;
      data[levelNum].enemyPopTimer=40;
      data[levelNum].enemyLimit=20;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=ramNova;
      data[levelNum].enemyType[2]=fireNova;
      data[levelNum].enemyType[3]=mineNova;
      levelNum++;

      // level 5
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level5;
      data[levelNum].goal=levelGoalDestroy;
      data[levelNum].goalVal=100;
      data[levelNum].pinkJewelAppearTime=20*frameRate;
      data[levelNum].enemyPopTimer=30;
      data[levelNum].enemyLimit=30;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=ramNova;
      data[levelNum].enemyType[2]=fireNova;
      data[levelNum].enemyType[3]=pulsarNova;
      levelNum++;

      // level 6
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level6;
      data[levelNum].goal=levelGoalDestroy;
      data[levelNum].goalVal=150;
      data[levelNum].pinkJewelAppearTime=40*frameRate;
      data[levelNum].enemyPopTimer=24;
      data[levelNum].enemyLimit=30;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=ramNova;
      data[levelNum].enemyType[2]=fireNova;
      data[levelNum].enemyType[3]=darkNova;
      data[levelNum].enemyType[4]=pulsarNova;
      levelNum++;

      // level 7
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level7;
      data[levelNum].goal=levelGoalSurvive;
      data[levelNum].goalVal=(1.25*60)*frameRate;
      data[levelNum].pinkJewelAppearTime=40*frameRate;
      data[levelNum].enemyPopTimer=23;
      data[levelNum].enemyLimit=30;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=ramNova;
      data[levelNum].enemyType[2]=fireNova;
      data[levelNum].enemyType[3]=darkNova;
      data[levelNum].enemyType[4]=mineNova;
      data[levelNum].enemyType[5]=pulsarNova;
      data[levelNum].superNovaPopTimer=new Array(30*frameRate,60*frameRate);
      levelNum++;

      // level 8
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level8;
      data[levelNum].goal=levelGoalDestroy;
      data[levelNum].goalVal=140;
      data[levelNum].pinkJewelAppearTime=40*frameRate;
      data[levelNum].enemyPopTimer=22;
      data[levelNum].enemyLimit=30;
      data[levelNum].enemyType[0]=mechNova;
      data[levelNum].enemyType[1]=fireNova;
      data[levelNum].enemyType[2]=darkNova;
      data[levelNum].enemyType[3]=mineNova;
      data[levelNum].enemyType[4]=pulsarNova;
      data[levelNum].ultraNovaPopTimer=new Array(30*frameRate,60*frameRate);
      levelNum++;

      // level 9
      data[levelNum]=new levelData();
      data[levelNum].desc=mTranslationData.IDS_LEVELGOAL_Level9;
      data[levelNum].goal=levelGoalBoss;
      data[levelNum].goalVal=1;
      data[levelNum].pinkJewelAppearTime=-1;
      data[levelNum].enemyPopTimer=60;
      data[levelNum].enemyLimit=30;
      data[levelNum].enemyType=new Array();
      data[levelNum].bossNovaPopTimer=new Array(2*frameRate,-1);
      levelNum++;
    }
  }
}
