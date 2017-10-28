package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Enemy mine class
   *  Enemy mine that sits in place and eventually dissapears
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class enemyMine extends gameObject
  {
    var timer:int=0;
    var life:int=150; // time before the shot dissapears, in frames

    public function enemyMine()
    {
      this.visible=true;

      this.zPos=2;
      this.collideWithPlayer=true;
      this.isEnemyShot=true;
    }

    public function doLoop()
    {
      this.timer++;

      if(this.timer==this.totalFrames)
        this.timer=0;

      this.gotoAndStop(timer);

      this.life--;

      if(this.life<=10)
        this.alpha-=0.1;

      if(this.life<=0)
        this.visible=false;
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
