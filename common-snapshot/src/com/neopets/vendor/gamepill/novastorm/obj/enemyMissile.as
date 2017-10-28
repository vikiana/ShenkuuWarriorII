package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.obj.gameObject;

  import flash.display.MovieClip;
  import flash.display.DisplayObject;

  /*
   *  Enemy Seeker Shot class
   *  Generic enemy shot that moves in a constant velocity
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class enemyMissile extends gameObject
  {
    public var rotation:int=0;

    public function enemyMissile()
    {
      this.visible=true;

      this.zPos=2;
      this.isMissile=true;
      this.collideWithPlayer=true;
      this.isEnemyShot=true;
      this.pointValue=0;
    }

    public function setRotation(xPos:Number,yPos:Number)
    {
      var tx=xPos;
      var ty=yPos;

      var dx=tx-this.x;
      var dy=ty-this.y;

      var sinTheta=0;

      var r=Math.sqrt((dx*dx)+(dy*dy));
      if(r==0)
        sinTheta=dy;
      else
        sinTheta=dy/r;
      var theta=Math.asin(sinTheta);

      if(xPos<this.x)
        this.rotation=90-(theta*57.5);
      else
        this.rotation=(theta*57.5)-90;

      if(this.rotation<0) this.rotation+=360;
      if(this.rotation>360) this.rotation-=360;
    }

    public function doLoop()
    {
      this.gotoAndStop(Math.round(this.rotation/7.5));

      this.move();

      this.checkOutOfBounds();
    }

    public function die()
    {
      this.visible=false;
    }
  }
}
