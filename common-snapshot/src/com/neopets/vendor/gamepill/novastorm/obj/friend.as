package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.media.Sound;

  /*
   *  Player Friend
   *  Player's friend that must be protected from enemy shots
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class friend extends gameObject
  {
    public var playerHitSnd=new playerHitSound() as Sound;

    public var hitTimer:int=0;

    public var shield:simpleLoopAnim; // shield animation

    public function friend()
    {
      this.visible=true;

      this.shield=new simpleLoopAnim();

      this.zPos=-2;
      this.playerFriend=true;
      this.health=8;

      this.renderList=new Array(shield);
    }

    public function setupAnimations()
    {
      shield.setContainer(container);
      shield.parseMovieClip(new playerShieldFullMC());
      shield.x=(this.width/2)-(shield.width/2);
      shield.y=(this.height/2)-(shield.height/2);
    }

    public function doLoop()
    {
      if(this.shield.visible==true) this.shield.doLoop();

      if(hitTimer>0)
      {
        hitTimer--;

        if(this.container.gCount%2==0)
          this.alpha=0;
        else
          this.alpha=1;
      }
      else
      {
        this.alpha=1;
      }
    }

    public function die()
    {

      if(this.hitTimer==0)
      {
        this.health--;

        if(this.health==4)
          shield.parseMovieClip(new playerShieldMediumMC());

        if(this.health==3)
          shield.parseMovieClip(new playerShieldLowMC());

        if(this.health==2)
          shield.parseMovieClip(new playerShieldVeryLowMC());

        if(this.health==1)
          shield.parseMovieClip(new playerShieldRemovedMC());

        if(this.health==0)
          shield.visible=false;

        this.hitTimer=60;

        if(this.container.container.playSound==true)
          playerHitSnd.play();
      }
    }
  }
}
