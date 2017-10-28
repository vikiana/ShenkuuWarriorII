package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Enemy Seeker Shot class
   *  Enemy shot that chases the player
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class enemySeekerShot extends gameObject
  {
    var life:int=150; // time before it dissapears

    public function enemySeekerShot()
    {
      this.visible=true;

      this.zPos=2;
      this.collideWithPlayer=true;
      this.isEnemyShot=true;
      this.sLimit=4;
    }

    public function doLoop()
    {
      // aim towards the player

      this.aimTowards(this.container.gamePlayer.x+25,this.container.gamePlayer.y+25,0.1);

      // check if over the speed limit

      this.checkSpeed();

      // add speed to x,y

      this.move();

      // decrement life time and check if it should dissapear

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
