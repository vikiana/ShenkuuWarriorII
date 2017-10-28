package com.neopets.vendor.gamepill.novastorm.obj
{
  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Fire Zone class
   *  Yellow ring that shows where the player's shots should be going
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class fireZone extends gameObject
  {
    public var timer:int=0;
    public var offX:Number;
    public var offY:Number;
    public var rotation:Number=0;

    public function fireZone()
    {
      this.visible=true;

      this.zPos=1;
      this.removeable=false;
    }

    public function setup()
    {
      this.x=650/2;
      this.y=600/2;
    }

    public function doLoop()
    {
      
    }

    // set offset relative to player position

    public function setOffset(gamePlayer:player)
    {
      this.offX=this.x-gamePlayer.x;
      this.offY=this.y-gamePlayer.y;
    }

    // set rotation

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

    // update position

    public function updatePosition(mousePressed:Boolean,gamePlayer:player)
    {
      if(mousePressed==true) // if mouse pressed, set position to offset relative to player's position
      {
        this.x=gamePlayer.x+this.offX;
        this.y=gamePlayer.y+this.offY;
      }
      if(mousePressed==false) // if mouse released, set position to follow player
      {
        var aimPos:Point=this.getPosAim(gamePlayer.x+gamePlayer.width/2,gamePlayer.y+gamePlayer.height/2,42);

        while(this.hitTestObjectRect(gamePlayer,gamePlayer.followArea)==false)
        {
          this.x+=aimPos.x;
          this.y+=aimPos.y;
        }

        this.setRotation(gamePlayer.x+gamePlayer.width/2,gamePlayer.y+gamePlayer.height/2);
        this.gotoAndStop(Math.round(this.rotation/7.5));
      }
    }
  }
}
